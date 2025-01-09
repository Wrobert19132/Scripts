#!/usr/bin/env bash

# An incredibly simple script to mount an encrypted partition.

REBUILD_COMMAND="nixos-rebuild switch --flake $HOME/Projects/dotfiles#steorra"

figlet -f big System Rebuild
echo ""
sudo $REBUILD_COMMAND;

echo ""
read -p "Done. Press any key to quit."