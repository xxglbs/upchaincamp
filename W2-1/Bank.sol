// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Bank {

    // 声明映射 mapping, 用于记录账户的余额
    mapping(address => uint256) private balances;

    // 声明一个事件, 用于记录交易记录
    event LogTransaction(address indexed sender, uint256 amount, string indexed transactionType);

    
    // 接收ETH代币方法
    receive() external payable {
        deposit();
    }

    // 合约账户中存款
    function deposit() public payable {
        // 需要转账金额大于0
        require(msg.value > 0, "Deposit amount must be greater than 0");
        // 在balances中更新映射余额
        balances[msg.sender] += msg.value;
        // 记录交易日志，发送人/转账金额/交易类型
        emit LogTransaction(msg.sender, msg.value, "DEPOSIT");
    }

    // 合约账户中提现
    function withdraw(uint256 amount) public {
        // 需要保证提现金额大于0
        require(amount > 0 ,"Withdraw amount must be greater than 0");
        // 需要保证用户的余额足够支付取款金额
        require(balances[msg.sender] >= amount, "Insufficient balance");
        // 更新账户余额
        balances[msg.sender] -= amount;
        // 支付ETH并确保成功, 可以提现到合约地址或钱包地址
        // payable(msg.sender).transfer(amount);
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to send ether");
        emit LogTransaction(msg.sender, amount, "WITHFRAW");
    }

    // 查询余额    
    function getBalance() public view returns(uint256){
        return balances[msg.sender];
    }
}
