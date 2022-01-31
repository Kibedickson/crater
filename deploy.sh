#!/bin/sh
set -e

#yarn build

git add .

git commit -m "Build for Prod"

git push

git checkout production
git merge master

git push origin production

git checkout master