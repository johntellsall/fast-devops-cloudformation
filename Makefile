STACK_NAME := johnmitchell-topic-9
BUCKET := stelligent-u-john.mitchell.labs-apr2
# TODO fetch from AWS
INVOKE_URL := https://dfsxy67vtb.execute-api.us-east-2.amazonaws.com/call
SOURCE_DIR := src

all:

#
# APP LAYER :::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
# invoke-app -- call app via HTTP (APIGW)
invoke-app:
	curl --silent \
	--header "Content-Type: application/json" \
	--request POST \
	--data '{"key1":"beer"}' \
	${INVOKE_URL}
#
# PYTHON LAYER :::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
lint-format-python:
	black ${SOURCE_DIR}
	flake8 ${SOURCE_DIR}

invoke-local:
	cd ${SOURCE_DIR} ; python -c 'import hello; print(hello.handler({"key1":"beer"}, None))'

# dev-local -- run code locally when source changes
dev-local:
	git ls-files '*.py' | entr -c make lint-format-python invoke-local
#
# LAMBDA LAYER :::::::::::::::::::::::::::::::::::::::::::::::::::::::
#

# invoke -- call Lambda directly
# TODO pass arg
invoke-lambda:
	aws lambda invoke \
	--function-name my-function \
	/dev/stdout

#
# RESOURCE LAYER :::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
lint-format-resource:
	cfn-format --write template.yaml
	cfn-lint template.yaml

deploy-resource: lint-format-resource
	@echo Package and upload code, create new template
	aws cloudformation package \
		--template-file template.yaml \
		--s3-bucket ${BUCKET} \
		--output-template-file output.yaml
	@echo Deploy from generated template
	aws cloudformation deploy \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-file output.yaml --stack-name ${STACK_NAME}

show-code:
	aws s3 ls s3://${BUCKET}

show-outputs:
	aws cloudformation describe-stacks --stack-name ${STACK_NAME} \
	| jq '.Stacks[].Outputs'

deploy: lint-format-resource deploy-resource show-code show-outputs

dev-all:
	git ls-files | entr make deploy

delete-resource:
	aws cloudformation delete-stack --stack-name ${STACK_NAME}

#
# OTHER :::::::::::::::::::::::::::::::::::::::::::::::::::::::
#

# # download Lambda zip and show on stdout
# check-lambda:
# 	aws s3 cp s3://stelligent-u-john.mitchell.labs-apr1/hello.zip output.zip
# 	unzip -p - output.zip


# ping -- abort if creds not right (e.g. check AWS_PROFILE)
ping:
	@aws sts get-caller-identity > /dev/null
