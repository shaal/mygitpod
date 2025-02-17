#!/usr/bin/env bash

# Load default envs
# export $(grep -v '^#' "$APP_ROOT"/.env | xargs -d '\n')

set -eu -o pipefail

# Initialize all variables with null if they do not exist
: "${DEBUG_SCRIPT:=}"
: "${DP_INSTALL_PROFILE:=}"
: "${DP_EXTRA_DEVEL:=}"
: "${DP_EXTRA_ADMIN_TOOLBAR:=}"
: "${DP_PROJECT_TYPE:=}"
: "${DEVEL_NAME:=}"
: "${DEVEL_PACKAGE:=}"
: "${ADMIN_TOOLBAR_NAME:=}"
: "${ADMIN_TOOLBAR_PACKAGE:=}"
: "${COMPOSER_DRUPAL_LENIENT:=}"
: "${DP_CORE_VERSION:=}"
: "${DP_ISSUE_BRANCH:=}"
: "${DP_ISSUE_FORK:=}"
: "${DP_MODULE_VERSION:=}"
: "${DP_PATCH_FILE:=}"

# Assuming .sh files are in the same directory as this script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

convert_version() {
    local version=$1
    if [[ $version =~ "-" ]]; then
        # Remove the part after the dash and replace the last numeric segment with 'x'
        local base_version=${version%-*}
        echo "${base_version%.*}.x"
    else
        echo "$version"
    fi
}

# Test cases
# echo $(convert_version "9.2.5-dev1")    # Output: 9.2.x
# echo $(convert_version "9.2.5")         # Output: 9.2.5
# echo $(convert_version "10.1.0-beta1")  # Output: 10.1.x
# echo $(convert_version "11.0-dev")      # Output: 11.x

# Skip setup if it already ran once and if no special setup is set by DrupalPod extension
if [ ! -f "${APP_ROOT}"/.drupalpod_initiated ]; then

    # Clone Drupal core repo
    if [ ! -d "${APP_ROOT}"/repos/drupal ]; then
        mkdir -p "${APP_ROOT}"/repos
        cd "${APP_ROOT}"/repos && time git clone https://git.drupalcode.org/project/drupal.git
        cd "${APP_ROOT}"
    fi

    # Set a default setup if project type wasn't specified
    if [ -z "$DP_PROJECT_TYPE" ]; then
        source "$DIR/fallback_setup.sh"
    fi

    source "$DIR/git_setup.sh"

    # If this is an issue fork of Drupal core - set the drupal core version based on that issue fork
    if [ "$DP_PROJECT_TYPE" == "project_core" ] && [ -n "$DP_ISSUE_FORK" ]; then
        VERSION_FROM_GIT=$(grep 'const VERSION' "${APP_ROOT}"/repos/drupal/core/lib/Drupal.php | awk -F "'" '{print $2}')
        DP_CORE_VERSION=$(convert_version "$VERSION_FROM_GIT")
        export DP_CORE_VERSION
    fi

    # Measure the time it takes to go through the script
    script_start_time=$(date +%s)

    source "$DIR/contrib_modules_setup.sh"
    source "$DIR/cleanup.sh"
    source "$DIR/composer_setup.sh"

    if [ -n "$DP_PATCH_FILE" ]; then
        echo Applying selected patch "$DP_PATCH_FILE"
        cd "${WORK_DIR}" && curl "$DP_PATCH_FILE" | patch -p1
    fi

    # Prepare special setup to work with Drupal core
    if [ "$DP_PROJECT_TYPE" == "project_core" ]; then
        source "$DIR/drupal_setup_core.sh"
    # Prepare special setup to work with Drupal contrib
    elif [ -n "$DP_PROJECT_NAME" ]; then
        source "$DIR/drupal_setup_contrib.sh"
    fi

    time "${DIR}"/install-essential-packages.sh
    # Configure phpcs for drupal.
    cd "$APP_ROOT" &&
        vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer

    # New site install
    time drush si -y --account-pass=admin --site-name="DrupalPod" "$DP_INSTALL_PROFILE"

    # Install devel and admin_toolbar modules
    if [ "$DP_EXTRA_DEVEL" != '1' ]; then
        DEVEL_NAME=
    fi
    if [ "$DP_EXTRA_ADMIN_TOOLBAR" != '1' ]; then
        ADMIN_TOOLBAR_NAME=
    fi

    # Enable extra modules
    cd "${APP_ROOT}" &&
        drush en -y \
            $ADMIN_TOOLBAR_NAME \
            $DEVEL_NAME

    # Enable the requested module
    if [ "$DP_PROJECT_TYPE" == "project_module" ]; then
        cd "${APP_ROOT}" && drush en -y "$DP_PROJECT_NAME"
    fi

    # Enable the requested theme
    if [ "$DP_PROJECT_TYPE" == "project_theme" ]; then
        cd "${APP_ROOT}" && drush then -y "$DP_PROJECT_NAME"
        cd "${APP_ROOT}" && drush config-set -y system.theme default "$DP_PROJECT_NAME"
    fi

    # Save a file to mark workspace already initiated
    touch "${APP_ROOT}"/.drupalpod_initiated

    # Finish measuring script time
    script_end_time=$(date +%s)
    runtime=$((script_end_time - script_start_time))
    echo "init.sh script ran for" $runtime "seconds"
fi
