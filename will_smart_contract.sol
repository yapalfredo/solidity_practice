pragma solidity > 0.5.7;

//This is a simple smart contract version of a will.
contract Will {
    
    address owner;
    uint fortune_amount;
    bool deceased;
    
    //payable allows the fucntion to send and receive payment
    constructor() payable{
        //msg.sender will set the contract deployer to be the owner
        //of the contract
        owner = msg.sender;
        //This will initialize the value of fortune_amount during
        //contract deployment
        fortune_amount = msg.value;
        deceased = false;
    }
    
    //declare a modifier so only contract owner can run a contract
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    //declare a modifier so that only contract can only distribute funds if the will owner
    //is Deceased
    modifier isDeceased {
        require(deceased == true);
        _;
    }
    
    //Array of wallets for beneficiaries
    address payable[] beneficiariesWallets;
    
    //key store values (mapping) for wallets and inheritance
    mapping (address => uint) inheritance;
    
    //set inheritance for wallet address  
    function setInheritance(address payable wallet, uint amount) public onlyOwner{
        beneficiariesWallets.push(wallet);
        inheritance[wallet] = amount;
    }
    
    //deliver inheritance to each beneficiary upon death of will owner
    function deliverInheritance() private isDeceased {
        for (uint i = 0; i < beneficiariesWallets.length; i++){
            //iterate through each wallet address and transfer the inheritance money
            //.transfer() is a solidity function used to transfer funds.
            beneficiariesWallets[i].transfer(inheritance[beneficiariesWallets[i]]);
        }
    }
    
    //Oracle / Trigger - when the will owner passes away
    //the contract will execute
    function isNowDeceased() public onlyOwner {
        deceased = true;
        deliverInheritance();
    }
    
}
