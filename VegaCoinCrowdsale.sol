pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol";



contract VegaCoinCrowdsale is Pausable, StandardToken {
    
    // Token Details
    string public name = "VegaCoin";
    string public symbol = "AAA";
    uint8 public decimals = 18;

    // Supply Details 
    uint256 constant public ICO_SUPPLY= 365000000e18;
    uint256 constant public TEAM_SUPPLY = 13520000e18;      
    uint256 constant public ALB_SUPPLY = 19800000e18;        
    uint256 constant public MAX_BOUNTY_TOKENS = 1000000e18;

    // Ether details
    uint256 private softCap = 10000 ether;
    uint256 private hardCap = 60000 ether;
    uint256 public currentAAAPerEther = 5000;

    // Current Round Details
    uint256 public currentRoundHardCap;
    string public currentRoundName;

    //uint8 public currentRoundBonus = 25;         //for development
    uint8 public currentRoundBonus;
    uint256 public currentRoundTokensSold;
    uint256 public currentRoundStartDate;
    uint256 public currentRoundEndDate;
    uint256 public currentRoundRemainingTokens;
    //bool public currentRoundCondition = false;   //for development
    bool public currentRoundCondition;
    //uint8 public currentRoundNumber = 0;         //for development
    uint8 public currentRoundNumber;
    
    // Events
    event Mint(address indexed to, uint256 amount);
    event MintFinished();
    
    // Addresses
    address public bountyAddress = 0x453990C0AA4b3C616CEeC05f5D909539920432F4;
    address public teamFund = 0x833cE4a216331af41961D01c5331e03EBfffb888;   // team wallet address
    address public albFund = 0xCd637E775C8ABC095BEc957807f6E7E6628931C2;    // advisors_and_legal wallet address
    uint256 public bountyCount;

    struct Round {
        string roundName;
        uint256 roundStartDate;
        uint256 roundEndDate;
        uint256 roundTokensSold;
        uint256 roundEthRaised;
        uint256 roundHardCap;
        uint8 roundBonus;
        bool roundCondition;
    }

    mapping (uint256 => Round) public rounds;
    mapping (address => uint256) public bonus;
    mapping (address => uint256) public etherContributed;

    uint256 public totalEtherRaised = 0;
    uint256 public totalTokensSold = 0;
    bool public mintingFinished = false;
    uint public sCap = 10000;
    uint public hCap = 60000;
    uint32 public StartDate = 1537605473; 
    uint32 public EndDate = 1537691872;

    constructor() public{
        
        balances[msg.sender] = ICO_SUPPLY;
        totalSupply_ = ICO_SUPPLY;
        currentRoundNumber = 0;

        //Round One
        Round storage roundOne = rounds[1];
        roundOne.roundName = "Round 1";
        roundOne.roundStartDate = 1532170800;          
        roundOne.roundEndDate = 1532257200;          
        roundOne.roundTokensSold = 0;
        roundOne.roundEthRaised = 0;
        roundOne.roundHardCap = 62500000e18 ;
        roundOne.roundBonus = 25;
        roundOne.roundCondition = true;

       //Round Two
        Round storage roundTwo = rounds[2];
        roundTwo.roundName = "Round 2";
        roundTwo.roundStartDate = 1532343600;        
        roundTwo.roundEndDate = 1532430000;          
        roundTwo.roundTokensSold = 0;
        roundTwo.roundEthRaised = 0;
        roundTwo.roundHardCap = 60000000e18;
        roundTwo.roundBonus = 20;
        roundTwo.roundCondition = true;

       //Round Three
        Round storage roundThree = rounds[3];
        roundThree.roundName = "Round 3";
        roundThree.roundStartDate = 1532516400;        
        roundThree.roundEndDate = 1532602800;          
        roundThree.roundTokensSold = 0;
        roundThree.roundEthRaised = 0;
        roundThree.roundHardCap = 57500000e18;
        roundThree.roundBonus=15;
        roundThree.roundCondition = true;

        //Round Four
        Round storage roundFour = rounds[4];
        roundFour.roundName = "Round 4";
        roundFour.roundStartDate = 1532689200;        
        roundFour.roundEndDate = 1532775600;          
        roundFour.roundTokensSold = 0;
        roundFour.roundEthRaised = 0;
        roundFour.roundHardCap = 55000000e18;
        roundFour.roundBonus = 10;
        roundFour.roundCondition = true;

        //Round Five
        Round storage roundFive = rounds[5];
        roundFive.roundName = "round 5";
        roundFive.roundStartDate = 1531979961;        
        roundFive.roundEndDate = 1532088000;          
        roundFive.roundTokensSold = 0;
        roundFive.roundEthRaised = 0;
        roundFive.roundHardCap = 52500000e18;
        roundFive.roundBonus = 5;
        roundFive.roundCondition = true;

        //Round Six
        Round storage roundSix = rounds[6];
        roundSix.roundName = "Round 6";
        roundSix.roundStartDate = 1531979961;        
        roundSix.roundEndDate = 1532088000;          
        roundSix.roundTokensSold = 0;
        roundSix.roundEthRaised = 0;
        roundSix.roundHardCap = 50000000e18;
        roundSix.roundBonus = 0;
        roundSix.roundCondition = true;
        
        mint(bountyAddress,MAX_BOUNTY_TOKENS);
   
    }   
    
    // Modifiers
    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    modifier softCapNotReached(){
        require (totalEtherRaised < softCap);
        _;
    }
    
    modifier saleIsOn(){
        require((now > currentRoundStartDate) && (now < currentRoundEndDate));
        _;
    }
    
    modifier currentSaleisFinished(){
        require((now > currentRoundEndDate) || (currentRoundTokensSold >= currentRoundHardCap)) ;
        _;
    }
    
    modifier saleIsFinished(){
        require(now > EndDate + 30 days); 
        _;
    }
    
    modifier canTransfer(address sender){
        if (sender == teamFund) 
            require(now > (EndDate + 365 days));
        else if (sender == albFund) 
            require(now > (EndDate + 365 days));
        else  
            require(now > (EndDate + 30 days));    
         _;
    }
    
    modifier softCapReached(){
        require(totalEtherRaised >= softCap);
        _;
    }
    //
    modifier roundSixOver(){
        require ((now > EndDate) || (currentRoundTokensSold == currentRoundHardCap) );
        _;
    }
    
    //onlyOwner
    function setCrowdsaleStage(uint8 _roundNumber)  external onlyOwner{
        require(_roundNumber > 0 && _roundNumber <= 6);
        currentRoundName= rounds[_roundNumber].roundName;
        currentRoundHardCap = rounds[_roundNumber].roundHardCap;
        currentRoundBonus = rounds[_roundNumber].roundBonus; 
        currentRoundTokensSold = rounds[_roundNumber].roundTokensSold;  
        currentRoundStartDate = rounds[_roundNumber].roundStartDate;
        currentRoundEndDate = rounds[_roundNumber].roundEndDate;
        currentRoundCondition = rounds[_roundNumber].roundCondition;
        currentRoundNumber = _roundNumber; 
    }

    function getCrowdsaleStage() external view returns (string, uint256, uint256, uint256, uint256)  {
        
        return(
            currentRoundName,
            currentRoundStartDate,
            currentRoundEndDate,
            currentRoundHardCap,
            currentRoundHardCap.sub(currentRoundTokensSold)        
        );
        
    }
    
    //canTransfer(msg.sender)
    function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool) {
        return super.transfer(_to, _value);
    }
    //canTransfer(_from)
    function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    //internal 
    function calculateBonus(uint256 _tok) internal view returns (uint256) {
        return((_tok.mul(currentRoundBonus)).div(100)); 
    }

    function getAccountDetails(address _yourAddress) external view returns (uint256,uint256) {
        return(balances[_yourAddress].sub(bonus[_yourAddress]), bonus[_yourAddress]);
    }

    function () external  saleIsOn whenNotPaused payable  {//saleIsonn whenNotPaused

        require(currentRoundCondition == true);
        require(msg.value > 100000000000000000);
        require (totalEtherRaised + msg.value <= hardCap);
        uint256 tokens;
        uint256 bonustokens;
        tokens = msg.value * currentAAAPerEther;
        require(currentRoundTokensSold + tokens <= currentRoundHardCap);
        totalEtherRaised = totalEtherRaised.add(msg.value);
        totalTokensSold = totalTokensSold.add(tokens); 
        bonustokens = calculateBonus(tokens);
        balances[owner] = balances[owner].sub(tokens);
        bonus[msg.sender] = bonus[msg.sender].add(bonustokens);

        balances[msg.sender] = balances[msg.sender].add(tokens);
        emit Transfer(owner, msg.sender, tokens);
        
        etherContributed[msg.sender] =  etherContributed[msg.sender].add(msg.value);
        mint(msg.sender,bonustokens);
        currentRoundTokensSold = currentRoundTokensSold.add(tokens);

    }
    //onlyOwner saleIsFinished  softCapReached
    function withdrawEther() external onlyOwner saleIsFinished softCapReached{
        //require(owner != 0);
        address thisAddress = this;
        owner.transfer(thisAddress.balance);
    }

    //refund of ether if the softcap is not reached.
    //saleIsFinished softCapNotReached
    function refundEther(address _yourAddresss) external saleIsFinished softCapNotReached{

        uint256 value = etherContributed[_yourAddresss];
        etherContributed[_yourAddresss] = 0;
        _yourAddresss.transfer(value);
        totalEtherRaised=totalEtherRaised.sub(value);
        
    }
    
    function endCurrentRoundSale() external currentSaleisFinished onlyOwner{
    //either the hardcap is reached or time for that round has ended.
        uint256 burnRemaining;
        currentRoundCondition = false;
        if (currentRoundNumber == 6) {
            
            burnRemaining = ICO_SUPPLY.sub(totalTokensSold);
            balances[owner]= balances[owner].sub(burnRemaining);
            totalSupply_ = totalSupply_.sub(burnRemaining);
            mint(teamFund,TEAM_SUPPLY);
            mint(albFund,ALB_SUPPLY);
            finishMinting();
            
        }
        
    }
    
    function mint(address _to, uint256 _amount) public canMint returns (bool){
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
   }
   
   function finishMinting() public onlyOwner canMint returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
   }
   
  function sendBounty(address to, uint256 tokens) external onlyOwner returns (bool) {
        uint256 tok = tokens.mul(1e18);
        require ((tok.add(bountyCount))  < MAX_BOUNTY_TOKENS );
        balances[bountyAddress]= balances[bountyAddress].sub(tok);
        emit Transfer(bountyAddress, to, tok);
        balances[to] = balances[to].add(tok);
        bountyCount = bountyCount.add(tok);
        return true;
    }

    function setDate(uint32 startDate, uint32 endDate) external returns (bool) {
        StartDate = startDate;
        EndDate = endDate;
        return true;
    }

}
