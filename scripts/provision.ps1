Set-StrictMode -Version 'Latest'

$VerbosePreference = 'Continue'
$ErrorActionPreference = 'Stop'

choco install jdk8 -y --allow-empty-checksums
choco install jenkins --version 2.46.1 -y --allow-empty-checksums
choco install nginx-service -y --allow-empty-checksums

# Setup firewall
New-NetFirewallRule -DisplayName "Inbound HTTP Port 80" -Direction Inbound -Action Allow -LocalPort 80 -Protocol TCP
# Create logs folder for Jenkins
New-Item -Path C:\ProgramData\nginx\logs\jenkins -ItemType Directory
