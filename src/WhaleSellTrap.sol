// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "./interfaces/ITrap.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

interface IPool {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

contract WhaleSellTrap is ITrap {
    // === CONFIGURATION ===

    address public constant TOKEN = 0x64f1904d1b419c6889BDf3238e31A138E258eA68;
    address public constant POOL = 0xB683004402e07618c67745A4a7DBE99839388136;
    uint256 public constant THRESHOLD = 50_000 * 1e18;

    // === COLLECT ===
    function collect() external view override returns (bytes memory) {
        uint256 tokenBalance = 0;
        uint256 size;
        address token = TOKEN;
        address pool = POOL;

        // Avoid calling non-contracts
        assembly {
            size := extcodesize(token)
        }
        if (size > 0) {
            try IERC20(token).balanceOf(pool) returns (uint256 bal) {
                tokenBalance = bal;
            } catch {
                // Leave as 0 if call fails
            }
        }

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

        uint256 newBal = abi.decode(data[0], (uint256));
        uint256 prevBal = abi.decode(data[1], (uint256));

        if (newBal > prevBal && (newBal - prevBal) >= THRESHOLD) {
            return (true, abi.encode(prevBal, newBal, newBal - prevBal));
        }

        return (false, bytes(""));
    }
}
