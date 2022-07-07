# Research: Profit Sharing Protocols

## Synthetix

### 1. Getting all fees
* On every swap, a fee in sUSD is minted to the [Fee Address](https://etherscan.io/address/0xfeefeefeefeefeefeefeefeefeefeefeefeefeef)
* With Apollo, we filter every `Transfer` event on `sUSD` where `from` == `address(0)`
and `to` == `0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF`:

```hcl
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

**Running**
```bash
apollo --rate-limit 500 --csv --log-level 0 
```
```
11:05:02.412 DBG [chainservice] query completed                query=0-susd_fee_mints
11:05:02.412 INF [chainservice] contract_calls: 0 requests     chain=ethereum
11:05:02.412 INF [chainservice] header_by_number: 19844 requests chain=ethereum
11:05:02.412 INF [chainservice] subscribe_logs: 0 requests     chain=ethereum
11:05:02.412 INF [chainservice] filter_logs: 51 requests       chain=ethereum
11:05:02.412 INF [chainservice] cache_hits: 11901 requests     chain=ethereum
11:05:02.412 INF [chainservice] processing_time: 1m23.524337116s chain=ethereum
```