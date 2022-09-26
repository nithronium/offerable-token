// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

contract Nonces {
    mapping(address => uint256) private _nonces;

    function getNonce(address user) public view returns (uint256 nonce) {
        return _nonces[user];
    }

    function _useNonce(address user, uint256 nonce) internal {
        require(getNonce(user) == nonce, "Incorrect nonce");
        _incrementNonce(user);
    }

    function _incrementNonce(address user) internal {
        _nonces[user]++;
    }
}
