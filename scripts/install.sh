#!/bin/bash
set -xe

echo "=== Running install.sh from repo ==="

# Ensure NVM is loaded
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo "=== Using Node version ==="
node -v
npm -v

echo "=== Installing NPM dependencies ==="
npm install

echo "=== Creating logs directory ==="
mkdir -p logs

echo "=== Starting Node app (background) ==="
npm start &

echo "=== install.sh completed ==="
