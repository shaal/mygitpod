#!/usr/bin/env bash
set -eu -o pipefail

# Initialize all variables with null if they do not exist
: "${DEBUG_SCRIPT:=}"
: "${GITPOD_HEADLESS:=}"
: "${DP_EXTRA_DEVEL:=}"
: "${DP_EXTRA_ADMIN_TOOLBAR:=}"
: "${DEVEL_PACKAGE:=}"
: "${ADMIN_TOOLBAR_PACKAGE:=}"

if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Install devel and admin_toolbar modules
if [ "$DP_EXTRA_DEVEL" != '1' ]; then
    DEVEL_PACKAGE=
fi
if [ "$DP_EXTRA_ADMIN_TOOLBAR" != '1' ]; then
    ADMIN_TOOLBAR_PACKAGE=
fi

cd "${GITPOD_REPO_ROOT}" && time ddev . composer require --dev "drupal/core-dev":* "phpspec/prophecy-phpunit":^2 -W --no-install
cd "${GITPOD_REPO_ROOT}" && time ddev . composer require "drush/drush" "drupal/coder" "$DEVEL_PACKAGE" "$ADMIN_TOOLBAR_PACKAGE"

# Only for Drupal core - apply special patch
if [ "$DP_PROJECT_TYPE" == "project_core" ]; then
    # Patch the scaffold index.php and update.php files
    # See https://www.drupal.org/project/drupal/issues/3188703
    # See https://www.drupal.org/project/drupal/issues/1792310
    echo "$(cat composer.json | jq '.scripts."post-install-cmd" |= . + ["src/composer-drupal-core-setup/patch-core-index-and-update.sh"]')" >composer.json
    echo "$(cat composer.json | jq '.scripts."post-update-cmd" |= . + ["src/composer-drupal-core-setup/patch-core-index-and-update.sh"]')" >composer.json

    # Run the patch once
    time src/composer-drupal-core-setup/patch-core-index-and-update.sh

    # Get the major version of 'drush/drush'
    drush_major_version=$(ddev composer show drush/drush --no-ansi | awk '/versions/ {print $NF}' | cut -d '.' -f1)

    drush_command_dir="$GITPOD_REPO_ROOT/drush/Commands/core_development"
    mkdir -p "$drush_command_dir"

    # Copy the correct version of DevelopmentProjectCommands.php file to the drush commands directory
    cp "$GITPOD_REPO_ROOT/src/drush-commands-core-development/$drush_major_version/DevelopmentProjectCommands.php" "$drush_command_dir/."
else
    # Only for contrib - add project as symlink

    echo "$(cat composer.json | jq '.scripts."post-install-cmd" |= . + ["repos/add-project-as-symlink.sh"]')" >composer.json
    echo "$(cat composer.json | jq '.scripts."post-update-cmd" |= . + ["repos/add-project-as-symlink.sh"]')" >composer.json
    time repos/add-project-as-symlink.sh
fi
