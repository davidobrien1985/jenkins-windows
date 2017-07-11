param (
    [string]$aws_profile,
    [string]$localuser,
    [string]$aws_region,
    [string]$jenkins_default_password
)

$aws_creds = (Get-AWSCredential -ProfileLocation C:\Users\$localuser\.aws\credentials -ProfileName $aws_profile).GetCredentials()
$AWS_ACCESS_KEY_ID= $aws_creds.AccessKey 
$AWS_SECRET_ACCESS_KEY= $aws_creds.SecretKey
$AWS_DEFAULT_REGION= $aws_region

$location = (Get-Location).Path

docker run -e JENKINS_DEFAULT_PASSWORD=$jenkins_default_password -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION -v ${location}:/packer -t davidobrien/packer_centos bash /packer/build-jenkins-master.sh