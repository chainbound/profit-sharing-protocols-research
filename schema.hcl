// Last 180 days
start_time = format_date("02-01-2006 15:04", "20-03-2021 00:00")
end_time = format_date("02-01-2006 15:04", "06-06-2022 00:00")
time_interval = 3600 * 12

// query "susd_fee_mints_optimism" {
//   chain = "optimism"

//   contract {
//     address = "0x8c6f28f2F1A3C87F0f938b96d27520d9751ec8d9"
//     abi = "erc20.abi.json"

//     event "Transfer" {
//       outputs = ["from", "to", "value"]
//     }
//   }

//   // Every time a synth swap is made, the fee is minted to
//   // the fee address. This is how we filter for those events.
//   filter = [
//     from == "0x0000000000000000000000000000000000000000",
//     to == "0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF"
//   ]

//   save {
//     timestamp = timestamp
//     block = blocknumber
//     tx = tx_hash

//     to = to

//     // Parse raw sUSD value
//     fee = parse_decimals(value, 18)
//   }
// }
query "gmx_staked_arbi" {
  chain = "arbitrum"

  contract {
    abi = "erc20.abi.json"
    address = "0xfc5A1A6EB076a2C7aD06eD22C90d7E710E35ad0a" # arbi
    // address = "0x62edc0692BD897D2295872a9FFCac5425011c661"

    method "balanceOf" {
      inputs = {
        _owner = "0x908C4D94D34924765f1eDc22A1DD098397c59dD4" # arbi
        // _owner = "0x2bD10f8E93B3669b6d42E74eEedC65dd1B0a1342"
      }

      outputs = ["balance"]
    }
  }

  save {
    time = timestamp
    block = blocknumber

    balance = parse_decimals(balance, 18)
  }
}
