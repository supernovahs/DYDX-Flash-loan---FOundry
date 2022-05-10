// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "../Contract.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";



    interface WETH9{
        function deposit() external payable ;

        function withdraw(uint) external ;

        function transfer(address, uint) external returns (bool);

        function balanceOf(address) external returns (uint);

    }

contract ContractTest is DSTest {
    // intializing WEth contract on Eth mainnet
    WETH9 public WETH;

    TestDyDxSoloMargin public flashloancontract;
    Vm public vm;
    // msg.sender address ie owner
    address immutable owner = address(0x1337);
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public wethholder = 0x52621cFe56Ea85588C14411360369Bf3F190F414;
    function setUp() public {
        WETH = WETH9(weth);
        vm = Vm(HEVM_ADDRESS);
        flashloancontract= new TestDyDxSoloMargin();
        // giving bot address 1 ether
        vm.deal(owner, 100000000000000000);
        // Checking weth balance of flash loan contract before initiating flash loan  
        uint bal = WETH.balanceOf(address(flashloancontract));
        console.log("balance of flashloancontract",bal);
        // using msg.sender for the next transaction to be a random weth holder taken from etherscan. 
        // This weth holder transfers 2 wei worth of WETH to our flashloan contract to pay back dydx flash loan fees
        // which is equal to 2 wei  in WETH
        vm.prank(wethholder);
        
        WETH.transfer(address(flashloancontract),2);
    }

    function testExample() public {
        // msg.sender for all transactions below set to owner address 
        vm.startPrank(owner);
        // initiating flash loan
        flashloancontract.initiateFlashLoan(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,100000000000000000000);
        // checking balance of flash loan after paying back the loan
        uint balance = WETH.balanceOf(address(flashloancontract));
        console.log("balance fo flashloan contract",balance);
    }
}
