pragma solidity ^0.8.30;
import "hardhat/console.sol";

contract TimerContract {
    // The time, in minutes, after which the contract will end
    uint256 public endTime;
    
    // 555 Owner
    address payable private owner; 

    // init total amount (0 eth by default)
    uint totalAmount = 0 ether;
    // Parameters, amount, owner, timer countdown (in minutes) 
    constructor(uint256 amount, address payable owner, uint256 countdown) internal payable {
        require (amount > 0, "Sorry, the amount must be greater than 0");

        owner = payable(msg.sender); 

        // Put the current owner's amount as total amount
        totalAmount = amount;         

        // Set the timer to end in x minutes from now
        endTime = block.timestamp + (countdown * 1 minutes);
        
    }
    
    // Modifier for restricting a contract's execution to a specific time
    modifier onlyBeforeExpirationTime {
        require(block.timestamp < endTime, "Timer has expired");
        _;
    }

    // After experiration of the time
    // Console.log "End of the contract"
    // Return the total amount to the owner
    function withdrawBalance() external onlyBeforeExpirationTime {
        owner.transfer(totalAmount);
        console.log("End of the function");
    }
}