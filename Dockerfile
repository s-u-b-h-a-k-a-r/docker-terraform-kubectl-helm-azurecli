FROM microsoft/azure-cli

ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="terraform-helm-kubectl-azurecli" \
      org.label-schema.url="https://hub.docker.com/r/subhakarkotta/terraform-kubectl-helm-azurecli/" \
      org.label-schema.vcs-url="https://github.com/subhakarkotta/docker-terraform-kubectl-helm-azurecli" \
      org.label-schema.build-date=$BUILD_DATE

ENV TERRAFORM_VERSION="0.11.14"

RUN apk update && \
    apk add curl jq python bash ca-certificates git openssl unzip wget && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*


# Note: Latest version of kubectl may be found at:
# https://aur.archlinux.org/packages/kubectl-bin/

ENV KUBE_LATEST_VERSION="v1.14.3"

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases

ENV HELM_VERSION="v2.14.1"

RUN apk add --no-cache ca-certificates bash git openssh curl \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

ENTRYPOINT ["/bin/bash"]