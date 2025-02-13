#!/usr/bin/env bash
set -eu -o pipefail

# Remove site that was installed before (for debugging)
rm -rf "${APP_ROOT}"/web
rm -rf "${APP_ROOT}"/vendor
rm -f "${APP_ROOT}"/composer.json
rm -f "${APP_ROOT}"/composer.lock
