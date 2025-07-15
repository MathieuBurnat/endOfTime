// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
import "hardhat/console.sol";

contract TimerContract {
    // The time, in seconds, when the contract will end
    uint256 public endTime;
    address payable public owner;
    uint256 public totalAmount;

    // Constructor to set the timer and owner
    constructor(uint256 countdown) payable {
        require(msg.value > 0, "Sorry, the amount must be greater than 0");
        require(countdown > 0, "Sorry, the countdown must be greater than 0");

        owner = payable(msg.sender);
        totalAmount = msg.value; // Store sent Ether
        
        endTime = block.timestamp + (countdown * 1 minutes);
    }

    // Modifier to restrict execution to after expiration
    modifier onlyAfterExpiration {
        require(block.timestamp >= endTime, "Timer has not expired yet");
        _;
    }

    // Withdraw balance after timer expiration
    function withdrawBalance() external onlyAfterExpiration {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 amount = totalAmount;
        
        totalAmount = 0; // Prevent reentrancy
        
        (bool sent, ) = owner.call{value: amount}("");
        
        require(sent, "Failed to send Ether");

        console.log("End of the contract");
    }

    // Function to check contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}