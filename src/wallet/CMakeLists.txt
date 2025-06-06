# Copyright (c) 2023-present The Arkham Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or https://opensource.org/license/mit/.

# Wallet functionality used by arkhamd and arkham-wallet executables.
add_library(arkham_wallet STATIC EXCLUDE_FROM_ALL
  coincontrol.cpp
  coinselection.cpp
  context.cpp
  crypter.cpp
  db.cpp
  dump.cpp
  external_signer_scriptpubkeyman.cpp
  feebumper.cpp
  fees.cpp
  interfaces.cpp
  load.cpp
  migrate.cpp
  receive.cpp
  rpc/addresses.cpp
  rpc/backup.cpp
  rpc/coins.cpp
  rpc/encrypt.cpp
  rpc/signmessage.cpp
  rpc/spend.cpp
  rpc/transactions.cpp
  rpc/util.cpp
  rpc/wallet.cpp
  scriptpubkeyman.cpp
  spend.cpp
  sqlite.cpp
  transaction.cpp
  wallet.cpp
  walletdb.cpp
  walletutil.cpp
)
target_link_libraries(arkham_wallet
  PRIVATE
    core_interface
    arkham_common
    $<TARGET_NAME_IF_EXISTS:unofficial::sqlite3::sqlite3>
    $<TARGET_NAME_IF_EXISTS:SQLite::SQLite3>
    univalue
    Boost::headers
    $<TARGET_NAME_IF_EXISTS:USDT::headers>
)
