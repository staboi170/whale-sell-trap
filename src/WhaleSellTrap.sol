// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "./interfaces/ITrap.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface IPool {
    function getReserves() external view returns (
        uint112 reserve0,
        uint112 reserve1,
        uint32 blockTimestampLast
    );
}

contract WhaleSellTrap is ITrap {
    // === CONFIGURATION ===
    address public constant TOKEN = 0x64f1904d1b419c6889BDf3238e31A138E258eA68;
    address public constant POOL  = 0xB683004402e07618c67745A4a7DBE99839388136;

    /// @notice 100 = 1% threshold (100 bps). Can be tuned.
    uint256 public constant THRESHOLD_BPS = 100;

    // === COLLECT PHASE ===
    function collect() external view override returns (bytes memory) {
        uint256 tokenBalance = 0;
        (uint112 r0, uint112 r1) = (0, 0);

        // Safely load token balance from pool
        try IERC20(TOKEN).balanceOf(POOL) returns (uint256 bal) {
            tokenBalance = bal;
        } catch {}

        // Try to get pool reserves (Uniswap-like pools)
        try IPool(POOL).getReserves() returns (uint112 reserve0, uint112 reserve1, uint32) {
            r0 = reserve0;
            r1 = reserve1;
        } catch {}

        return abi.encode(tokenBalance, r0, r1, block.number);
    }

    // === SHOULD RESPOND PHASE ===
    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (data.length < 2) return (false, "");

        // Decode latest and previous samples
        (uint256 newBal, uint112 newR0, uint112 newR1, uint256 newBlock) =
            abi.decode(data[0], (uint256, uint112, uint112, uint256));
        (uint256 prevBal, uint112 prevR0, uint112 prevR1, ) =
            abi.decode(data[1], (uint256, uint112, uint112, uint256));

        if (newBal <= prevBal || prevBal == 0) {
            return (false, "");
        }

        uint256 delta = newBal - prevBal;
        uint256 bps   = (delta * 10_000) / prevBal;

        // Optional reserve confirmation: if TOKEN is reserve0,
        // a sell should increase token balance AND decrease reserve0 or increase quote side.
        bool reserveConfirmsSell = false;
        if (newR0 < prevR0) {
            reserveConfirmsSell = true;
        }

        if (bps >= THRESHOLD_BPS && reserveConfirmsSell) {
            return (true, abi.encode(prevBal, newBal, delta, newBlock));
        }

        return (false, "");
    }
}
