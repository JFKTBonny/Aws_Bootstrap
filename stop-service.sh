#!/bin/bash -xe

# ------------------------------
# Load user environment
# ------------------------------
# Ensures NVM, PATH, and other environment variables are available
source /home/ec2-user/.bash_profile

# ------------------------------
# Change to release directory if it exists
# ------------------------------
RELEASE_DIR="/home/ec2-user/app/release"

if [ -d "$RELEASE_DIR" ]; then
    cd "$RELEASE_DIR"
else
    echo "Release directory not found: $RELEASE_DIR"
    exit 1
fi

# ------------------------------
# Stop the running Node.js application
# ------------------------------
# This assumes your package.json has a "stop" script defined
npm stop
