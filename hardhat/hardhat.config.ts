import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const acc_0_owner_private_key = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
const acc_1_tom_private_key = "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d";
const acc_2_max_private_key = "0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a";
const acc_3_jack_private_key = "0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6";

const config: HardhatUserConfig = {
    solidity: {
        version: "0.8.24",
        settings: {           // +
            optimizer: {
                enabled: true,
                runs: 200,
            },
            evmVersion: "cancun"        // +
        },
    },
    networks: {
        localhost: {
            url: "http://127.0.0.1:8545",
        },
        hardhat: {
            hardfork: "cancun",        // +
            accounts: [
                {
                    privateKey: acc_0_owner_private_key, balance: "100000000000000000000000",
                },
                {
                    privateKey: acc_1_tom_private_key, balance: "100000000000000000000000",
                },
                {
                    privateKey: acc_2_max_private_key, balance: "100000000000000000000000",
                },
                {
                    privateKey: acc_3_jack_private_key, balance: "100000000000000000000000",
                }
            ]
        }
    }
};

export default config;
