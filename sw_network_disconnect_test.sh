#!/bin/bash

# USAGE:
#      Make the script executable:
#        chmod +x sw_network_disconnect_test.sh
#      Run script:
#	       ./sw_network_disconnect_test.sh

# Function to check if the script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "This script must be by wheel user or root. Requesting sudo access for 1 S+W command..."
        sudo "$0" "$@"  # Run the script with sudo
        exit 0
    fi
}

# Check if the script is run with sudo/root access
check_root "$@"

# Basic Function to check internet connectivity via Google
check_internet() {
    ping -c 1 8.8.8.8 > /dev/null 2>&1
    return $?
}

# Main
clear
while true; do
    # Check internet connectivity
    echo "Validating internet access every 2 seconds"
    if ! check_internet; then
        # Countdown from 10 to 1
        for i in {10..1}; do
            echo "Internet disconnect discovered"
            echo "Running S+W fix in $i seconds..."
            sleep 1
            clear
        done

        # Run the command with sudo and show output
        echo "Stone+Wire restarting"
        sudo /opt/Autodesk/sw/sw_restart all
        echo "S+W has been reset, please try exiting and relaunching flame"
        exit 0    # Exit gracefully
    else
        echo "Internet access detected"
    fi

    # Sleep and clean and go again
    sleep 2
    clear
done
