Content-Type: multipart/mixed; boundary="BOUNDARY"

--BOUNDARY
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: jlr-stage-eks-cluster
    apiServerEndpoint: https://3C22899D1256BC0E2507D77FE7D73C6D.gr7.us-east-1.eks.amazonaws.com
    certificateAuthority: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJQjIwQms3d1dzQlV3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRBeE1UVXhNVEV3TkRsYUZ3MHpOREF4TVRJeE1URTFORGxhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUM3em04UDh6MlFpWG1MUUJITjZmM0R4RjlWKzFQelhEWU1xVHRId3hseUhUZ3pVeFFhckZrQlJjVDEKVGpuMjVkcTk4MDBRYUpBUW5FeW5qM1hKcTF3ZWRPM3RXQ01CMEdUUllOWm9JMTFxVzVmOUhvcnlNQzZKU1l3QwpRL0FEdmp5TkthWVFFemhaSUlEU0hSako1dUtqZ1NLNVBmbFY1K00xOG5MNGYxYk5tbkI2WGQySVJPVzZDK1g1CnJjRm1rNWczMmlxNldqWjJtSW1PRnhjZDNBMnpIWm81UVhIWllLK295bUtYNG85d0d2TW9tNjN0U3hRMXRqZlMKRnltOUlDVURZQ2hSanJPV2xVdlBvMUJFSXRWZUk5YndiMExKcTJpSXhHS0puTUFoMXJBUGVVcWk3ekNZZDBRVAoxbjg3cWR5Vnl2NVg5NFA3YjQ4M0dvU0YrME4zQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSbDc1UnUvUmQ1SG5Ua3gvaHJzaHV5UEVPMFlEQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQmNvczErMGxSQwpBVmhFdjU5L0VMNFVYZS9tZzdGRFJkS0VZN1c0alFSN1I0aitUbWphZ0VnT3V3blZ2MjZLOEN6dG50OHNFL0s2CjhPalVacnFBR2U5bnRZRWR6THUzeGdodFNJNzRzRWRoY2NEc1BEYTl5RWcrQkp0UE1XZEJaNUluaTRLV3lwTjMKTzdmV3RHeGJHWWMzV3ZTMXoyNHN6Q1BMNm45MjFmeVByM0dUbkIrZHpYa3N1MWg2SDRzS1pjUEdwbWdwSHRpYwp1WUYrcU16bTR6RUtKQ3RQSTFoTEJyaEM5dG90a1ZNRFA5WDY0T2VGcnE4YjVWVnh4YlVYMDNaQWVuN1NqZGIrCjRjYTYybmQrejFLLytCaGs5amZJcldaZVFTM0ZnTXhDc0NTNmwrOXJhbmZ4N21aWC9hemZqUUhNSUJMTm9MNHEKc0d0dDRaYkZkM0pvCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K

--BOUNDARY
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  kubelet:
    config:
      shutdownGracePeriod: 30s
      featureGates:
        DisableKubeletCloudCredentialProviders: true

--BOUNDARY
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -o xtrace
# Define the nameserver line
line="nameserver 10.14.0.2"

# Check if the line already exists in /etc/resolv.conf
if ! grep -Fxq "$line" /etc/resolv.conf; then
    # Prepend the nameserver line to /etc/resolv.conf without removing any content
    sudo sh -c "echo '$line' > /etc/resolv.conf.tmp && cp /etc/resolv.conf /tmp/resolv.conf && cat /etc/resolv.conf >> /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf"
fi

sleep 10

# Install SSM Agent
yum install -y https://s3.us-west-2.amazonaws.com/amazon-ssm-us-west-2/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Update packages
sudo dnf update -y

# Install Docker
sudo dnf install -y docker cronie
sudo systemctl enable crond.service
sudo systemctl start crond.service

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Go back to the original resolv.conf file that doesn't use AWS DNS
mv /tmp/resolv.conf /etc/resolv.conf

# Ensure IPv4 resolution
echo "ip_resolve=4" | sudo tee -a /etc/dnf/dnf.conf

# Install Amazon EFS Utilities
sudo dnf install -y amazon-efs-utils


# Install Docker and utilities
#sudo amazon-linux-extras install docker -y
#echo "ip_resolve=4" >> /etc/yum.conf
#yum install -y amazon-efs-utils

# Create directories for EFS mounts
mkdir /opt/log /opt/cms /opt/keycloak
sleep 10

# Mount EFS volumes
mount -t efs -o _netdev efs-logs:/ /opt/log
mount -t efs -o _netdev efs-cms:/ /opt/cms
mount -t efs -o _netdev efs-keycloak:/ /opt/keycloak

# Download necessary files from the internal repository
cd /root/
wget -r -np -nH --cut-dirs=1 -R "index.html*" https://repo-access:fwuyBKbfNuMTvRzV@repo.appdevices.com/jlr-eks/

# Download necessary files for nagios installation from the internal repository
cd /root/
wget -r -np -nH --cut-dirs=1 -R "index.html*" https://repo-access:fwuyBKbfNuMTvRzV@repo.appdevices.com/jlr-eks-1.31/

# Setup SSH keys
#mv /root/id_ecdsa /root/.ssh/id_ecdsa
if [ -f /root/id_ecdsa ]; then
    mv /root/id_ecdsa /root/.ssh/id_ecdsa
    chmod go-rwx /root/.ssh/id_ecdsa
else
    echo "SSH key /root/id_ecdsa not found." >&2
fi
#mv /root/id_ecdsa /root/.ssh/id_ecdsa
#chmod go-rwx /root/.ssh/id_ecdsa

# Set executable permissions
chmod u+x /root/bin/kube-install
chmod u+x /root/bin/lbupdate.sh
chmod u+x /root/nagios_install.sh
/root/nagios_install.sh
/root/bin/kube-install

# Update kubeconfig and move cron job for eks info
(sleep 50; /bin/aws eks update-kubeconfig --region us-east-1 --name jlr-stage-eks-cluster; mv /root/eks-info /etc/cron.d/eks-info) &

--BOUNDARY--
EOF
)
