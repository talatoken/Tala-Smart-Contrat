// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TALA is ERC20, Ownable {
    uint256 public constant FEE_PERCENTAGE = 200;
    uint256 public constant TOTAL_SUPPLY = 3_220_000 * 10 ** 6;
    address public feeRecipient;

    event FeeRecipientUpdated(address indexed newFeeRecipient);
    event TransferWithFee(
        address indexed from,
        address indexed to,
        uint256 amount,
        uint256 fee
    );

    constructor(address _feeRecipient, address _owner) ERC20("Tala", "1ozt") {
        require(_feeRecipient != address(0), "Invalid fee recipient");
        require(_owner != address(0), "Invalid owner address");

        feeRecipient = _feeRecipient;
        _mint(_owner, TOTAL_SUPPLY);
        transferOwnership(_owner);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function setFeeRecipient(address _feeRecipient) external onlyOwner {
        require(_feeRecipient != address(0), "Invalid address");
        feeRecipient = _feeRecipient;
        emit FeeRecipientUpdated(_feeRecipient);
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        uint256 fee = (amount * FEE_PERCENTAGE) / 100000;
        uint256 amountAfterFee = amount - fee;

        super._transfer(sender, feeRecipient, fee);
        super._transfer(sender, recipient, amountAfterFee);

        emit TransferWithFee(sender, recipient, amountAfterFee, fee);
    }
}
