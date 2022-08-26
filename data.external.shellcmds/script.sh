#!/bin/sh

# script.sh

# parse input as JSON & assign to a variable
eval "$(jq -r '@sh "name=\(.name)"')"

#return a valid JSON object
cat <<EOF
{
  "name": "$name"
}
EOF