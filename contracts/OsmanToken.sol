/// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "./extension/ERC20Offerable.sol";

contract OsmanToken is ERC20, ERC20Offerable {
    constructor(uint256 networkId)
        ERC20("Osman Token", "OTKN")
        ERC20Offerable(networkId)
    {}

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        _incrementNonce(from);
    }
}
