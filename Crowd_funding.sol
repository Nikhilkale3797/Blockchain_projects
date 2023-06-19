// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract crowdfunding{
    mapping (address=>uint) public contributers;
    address public manager;
    uint public minimum_contri;
    uint public deadline;
    uint public target;
    uint public noofcontributers;
    uint public raisedamount;

    struct Request{
        string describtion;
        address payable recipient;
        uint value;
        bool completed;
        uint noofvoters;
        mapping (address=>bool) voters;
    }

    mapping(uint=>Request) record;
    uint numrequest;

    constructor(uint _target , uint _deadline){
        target = _target;
        deadline = block.timestamp + _deadline;
        manager = msg.sender;
        minimum_contri = 1 ether;

    }

    function sendeather() public payable{
        require(block.timestamp < deadline,"deadline have passed");
        require(msg.value > minimum_contri,"minimum contirbution is 1 ether");

        if(contributers[msg.sender]==0){
            noofcontributers++ ;
        }

        contributers[msg.sender] += msg.value;
        raisedamount += msg.value;
    }

    function contractbalance () public view returns(uint){
        return address(this).balance; 
    }

    function refund() public{
        require(block.timestamp > deadline && raisedamount < target,"refund not possible for current situation");
        require(contributers[msg.sender]>0);
        address payable user = payable(msg.sender);
        user.transfer(contributers[msg.sender]);
        contributers[msg.sender]=0;
    }

    modifier onlymanager(){
        require(msg.sender == manager,"only manager can call this function");
        _;
    }

    function createrequest(string memory _describtion, address payable _reciepent,uint _value) public onlymanager{
        Request storage newrequest = record[numrequest];
        numrequest ++;
        newrequest.describtion =  _describtion;
        newrequest.recipient =  _reciepent;
        newrequest.value =  _value;
        newrequest.completed = false;
        newrequest.noofvoters = 0;
    }

    function voterequest(uint _recordno) public {
        require( contributers[msg.sender]>0,"you are not contributer");
        Request storage thisrequest = record[_recordno];
        require(thisrequest.voters[msg.sender]==false,"you have allready voted");
        thisrequest.voters[msg.sender]=true;
        thisrequest.noofvoters ++;
        }

    function makepayment(uint _recordno) public onlymanager{
        require(raisedamount>=target);
        Request storage thisrequest = record[_recordno];
        require(thisrequest.completed == false, "this request is already completed");
        require(thisrequest.noofvoters >= noofcontributers/2,"majority does not support");
        thisrequest.recipient.transfer(thisrequest.value);
        thisrequest.completed = true;

    }
    // function get_request() public returns(string memory){
    //     return newrequest.describtion;
    // }
   
}//end
