#!/usr/bin/env bash

# An incredibly simple script to mount an encrypted partition.

echo "Welcome to the decryptor util."
exec sudo mount -t ecryptfs -o no_sig_cache,verbose,ecryptfs_cipher=aes,ecryptfs_key_bytes=32,ecryptfs_enable_filename=y,ecryptfs_passthrough=n,ecryptfs_enable_filename_crypto=y ~/.bones ~/.body
