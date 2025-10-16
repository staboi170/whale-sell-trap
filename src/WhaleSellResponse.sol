// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WhaleSellResponse {
    event WhaleSellDetected(uint256 latestBalance, uint256 previousBalance, uint256 delta);

    function respondToWhaleSell(uint256 latestBalance, uint256 previousBalance, uint256 delta) external {
        emit WhaleSellDetected(latestBalance, previousBalance, delta);
    }
}
