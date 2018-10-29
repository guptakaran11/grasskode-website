#!/bin/bash

echo -e "\033[0;32mUpdating master...\033[0m"

# commit pending changes
msg="uncommitted changes `date`"
git commit -am "$msg"

# pull changes
git pull

# push changes
git push origin master


echo -e "\033[0;32mRebuilding site...\033[0m"

# Clean the public folder.
if [ -d public ]; then
  rm -r public
fi
git subtree add --prefix=public git@github.com:grasskode/grasskode-website.git gh-pages

set -x

# swap .gitignore
cp .gitignore-gh-pages .gitignore

# Build the project.
hugo

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Add and commit site changes to git if any.
#git add -A
#msg="rebuilding site `date`"
#if [ $# -eq 1 ]
#  then msg="$1"
#fi
#git commit -m "$msg"
#git push origin master

# Push source and build repos.
git add public
msg="rebuilding site `date`"
git commit -m "$msg"
git subtree push --prefix=public git@github.com:grasskode/grasskode-website.git gh-pages

# revert to master's .gitignore
cp .gitignore-master .gitignore

set +x
