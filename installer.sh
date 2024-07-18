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
APPLICATION="mirrors"
BASE="$HOME/bash.$APPLICATION"
FILES="$BASE/files"
PD="10"

################################################################################################## INSTALLATION

# Function to update ParallelDownloads
update_parallel_downloads() {
    local conf_file="/etc/pacman.conf"
    local search_string="#ParallelDownloads = 5"
    local replace_string="ParallelDownloads = $PD"
    
    if [[ -f $conf_file ]]; then
        sudo sed -i "s/$search_string/$replace_string/" "$conf_file"
        echo "${CYAN} Updated ParallelDownloads in $conf_file. ${NC}"
    else
        echo "${RED} Error: $conf_file not found. ${NC}"
    fi
}

# Enables the [MultiLib] mirrorlist if not activated already
enable_multilib() {
    local pacman_conf="/etc/pacman.conf"
    
    if [ ! -f "$pacman_conf" ]; then
        echo "${RED} Error: $pacman_conf not found. ${NC}"
        return 1
    fi

    # Check if the multilib section is already uncommented
    if grep -q '^\[multilib\]' "$pacman_conf"; then
        echo "${YELLOW} Multilib repository is already enabled. ${GREEN}"
        return 0
    fi

    # Backup the original pacman.conf
    sudo cp "$pacman_conf" "${pacman_conf}.bak"

    # Uncomment the multilib section
    sudo sed -i '/#\[multilib\]/{s/^#//;n;s/^#//}' "$pacman_conf"

    echo -e "${GREEN} Multilib repository has been enabled. ${NC}"
    return 0
}


################################################################################################## MAIN

# Activate MultiLib if not already.
enable_multilib

# Activate ParallelDownloads and change to 10.
update_parallel_downloads

# Fast Track mirrors.
echo -e "${YELLOW} Fast Track Mirrors - Changing to Fastest Mirrors. ${NC}" 
sudo pacman-mirrors --fasttrack

echo -e "${PURPLE} Pre-Configuration Done! ${NC}" 
