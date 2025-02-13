#!/usr/bin/env bash
set -eu -o pipefail

# For versions end with x - add `-dev` suffix (ie. 9.3.x-dev)
# For versions without x - add `~` prefix (ie. ~9.2.0)
d="$DP_CORE_VERSION"
case $d in
*.x)
    install_version="$d"-dev
    ;;
*)
    install_version=~"$d"
    ;;
esac

# Create required composer.json and composer.lock files
cd "$APP_ROOT" && time composer create -n --no-install drupal/recommended-project:"$install_version" temp-composer-files
cp "$APP_ROOT"/temp-composer-files/* "$APP_ROOT"/.
rm -rf "$APP_ROOT"/temp-composer-files

# Programmatically fix Composer 2.2 allow-plugins to avoid errors
composer config --no-plugins allow-plugins.composer/installers true
composer config --no-plugins allow-plugins.drupal/core-project-message true
composer config --no-plugins allow-plugins.drupal/core-vendor-hardening true
composer config --no-plugins allow-plugins.drupal/core-composer-scaffold true
composer config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
composer config --no-plugins allow-plugins.phpstan/extension-installer true
composer config --no-plugins allow-plugins.mglaman/composer-drupal-lenient true
composer config --no-plugins allow-plugins.php-http/discovery true
composer config --no-plugins allow-plugins.tbachert/spi false

# Add project source code as symlink (to repos/name_of_project)
# double quotes explained - https://stackoverflow.com/a/1250279/5754049
if [ -n "$DP_PROJECT_NAME" ]; then
    cd "${APP_ROOT}" &&
        composer config \
            repositories.core1 \
            '{"type": "path", "url": "repos/'"$DP_PROJECT_NAME"'", "options": {"symlink": true}}'

    cd "$APP_ROOT" &&
        composer config minimum-stability dev
fi

# Scaffold settings.php.
composer config --no-plugins -j extra.drupal-scaffold.file-mapping '{
    "[web-root]/sites/default/settings.php": {
        "path": "web/core/assets/scaffold/files/default.settings.php",
        "overwrite": false
    }
}'
composer config --no-plugins scripts.post-drupal-scaffold-cmd \
    'cd web/sites/default && (patch -Np1 -r /dev/null < "${APP_ROOT}"/.devpanel/drupal-settings.patch | : )'
