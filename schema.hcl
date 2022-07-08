// Last 180 days
start_time = format_date("02-01-2006 15:04", "01-01-2022 00:00")
end_time = format_date("02-01-2006 15:04", "07-07-2022 00:00")
time_interval = 3600 * 12

variables = {
  // The top debt holders
  top_sds_holders = [
    "0x99F4176EE457afedFfCB1839c7aB7A030a5e4A92",// treasury
    "0x8cA24021E3Ee3B5c241BBfcee0712554D7Dc38a1",
    "0xC8C2b727d864CC75199f5118F0943d2087fB543b" ,
    "0x27Cc4d6bc95b55a3a981BF1F1c7261CDa7bB0931",
    "0xE7178Db9e123f053AAbfd2C28520bf6b63cB4A47",
    "0xC34a7c65aa08Cb36744bdA8eEEC7b8e9891e147C",
    "0x6Db65261a4Fc3F88E60B7470e9b38Db0B22E785C",
    "0x629b1166064abc68a4eA392E37Cd4133103d7516"
  ]
}

// loop {
//   items = top_sds_holders

//   query "top_snx_stakers" {
//     chain = "ethereum"

//     contract {
//       address = "0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F" // SNX token
//       abi = "snx.abi.json"

//       method "collateral" {
//         inputs = {
//           account = item
//         } 

//         outputs = ["collateral"]
//       }

//       method "collateralisationRatio" {
//         inputs = {
//           _issuer = item
//         } 

//         outputs = ["ratio"]
//       }

//       method "totalSupply" {
//         outputs = ["totalSupply"]
//       }
//     }

//     save {
//       block = blocknumber
//       time = timestamp

//       account = account
//       collateral = parse_decimals(collateral, 18)
//       ratio = ratio
//       totalSupply = totalSupply
//     }
//   }
// }

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

// query "snx_stakers_optimism" {
//   chain = "optimism"

//   contract {
//     abi = "sds.abi.json"
//     // address = "0x89FCb32F29e509cc42d0C8b6f058C993013A843F" # mainnet
//     address = "0x45c55BF488D3Cb8640f12F63CbeDC027E8261E79"

//     event "Mint" {
//       outputs = ["account", "amount"]
//     }
//   }

//   save {
//     time = timestamp
//     block = blocknumber
//     account = account
//     debt = parse_decimals(amount, 18)
//     event = event_name
//   }
// }

query "gmx_staked_avax" {
  chain = "avax"

  contract {
    abi = "erc20.abi.json"
    // address = "0xfc5A1A6EB076a2C7aD06eD22C90d7E710E35ad0a" # arbi
    address = "0x62edc0692BD897D2295872a9FFCac5425011c661" # avax

    method "balanceOf" {
      inputs = {
        // _owner = "0x908C4D94D34924765f1eDc22A1DD098397c59dD4" # arbi
        _owner = "0x2bD10f8E93B3669b6d42E74eEedC65dd1B0a1342" # avax
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
