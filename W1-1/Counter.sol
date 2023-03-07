// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Counter {

    uint public count;
    
    constructor() {
        count = 0;
    }

    function add(uint x) public returns(uint){
        count = count + x;
        return count;
    }

}