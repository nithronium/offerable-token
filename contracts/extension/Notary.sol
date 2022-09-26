/// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

contract Notary {
    struct Message {
        uint256 networkId;
        address from;
        address to;
        uint256 amount;
        uint256 feeAmount;
        uint256 nonce;
        bytes signature;
        address signer;
    }

    function getMessageHash(
        uint256 networkId,
        address from,
        address to,
        uint256 amount,
        uint256 feeAmount,
        uint256 nonce
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(networkId, from, to, amount, feeAmount, nonce)
            );
    }

    function getEthSignedMessageHash(bytes32 messageHash)
        public
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    messageHash
                )
            );
    }

    function verify(Message memory message) public pure returns (bool) {
        bytes32 messageHash_ = getMessageHash(
            message.networkId,
            message.from,
            message.to,
            message.amount,
            message.feeAmount,
            message.nonce
        );
        bytes32 ethSignedMessageHash_ = getEthSignedMessageHash(messageHash_);

        return
            recoverSigner(ethSignedMessageHash_, message.signature) ==
            message.signer;
    }

    function recoverSigner(bytes32 ethSignedMessageHash, bytes memory signature)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(signature);

        return ecrecover(ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        public
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "SignVerifier: invalid signature length");

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
