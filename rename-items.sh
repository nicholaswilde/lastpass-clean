#!/bin/bash
# set -e
set -o pipefail

SCRIPT_VERSION="0.1.0"

SCRIPT_NAME="$(basename "${0}")"
SCRIPT_DESC="Rename items from LastPass vault"
readonly SCRIPT_NAME
readonly SCRIPT_DESC
readonly SCRIPT_VERSION

source ./lib/libbash

function check_status(){
  status=$(lpass status)
  if [[ "${status}" == "Not logged in." ]]; then
    printf "%s\n" "Not logged in. Please login using lpass login."
    exit 1
  fi
}

function get_id(){
  IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
  echo "${arr[0]}" 
}

function get_new_name(){
  IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
  echo "${arr[2]}"
}

# function is_int() { (( 10#$1 )) 2>/dev/null ;}
function is_int(){ case ${1#[-+]} in '' | *[!0-9]*) return 1;; esac ; }

function rename_items(){
  local filename="${1}"
  while read -r line; do
    id=$(get_id "${line}" ",")
    new_name=$(get_new_name "${line}" ",")
    if ! is_null "${id}" && is_int "${id}" && ! is_null "${new_name}"; then
      echo "${new_name}" | lpass edit --non-interactive --name "${id}"
    fi
  done < "${filename}"
}

function confirm(){
  while true; do
    read -p "Are you sure you want to rename the LastPass items?[yn] " yn
    case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit 1;;
      * ) echo "Please answer y or n.";;
    esac
  done  
}

function check_file(){
  if ! file_exists "${1}"; then
    printf "%s, %s\n" "File does not exist" "${1}"
    exit 1
  fi
}

function main(){
  # check_file "$@"
  check_apps
  check_status
  confirm
  rename_items "$@"
}

if [ $# -ne 1 ]; then usage_error "${SCRIPT_NAME}"; fi                                                                                                                                                                                                                     

# https://www.jamescoyle.net/how-to/1774-bash-getops-example
# https://opensource.com/article/19/12/help-bash-program
# Get the options
# while getopts ":hv" o; do
while getopts ":hv-" o; do
  # support long options: https://stackoverflow.com/a/28466267/519360
  if [ "${o}" = "-" ]; then   # long option: reformulate o and OPTARG
    o="${OPTARG%%=*}"       # extract long option name
    OPTARG="${OPTARG#"$o"}"   # extract long option argument (may be empty)
    OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
  fi
  case "${o}" in
    h|help)    show_help "${SCRIPT_NAME}" "${SCRIPT_DESC}";;
    v|version) show_version "${SCRIPT_NAME}" "${SCRIPT_VERSION}";;
    ??*)         usage_error "${SCRIPT_NAME}";;
    ?)           usage_error "${SCRIPT_NAME}";;
  esac
done
shift $((OPTIND-1)) # remove parsed options and args from $@ list
main "$@"
