#!/bin/sh

# Download the zip file
curl -L https://github.com/GustavoPerezYSSY/inter-middleware/releases/download/v1.0/yssy-mutuauth-middleware-v1-0-0.zip -o yssy-mutuauth-middleware-v1-0-0.zip

# Create the yssy-mutuauth directory if it doesn't exist
mkdir -p yssy-mutuauth

# Unzip the file to the yssy-mutuauth directory
unzip yssy-mutuauth-middleware-v1-0-0.zip -d yssy-mutuauth

# Change directory to yssy-mutuauth
cd yssy-mutuauth

# Give execution permissions to the install script and execute it
chmod +x install.sh
./install.sh
