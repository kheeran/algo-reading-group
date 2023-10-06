#!/bin/bash
stashOut="$(git stash)"
isStashed=true
initialBranch=$(git rev-parse --abbrev-ref HEAD)
if [ "$stashOut" = "No local changes to save" ]; then isStashed=false; else echo "STASHED UNCOMMITTED CHANGES!" ; fi
git checkout dev
git pull
git checkout master
git pull
git checkout dev
commit_id=$(git rev-parse HEAD)
bundle install
bundle exec jekyll build
echo "BUILD COMPLETE!"
git checkout master
rm -r !("_site")
mv _site/* ./
rm -d _site
rm LICENSE
rm deploy.sh
rm run.sh
git add .
git commit -m "Deploy: $(date) $commit_id"
git push origin master
echo "WEBSITE DEPLOYED!"
git checkout $initialBranch
if [ "$isStashed" = true ]; then git stash apply; fi