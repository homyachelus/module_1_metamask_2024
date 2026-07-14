// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";     // право на использование ERC20

contract Token is ERC20 {
    address owner;
    
    // передача параметров
    constructor () ERC20("Professional", "PROFI") {
        owner = msg.sender;

        _mint(msg.sender, 1000000 * 10**6);
    }

    // переопределение знаков на 6
    function decimals() public view virtual override returns (uint8) {
        return 6;
    }
}