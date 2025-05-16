//SDPX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "../lib/forge-std/src/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    uint public constant MAX_VALUE = type(uint).max;

    function setUp() public {
        counter = new Counter();
    }

    function testIncrement(uint _amount) public {
        if (_amount >= MAX_VALUE) {
            return;
        }
        counter.set(_amount);
        counter.inc();

        assertEq(counter.get(), _amount + 1);
    }

    function testDecrement(uint _amount) public {
        if (_amount <= 0) {
            return;
        }
        counter.set(_amount);
        counter.dec();

        assertEq(counter.get(), _amount - 1);
    }

    function testRevertIncOnMaxUint(uint _amount) public {
        if (_amount == MAX_VALUE) {
            counter.set(_amount);
            vm.expectRevert(Counter.Counter__MaximumReached.selector);
            counter.inc();
        }
    }

    function testRevertOnDecZero(uint _amount) public {
        if (_amount == 0) {
            counter.set(_amount);
            vm.expectRevert(Counter.Counter__MinimumReached.selector);
            counter.dec();
        }
    }

    function testSet(uint _amount) public {
        counter.set(_amount);
        assertEq(counter.count(), counter.get());
    }

    function testGet(uint _amount) public {
        counter.set(_amount);
        uint num = counter.get();
        assertEq(counter.count(), num);
    }
}
