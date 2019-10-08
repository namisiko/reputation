pragma solidity ^0.5.11;
import "./Ownable.sol";
import "./KillerContract.sol";
//import "./MarketPlace.sol";
contract Endorse is Ownable , KillerContract {
address the_owner;
struct Entity {
address identity;
string entity_name;
}
struct EndorserSystem {
uint index;
address sender;
uint eg;
uint used_Power;
address[] given_To;
mapping(address => bool) has_Given_To;
}
struct EndorseeSystem {
uint index;
address receiver;
uint er;
//The receivedPoints are of the form uint;
address[] received_From;
mapping(address => bool) has_Received_From;
}
Entity [] public entities;
uint number_Of_Entities;
mapping(address => bool) joined;
mapping (address => EndorserSystem) endorsers;
address[] public endorserAccounts;
mapping (address => EndorseeSystem ) endorsees;
address[] public endorseeAccounts;
mapping (address => uint) public previous_Length;
mapping (address => uint) public received_Points;

// Modifiers 
// setting the owner of contract 
modifier only_Owner() {
require(msg.sender == the_owner );
_;
}
//Disallow any ETH transfers
modifier HasNoEther( ){
require(msg.value == 0);
_;
}
