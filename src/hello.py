def handler(event, context):
    print(f"event: {event}")
    print(f"keys: {sorted(event.keys())}")
    # allow call via APIGW or direct invoke
    # - context given via API Gateway, but not in a direct Invoke
    return {
        "body": "Hello there 852",
        "headers": {"Content-Type": "text/plain"},
        "statusCode": 200,
    }
