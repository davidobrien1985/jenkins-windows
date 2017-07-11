# Jenkins on Windows Server 2016

This repository holds code to create an AWS AMI for Jenkins.

## How to execute

This repository comes with a PowerShell script to execute all of this on Windows.
The only prerequisite for this to work is to have a local docker installation and a configured AWS CLI. I will remove the dependency on the latter in a next release.
Packer runs perfectly fine on Windows, the abstraction into docker was only introduced to have a common execution layer across platforms.

`.\execute.ps1 -aws_profile david -localuser obrie -aws_region ap-southeast-2 -jenkins_password David1234!`

* `aws_profile` : the local AWS profile in ~/.aws/credentials (this path works on Windows as well)
* `localuser` : depending on your setup your aws credentials are configured in a different user profile than what you are currently executing from. I need to execute this script from an administrative user session, otherwise docker won't run. My AWS credentials are configured in my non-admin user.
* `aws_region` : The AWS region you want to deploy this packer image to.
* `jenkins_password` : the Jenkins default password as a string, clear-text, insecure!!! (Will fix soon)

The script will download a custom docker image `davidobrien/packer_centos` and will map the running working directory into the container. For this to work "drive/folder sharing" needs to be enabled in the docker settings.

The `build-jenkins-master.sh` script will then pick up those values and get the latest Base AMI for Windows Server 2016 for your specific region, so this script will work anywhere you are in the world.

### Flow of execution

`execute.ps1` -> `docker` -> `build-jenkins-master.sh` -> `packer` -> `jenkins-master.json`

## Content

The resulting AWS AMI will consist of a Windows Server 2016 with Jenkins 2.46.1 installed and preconfigured with a bunch of plugins. Check `/scripts/configure-Jenkins.ps1` for the list of plugins that get installed.
The Jenkins version is hard coded because they made a change to the CLI which broke the scripts, plus their doco on the CLI is not really updated, so I'm sticking to the last known working version.
When you spin up the Jenkins AMI after it has been baked you will be able to log on to the Jenkins website with the password you have passed into the first PowerShell script.