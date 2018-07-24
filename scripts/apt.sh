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

source printers

function check {
  apt-get --version &> /dev/null
  MISSING "apt-get"
}

function apt_install {
  PACKAGES=$1

  INFO "Updating packages..."
  DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null
  FAIL

  if [[ $PACKAGES ]]; then
    INFO "Installing $PACKAGES..."
    DEBIAN_FRONTEND=noninteractive apt-get install -qq $PACKAGES > /dev/null
    FAIL
  else
    WARN "Empty package list. Not gonna install anything."
  fi
}

case "$1" in
  "check")
    check
    ;;
  "install")
    apt_install "${@:2}"
    ;;
  *)
    UNSUPPORTED $0 $1
    ;;
esac
