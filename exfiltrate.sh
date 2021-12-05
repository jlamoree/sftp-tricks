#!/usr/bin/env bash

#
# The sshpass utility comes from the sshpass package, widely available:
#   Homebrew: brew install esolitos/ipa/sshpass
#   Ubuntu: apt install sshpass
#   RHEL-ish: yum install sshpass
#
# It looks for the password in the SSHPASS environment variable and will emit it to the server when prompted.
#

# Setup
project_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
sftp_user=slappy
sftp_host=secure.whistleblower.pizza
payload="${project_dir}/bigdata.txt"

# Option 1
# Fetch the secret using the special decryption program
export SSHPASS=$("${project_dir}/decrypter.sh")
sshpass -e sftp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $sftp_user@$sftp_host <<EOF
put $payload
exit
EOF


# Option 2
# Have sshpass read the password
sshpass -f "${project_dir}/.password" sftp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $sftp_user@$sftp_host <<EOF
put $payload
exit
EOF
