#!/bin/bash

set -euo pipefail # strict mode

stack_name="$1"

aws cloudformation describe-stack-events --stack-name ${stack_name} > z.json

jq  < z.json > .diagnose.txt --raw-output \
    '.StackEvents[]|.ResourceStatus, .ResourceStatusReason, .ResourceProperties'

egrep -v '^null$' .diagnose.txt

# TODO: zoom to "rollback in progress" stanza?
# | egrep -A20 ROLLBACK_IN