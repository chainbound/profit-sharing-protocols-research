# Research: Profit Sharing Protocols

## Synthetix

### 1. Getting all fees
* On every swap, a fee in sUSD is minted to the [Fee Address](https://etherscan.io/address/0xfeefeefeefeefeefeefeefeefeefeefeefeefeef)
* With Apollo, we filter every `Transfer` event on `sUSD` where `from` == `address(0)`
and `to` == `0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF`:

* **Mainnet**
```hcl
// Last 180 days
start_time = format_date("02-01-2006 15:04", "01-01-2022 00:00")
end_time = format_date("02-01-2006 15:04", "06-06-2022 00:00")

query "susd_fee_mints" {
  chain = "ethereum"

  contract {
    address = "0x57Ab1ec28D129707052df4dF418D58a2D46d5f51"
    abi = "erc20.abi.json"

    event "Transfer" {
      outputs = ["from", "to", "value"]
    }
  }

  // Every time a synth swap is made, the fee is minted to
  // the fee address. This is how we filter for those events.
  filter = [
    from == "0x0000000000000000000000000000000000000000",
    to == "0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF"
  ]

  save {
    timestamp = timestamp
    block = blocknumber
    tx = tx_hash

    // Parse raw sUSD value
    fee = parse_decimals(value, 18)
  }
}
```

* **Optimism**
```hcl
// Last 180 days
start_time = format_date("02-01-2006 15:04", "06-01-2022 00:00")
end_time = format_date("02-01-2006 15:04", "06-06-2022 00:00")

query "susd_fee_mints_optimism" {
  chain = "optimism"

  contract {
    address = "0x8c6f28f2F1A3C87F0f938b96d27520d9751ec8d9"
    abi = "erc20.abi.json"

    event "Transfer" {
      outputs = ["from", "to", "value"]
    }
  }

  // Every time a synth swap is made, the fee is minted to
  // the fee address. This is how we filter for those events.
  filter = [
    from == "0x0000000000000000000000000000000000000000",
    to == "0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF"
  ]

  save {
    timestamp = timestamp
    block = blocknumber
    tx = tx_hash

    // Parse raw sUSD value
    fee = parse_decimals(value, 18)
  }
}
```

### 2. Getting staked SNX over time
* We need to get staked SNX (total collateral value) over time.
* Problem: there is no global state variable keeping track of the amount of staked SNX or collateral ratio,
it's all individual. The SNX you stake doesn't even leave your wallet, but you get minted a debt token (SDS)
representing your debt in USD.
* To get all the addresses that ever staked SNX, we can filter all the `Mint` events on SDS.
* We can use these addresses to get the SNX staked. Because it's not feasible to do it for all the addresses,
we can filter out the top holders, look at all their claims over time and get an idea of the total APY.
* We can get the top SDS holders, get their share of the total staked SNX by looking at their collateral and collateral ratios, and then calculate the percentage of total fees they would make.

### 3. Getting claimed SNX

## GMX
### 1. Getting all staked GMX
* sGMX is the contract that holds all staked GMX, so we just have to get its balance over time.

```hcl
// Last 180 days
start_time = format_date("02-01-2006 15:04", "06-01-2022 00:00")
end_time = format_date("02-01-2006 15:04", "06-06-2022 00:00")
// 1hr interval
time_interval = 3600

// Do this for both chains
query "gmx_staked_avax" {
  chain = "avax"

  contract {
    abi = "erc20.abi.json"
    // address = "0xfc5A1A6EB076a2C7aD06eD22C90d7E710E35ad0a" # arbi
    address = "0x62edc0692BD897D2295872a9FFCac5425011c661"

    method "balanceOf" {
      inputs = {
        // _owner = "0x908C4D94D34924765f1eDc22A1DD098397c59dD4" # arbi
        _owner = "0x2bD10f8E93B3669b6d42E74eEedC65dd1B0a1342"
      }

      outputs = ["balance"]
    }
  }

  save {
    time = timestamp
    block = blocknumber

    gmx_staked = parse_decimals(balance, 18)
  }
}

```
* The rest of the stats can be downloaded from https://stats.gmx.io

## Maple