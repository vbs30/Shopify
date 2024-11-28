#!/bin/bash

<< Overview
This is a django app about e-commerce
we are basically running the django through python by cloning a git repository
Overview

# Variables
RepoURL="https://github.com/vbs30/Shopify.git"
name=$(basename "$RepoURL" .git)
PORT=8000


if ! command -v python3 &> /dev/null; then
    echo "Python3 is not installed. Installing Python3..."

    # Detect the OS and install Python accordingly
    if [[ "$(uname)" == "Darwin" ]]; then
        # For macOS
        brew install python
    elif [[ "$(uname)" == "Linux" ]]; then
        # For Linux (Ubuntu/Debian)
        sudo apt update
        sudo apt install -y python3 python3-pip python3-venv    elif [[ "$(uname)" == "CYGWIN"* || "$(uname)" == "MINGW"* ]]; then
        # For Windows (using Git Bash)
        echo "Please install Python from https://www.python.org/downloads/ and ensure it's added to PATH."
        exit 1
    else
        echo "Unsupported OS. Please install Python manually."
        exit 1
    fi
fi

# Step 1: We will clone the repository, if repo exists then we will just enter into that directory

if [[ ! -d "name" ]]; then
        echo "Cloning repository..."
        git clone "$RepoURL"
else
        echo "Repository already exists, pulling latest changes"
        echo "$name" || exit 1
        git pull
        cd ..
fi


# Step 2, we will enter in the project if new clone has happened
cd "$name" || exit 1

echo "Setting up a virtual env..."
python3 -m venv venv
source venv/bin/activate


# Step 3, we will now install all the requirements
if [[ -f "requirements.txt" ]]; then
        echo "Installing modules..."
        python3 -m pip install -r requirements.txt
else
        echo "No requirements.txt found. Skipping modules installation"
fi


# Step 4: We will apply migration so that database will be connected with our app
echo "Applying database migration..."
python3 manage.py migrate


# Step 6: Running the app server
echo "************* DJANGO Deployment Started ***********"
echo " Server running on port $PORT "
python3 manage.py runserver "$PORT"
