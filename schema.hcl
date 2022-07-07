// Last 180 days
start_time = format_date("02-01-2006 15:04", "06-01-2022 00:00")
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