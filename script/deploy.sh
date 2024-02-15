#!/bin/sh -l

set -e

# Check values

if [ -n "${PUBLISH_REPOSITORY}" ]; then
    TARGET_REPOSITORY=${PUBLISH_REPOSITORY}
else
    TARGET_REPOSITORY=${GITHUB_REPOSITORY}
fi

if [ -n "${BRANCH}" ]; then
    TARGET_BRANCH=${BRANCH}
else
    TARGET_BRANCH="master"
fi

if [ -n "${PUBLISH_DIR}" ]; then
    TARGET_PUBLISH_DIR=${PUBLISH_DIR}
else
    TARGET_PUBLISH_DIR="./public"
fi

if [ -z "$PERSONAL_TOKEN" ]
then
  echo "You must provide the action with either a Personal Access Token or the GitHub Token secret in order to deploy."
  exit 1
fi

REPOSITORY_PATH="https://x-access-token:${PERSONAL_TOKEN}@github.com/${TARGET_REPOSITORY}.git"

# Start deploy

echo ">_ Start deploy to ${TARGET_REPOSITORY}"

git config --global core.quotepath false
git config --global --add safe.directory /github/workspace


echo ">_ Clone ${GITHUB_WORKSPACE} ..."

cd "${GITHUB_WORKSPACE}"

echo ">_ Install yuque-hexo dependencies ..."
npm i -g yuque-hexo@1.9.5

echo ">_ Pull yuque articles ..."
YUQUE_TOKEN=${YUQUE_TOKEN} yuque-hexo sync

find source/_posts -name "*.md" | while read file; do
  timestamp=$(git log -1 --format="%ct" "$file")
  formatted_timestamp=$(date -u -d "$timestamp" "+%Y%m%d%H%M.%S")
  touch -t "$formatted_timestamp" "$file"
done

# Annotate this section of code for easy addition workflows actions
echo ">_ Install NPM dependencies ..."
npm install

if [ -f "generate.sh" ]; then
  ./script/generate.sh
else
  echo ">_ Clean cache files ..."
  npx hexo clean

  if [ -d "actions" ]; then
      echo ">_ Add workflows actions ..."
      mkdir -p public/.github/workflows/
      cp -r actions/* public/.github/workflows/
  else
      echo ">_ The actions directory does not exist."
  fi

  echo ">_ Generate file ..."
  npx hexo generate
fi

cd "${TARGET_PUBLISH_DIR}"

CURRENT_DIR=$(pwd)

if [ -n "${CNAME}" ]; then
    echo ${CNAME} > CNAME
fi

# Configures Git

echo ">_ Config git ..."

git init
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global --add safe.directory "${CURRENT_DIR}"

git remote add origin "${REPOSITORY_PATH}"
git checkout --orphan "${TARGET_BRANCH}"

git add .

echo '>_ Start Commit ...'
git commit --allow-empty -m "Build and Deploy from Github Actions"

echo '>_ Start Push ...'
git push -u origin "${TARGET_BRANCH}" --force

echo ">_ Deployment successful"
