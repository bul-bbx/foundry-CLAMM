//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Counter {
    error Counter__MaximumReached();
    error Counter__MinimumReached();

    uint public count;
    uint private constant MAX_VALUE = type(uint).max;

    function get() public view returns (uint) {
        return count;
    }

    function inc() public {
        require(count < MAX_VALUE, Counter__MaximumReached());
        count++;
    }

    function dec() public {
        require(count > 0, Counter__MinimumReached());
        count--;
    }

    function set(uint _count) public {
        count = _count;
    }
}
