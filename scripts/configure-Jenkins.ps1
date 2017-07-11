Set-StrictMode -Version 'Latest'
$VerbosePreference = 'Continue'
$ErrorActionPreference = 'Stop'

$jenkinsJarFile = 'C:\Program Files (x86)\Jenkins\jenkins-cli.jar'
$jenkinsAdmin = 'admin'
$jenkinsURL = 'http://127.0.0.1:8080'

Function Enable-JenkinsClientConnection {
  param (
    [string]$slaveAgentPort
  )
  $jenkinsConfigPath = Join-Path ${env:ProgramFiles(x86)} Jenkins\config.xml
  [xml]$jenkinsConfig = Get-Content $jenkinsConfigPath
  $jenkinsConfig.hudson.slaveAgentPort = $slaveAgentPort
  'Saving Jenkins Config file to {0}' -f $jenkinsConfigPath
  $jenkinsConfig.Save($jenkinsConfigPath)
}

Function Get-JenkinsJarFile {
  param (
    $jenkinsJarFile
  )
   Invoke-RestMethod -Uri "${jenkinsURL}/jnlpJars/jenkins-cli.jar" -Method Get -OutFile $jenkinsJarFile
}

Stop-Service -Name Jenkins -Force
'Enabling connections to Jenkins via the CLI'
Enable-JenkinsClientConnection -slaveAgentPort '49817'
Start-Service -Name Jenkins
Start-Sleep -Seconds 120

$initialAdminPassword = Get-Content -Path 'C:\Program Files (x86)\Jenkins\secrets\initialAdminPassword'

Get-JenkinsJarFile -jenkinsJarFile $jenkinsJarFile

$jenkinsPlugins = @(
  'ace-editor',
  'ant',
  'antisamy-markup-formatter',
  'azure-vm-agents',
  'bouncycastle-api',
  'branch-api',
  'build-timeout',
  'cloudbees-folder',
  'credentials',
  'credentials-binding',
  'display-url-api',
  'durable-task',
  'email-ext',
  'external-monitor-job',
  'git',
  'git-client',
  'git-server',
  'github',
  'github-api',
  'github-branch-source',
  'github-organization-folder',
  'gradle',
  'handlebars',
  'icon-shim',
  'jquery-detached',
  'junit',
  'ldap',
  'mailer',
  'mapdb-api',
  'matrix-auth',
  'matrix-project',
  'momentjs',
  'pam-auth',
  'pipeline-build-step',
  'pipeline-graph-analysis',
  'pipeline-input-step',
  'pipeline-milestone-step',
  'pipeline-rest-api',
  'pipeline-stage-step',
  'pipeline-stage-view',
  'plain-credentials',
  'powershell',
  'resource-disposer',
  'scm-api',
  'script-security',
  'ssh-credentials',
  'ssh-slaves',
  'structs',
  'subversion',
  'timestamper',
  'token-macro',
  'windows-slaves',
  'workflow-aggregator',
  'workflow-api',
  'workflow-basic-steps',
  'workflow-cps',
  'workflow-cps-global-lib',
  'workflow-durable-task-step',
  'workflow-job',
  'workflow-multibranch',
  'workflow-scm-step',
  'workflow-step-api',
  'workflow-support',
  'ws-cleanup'
)

foreach ($jenkinsPlugin in $jenkinsPlugins) {
  'Installing Plugin {0}' -f $jenkinsPlugin
  . java -jar $jenkinsJarFile -s $jenkinsURL -noKeyAuth install-plugin $jenkinsPlugin --username $jenkinsAdmin --password $initialAdminPassword
}

Copy-Item -Path 'C:\Program Files (x86)\Jenkins\jenkins.install.UpgradeWizard.state' -Destination 'C:\Program Files (x86)\Jenkins\jenkins.install.InstallUtil.lastExecVersion'
