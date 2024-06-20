#!/bin/bash

# Variables
USERNAME="testuser"
HOMEDIR="/testuser"
PASSWORD="linux"

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Create the user with the specified home directory
useradd -m -d "$HOMEDIR" "$USERNAME"
if [[ $? -ne 0 ]]; then
    echo "Failed to create user $USERNAME"
    exit 1
fi

# Set the user's password
echo "$USERNAME:$PASSWORD" | chpasswd
if [[ $? -ne 0 ]]; then
    echo "Failed to set password for $USERNAME"
    exit 1
fi

# Add the user to the sudoers file
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USERNAME
if [[ $? -ne 0 ]]; then
    echo "Failed to add $USERNAME to the sudoers file"
    exit 1
fi

# Verify the user creation
getent passwd "$USERNAME"
if [[ $? -ne 0 ]]; then
    echo "User $USERNAME does not exist"
    exit 1
else
    echo "User $USERNAME created successfully with home directory $HOMEDIR"
fi

# Verify the home directory
if [[ -d "$HOMEDIR" ]]; then
    echo "Home directory $HOMEDIR created successfully"
else
    echo "Home directory $HOMEDIR was not created"
    exit 1
fi

echo "User $USERNAME has been added to the sudoers file with no password requirement for sudo commands."
