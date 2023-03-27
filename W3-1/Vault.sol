// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Vault is ERC20 {
    // 定义变量存储钱包余额
    mapping(address => uint256) private _balances;

    // 构造函数
    // constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    // function mint(address to, uint256 amount)  {
    //     _mint(to, amount);
    // }

    constructor() ERC20("My test token2", "XDTS") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Vault: amount must be greater than zero");
        _balances[msg.sender] += amount;
        _mint(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Vault: amount must be greater than zero");
        require(_balances[msg.sender] >= amount, "Vault: insufficient balance");
        _balances[msg.sender] -= amount;
        _burn(msg.sender, amount);
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
}
