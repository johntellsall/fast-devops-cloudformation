#!/bin/bash

# get-cfn-events -- display recent CloudFormation events, to diagnose deployments
#
# HINT: watch CloudFormation events as they happen!
#   watch --interval=10 -d ./get-cfn-events.sh mystackname

set -euo pipefail # strict mode

stack_name="$1"

aws cloudformation describe-stack-events --stack-name ${stack_name} > z.json

jq  < z.json > .diagnose.txt --raw-output \
    '.StackEvents[]|.ResourceStatus, .ResourceStatusReason, .ResourceProperties'

egrep -v '^null$' .diagnose.txt
