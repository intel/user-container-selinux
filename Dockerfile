FROM registry.access.redhat.com/ubi8/ubi:latest

RUN yum -y install --disableplugin=subscription-manager selinux-policy

ADD container_sr.pp.bz2 /tmp/container_sr.pp.bz2

CMD bash
