pragma solidity ^0.5.15;

import "ds-test/test.sol";

import "./MkrFutarchy.sol";

contract MkrFutarchyTest is DSTest {
    MkrFutarchy futarchy;

    function setUp() public {
        futarchy = new MkrFutarchy();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
