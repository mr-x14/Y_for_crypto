// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {
    address public owner;

    // Маппінг для зберігання балансу користувачів
    mapping(address => uint256) public balances;

    // Подія для відслідковування депозитів
    event Deposited(address indexed user, uint256 amount);
    
    // Подія для відслідковування зняття коштів
    event Withdrawn(address indexed user, uint256 amount);

    // Конструктор, щоб встановити власника контракту
    constructor() {
        owner = msg.sender;
    }

    // Функція для депонування ефірів на контракт
    function deposit() external payable {
        require(msg.value > 0, "Must send some Ether");
        balances[msg.sender] += msg.value;

        emit Deposited(msg.sender, msg.value);
    }

    // Функція для виведення ефірів з контракту
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawn(msg.sender, amount);
    }

    // Функція для перевірки балансу користувача
    function checkBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    // Функція, щоб перевести ефіри на іншу адресу (тільки для власника контракту)
    function transferEther(address payable recipient, uint256 amount) external {
        require(msg.sender == owner, "Only owner can transfer Ether");
        require(address(this).balance >= amount, "Insufficient contract balance");

        recipient.transfer(amount);
    }
}
