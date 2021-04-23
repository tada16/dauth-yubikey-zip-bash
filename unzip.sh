#!/bin/bash

# Usage : unzip.sh file.xxxxxxxx.zip otp

# Set your key here.
APIKEY=<API KEY>
RAPIDKEY=<RAPID KEY>

# Get the keyword from the file name.
# test.txt.XXXXXX.zip -> XXXXXX
ZIPFILE=${1}
KEY=$(echo ${ZIPFILE} | sed 's/^.*\.\([^\.]*\)\.\([^\.]*\)$/\1/')
OTP=${2}

# call DAuth API
RESULT=$(curl \
  -s \
  -H "X-DAUTH-API-KEY:${APIKEY}" \
  -H "x-rapidapi-key: ${RAPIDKEY}" \
  "https://dauth-trial.p.rapidapi.com/v1/dkvs/yubikey_otp?key=${KEY}&otp=${OTP}")

# Error check
if [ "`echo ${RESULT} | grep 'errors'`" ] ; then
  echo
  echo "Error!!"
  echo "`echo ${RESULT} | jq -r '.errors[0].message'`"
  exit 1
fi

PASSWORD=`echo ${RESULT} | jq -r '.[0].value'`

unzip -o -P ${PASSWORD} ${ZIPFILE}