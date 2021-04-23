#!/bin/bash

# Usage : zip.sh source.txt otp

# Set your key here.
APIKEY=<API KEY>
RAPIDKEY=<RAPID KEY>

# Linux
# Generate keywords and passwords.
PASSWORD=$(tr -dc 'A-Za-z0-9#%@&()' < /dev/urandom | fold -w64 | head -n 1)
KEY=$(tr -dc 'A-Za-z0-9' < /dev/urandom | fold -w8 | head -n 1)

# MAC
# Generate keywords and passwords.
# PASSWORD=$(LC_CTYPE=C tr -dc 'A-Za-z0-9#%@&()' < /dev/urandom | fold -w64 | head -n 1)
# KEY=$(LC_CTYPE=C tr -dc 'A-Za-z0-9' < /dev/urandom | fold -w8 | head -n 1)

ZIPFILE=${1}
OTP=${2}
KEYID=${OTP::12}

# call DAuth API

# Rapid
RESULT=$(curl \
  -X POST \
  -s \
  -H "X-DAUTH-API-KEY:${APIKEY}" \
  -H "x-rapidapi-key: ${RAPIDKEY}" \
  -H "Content-Type: application/json" \
  -d '{"device_id":"'${KEYID}'", "key":"'${KEY}'", "value":"\"'${PASSWORD}'\""}' \
  'https://dauth-trial.p.rapidapi.com/v1/dkvs' \
)

# Error check
if [ "`echo ${RESULT} | grep 'errors'`" ] ; then
  echo "Error!!"
  echo "`echo ${RESULT} | jq -r '.errors[0].message'`"
  exit 1
fi

# zip
zip -e --password=${PASSWORD} ${ZIPFILE}.${KEY}.zip ${ZIPFILE}
