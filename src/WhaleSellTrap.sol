// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "./interfaces/ITrap.sol";

/// @notice Minimal ERC20 interface
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract WhaleSellTrap is ITrap {
    // === CONFIGURATION ===

    // TOKEN: Verified ERC20 on Hoodi network
    address public constant TOKEN = 0x64f1904d1b419c6889BDf3238e31A138E258eA68;

    // POOL: Verified liquidity pool (we just read its token balance)
    address public constant POOL = 0xB683004402e07618c67745A4a7DBE99839388136;

    // Trigger if pool token balance increases by at least 50,000 tokens
    uint256 public constant THRESHOLD = 50_000 * 1e18;

    // === COLLECT ===
    function collect() external view override returns (bytes memory) {
        uint256 tokenBalance = IERC20(TOKEN).balanceOf(POOL);
        return abi.encode(tokenBalance);
    }

    // === RESPOND DECISION ===
    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (data.length < 2) return (false, bytes(""));

        uint256 balance_new = abi.decode(data[0], (uint256));
        uint256 balance_prev = abi.decode(data[1], (uint256));

        if (balance_new > balance_prev && (balance_new - balance_prev) >= THRESHOLD) {
            return (true, abi.encode(balance_prev, balance_new, balance_new - balance_prev));
        }

        return (false, bytes(""));
    }
}
