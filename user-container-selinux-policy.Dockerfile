# Copyright 2022 Intel Corporation. All Rights Reserved.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# FINAL_BASE can be used to configure the base image of the final image.
#
# FINAL_BASE is primarily used to build Redhat Certified Openshift Operator container images that must be UBI based.
ARG FINAL_BASE=registry.access.redhat.com/ubi8-minimal:latest
FROM centos as builder

ARG DIR=/user-container-selinux
WORKDIR ${DIR}
COPY . .

RUN dnf -y --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos && \
    dnf -y distro-sync && \
    dnf -y install make selinux-policy selinux-policy-devel container-selinux && \
    make -f /usr/share/selinux/devel/Makefile

RUN install -D ${DIR}/LICENSE /install_root/licenses/user-container-selinux/LICENSE && \
    install -D ${DIR}/container_sr.pp /install_root/opt/selinux-policy/container_sr.pp

FROM ${FINAL_BASE}

LABEL name='user-container-selinux-policy' 
LABEL vendor='Intel®' 
LABEL version='0.1' 
LABEL release='1' 
LABEL summary='SELinux policy deployment tailored for device plugins or other user workloads for RedHat OpenShift' 
LABEL description='SELinux policy deployment tailored for device plugins or other user workloads for RedHat OpenShift Container Platform. In RedHat OpenShift, the SELinux is in enforcing mode by default. Containers run in the container_t domain by default, but containers running device plugins do not have enough privileges to run correctly. This policy grants the necessary privileges to those containers.'

RUN microdnf upgrade && \
    microdnf -y install selinux-policy && \
    microdnf clean all && rm -rf /var/cache/yum

COPY --from=builder /install_root /

ENTRYPOINT [ "/bin/sh", "-c", "semodule -i /opt/selinux-policy/container_sr.pp" ]
