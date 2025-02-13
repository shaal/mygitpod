#!/usr/bin/env bash
# ---------------------------------------------------------------------
# Copyright (C) 2024 DevPanel
# You can install any service here to support your project
# Please make sure you run apt update before install any packages
# Example:
# - sudo apt-get update
# - sudo apt-get install nano
#
# ----------------------------------------------------------------------
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

# Load default envs
# export "$(grep -v '^#' "$GITPOD_REPO_ROOT"/.env | xargs -d '\n')"

# Run this script only the first time by checking npm is not installed.
if command -v npm >/dev/null 2>&1; then
  echo "npm is installed. Exiting the script."
  exit 0
fi

sudo apt-get update
sudo apt-get install -y jq nano npm

sudo pecl update-channels
sudo pecl install apcu <<< ''
echo 'extension=apcu.so' | sudo tee /usr/local/etc/php/conf.d/apcu.ini
sudo pecl install uploadprogress
echo 'extension=uploadprogress.so' | sudo tee /usr/local/etc/php/conf.d/uploadprogress.ini
if sudo /etc/init.d/apache2 status > /dev/null; then
  sudo /etc/init.d/apache2 reload
fi

# Clone Drupal core repo
mkdir -p "${APP_ROOT}"/repos
cd "${APP_ROOT}"/repos && time git clone https://git.drupalcode.org/project/drupal.git
