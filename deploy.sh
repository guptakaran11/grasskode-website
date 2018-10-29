#!/bin/bash

set -ex

echo -e "\033[0;32mUpdating master...\033[0m"

# commit pending changes
msg="uncommitted changes `date`"
git commit -am "$msg"

echo -e "\033[0;32mPulling changes from GitHub...\033[0m"

# pull changes
git pull

echo -e "\033[0;32mRebuilding site...\033[0m"

# Clean the public folder.
if [ -d public ]; then
  rm -r public
fi
git subtree add --prefix=public git@github.com:grasskode/grasskode-website.git gh-pages

# Build the project.
hugo

set +e
set -x

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Push source and build repos.
mv .gitignore .gitignore-master
mv .gitignore-gh-pages .gitignore
git subtree push --prefix=public git@github.com:grasskode/grasskode-website.git gh-pages
mv .gitignore .gitignore-gh-pages
mv .gitignore-master .gitignore

# Add and commit site changes to git if any.
git add -A
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"
git push origin master

set +x
