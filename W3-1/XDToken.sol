// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract XDToken is ERC20{

    constructor() ERC20("My test token", "XDT") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }
}

