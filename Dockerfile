FROM ubuntu:22.04

ENV TOKEN=""
ENV ORGANIZATION=""
ENV SSHKEY=""

ENV BINARY_URL=https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-x64-2.319.1.tar.gz
ENV HOST=https://github.com
ENV RUNNER_ALLOW_RUNASROOT=1
ENV RUNNER_NAME=ansible-runner
ENV RUNNER_GROUP=Default
ENV RUNNER_LABELS="self-hosted,Linux,X64"
ENV RUNNER_WORKDIR=_work

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y software-properties-common openssh-client sshpass sudo curl software-properties-common python3-pip libssh-dev && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt install -y ansible && \
    apt clean

RUN pip install \
    --user \
    --no-binary ansible-pylibssh \
    ansible-pylibssh

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# RUN useradd runner && \
#     echo "runner:runner" | chpasswd && \
#     chsh -s /usr/bin/bash runner && \
#     usermod -aG sudo runner && \
#     mkdir /ansible-runner && \
#     echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
#     chown runner:runner /ansible-runner

# USER runner
WORKDIR /ansible-runner

COPY exec-runner.sh /ansible-runner/exec-runner.sh

RUN curl -fsSL -o actions-runner.tar.gz -L $BINARY_URL && \
    tar xf actions-runner.tar.gz && \
    rm actions-runner.tar.gz && \
    sudo ./bin/installdependencies.sh

CMD ["/ansible-runner/exec-runner.sh"]

