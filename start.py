import boto3

region = "us-east-1"
instance_ids = ["i-ec2id-from-previous-deployment"]

def start_instances(instance_ids, region):
    ec2 = boto3.client('ec2', region_name=region)
    response = ec2.start_instances(InstanceIds=instance_ids)

    if response['StartingInstances']:
        print('Instances successfully started: {}'.format(instance_ids))
    else:
        print('Failed to start instances.')

def handler(event, context):
    start_instances(instance_ids, region)
