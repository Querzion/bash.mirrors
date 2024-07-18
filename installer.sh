#!/bin/bash

############ COLOURED BASH TEXT

# ANSI color codes
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


################################################################################################## FILE & FOLDER PATHS

# Location
APPLICATION="arch-suite"
BASE="$HOME/bash.$APPLICATION"
FILES="$BASE/files"


################################################################################################## INSTALLATION

# Function to update ParallelDownloads
update_parallel_downloads() {
    local conf_file="/etc/pacman.conf"
    local search_string="#ParallelDownloads = 5"
    local replace_string="ParallelDownloads = 10"
    
    if [[ -f $conf_file ]]; then
        sudo sed -i "s/$search_string/$replace_string/" "$conf_file"
        echo "Updated ParallelDownloads in $conf_file."
    else
        echo "Error: $conf_file not found."
    fi
}

# Enables the [MultiLib] mirrorlist if not activated already
enable_multilib() {
    local pacman_conf="/etc/pacman.conf"
    
    if [ ! -f "$pacman_conf" ]; then
        echo "Error: $pacman_conf not found."
        return 1
    fi

    # Check if the multilib section is already uncommented
    if grep -q '^\[multilib\]' "$pacman_conf"; then
        echo "Multilib repository is already enabled."
        return 0
    fi

    # Backup the original pacman.conf
    sudo cp "$pacman_conf" "${pacman_conf}.bak"

    # Uncomment the multilib section
    sudo sed -i '/#\[multilib\]/{s/^#//;n;s/^#//}' "$pacman_conf"

    echo "Multilib repository has been enabled."
    return 0
}


################################################################################################## MAIN

# Fast Track mirrors
sudo pacman-mirrors --fasttrack

# Call the function
enable_multilib

# Call the function
update_parallel_downloads
