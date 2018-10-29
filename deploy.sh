#!/bin/bash

set -e

echo -e "\033[0;32mCleaning up...\033[0m"

# Clean the public folder.
if [ -d public ]; then
  rm -r public
fi

echo -e "\033[0;32mPulling changes from GitHub...\033[0m"

# pull changes
git pull

echo -e "\033[0;32mRebuilding site...\033[0m"

# Build the project.
hugo

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Push source and build repos.
git push origin master
git subtree push --prefix=public git@github.com:grasskode/grasskode-website.git gh-pages

set +e
