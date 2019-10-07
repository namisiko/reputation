pragma solidity ^0.5.11;
contract Ownable {address public the_owner;
address new_Owner;
event ownershipTransfer (
address indexed old_Owner ,
address indexed new_Owner);
//This function sets the owner of the smart contract
function for_Ownable( ) public {
    the_owner = msg.sender;}
modifier only_the_Owner(){require(msg.sender == the_owner);
_;}
function transfer_Ownership(address _new_Owner) public only_the_Owner{
require(_new_Owner != address(0));
the_owner=_new_Owner;
the_owner = new_Owner;
}
}
