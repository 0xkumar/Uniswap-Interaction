// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/AddLiquidityUniswapV3.sol";

contract UniswapV3LiquidityTest is Test {
    IWETH private constant weth = IWETH(WETH);
    IERC20 private constant dai = IERC20(DAI);

    address private constant DAI_WHALE = 0xe81D6f03028107A20DBc83176DA82aE8099E9C42;
    UniswapV3Liquidity  private uni = new UniswapV3Liquidity();
    



    function setUp() public {
        console.log("Dai Whale Before sending dai :", dai.balanceOf(DAI_WHALE));
        vm.startPrank(DAI_WHALE);
        dai.transfer(address(this), 20 * 1e18);
        vm.stopPrank();

        weth.deposit{value: 2 * 1e18}();

        dai.approve(address(uni), 20 * 1e18);
        weth.approve(address(uni), 2 * 1e18);
        //console.log("Whale balance : ", dai.balanceOf(DAI_WHALE));
       
    }


    function testAddresses() public {
        address dai_ = address(dai);
        address weth_ = address(weth);
        console.log("Address of DAI is :", dai_);
        console.log("Address of WEth is :", weth_);
        
    }

    function testLiquidity() public {
        // Track total liquidity
        uint128 liquidity;

        // Mint new position
        uint daiAmount = 10 * 1e18;
        uint wethAmount = 1e18;
        console.log("DAI send in the uni address : ", daiAmount);
        console.log("WETH send in the uni address :",wethAmount);

        (uint tokenId, uint128 liquidityDelta, uint amount0, uint amount1) = uni
            .mintNewPosition(daiAmount, wethAmount);
        liquidity += liquidityDelta;

        console.log("--- Mint new position ---");
        console.log("token id", tokenId);

        console.log("dai send by the uni contract to testing contract :",daiAmount - amount0);
        console.log("weth send by the uni contract to the testing contract :",wethAmount - amount1);
        console.log("liquidity", liquidity);
        console.log("amount 0", amount0);
        console.log("amount 1", amount1);

        // Collect fees
        (uint fee0, uint fee1) = uni.collectAllFees(tokenId);

        console.log("--- Collect fees ---");
        console.log("fee 0", fee0);
        console.log("fee 1", fee1);

        // Increase liquidity
        uint daiAmountToAdd = 5 * 1e18;
        uint wethAmountToAdd = 0.5 * 1e18;

        (liquidityDelta, amount0, amount1) = uni.increaseLiquidityCurrentRange(
            tokenId,
            daiAmountToAdd,
            wethAmountToAdd
        );
        liquidity += liquidityDelta;

        console.log("--- Increase liquidity ---");
        console.log("liquidity", liquidity);
        console.log("amount 0", amount0);
        console.log("amount 1", amount1);

        // Decrease liquidity
        (amount0, amount1) = uni.decreaseLiquidityCurrentRange(tokenId, liquidity);
        console.log("--- Decrease liquidity ---");
        console.log("amount 0", amount0);
        console.log("amount 1", amount1);
    }
}
