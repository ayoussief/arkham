# Libraries

| Name                     | Description |
|--------------------------|-------------|
| *libarkham_cli*         | RPC client functionality used by *arkham-cli* executable |
| *libarkham_common*      | Home for common functionality shared by different executables and libraries. Similar to *libarkham_util*, but higher-level (see [Dependencies](#dependencies)). |
| *libarkham_consensus*   | Consensus functionality used by *libarkham_node* and *libarkham_wallet*. |
| *libarkham_crypto*      | Hardware-optimized functions for data encryption, hashing, message authentication, and key derivation. |
| *libarkham_kernel*      | Consensus engine and support library used for validation by *libarkham_node*. |
| *libarkhamqt*           | GUI functionality used by *arkham-qt* and *arkham-gui* executables. |
| *libarkham_ipc*         | IPC functionality used by *arkham-node*, *arkham-wallet*, *arkham-gui* executables to communicate when [`-DENABLE_IPC=ON`](multiprocess.md) is used. |
| *libarkham_node*        | P2P and RPC server functionality used by *arkhamd* and *arkham-qt* executables. |
| *libarkham_util*        | Home for common functionality shared by different executables and libraries. Similar to *libarkham_common*, but lower-level (see [Dependencies](#dependencies)). |
| *libarkham_wallet*      | Wallet functionality used by *arkhamd* and *arkham-wallet* executables. |
| *libarkham_wallet_tool* | Lower-level wallet functionality used by *arkham-wallet* executable. |
| *libarkham_zmq*         | [ZeroMQ](../zmq.md) functionality used by *arkhamd* and *arkham-qt* executables. |

## Conventions

- Most libraries are internal libraries and have APIs which are completely unstable! There are few or no restrictions on backwards compatibility or rules about external dependencies. An exception is *libarkham_kernel*, which, at some future point, will have a documented external interface.

- Generally each library should have a corresponding source directory and namespace. Source code organization is a work in progress, so it is true that some namespaces are applied inconsistently, and if you look at [`add_library(arkham_* ...)`](../../src/CMakeLists.txt) lists you can see that many libraries pull in files from outside their source directory. But when working with libraries, it is good to follow a consistent pattern like:

  - *libarkham_node* code lives in `src/node/` in the `node::` namespace
  - *libarkham_wallet* code lives in `src/wallet/` in the `wallet::` namespace
  - *libarkham_ipc* code lives in `src/ipc/` in the `ipc::` namespace
  - *libarkham_util* code lives in `src/util/` in the `util::` namespace
  - *libarkham_consensus* code lives in `src/consensus/` in the `Consensus::` namespace

## Dependencies

- Libraries should minimize what other libraries they depend on, and only reference symbols following the arrows shown in the dependency graph below:

<table><tr><td>

```mermaid

%%{ init : { "flowchart" : { "curve" : "basis" }}}%%

graph TD;

arkham-cli[arkham-cli]-->libarkham_cli;

arkhamd[arkhamd]-->libarkham_node;
arkhamd[arkhamd]-->libarkham_wallet;

arkham-qt[arkham-qt]-->libarkham_node;
arkham-qt[arkham-qt]-->libarkhamqt;
arkham-qt[arkham-qt]-->libarkham_wallet;

arkham-wallet[arkham-wallet]-->libarkham_wallet;
arkham-wallet[arkham-wallet]-->libarkham_wallet_tool;

libarkham_cli-->libarkham_util;
libarkham_cli-->libarkham_common;

libarkham_consensus-->libarkham_crypto;

libarkham_common-->libarkham_consensus;
libarkham_common-->libarkham_crypto;
libarkham_common-->libarkham_util;

libarkham_kernel-->libarkham_consensus;
libarkham_kernel-->libarkham_crypto;
libarkham_kernel-->libarkham_util;

libarkham_node-->libarkham_consensus;
libarkham_node-->libarkham_crypto;
libarkham_node-->libarkham_kernel;
libarkham_node-->libarkham_common;
libarkham_node-->libarkham_util;

libarkhamqt-->libarkham_common;
libarkhamqt-->libarkham_util;

libarkham_util-->libarkham_crypto;

libarkham_wallet-->libarkham_common;
libarkham_wallet-->libarkham_crypto;
libarkham_wallet-->libarkham_util;

libarkham_wallet_tool-->libarkham_wallet;
libarkham_wallet_tool-->libarkham_util;

classDef bold stroke-width:2px, font-weight:bold, font-size: smaller;
class arkham-qt,arkhamd,arkham-cli,arkham-wallet bold
```
</td></tr><tr><td>

**Dependency graph**. Arrows show linker symbol dependencies. *Crypto* lib depends on nothing. *Util* lib is depended on by everything. *Kernel* lib depends only on consensus, crypto, and util.

</td></tr></table>

- The graph shows what _linker symbols_ (functions and variables) from each library other libraries can call and reference directly, but it is not a call graph. For example, there is no arrow connecting *libarkham_wallet* and *libarkham_node* libraries, because these libraries are intended to be modular and not depend on each other's internal implementation details. But wallet code is still able to call node code indirectly through the `interfaces::Chain` abstract class in [`interfaces/chain.h`](../../src/interfaces/chain.h) and node code calls wallet code through the `interfaces::ChainClient` and `interfaces::Chain::Notifications` abstract classes in the same file. In general, defining abstract classes in [`src/interfaces/`](../../src/interfaces/) can be a convenient way of avoiding unwanted direct dependencies or circular dependencies between libraries.

- *libarkham_crypto* should be a standalone dependency that any library can depend on, and it should not depend on any other libraries itself.

- *libarkham_consensus* should only depend on *libarkham_crypto*, and all other libraries besides *libarkham_crypto* should be allowed to depend on it.

- *libarkham_util* should be a standalone dependency that any library can depend on, and it should not depend on other libraries except *libarkham_crypto*. It provides basic utilities that fill in gaps in the C++ standard library and provide lightweight abstractions over platform-specific features. Since the util library is distributed with the kernel and is usable by kernel applications, it shouldn't contain functions that external code shouldn't call, like higher level code targeted at the node or wallet. (*libarkham_common* is a better place for higher level code, or code that is meant to be used by internal applications only.)

- *libarkham_common* is a home for miscellaneous shared code used by different Arkham Core applications. It should not depend on anything other than *libarkham_util*, *libarkham_consensus*, and *libarkham_crypto*.

- *libarkham_kernel* should only depend on *libarkham_util*, *libarkham_consensus*, and *libarkham_crypto*.

- The only thing that should depend on *libarkham_kernel* internally should be *libarkham_node*. GUI and wallet libraries *libarkhamqt* and *libarkham_wallet* in particular should not depend on *libarkham_kernel* and the unneeded functionality it would pull in, like block validation. To the extent that GUI and wallet code need scripting and signing functionality, they should be able to get it from *libarkham_consensus*, *libarkham_common*, *libarkham_crypto*, and *libarkham_util*, instead of *libarkham_kernel*.

- GUI, node, and wallet code internal implementations should all be independent of each other, and the *libarkhamqt*, *libarkham_node*, *libarkham_wallet* libraries should never reference each other's symbols. They should only call each other through [`src/interfaces/`](../../src/interfaces/) abstract interfaces.

## Work in progress

- Validation code is moving from *libarkham_node* to *libarkham_kernel* as part of [The libarkhamkernel Project #27587](https://github.com/arkham/arkham/issues/27587)
