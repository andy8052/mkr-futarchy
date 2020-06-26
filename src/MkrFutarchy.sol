pragma solidity ^0.5.15;

import {DSChiefAbstract, GemAbstract} from "dss-interfaces/Interfaces.sol";
import "./Market.sol";

contract MkrFutarchy {

    DSChiefAbstract chief;
    GemAbstract mkr;
    GemAbstract dai;
    mapping(address => uint256) public mkrBalances;
    mapping(address => uint256) public daiBalances;

    bytes32 currentSlate;
    bool live = false;
    uint256 yesVotes;
    uint256 noVotes;

    constructor() public {
        chief = DSChiefAbstract(0x9eF05f7F6deB616fd37aC3c959a2dDD25A54E4F5);
        mkr = GemAbstract(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);
        dai = GemAbstract(0x6b175474e89094c44da98b954eedeac495271d0f);
        mkr.approve(address(chief), uint(-1));
    }

    function join(uint256 wad) public {
        require(mkr.transferFrom(msg.sender, address(this), wad), "join/transferFrom-failed");
        mkrBalances[msg.sender] += wad;
    }

    function exit(uint256 wad) public {
        require(mkrBalances[msg.sender] >= wad, "exit/insufficient-bal");
        mkrBalances[msg.sender] -= wad;
        mkr.transfer(msg.sender, wad);
    }

    function newExecutive(bytes32 slate) public {
        require(!live);
        currentSlate = slate;
        //create prediction markets for yes and no
        //set timer for 24 hours
    }

    function yes(uint256 wad) public {
        require(dai.transferFrom(msg.sender, address(this), wad), "yes/transferFrom-failed");
        daiBalances[msg.sender] += wad;
        yesVotes += wad;
    }

    function no(uint256 wad) public {
        require(dai.transferFrom(msg.sender, address(this), wad), "yes/transferFrom-failed");
        daiBalances[msg.sender] += wad;
        noVotes += wad;
    }

}
