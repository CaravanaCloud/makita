FROM gitpod/workspace-full

# OS Packages
RUN bash -c "sudo apt-get update"
RUN bash -c "sudo pip install --upgrade pip"
RUN bash -c "sudo install-packages gettext htop"


# Java, Maven and Quarkus
ARG JAVA_VERSION=21-amzn
RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh \
    && sdk install java ${JAVA_VERSION} \
    && sdk default java ${JAVA_VERSION} \
    && sdk install maven \
    &&  sdk install quarkus"

# AWS CLI
RUN bash -c "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' && unzip awscliv2.zip && sudo ./aws/install"

# AWS SAM
RUN bash -c "curl -Ls 'https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip' -o '/tmp/aws-sam-cli-linux-x86_64.zip' && unzip '/tmp/aws-sam-cli-linux-x86_64.zip' -d '/tmp/sam-installation' && sudo '/tmp/sam-installation/install' && sam --version"

# AWS CDK
RUN bash -c "npm install -g aws-cdk"
