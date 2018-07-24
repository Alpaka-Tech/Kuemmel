#!/bin/bash

# Kuemmel
# Copyright (C) 2018 Alpaka.Tech
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation in version 2 of the License.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Include printers
source printers

function copyright {
  echo
  echo
  echo
  echo "Kuemmel"
  echo "Copyright (C) 2018 Alpaka.Tech"
  echo
  echo "This program is free software; you can redistribute it and/or modify"
  echo "it under the terms of the GNU General Public License as published by"
  echo "the Free Software Foundation in version 2 of the License."
  echo
  echo "This program is distributed in the hope that it will be useful,"
  echo "but WITHOUT ANY WARRANTY; without even the implied warranty of"
  echo "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"
  echo "GNU General Public License for more details."
  echo
  echo "You should have received a copy of the GNU General Public License along"
  echo "with this program; if not, write to the Free Software Foundation, Inc.,"
  echo "51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA."
  echo
  echo
  echo
}

function stage_err {
  if [[ $? -ne 0 || $1 == "fail" ]]; then
    ERROR "Stage failed. Aborting :("
  fi
}

copyright

# Check if we got all the options
if [[ ! $1 || $1 == "--help" ]]; then
  ERROR "Usage: $0 </path/to/config.yml>"
fi

# Parse that yaml file
./scripts/cyml.sh check
eval $(./scripts/cyml.sh parse $1)

# Work through the steps specified
i=1
while true; do
  step="order_$i"
  [[ "${!step}" ]] || break
  provider="${!step}_provider"
  if [[ ! ${!provider} ]]; then
    ERROR "No provider specified for stage ${!step}"
  else
    if [[ ! -f ./scripts/${!provider}.sh ]]; then
      ERROR "No implementation for provider \"${!provider}\" found."
    fi
  fi
  ./scripts/${!provider}.sh check
  INFO "-> Will run stage ${!step}"
  i=$((i + 1))
done

for ((step=1; step < $i; step++)); do
  stage="order_${step}"
  type="${!stage}_type"
  INFO "## Now running stage ${!stage} ##"
  provider="${!stage}_provider"
  case "${!type}" in
    "install")
      packages="${!stage}_packages"
      ./scripts/${!provider}.sh install "${!packages}"
      stage_err
      ;;
    "download")
      from="${!stage}_from"
      to="${!stage}_to"
      ./scripts/${!provider}.sh download "${!from}" "${!to}"
      stage_err
      ;;
    *)
      INFO "Unsupported type: ${!type}"
      stage_err "fail"
      ;;
  esac
done