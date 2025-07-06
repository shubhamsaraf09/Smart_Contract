//SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "./ownable.sol";

contract ExampleModifier is Owner{
    mapping(address=>uint) public Tokenbalance;

   // address owner;

    uint TokenPrice=1 ether;

    constructor(){
     //   owner=msg.sender;
        Tokenbalance[owner]=100;
    }

    function createNewToken() public onlyowner{
    //    require(msg.sender==owner,"You are not owner");
        Tokenbalance[owner]++;
    }

    function burnToken() public onlyowner{
    //    require(msg.sender==owner,"You are not owner");
        Tokenbalance[owner]--;
    }

    function sendToken(address to,uint amount) public{
        require(msg.sender==owner,"You are not owner");
        require(Tokenbalance[msg.sender]>=amount,"Not sufficient funds");
        Tokenbalance[to]+=amount;
        Tokenbalance[msg.sender]-=amount;
    }

    function purchaseToken() public payable {
        require((Tokenbalance[owner] * TokenPrice) / msg.value > 0, "not enough tokens");
        Tokenbalance[owner] -= msg.value / TokenPrice;
        Tokenbalance[msg.sender] += msg.value / TokenPrice;
    }

}