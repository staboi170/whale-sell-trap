// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WhaleSellResponse
/// @notice Emits an event when a whale sell is detected by the trap.
contract WhaleSellResponse {
    event WhaleSellDetected(
        uint256 prevBalance,
        uint256 newBalance,
        uint256 delta
    );

    // MUST match drosera.toml configuration exactly
    function respondToWhaleSell(
        uint256 prevBalance,
        uint256 newBalance,
        uint256 delta
    ) external {
        emit WhaleSellDetected(prevBalance, newBalance, delta);
    }
}
