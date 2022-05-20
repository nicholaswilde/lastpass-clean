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

function show_usage(){
  printf "Usage: %s [-h|-v] FILENAME\n" "${SCRIPT_NAME}"
}

function script_desc(){
  printf "%s\n\n" "${SCRIPT_DESC}"
}

# Show the help
function show_help(){
  show_usage
  script_desc
  printf "Mandatory arguments:\n"
  printf "  FILENAME            The filename to export the dead urls to\n\n"
  printf "Options:\n"
  printf "  -h                  Print this Help.\n"
  printf "  -v                  Print script version and exit.\n"
  exit 0
}

function show_version(){
  printf "%s version %s\n" "${SCRIPT_NAME}" "${SCRIPT_VERSION}"; exit 0
}

# printf usage_error if something isn't right.
function usage_error() {
  show_usage
  printf "\nTry %s -h for more options.\n" "${SCRIPT_NAME}" >&2
  exit 1
}

function check_apps(){
  ! command_exists lpass  && printf "lpass is not installed\n" && exit 1
  ! command_exists jq     && printf "jp is not installed\n" && exit 1
  ! command_exists curl   && printf "curl is not installed\n" && exit 1
}

function check_urls(){
  local filename="${1}"
  # https://unix.stackexchange.com/a/477218/93726
  data=$(get_data)
  n=$(echo "${data}" | jq '.|length')
  for k in $(echo "${data}" | jq '.|keys|.[]'); do
    value=$(echo "${data}" | jq ".[${k}]")
    name=$(jq -r '.name' <<< "${value}")
    url=$(jq -r '.url' <<< "${value}")
    id=$(jq -r '.id' <<< "${value}")
    domain=$(get_domain "${url}")
    if ! is_null "${domain}" && [[ "${domain}" != "sn" ]] ; then
      if ! test_domain "${domain}"; then
        s=$(printf "%s,%s,%s\n" "${id}" "${name}" "${domain}")
        printf "(${k}/${n})\t%s\n" "${s}"
        arr+=("${s}")
      fi
    fi
  done
  echo "${arr[@]}" > "${filename}"
}

function main(){
  check_apps
  check_urls "$@"
}

if [ $# -ne 1 ]; then usage_error; fi                                                                                                                                                                                                                     

# https://www.jamescoyle.net/how-to/1774-bash-getops-example
# https://opensource.com/article/19/12/help-bash-program
# Get the options
while getopts ":hv" o; do
  case "${o}" in
    h)  show_help;;
    v)  show_version;;
    \?) usage_error;;
  esac
done

main "$@"
