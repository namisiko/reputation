pragma solidity ^0.5.11;
import "./ownable.sol";
contract KillerContract is Ownable {
    function kill() public {
        selfdestruct(msg.sender);
    }
}
