#!/bin/bash

# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

growpart /dev/nvme0n1 4
lvextend -l +50%FREE /dev/RootVG/rootVol
lvextend -l +50%FREE /dev/RootVG/varVol
xfs_growfs /
xfs_growfs /var

dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

#kubectl install
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.2/2026-02-27/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/kubectl
#kubectl version


#eksctl install
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl
#sudo mv /tmp/eksctl /usr/local/bin
#eksctl version

eksctl version
kubectl version

#kubens install
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

#k9s tool installation
curl -sS https://webinstall.dev/k9s | bash

# sudo growpart /dev/nvme0n1 4
# sudo xfs_growfs -d /

# aws ec2 modify-volume \
# --volume-id vol-01d8113b317916c88 \
# --size 50

# aws ec2 describe-volumes-modifications \
# --volume-id vol-01d8113b317916c88

# vol-01d8113b317916c88

# sudo dnf install cloud-utils-growpart -y
# sudo growpart /dev/nvme0n1 4
# df -Th
# sudo resize2fs /dev/nvme0n1p4

#kubectl install

# Jenkins install

curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/rpm-stable/jenkins.repo
# Add required dependencies for the jenkins package
yum install fontconfig java-21-openjdk
yum install jenkins
systemctl daemon-reload

systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins
