pragma solidity ^0.8.17;
//SPDX-License-Identifier: MIT

import 'hardhat/console.sol';
import './ExampleExternalContract.sol';

error ZeroAddressSender();
error InsufficientStakeAmount(uint256 amount);

contract Staker {
  event Stake(address indexed staker, uint256 amount);

  ExampleExternalContract public exampleExternalContract;

  /// @notice - handles stakers total staked balances
  mapping(address => uint256) balances;
  
  /// @notice - handles total staked balance
  uint256 totalStaked = 0;

  constructor(address exampleExternalContractAddress) {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // TODO: Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() external payable {
    // If sender is zero-address
    if (msg.sender == address(0)) {
      revert ZeroAddressSender();
    }

    uint256 updatedStake = address(this).balance;
    uint256 stakeAmount = updatedStake - totalStaked;
    if (updatedStake <= totalStaked) {
      revert InsufficientStakeAmount(stakeAmount);
    }

    uint256 initialValue = balances[msg.sender];
    if (initialValue != 0) {
      balances[msg.sender] = initialValue + stakeAmount;
    } else {
      balances[msg.sender] = stakeAmount;
    }

    // reset state variable
    totalStaked = updatedStake;

    emit Stake(msg.sender, stakeAmount);
  }

  // TODO: After some `deadline` allow anyone to call an `execute()` function
  //  It should call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value

  // TODO: if the `threshold` was not met, allow everyone to call a `withdraw()` function

  // TODO: Add a `timeLeft()` view function that returns the time left before the deadline for the frontend

  // TODO: Add the `receive()` special function that receives eth and calls stake()
}
