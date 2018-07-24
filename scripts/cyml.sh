#!/bin/bash

source printers

function parse_yaml {
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s=\"%s\"\n",vn, $2, $3);
      }
   }'
}

function check {
  awk > /dev/null
  MISSING "awk"
  sed --version > /dev/null
  MISSING "sed"
}

case "$1" in
  "check")
    check
    ;;
  "parse")
    parse_yaml $2
    ;;
  *)
    UNSUPPORTED $0 $1
    ;;
esac

