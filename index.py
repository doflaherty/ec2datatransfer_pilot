import json
import boto3

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))
    s3 = boto3.client('s3')

    # Safely extract bucket name
    bucket = (
        event.get('ResourceProperties', {}).get('BucketName') or
        event.get('BucketName') or
        'sgn-0ps-datatransfer'
    )

    folders = [
        f"Inbound/sgn/",
        f"Outbound/sgn/",
        f"Reports/sgn/"
    ]

    for prefix in folders:
        print(f"Creating folder: {prefix}")
        s3.put_object(Bucket=bucket, Key=prefix)

    return {
        "Status": "SUCCESS",
        "Message": f"Created folders in bucket {bucket}",
    }
