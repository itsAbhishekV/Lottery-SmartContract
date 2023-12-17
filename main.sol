// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery{

    address public manager;
    address payable[] public players;

    constructor(){
        manager = msg.sender;
    }

    function alreadyJoined() view private returns(bool){
        for(uint i = 0; i<players.length; i++){
            if(players[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function joinTheGame() payable public{
        require(msg.sender != manager, "Manager cannot be a part of the game!");
        require(alreadyJoined() == false, "One Player can only join the game once");
        require(msg.value >= 1 ether, "Min amount of 1 ether should be paid to join the game.");

        players.push(payable(msg.sender));
    }

    function generateRandom() view private returns(uint){
        return uint(sha256(abi.encodePacked(block.number, block.timestamp, players, msg.sender)));
    }

    function pickWinner() public{
        require(msg.sender == manager, "Only manager can pick the winner");
        uint index = generateRandom() % players.length;
        address contractAddress = address(this);
        players[index].transfer(contractAddress.balance);

        players = new address payable[](0);
    }

    function getPlayers() view public returns(address payable[] memory){
        return players;
    }


}