//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {WETH} from "../src/WETH.sol";

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

contract Handler is CommonBase, StdCheats, StdUtils {
    WETH private weth;

    uint public wethBalance;

    constructor(WETH _weth) {
        weth = _weth;
    }

    receive() external payable {}

    function sendToFallback(uint amount) public {
        amount = bound(amount, 0, address(this).balance);
        (bool ok, ) = address(weth).call{value: amount}("");
        require(ok, "sendToFallback failed");
    }

    function deposit(uint amount) public {
        amount = bound(amount, 0, address(this).balance);
        weth.deposit{value: amount}();
        wethBalance += amount;
    }

    function withdraw(uint amount) public {
        amount = bound(amount, 0, weth.balanceOf(address(this)));
        wethBalance -= amount;
        weth.withdraw(amount);
    }

    // function fail() public {
    //     revert("failed");
    // }
}

contract WETH_Handler_Based_Invariant_Test is Test {
    WETH public weth;
    Handler public handler;

    function setUp() public {
        weth = new WETH();
        handler = new Handler(weth);

        deal(address(handler), 100 * 1e18);

        targetContract(address(handler));

        // bytes4[] memory selectors = new bytes4[](3);
        // selectors[0] = Handler.deposit.selector;
        // selectors[0] = Handler.withdraw.selector;
        // selectors[0] = Handler.sendToFallback.selector;

        // targetSelector(
        //     FuzzSelector({addr: address(handler), selectors: selectors})
        // );
    }

    function invariant_eth_balance() public {
        assertGe(address(this).balance, handler.wethBalance());
    }
}
