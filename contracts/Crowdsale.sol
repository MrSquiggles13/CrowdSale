pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "OpenZeppelin/openzeppelin-contracts@2.5.0/contracts/crowdsale/Crowdsale.sol";
import "OpenZeppelin/openzeppelin-contracts@2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "OpenZeppelin/openzeppelin-contracts@2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "OpenZeppelin/openzeppelin-contracts@2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "OpenZeppelin/openzeppelin-contracts@2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate,
        uint cap,
        uint openingTime,
        uint closingTime,
        uint goal,
        address payable wallet,
        PupperCoin token
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token)
        MintedCrowdsale()
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale token_sale = new PupperCoinSale(1, 300000000000000000000000000, now, now + 24 weeks, 300000000000000000000000000, wallet, token);
        token_sale_address = address(token_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
