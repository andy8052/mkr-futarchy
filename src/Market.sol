pragma solidity ^0.5.15;

import {DSChiefAbstract, GemAbstract} from "dss-interfaces/Interfaces.sol";

contract Market {

    GemAbstract dai;

    mapping(address => uint256) public votes;

    bool live = false;
    uint256 end;
    uint256 startPrice;
    uint256 endPrice;
    uint256 yesVotes;
    uint256 noVotes;
    uint256 resolution;

    constructor() public {
        dai = GemAbstract(0x6b175474e89094c44da98b954eedeac495271d0f);
        live == true;
        end == now + 24 hours;
        resolution = now + 8 days;
        startPrice = 1;//get uniswap price
    }

    function yes() public {
        require(live, "yes/not-live");
        require(dai.transferFrom(msg.sender, address(this), 10 ether), "yes/transferFrom-failed");
        votes[msg.sender] = 0;
        yesVotes += 1;
    }

    function no() public {
        require(live, "no/not-live");
        require(dai.transferFrom(msg.sender, address(this), 10 ether), "yes/transferFrom-failed");
        votes[msg.sender] = 1;
        noVotes += 1;
    }

    function close() public {
        require(live, "close/not-live");
        require(end <= now, "close/too-soon");
        live == false;
        endPrice = 1;//get final uniswap price
    }

    function voteResult() public view returns(uint256) {
        if (yesVotes > noVotes) {
            return 0;
        } else if (noVotes > yesVotes) {
            return 1;
        } else {
            return 2;
        }
    }

    function exit() public {
        require(!live, "exit/market-not-closed");
        require(resolution <= now, "exit/too-soon");

        (uint startDiff, uint endDiff) = closerToOne();
        uint256 closer = 2;
        if (endDiff < startDiff) {
            closer = 0;
        } else if (startDiff < endDiff) {
            closer = 1;
        }

        if (voteResult() == 2 || closer == 2) {
            dai.transfer(msg.sender, 10 ether);
        } else if (voteResult() == votes[msg.sender] && closer == 0) {
            if (voteResult() == 0){
                uint256 memory reward = ((noVotes * 1 ether) / yesVotes;
                dai.transfer(msg.sender, 10 ether + reward)
            } else {
                uint256 memory reward = ((yesVotes * 1 ether) / noVotes;
                dai.transfer(msg.sender, 10 ether + reward)
            }
        } else if (voteResult() == votes[msg.sender] && closer == 1) {
            if (voteResult() == 1){
                uint256 memory reward = ((noVotes * 1 ether) / yesVotes;
                dai.transfer(msg.sender, 10 ether + reward)
            } else {
                uint256 memory reward = ((yesVotes * 1 ether) / noVotes;
                dai.transfer(msg.sender, 10 ether + reward)
            }
        } else {
            dai.transfer(msg.sender, 9 ether);
        }
    }

    function closerToOne() public view returns(uint, uint) {
        uint256 endPriceDiff = 0;
        uint256 startPriceDiff = 0;
        if (endPrice > 1) {
            endPriceDiff = endPrice - 1;
        } else {
            endPriceDiff = 1 - endPrice;
        }

        if (startPrice > 1) {
            startPriceDiff = startPrice - 1;
        } else {
            startPriceDiff = 1 - startPrice;
        }

        return (startPriceDiff, endPriceDiff);
    }


}

contract MarketFab {

    mapping(bytes32 => Market) public markets;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function newMarket(uint256 exp, uint256 price, bytes32 slate) public {
        require(msg.sender == owner, "newMarket/only-owner");
        markets[slate] = new Market(exp, price);
    }

}
