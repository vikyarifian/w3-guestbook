# w3-guestbook

Decentralized guestbook and attendance logger (*buku tamu & absensi*) for internal corporate tech talks and townhalls on EVM-compatible networks.

The project consists of a Solidity smart contract (`BukuTamu.sol`), Foundry deployment/test scripts, and a TypeScript utility script using Viem for fetching and parsing guestbook entries off-chain.

## Features

- On-chain record storage for visitor addresses, timestamps, and optional feedback notes
- Per-wallet rate-limiting cooldown to prevent spam entries during live townhalls
- Admin functions managed by event organizers (`panitia`)
- TypeScript reader script built with Viem (`v2`) for efficient log query and parsing
- Foundry unit tests for core registration flows and event emissions

## Tech Stack

- **Smart Contracts:** Solidity 0.8.24, Foundry
- **Client Scripting:** TypeScript 5.0, Viem

## Prerequisites

- [Foundry](https://getfoundry.sh/)
- Node.js 20+ and `pnpm` (or `npm`)

## Setup & Installation

```bash
# Clone repository
git clone https://github.com/corporate-it/w3-guestbook.git
cd w3-guestbook

# Install Node dependencies
pnpm install

# Build contracts
forge build
```

## Testing

Run contract unit tests using Foundry:

```bash
forge test
```

## Deployment

Deploy `BukuTamu` contract to your target EVM network:

```bash
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url <RPC_URL> \
  --private-key <PRIVATE_KEY> \
  --broadcast
```

*Note: The deployer address becomes the contract `panitia` (owner), which can adjust the attendance cooldown period (`jedaAbsensi`).*

## Off-chain Log Reader (Viem)

To fetch recorded guestbook entries off-chain using TypeScript:

```typescript
import { createPublicClient, http, parseAbiItem } from 'viem';
import { mainnet } from 'viem/chains';

const client = createPublicClient({
  chain: mainnet,
  transport: http(process.env.RPC_URL),
});

// Viem parseContractLogs workaround: RPC block range limitation on standard node endpoints
// Fetching in chunks of 2000 blocks to avoid node rate limits / response payload bounds
export async function getAttendanceLogs(contractAddress: `0x${string}`, fromBlock: bigint, toBlock: bigint) {
  const chunkSize = 2000n;
  let logs: any[] = [];
  
  for (let current = fromBlock; current < toBlock; current += chunkSize) {
    const end = current + chunkSize > toBlock ? toBlock : current + chunkSize;
    const chunkLogs = await client.getLogs({
      address: contractAddress,
      event: parseAbiItem('event KehadiranDicatat(address indexed visitor, uint256 timestamp, string pesan)'),
      fromBlock: current,
      toBlock: end,
    });
    logs = logs.concat(chunkLogs);
  }
  
  return logs;
}
```

Run the reader script:

```bash
pnpm run read-logs
```

## License

Internal Corporate License - Restricted to company infrastructure and internal networks.
