//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7; 

contract Context {
    function _msgSender() internal view returns(address) {
        return msg.sender;
    }
}