#!/bin/bash -xe

# ------------------------------
# Load user environment
# ------------------------------
# Ensures NVM, PATH, and other environment variables are available
source /home/ec2-user/.bash_profile

# ------------------------------
# Change to release directory
# ------------------------------
RELEASE_DIR="/home/ec2-user/app/release"

if [ -d "$RELEASE_DIR" ]; then
    cd "$RELEASE_DIR"
else
    echo "Release directory not found: $RELEASE_DIR"
    exit 1
fi

# ------------------------------
# Install/update Node.js dependencies
# ------------------------------
npm install

# ------------------------------
# Start the application
# ------------------------------
npm run start
