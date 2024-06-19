#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Variables
USERNAME="testuser"
MOUNT_POINT="/testuser"

# Create the user if they do not exist
if ! id -u $USERNAME >/dev/null 2>&1; then
    useradd -m -s /bin/bash $USERNAME
    echo "User $USERNAME created."
else
    echo "User $USERNAME already exists."
fi

# Set password for the user
echo "Set password for $USERNAME:"
passwd $USERNAME

# Create the mount point if it does not exist
if [ ! -d "$MOUNT_POINT" ]; then
    mkdir -p $MOUNT_POINT
    chown $USERNAME:$USERNAME $MOUNT_POINT
    echo "Directory $MOUNT_POINT created and ownership set to $USERNAME."
else
    echo "Directory $MOUNT_POINT already exists."
fi

# Add the user to the wheel group
usermod -aG wheel $USERNAME

# Verify the user is in the wheel group
if groups $USERNAME | grep &>/dev/null "\bwheel\b"; then
    echo "User $USERNAME added to wheel group."
else
    echo "Failed to add $USERNAME to wheel group."
    exit 1
fi

echo "Setup complete. User $USERNAME has a directory at $MOUNT_POINT and is a member of the wheel group."
