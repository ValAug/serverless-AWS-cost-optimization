import boto3

region = "us-east-1"
instance_ids = ["i-ec2id-from-previous-deployment"]

def stop_instances(instance_ids, region):
    ec2 = boto3.client('ec2', region_name=region)
    response = ec2.stop_instances(InstanceIds=instance_ids)
    
    if response['StoppingInstances']:
        print('Instances successfully stopped: {}'.format(instance_ids))
    else:
        print('Failed to stop instances.')

def handler(event, context):
    stop_instances(instance_ids, region)
