#!/usr/bin/env bash
set -eu -o pipefail

# Check if additional modules should be installed
export DEVEL_NAME="devel"
export DEVEL_PACKAGE="drupal/devel"

export ADMIN_TOOLBAR_NAME="admin_toolbar_tools"
export ADMIN_TOOLBAR_PACKAGE="drupal/admin_toolbar"

# TODO: once Drupalpod extension supports additional modules - remove these 2 lines
export DP_EXTRA_DEVEL=1
export DP_EXTRA_ADMIN_TOOLBAR=1

# Adding support for composer-drupal-lenient - https://packagist.org/packages/mglaman/composer-drupal-lenient
if [[ "$DP_CORE_VERSION" =~ ^10(\..*)?$ ]]; then
    if [ "$DP_PROJECT_TYPE" != "project_core" ]; then
        export COMPOSER_DRUPAL_LENIENT=mglaman/composer-drupal-lenient
    else
        export COMPOSER_DRUPAL_LENIENT=''
    fi
fi

# Adding support for composer-drupal-lenient - https://packagist.org/packages/mglaman/composer-drupal-lenient
if [[ "$DP_CORE_VERSION" =~ ^11(\..*)?$ ]]; then
    # admin_toolbar and devel are not compatible yet with Drupal 11
    export DP_EXTRA_ADMIN_TOOLBAR=
    export DP_EXTRA_DEVEL=
    if [ "$DP_PROJECT_TYPE" != "project_core" ]; then
        export COMPOSER_DRUPAL_LENIENT=mglaman/composer-drupal-lenient
    else
        export COMPOSER_DRUPAL_LENIENT=''
    fi
fi
