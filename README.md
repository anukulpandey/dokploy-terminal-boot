# Dokploy Terminal Boot

Dockerfile to boot into terminal using ssh

Default password is `reef:reefPass`, login using ssh reef@reef.host -P 2222

Change to root
`sudo su`

Change password

```
passwd
```

make a user `reef`

```
mkdir /home/reef/reef-node
```

Copy the node from local to ssh

```
scp -P 2222 /Users/anukul/Desktop/chain-upgrade-main.zip reef@reef.host:/home/reef/reef-node/
```

unzip the `chain-upgrade-main.zip`

```
unzip chain-upgrade-main.zip
```

Change directory to `chain-upgrade-main`

```
cd chain-upgrade-main
```

Build the node

```
cargo build --release
```

Once done, checking if the built binary has `reef-node` & `eth-rpc`

I can't see eth-rpc binary, but found `reef-node`

This is how target/release looks like

```
build                               liborml_authority.d
deps                                liborml_authority.rlib
examples                            liborml_currencies.d
incremental                         liborml_currencies.rlib
libevm_rpc.d                        liborml_tokens.d
libevm_rpc.rlib                     liborml_tokens.rlib
libmodule_currencies.d              liborml_traits.d
libmodule_currencies.rlib           liborml_traits.rlib
libmodule_evm.d                     liborml_utilities.d
libmodule_evm.rlib                  liborml_utilities.rlib
libmodule_evm_accounts.d            libpallet_staking.d
libmodule_evm_accounts.rlib         libpallet_staking.rlib
libmodule_evm_bridge.d              libreef_node.d
libmodule_evm_bridge.rlib           libreef_node.rlib
libmodule_evm_rpc_runtime_api.d     libreef_primitives.d
libmodule_evm_rpc_runtime_api.rlib  libreef_primitives.rlib
libmodule_example.d                 libreef_runtime.d
libmodule_example.rlib              libreef_runtime.rlib
libmodule_poc.d                     libruntime_common.d
libmodule_poc.rlib                  libruntime_common.rlib
libmodule_support.d                 reef-node
libmodule_support.rlib              reef-node.d
libmodule_transaction_payment.d     wbuild
libmodule_transaction_payment.rlib
```

Ran this to build `customSpec.json` 

```
./target/release/reef-node build-spec --disable-default-bootnode --chain testnet-new > customSpec.json
```

running this command to generate (sr25519)

```
./target/release/reef-node key generate --scheme Sr25519
```

got this output

```
Secret phrase:       <redacted>
  Network ID:        substrate
  Secret seed:       <redacted>
  Public key (hex):  0x88610325d0cc1cd4534c1335a1ac72ec359ff8c7c614f8d5503ed815ad19093a
  Account ID:        0x88610325d0cc1cd4534c1335a1ac72ec359ff8c7c614f8d5503ed815ad19093a
  Public key (SS58): 5F9XBsCJEaBj19Lhvyvoq7uH9QWdgmyiUHiBNGywb96Gum4k
  SS58 Address:      5F9XBsCJEaBj19Lhvyvoq7uH9QWdgmyiUHiBNGywb96Gum4k
```

running this command to generate grandpa(ed25519)

```
./target/release/reef-node key inspect --scheme Ed25519 "MNEMONICS_OF_SR25519"
```

got this

```
Secret phrase:       <redacted>
  Network ID:        substrate
  Secret seed:       <redacted>
  Public key (hex):  0xc4c4ddd12668d55ee1e1605673b02e1f86679eb1b78e8941c2306a73da7f35c7
  Account ID:        0xc4c4ddd12668d55ee1e1605673b02e1f86679eb1b78e8941c2306a73da7f35c7
  Public key (SS58): 5GWhixCE4ciZRYXYjdnLDZRo2NT8TscXxj4hDwNFGimoyXrh
  SS58 Address:      5GWhixCE4ciZRYXYjdnLDZRo2NT8TscXxj4hDwNFGimoyXrh
```

Next, I downloaded the file using scp

```
scp -P 2222 reef@reef.host:/home/reef/reef-node/chain-upgrade-main/customSpec.json ~/Desktop/
```

Changing vars in `customSpec.json` by taking reference from [here](https://docs.polkadot.com/develop/parachains/deployment/generate-chain-specs/)

i made the changes, now uploading it back to the ssh server

```
scp -P 2222 ~/Desktop/customSpec.json reef@reef.host:/home/reef/reef-node/chain-upgrade-main/
```

Was getting this error

```
reef@reef.host's password: 
scp: dest open "/home/reef/reef-node/chain-upgrade-main/customSpec.json": Permission denied
scp: failed to upload file /Users/anukul/Desktop/customSpec.json to /home/reef/reef-node/chain-upgrade-main/
anukul@Mac Desktop % scp -P 2222 ~/Desktop/customSpec.json reef@reef.host:/home/reef/reef-node/chain-upgrade-main/
```

so added permissions for `reef` user

```
chown reef:reef /home/reef/reef-node/chain-upgrade-main/
```

Now converting the chainSpec to raw format

```
./target/release/reef-node build-spec --disable-default-bootnode --chain customSpec.json --raw > customSpecRaw.json
```

Once done I got this

```
2025-09-18 11:04:21 Building chain spec    
2025-09-18 11:04:21 [0] 💸 generated 1 npos voters, 1 from validators and 0 nominators    
2025-09-18 11:04:21 [0] 💸 generated 1 npos targets 
```

Starting Node with this

```
./target/release/reef-node \
  --base-path ../enter-node-database \
  --chain ./customSpecRaw.json \
  --port 30333 \
  --rpc-port 9944 \
  --no-telemetry \
  --validator \
  --rpc-methods Unsafe \
  --name bootnode \
  --rpc-cors all \
  --rpc-external
```

<img width="847" height="327" alt="Screenshot 2025-09-18 at 4 39 31 PM" src="https://github.com/user-attachments/assets/9e12f8fc-dd64-432f-8fbf-48d19bc74ad5" />

I installed tmux and added tmux session

```
tmux new -s reef-node
```

inside this ran 

```
./target/release/reef-node \
  --base-path ../enter-node-database \
  --chain ./customSpecRaw.json \
  --port 30333 \
  --rpc-port 9944 \
  --no-telemetry \
  --validator \
  --rpc-methods Unsafe \
  --name bootnode \
  --rpc-cors all \
  --rpc-external
```

Exposed the dockploy port

<img width="947" height="439" alt="Screenshot 2025-09-18 at 4 45 44 PM" src="https://github.com/user-attachments/assets/a4a01a8d-c1e7-4b9a-8ea9-272e5a26bd0b" />

And added it to the domains

<img width="1342" height="761" alt="Screenshot 2025-09-18 at 4 46 23 PM" src="https://github.com/user-attachments/assets/0dd687ec-db9e-4c4c-b286-ffa34a593429" />

Voila! The bootnode is running now :)

<img width="1352" height="806" alt="Screenshot 2025-09-18 at 4 46 45 PM" src="https://github.com/user-attachments/assets/44ce11f7-f28d-4496-b2dd-a2bfbe0d6c06" />

