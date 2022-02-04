#!/bin/bash
set -eu -o pipefail -E 

ENVS=()
REGION="eu-west-1"
PARAMETERS=()
TYPE="SecureString"

usage() {
  echo "$__usage"
  exit 1
}

__usage="
Usage: $(basename "$0") [OPTIONS]

Options:
  -e, --envs         environment list (separated by comma, named as aws profiles) i.e. dev,stage,prod
  -p, --parameters   name-value key separated by ; i.e. name1=value1;name2={\"key1\": \"value1\", \"key2\": \"value2\"}
  -r, --region       aws region (defualt eu-west-1)
  -t, --type         parameter type (defualt SecureString)
"

if (( $# < 1 ))
then
  usage
fi

while [ $# -gt 0 ]; do
  case "$1" in
    -e|--envs)
      shift
      IFS=, read -ra ENVS <<< "$1"
      ;;
    -e=*|--envs=*)
      IFS=, read -ra ENVS <<< "${1#*=}" 
      ;;
    -r|--region)
      shift
      REGION="$1"
      ;;
    -r=*|--region=*)
      REGION="${1#*=}"
      ;;
    -p|--parameters)
      shift
      IFS=';' read -ra PARAMETERS <<< "$1"
      ;;
    -p=*|--parameters=*)
      IFS=';' read -ra PARAMETERS <<< "${1#*=}" 
      ;;
    -t|--type)
      shift
      TYPE="$1"
      ;;
    -t=*|--type=*)
      TYPE="${1#*=}"
      ;;
    -h|--help|-h=*|--help=*)
      usage
      ;;
    *)
      usage
      ;;
  esac
  shift
done

if [[ -z "$ENVS" ]] || [[ -z "$PARAMETERS" ]]
then
  usage
fi

for env in "${ENVS[@]}"
do
  echo "Env: $env"
  export AWS_PROFILE=$env
  for pair in "${PARAMETERS[@]}"
  do
  	IFS='=' read -ra params <<< "$pair"
  	echo "Key=${params[0]}, Value=${params[1]}, type=$TYPE, region=$REGION"
    aws ssm put-parameter \
      --name "${params[0]}" \
      --type "$TYPE" \
      --value "${params[1]}" \
      --overwrite
      --region $REGION
  done
done
