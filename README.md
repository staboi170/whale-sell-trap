🐋 WhaleSellTrap

WhaleSellTrap is a Drosera
 smart trap designed to detect large sell-offs of a specific ERC20 token into a liquidity pool on the Hoodi network.

When the pool’s token balance suddenly increases by a significant amount, it indicates a whale has sold a large volume of tokens — and the trap responds automatically.

⚙️ Overview
Component	            Description
Trap Contract	        WhaleSellTrap.sol — monitors pool token balances.
Response Contract	    WhaleSellResponse.sol — logs detected whale sells (you deploy this).
Network             	Hoodi (EVM-compatible)
RPC                 	https://ethereum-hoodi-rpc.publicnode.com
Drosera Relay       	https://relay.hoodi.drosera.io
🧠 How It Works

Collect phase – The trap queries the ERC20 token’s balanceOf(pool) to see how many tokens are currently in the pool.

Compare phase – If the balance rises sharply (by ≥ 50,000 tokens), it infers a whale just sold.

Respond phase – Calls the respondToWhaleSell() function on your response contract, which can log or trigger any custom behavior.

🧩 Key Parameters
Variable	Value                                  	    Description
TOKEN	    0x64f1904d1b419c6889BDf3238e31A138E258eA68	ERC20 token monitored
POOL	    0xB683004402e07618c67745A4a7DBE99839388136	Liquidity pool address
THRESHOLD	50,000 * 1e18	Minimum token inflow to trigger alert
