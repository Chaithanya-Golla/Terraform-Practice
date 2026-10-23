#!/bin/bash

set -Eeuo pipefail

# Log installation output
exec > >(tee -a /var/log/jenkins-user-data.log) 2>&1

echo "===== Jenkins installation started ====="

# Verify Amazon Linux 2023
source /etc/os-release

if [[ "${ID:-}" != "amzn" || "${VERSION_ID:-}" != "2023" ]]; then
    echo "ERROR: Amazon Linux 2023 is required."
    exit 1
fi

# Update system packages
yum upgrade -y

# Install Java 21 and dependencies
yum install -y \
    fontconfig \
    wget \
    java-21-amazon-corretto

# Verify Java installation
java -version

# Configure Jenkins LTS repository
wget -q -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/rpm-stable/jenkins.repo

# Import Jenkins signing key
rpm --import \
    https://pkg.jenkins.io/rpm-stable/jenkins.io-2026.key

# Refresh package metadata
yum makecache -y

# Install Jenkins
yum install -y jenkins

# Enable and start Jenkins
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# Verify Jenkins service
if systemctl is-active --quiet jenkins; then
    echo "SUCCESS: Jenkins is running."
    rpm -q jenkins
else
    echo "ERROR: Jenkins failed to start."
    systemctl status jenkins --no-pager || true
    journalctl -u jenkins -n 50 --no-pager || true
    exit 1
fi

echo "===== Jenkins installation completed ====="
echo "Jenkins listens on port 8080."
echo "Retrieve the initial password after installation."
