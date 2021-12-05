#!/usr/bin/env bash

#
# The sshpass utility comes from the sshpass package, widely available:
#   Homebrew: brew install esolitos/ipa/sshpass
#   Ubuntu: apt install sshpass
#   RHEL-ish: yum install sshpass
#
# Two options are presented below. If an external program needs to perform the decryption,
# capture the plain text into an environment variable.
#
# If the secret is readable directly, have sshpass get the content from the file.
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
