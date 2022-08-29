#!/bin/sh

# script.sh

# parse input as JSON & assign to a variable
eval "$(jq -r '@sh "name=\(.name);email=\(.email)"')"

#return a valid JSON object
cat <<EOF
{
  "name": "$name",
  "email": "$email"
}
EOF