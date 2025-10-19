#  🐋 WhaleSellTrap

WhaleSellTrap is a Drosera smart trap designed to detect large sell-offs of a specific ERC20 token into a liquidity pool on the Hoodi network.

When the pool’s token balance suddenly increases by a significant amount, it indicates a whale has sold a large volume of tokens — and the trap responds automatically.

---

## 📦 Prerequisites

1. Install sudo and other pre-requisites :
```bash
apt update && apt install -y sudo && sudo apt-get update && sudo apt-get upgrade -y && sudo apt install curl ufw iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y
```
3. Install environment requirements:
Drosera Cli
```bash
curl -L https://app.drosera.io/install | bash
source /root/.bashrc
droseraup
```
Foundry cli
```bash
curl -L https://foundry.paradigm.xyz | bash
source /root/.bashrc
foundryup
```
Bun
```bash
curl -fsSL https://bun.sh/install | bash
source /root/.bashrc
```
   

## ⚙️ Setup

Clone this repository

```bash
git clone https://github.com/staboi170/whale-sell-trap
cd whale-sell-trap
```
Compile contract

```bash
forge build
```
Whitelist wallet address
```bash
nano drosera.toml
# Put your EVM public address funded with hoodi ETH in whitelist
e.g ["0xedj..."]  
```
Deploy the trap
```bash
DROSERA_PRIVATE_KEY=xxx drosera apply
```
 Replace xxx with your EVM wallet privatekey (Ensure it's funded with Hoodi ETH, you can claim 1E from hoodifaucet.io)
