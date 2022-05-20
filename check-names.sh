#!/bin/bash
# set -e
set -o pipefail

SCRIPT_VERSION="0.1.0"

SCRIPT_NAME="$(basename "${0}")"
SCRIPT_DESC="Check LastPass vault for dead urls"
readonly SCRIPT_NAME
readonly SCRIPT_DESC
readonly SCRIPT_VERSION

source ./lib/libbash
