#!/usr/bin/env bash

function error_msg() {
  printf "ERROR:\n  $*\n" >&2
  exit 1
}

STRATEGY="patch"

while test $# -gt 0; do
  case "$1" in
    -s)
      shift
      STRATEGY="$1"
      shift
      ;;
    *)
      break;
      ;;
  esac
done

if [ "patch" != "$STRATEGY" -a "minor" != "$STRATEGY" -a "major" != "$STRATEGY" ]; then
  error_msg "Invalid strategy. Available options: patch, minor, major"
fi

replace_version_number() {
    # Get the provided version number
    version=$1
    # Get the file path
    file_path=$2

    # Find the line that starts with "image:"
    line=$(grep "^[ \t]*image: ghcr.io/bushido-games/" "$file_path")

    # Extract the current version number
    current_version=$(echo $line | awk '{print $2}' | awk -F: '{print $2}')

    echo "Updating $2 file lines:"
    echo "$line"

    # Replace all occurrences of the current version number with the provided version number
    sed -i -e "s/$current_version/$version/g" "$file_path"

    line=$(grep "image: ghcr.io/bushido-games/" "$file_path")
    echo "After update:"
    echo "$line"
}

yarn version "$STRATEGY"
git add .yarn/versions

PACKAGE_VERSION=$(cat package.json|grep version|head -1|awk -F: '{ print $2 }'|sed 's/[", ]//g')

replace_version_number "$PACKAGE_VERSION" "./docker-compose-prod.yml"

git commit -a -m"new version: v${PACKAGE_VERSION}" --no-verify
git tag -a "v${PACKAGE_VERSION}" -m"new version: v${PACKAGE_VERSION}"
git push && git push --tags
