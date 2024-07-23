#!/bin/bash

set -e
set -x

cd ../

git submodule update --init --recursive

sudo apt remove -y nodejs nodejs-doc

curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

# Run npm install with 3 re-tries, because I have dns issues sometimes
# Define the maximum number of retries
MAX_RETRIES=3

# Define the exit code for npm install
NPM_INSTALL_EXIT_CODE=0

# Loop through the retries
for i in $(seq 1 $MAX_RETRIES); do
  echo "Running npm install (attempt $i)..."
  sudo npm install
  NPM_INSTALL_EXIT_CODE=$?

  # If npm install was successful, break out of the loop
  if [ $NPM_INSTALL_EXIT_CODE -eq 0 ]; then
    echo "npm install succeeded on attempt $i"
    break
  fi

  # If we've reached the maximum number of retries, exit with the last exit code
  if [ $i -eq $MAX_RETRIES ]; then
    echo "npm install failed after $MAX_RETRIES attempts"
    exit $NPM_INSTALL_EXIT_CODE
  fi

  # Otherwise, wait for a bit before trying again
  echo "npm install failed on attempt $i. Retrying in 5 seconds..."
  sleep 5
done

npm run build

## Change user and home dir to defaults, then reload service
sudo systemctl daemon-reload
#username = ubuntu
sudo systemctl enable uavlogviewer.service