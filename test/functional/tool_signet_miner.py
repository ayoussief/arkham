#!/usr/bin/env python3
# Copyright (c) 2022 The Arkham Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.
"""Test signet miner tool"""

import os.path
import shlex
import subprocess
import sys
import time

from test_framework.blocktools import DIFF_1_N_BITS
from test_framework.key import ECKey
from test_framework.script_util import key_to_p2wpkh_script
from test_framework.test_framework import ArkhamTestFramework
from test_framework.util import (
    assert_equal,
    wallet_importprivkey,
)
from test_framework.wallet_util import bytes_to_wif


CHALLENGE_PRIVATE_KEY = (42).to_bytes(32, 'big')


class SignetMinerTest(ArkhamTestFramework):
    def set_test_params(self):
        self.chain = "signet"
        self.setup_clean_chain = True
        self.num_nodes = 1

        # generate and specify signet challenge (simple p2wpkh script)
        privkey = ECKey()
        privkey.set(CHALLENGE_PRIVATE_KEY, True)
        pubkey = privkey.get_pubkey().get_bytes()
        challenge = key_to_p2wpkh_script(pubkey)
        self.extra_args = [[f'-signetchallenge={challenge.hex()}']]

    def skip_test_if_missing_module(self):
        self.skip_if_no_cli()
        self.skip_if_no_wallet()
        self.skip_if_no_arkham_util()

    def run_test(self):
        node = self.nodes[0]
        # import private key needed for signing block
        wallet_importprivkey(node, bytes_to_wif(CHALLENGE_PRIVATE_KEY), "now")

        # generate block with signet miner tool
        base_dir = self.config["environment"]["SRCDIR"]
        signet_miner_path = os.path.join(base_dir, "contrib", "signet", "miner")
        rpc_argv = node.binaries.rpc_argv() + [f"-datadir={node.cli.datadir}"]
        util_argv = node.binaries.util_argv() + ["grind"]
        subprocess.run([
                sys.executable,
                signet_miner_path,
                f'--cli={shlex.join(rpc_argv)}',
                'generate',
                f'--address={node.getnewaddress()}',
                f'--grind-cmd={shlex.join(util_argv)}',
                f'--nbits={DIFF_1_N_BITS:08x}',
                f'--set-block-time={int(time.time())}',
                '--poolnum=99',
            ], check=True, stderr=subprocess.STDOUT)
        assert_equal(node.getblockcount(), 1)


if __name__ == "__main__":
    SignetMinerTest(__file__).main()
