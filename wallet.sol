//SPDX-License-Identifier:MIT

pragma solidity ^0.8.6;
// there are some ossues fix using chatgpt
contract wallet{
    address public owner;

    constructor() {
        owner=msg.sender;
    }

    address payable nextowner;

    mapping(address=>uint) TotalBalance;

    mapping(address=>bool) allowed;

    mapping(address=>uint) allowance;

    mapping(address=>bool) gaurdian;

    uint noOfGaurdianVoted;

    mapping(address=>bool) hasVoted;

    uint gaurdianConformationtoReset=3;

    function ChangeOwner(address payable newowner) public {
        require(gaurdian[msg.sender],"you are not Gaurdian");
        if(nextowner!=newowner){
            nextowner=newowner;
            noOfGaurdianVoted=0;
    }
        noOfGaurdianVoted++;
        if(noOfGaurdianVoted>=gaurdianConformationtoReset){
            owner=nextowner;
            nextowner=payable(address(0));
        }
    }

    function setGaurdian(address add) public{
        require(owner==msg.sender,"you are not the owner Aborting");
        gaurdian[add]=true;
    }

    receive() external payable{
        TotalBalance[msg.sender]+=msg.value;
    }

    function setallowance(address add,uint amount)public{
        require(owner==msg.sender,"you are not the owner Aborting");
        allowed[add]=true;
        allowance[add]=amount;
    }

    function sendallowance(address payable add) public{
        require(owner==msg.sender,"you are not the owner Aborting");
        require(allowed[add],"You are not getting allowance Aborting");
        add.transfer(allowance[add]);
    }

    function sendMoney(address payable to,uint amount,bytes memory payload) public returns(bytes memory){
        require(amount<=address(this).balance,"Insufficient Fund Abborting");
        if(owner!=msg.sender){
            require(allowed[msg.sender], "You are not allowed to send any transactions, aborting");
            require(allowance[msg.sender] >= amount, "You are trying to send more than you are allowed to, aborting");
            allowance[msg.sender]-=amount;
        }

        (bool success,bytes memory returnData)=to.call{value: amount}(payload);
        require(success);
        return returnData;
    }

}