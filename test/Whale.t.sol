//SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;


import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../lib/forge-std/src/interfaces/IERC20.sol";


contract ForkTest is Test {

    IERC20  public dai;
    function setUp() public {
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    }

    function testDeposit() public {

        address alice = address(123);

        uint balanceBefore = dai.balanceOf(alice);

        console.log("balance Before : ", balanceBefore / 1e18);


        uint256 totalSupply = dai.totalSupply();

        console.log("Total supply is :", totalSupply / 1e18);


        deal(address(dai), alice, 1e18 * 10e6, true);

        uint balanceAfter = dai.balanceOf(alice);

        console.log(balanceAfter / 1e18);

        uint256 totalSupplyAfter = dai.totalSupply();

        console.log(totalSupplyAfter / 1e18);




    }
}