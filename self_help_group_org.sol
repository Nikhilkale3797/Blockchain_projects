// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract selfhelpgroup{
    address manager;
    constructor(){
       manager = msg.sender;
    }

    struct member{
        string name;
        uint fund;
        address accadd;
        bool applied;
        bool dispersed;
    }

    address[] public arr_add;
    mapping(address=>member) public addlink;
    uint limit = 1 ;

    function Enroll (string memory _name ) public payable{
        require(limit<=5,"membership over");
        member storage mem = addlink[msg.sender];
        require(mem.applied==false,"allready applied");
        mem.name=_name;
        mem.accadd = msg.sender;
        mem.applied = true;
        mem.fund = msg.value;
        limit ++;
        arr_add.push(msg.sender);

    }

    function depositefund() public payable{   
        require(msg.value==1 ether,"only deposite 1 ether") ;  
        member storage mem = addlink[msg.sender];
        require(mem.accadd==msg.sender,"you are not member");
        require(mem.fund==0,"you have already deposited");
        mem.fund = msg.value;
        
    }

    function balance()public view returns(uint){

        return address(this).balance;
    }
    modifier onlymanager(){
        require(msg.sender==manager,"you are not the manager");
        _;
    }

    function Dispersed(address payable _memadd) public onlymanager{
        require(address(this).balance==5 ether,"collection not completed");
        member storage mem = addlink[_memadd];
        require(mem.applied == true,"you are not member");
        require(mem.fund == 1 ether,"you have not deposited");
        require(mem.dispersed == false,"allready fetched");
        _memadd.transfer(address(this).balance);
        mem.dispersed=true;

        for(uint i = 0; i<arr_add.length;i++){
            member storage mem1 = addlink[arr_add[i]];
            mem1.fund=0;
        }

    }
  

}//end
