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

//This is a constructor
function Endorsement() public {
the_owner = msg.sender;
}
//These are event logs generated
event LogJoinNetwork(
address _entity ,
string _entityname
);

event LogEndorse(
address _endorser ,
address _endorsee
);
address [] public allEntities;
mapping (address => uint ) entityIndex;
//Join the network as any node
function joinNetwork(string _userName) public HasNoEther {
//only allow the unregistered entities
require(!joined[msg.sender]);
joined[msg.sender] = true;

// Record the senders name and id 
Entity memory newEntity = Entity({
identity: msg.sender ,
entity_name: _userName
});
//add new entity to the existing members
entity.push(newEntity);
number_Of_Entities++;
entityIndex[msg.sender] = number_Of_Entities -1;
LogJoinNetwork(msg.sender , _userName);

allEntities.push(msg.sender);
}

//Function to obtain a list of all the entities
function getAllEntities() public view returns(address[]) {
return allEntities;
}


//Determine the index of each entity by address , the helper function , and view modifier
function getEntityIndex(address _entity) public view returns (uint ) {

uint userIndex = entityIndex[_entity];
return userIndex;
}
//Generate the profiles
function getName(uint _index ) public view returns (string ) {

string name = entities[_index].entityname;
return entityname;
}

function editProfile(address _entity ,
string _entityname) 
public HasNoEther {

//Check the editor for the name as the profile owner
require(msg.sender == _entity);

//change the states
uint id = getEntityIndex(_entity);
entities[id].entityname = _entityname;
}

//send the endorsement 
function endorse(uint _index) public HasNoEther {

// Obtain the address of the endorsee
address receiver = entities[_index].identity;



//Confirm that the endorser and endorsee are registered
require(joined[msg.sender]);
require(receiver != address(0));
require(receiver != msg.sender);

//Record and update the endorser's information
Endorser storage endorser = endorsers[msg.sender];
endorser.index++;
endorser.sender = msg.sender;
endorser.eg++;

// if (endorser.eg>1 ){
// endorser.used_Power = Division(1, endorser.eg ,9);
// } else {
// endorser.used_Power = 0;
// }

endorser.used_Power =Division(1,endorser.eg, 9);
endorser.given_To.push(receiver);
endorser.has_Given_To[receiver] = true;

endorserAccounts.push(msg.sender) - 1;

//Update the endorsee information
updateEndorsee(receiver , msg.sender);
//Log and flag the endorsement event
LogEndorse(msg.sender , receiver);
}

//store and update the new endorsee data
function updateEndorsee(address _receiver ,
address _sender) internal {
Endorsee storage endorsee = endorsees[_receiver];
endorsee.receiver = _receiver;
endorsee.index++;
endorsee.er++;

endorsee.received_From.push(_sender);
endorsee.has_Received_From[_sender] = true;
endorseeAccounts.push(_receiver) - 1;
}

//Eliminate the endorsement of the endorsee
function removeEndorsement(address _endorsee) public returns(uint) {

require (joined[_endorsee]);

Endorser storage endorser = endorsers[msg.sender];
Endorsee storage endorsee = endorsees[_endorsee];

//Continue only if the endorsee is present in the list 
if (endorser.has_Given_To[_endorsee]) {
endorser.has_Given_To[_endorsee] = false;
endorser.eg--;

//remove the endorsee from the erray
endorsee.has_Received_From[msg.sender] = false;
endorsee.er--;

//remove the endorser's address from the array
}
return endorsers[msg.sender].index;
}

//Calculate the total received points of the endorsee
function computeReceivedPoints(address _endorsee) public view returns(uint) {

require(joined[_endorsee]);

//Obtain list of all the endorsers addresses for which the _endorsee has received endorsements from
address [] memory receivedFrom = getReceivedFrom(_endorsee);

uint totalpoints = receivedPoints[_endorsee];
uint len = previousLength[_endorsee];

for (uint i=len; i< receivedFrom.length; i++){
totalpoints = totalpoints + endorsers[receivedFrom[i]].used_Power;
}
receivedPoints[_endorsee] = totalpoints;
previousLength[_endorsee] = receivedFrom.length;
return totalpoints;
}
function computeImpact(address _entity) public view returns (uint){
require (joined[_entity]);
uint eg = endorsers[_entity].eg;
uint er = endorsees[_entity].er;
uint _RE = computeReceivedPoints(_entity);
uint impactFactor;
uint totalImpactFactor;
if (eg <=1 && er <=1 ) {
impactFactor = 0;
return impactFactor;
//return the impact factor and exit 
} 
else 
{
uint minvalue = min(eg,er);
uint maxvalue = max(eg,er);
uint ratio = Division(minvalue , maxvalue ,9);
uint usedUpByEntity = endorsers[_entity].used_Power;
uint RE = _RE;
impactFactor = ratio * RE;
}

totalImpactFactor = transactionFeedBack(_entity , impactFactor);
return totalImpactFactor;
}

//Obtain the feedback from the  Network and penalize the nodes
function transactionFeedBack(address _entity ,
uint _impactFactor )
public returns (uint) {

if (flagCount[_entity] >= 1) {
//Decrement the current impact factor by 50 %
uint res = Division(_impact ,2,9);
uint penalty = _impactFactor - res ;

} else {
penalty = _impactFactor;

}
return penalty;
}

function getProfile(address _entity) public view returns (
uint,
uint,
address[],
uint,
uint,
address[] )

{

uint outDegree = endorsers[_entity].eg;
uint used_Power = endorsers[_entity].used_Power;
address[] outConns = endorsers[_entity].given_To;

uint inDegree = endorsees[_entity].er;
uint receivedPoints = computeReceivedPoints(_entity);
address[] inConns = endorsees[_entity].receivedFrom;

return (
outDegree ,
used_Power ,
outConns ,
inDegree ,
receivedPoints ,
inConns
);
}

//get the connections and their degree sof connections 
function getConnections(address _entity) public view returns (
address [],
address []
){

require (joined[_entity]);

address [] inConns = endorsees[_entity].receivedFrom;
address [] outConns = endorsers[_entity].given_To;

return (inConns , outConns);
}

//count the total number of registered entities
function getCount( ) public view returns (uint) {

return number_Of_Entities;

}

//return an array of allthe  endorsers
function getEndorsers() view public returns (address []) {

return endorserAccounts;
}

//return the total consumable points used by the endorser
function getUsedPower(address _endorser) view public returns(uint) {

return (endorsers[_endorser].used_Power);

}

//return list of addresses that endorser has sent the endorsements to
function getGivenTo(address _endorser) view public returns(address []) {
return (endorsers[_endorser].given_To);
}

//return the number of endorsees that an endorser has sent the endorsements to
function getGivenToCount(address _endorser ) view public returns (uint) {
return (endorsers[_endorser].given_To).length;
}

//return a boolean value specifying hasGivenTo to check
//whether an endorsee’s address is in the list 
function gethasGivenTo(address _endorser ,
address _endorsee) view public returns(bool) {
return (endorsers[_endorser].has_Given_To[_endorsee]);
}

//return an array for all the endorsee accounts 
function getEndorsees() view public returns (address []) {
return endorseeAccounts;
}
//return the address of all the endorsers for a particular endorsee 
function getReceivedFrom(address _endorsee) view public returns(address []) {
return (endorsees[_endorsee].receivedFrom);
}


function getReceivedFromCount(address _endorsee) view public returns (uint ) {
return (endorsees[_endorsee].receivedFrom).length;
}

function gethasReceivedFrom(address _endorser ,
address _endorsee) view public returns(bool) {
return (endorsees[_endorsee].has_Received_From[_endorser]);
}

//Helper functions for floating point computations
function Division( uint _numerator ,
uint _denominator ,
uint _precision) internal pure returns (uint _quotient) {

uint numerator = _numerator * 10 ** (_precision + 1);
uint quotient = ((numerator / _denominator) + 5 ) / 10;

return (quotient);
}

//compute max and min value.

function max (uint num1, uint num2 ) internal pure returns (uint) {
if (num1 < num2) {
return num2;
} else {
return num1;
}
}

function min (uint num1, uint num2 ) internal pure returns (uint) {
if (num1 < num2) {
return num1;
} else {
return num2;
}
}
}
