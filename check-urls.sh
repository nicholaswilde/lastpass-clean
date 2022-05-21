#!/bin/bash
# set -e
# set -o pipefail

SCRIPT_VERSION="0.1.0"

SCRIPT_NAME="$(basename "${0}")"
SCRIPT_DESC="Check LastPass vault for dead urls"
readonly SCRIPT_NAME
readonly SCRIPT_DESC
readonly SCRIPT_VERSION

source ./lib/libbash

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
      domain=$(split "${domain}" ".")
      if ! test_domain "${domain}"; then
        s=$(printf "%s,%s,%s" "${id}" "${name}" "${domain}")
        printf "(${k}/${n})\t%s\n" "${s}"
        arr+=("${s}")
      fi
    fi
  done
  printf "%s\n" "${arr[@]}" > "${filename}"
}

function main(){
  check_apps
  check_urls "$@"
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
