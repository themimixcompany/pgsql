#!/usr/bin/env bash

set -euo pipefail

readonly SELF="$(basename ${BASH_SOURCE[0]})"
readonly SELF_DIR="$(cd $(dirname $(readlink -f ${BASH_SOURCE[0]})) > /dev/null 2>&1 && pwd)"
readonly OS="$(uname)"
readonly VERSION="1.0.2"

OPT_HELP=
OPT_DEBUG=
OPT_VERBOSE=
OPT_VERSION=

OPT_CONFIG="/var/miki/config.yml"
OPT_FILE=

function error () {
  if [[ "${OS}" == "Darwin" ]]; then
    echo "ERROR: ${@}" >&2
  else
    echo -e "\e[0;31m\e[1mERROR: \e[0;0m${@}" >&2
  fi

  exit 1
}

function warn () {
  if [[ "${OS}" == "Darwin" ]]; then
    echo "WARNING: ${@}" >&2
  else
    echo -e "\e[0;33mWARNING: \e[0;0m${@}" >&2
  fi
}

function debug () {
  if [[ -n "${OPT_DEBUG}" ]]; then
    echo -n "** "
    echo "\${PWD}: ${PWD}"
    echo "\${@}: ${@}"
  fi
}

function parse_arguments () {
  debug ${FUNCNAME[0]} "$@"

  local opts=$(getopt -n "${SELF}" --options C:f: --longoptions help,debug,verbose,config:,file: -- "$@")

  if [[ $? != 0 ]]; then
    error "Failed to parse arguments. Aborting."
  fi

  eval set -- "${opts}"

  while true; do
    case "$1" in
      (--help) OPT_HELP=true; shift ;;
      (--debug) OPT_DEBUG=true; shift ;;
      (--verbose) OPT_VERBOSE=true; shift ;;
      (--version) OPT_VERSION=true; shift ;;
      (-C|--config) OPT_CONFIG=$2; shift 2 ;;
      (-f|--file) OPT_FILE=$2; shift 2 ;;
      (*) break ;;
    esac
  done
}

function process_arguments () {
  debug ${FUNCNAME[0]} "$@"

  if [[ -n "${OPT_HELP}" ]]; then
    display_usage
  elif [[ -z "${OPT_CONFIG}" ]]; then
    display_usage
 else
    return 0
  fi
}

function display_usage () {
  debug ${FUNCNAME[0]} "$@"

  cat << EOF
${SELF} v${VERSION} [OPTIONS]...

OPTIONS:
      --help     Show this help
      --debug    Enable debugging mode
      --verbose  Enable verbose output
      --version  Display program version info
  -C, --config   Set config source
  -f, --file     Specify the SQL file to load
EOF
  exit 0
}

function display_version () {
  debug ${FUNCNAME[0]} "$@"

  cat << EOF
${SELF} v${VERSION}
EOF
  exit 0
}

function query () {
  debug ${FUNCNAME[0]} "$@"

  yq -y "$1" "${OPT_CONFIG}" | sed 2d
}

function run_psql () {
  debug ${FUNCNAME[0]} "$@"

  local password=$(query '.db.pass' "${OPT_CONFIG}")
  local host=$(query '.db.host' "${OPT_CONFIG}")
  local dbname=$(query '.db.db' "${OPT_CONFIG}")
  local username=$(query '.db.user' "${OPT_CONFIG}")

  sudo PGPASSWORD="${password}" psql --host="${host}" --dbname="${dbname}" \
       --username="${username}" "$@"
}

function run () {
  debug ${FUNCNAME[0]} "$@"

  if [[ -n "${OPT_FILE}" ]]; then
    run_psql "--file=${OPT_FILE}"
  else
    run_psql
  fi
}

function main () {
  debug ${FUNCNAME[0]} "$@"

  parse_arguments "$@"
  process_arguments "$@"

  run "$@"
}

main "$@"
