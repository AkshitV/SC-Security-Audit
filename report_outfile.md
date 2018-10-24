## Sūrya's Description Report

### Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| VegaCoinCrowdsale.sol | 44e3f05c3675e302202d911050fdd64b25797fb7 |


### Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **VegaCoinCrowdsale** | Implementation | Pausable, StandardToken |||
| └ | \<Constructor\> | Public ❗️ | 🛑  | |
| └ | setCrowdsaleStage | External ❗️ | 🛑  | onlyOwner |
| └ | getCrowdsaleStage | External ❗️ |   | |
| └ | transfer | Public ❗️ | 🛑  | |
| └ | transferFrom | Public ❗️ | 🛑  | |
| └ | calculateBonus | Public ❗️ |   | |
| └ | getAccountDetails | External ❗️ |   | |
| └ | \<Fallback\> | External ❗️ |  💵 | |
| └ | withdrawEther | External ❗️ | 🛑  | |
| └ | refundEther | External ❗️ | 🛑  | |
| └ | endCurrentRoundSale | External ❗️ | 🛑  | currentSaleisFinished onlyOwner |
| └ | mint | Public ❗️ | 🛑  | canMint |
| └ | finishMinting | Public ❗️ | 🛑  | onlyOwner canMint |
| └ | sendBounty | External ❗️ | 🛑  | |
| └ | setDate | External ❗️ | 🛑  | onlyOwner |
| └ | setBountyAddress | External ❗️ | 🛑  | onlyOwner |
| └ | setTeamAddress | External ❗️ | 🛑  | onlyOwner |
| └ | setAlbAddress | External ❗️ | 🛑  | onlyOwner |


### Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |
