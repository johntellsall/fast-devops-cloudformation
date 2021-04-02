As engineers, we want to "MIN LAG GAP":
1) minimize the LAG between our changes and seeing the results, and
2) minimize the GAP from what we've produced and what our client wants.

This repos shows how to do this with AWS CloudFormation, for a simple Lambda function behind an API Gateway.

# GOAL:
- Python code running behind Gateway

# LAYERS:
- App: web api returns data from POST
- Lambda/Python: update Python code
- Resource: structure of Lambda, API Gateway

# FEEDBACK:
- Vscode (very fast, dumb)
- lint (fast, good)
- direct invoke
- outer level metadata
