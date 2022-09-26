/// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Nonces.sol";
import "./Notary.sol";

abstract contract ERC20Offerable is Nonces, Notary, ERC20 {
    uint256 private _networkId;

    constructor(uint256 networkId) {
        _networkId = networkId;
    }

    function transferWithOffer(
        address from,
        address to,
        uint256 amount,
        uint256 feeAmount,
        uint256 nonce,
        bytes memory signature
    ) public returns (bool success) {
        require(getNonce(from) == nonce, "Incorrect nonce");
        _transfer(from, to, amount);
        _transfer(from, msg.sender, feeAmount);

        Message memory currentMessage;
        currentMessage.networkId = _networkId;
        currentMessage.from = from;
        currentMessage.to = to;
        currentMessage.amount = amount;
        currentMessage.feeAmount = feeAmount;
        currentMessage.nonce = nonce;
        currentMessage.signature = signature;
        currentMessage.signer = from;

        require(verify(currentMessage), "Invalid signature");

        return true;
    }
}
