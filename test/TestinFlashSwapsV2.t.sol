// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/FlashSwapsUniswapV2.sol";

address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

contract UniswapV2FlashSwapTest is Test {
    IWETH private weth = IWETH(WETH);

    UniswapV2FlashSwap private uni = new UniswapV2FlashSwap();

    function setUp() public {}

    function testFlashSwap() public {
        weth.deposit{value: 1e18}();
        //console.log("amount of ETHER deposited in WETH : ", weth.balanceOf(address(this)));
        // Approve flash swap fee
        weth.approve(address(uni), 1e18);

        uint amountToBorrow = 100 * 1e18;
        uni.flashSwap(amountToBorrow);

        console.log("amount 1 : ", weth.balanceOf(address(this)));

        assertGt(uni.amountToRepay(), amountToBorrow);
        // assertEq(amountToBorrow + uni.fee(), uni.amountToRepay());
        // console.log(amountToBorrow + uni.fee());
        // console.log(uni.amountToRepay());


        
    }
}

