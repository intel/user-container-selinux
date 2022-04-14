FROM registry.access.redhat.com/ubi8/ubi:latest

RUN yum -y install --disableplugin=subscription-manager selinux-policy

ADD intelplugins.pp.bz2 /tmp/intelplugins.pp.bz2

#CMD semodule -i /tmp/intelplugins.pp.bz2
CMD bash
