FROM gitpod/workspace-base as workspace-base
SHELL ["/bin/bash", "-c"]

# This makes the DDEV global configuration live in persistent /workspace/.config/ddev
ENV XDG_CONFIG_HOME=/workspace/.config

RUN sudo apt-get -qq update

# Install dialog (interactive script)
RUN sudo apt-get -qq install -y dialog

# Install DDEV
USER gitpod
# Add DDEV’s GPG key to your keyring
RUN curl -fsSL https://pkg.ddev.com/apt/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/ddev.gpg > /dev/null
# Add DDEV releases to your package repository
RUN echo "deb [signed-by=/etc/apt/keyrings/ddev.gpg] https://pkg.ddev.com/apt/ * *" | sudo tee /etc/apt/sources.list.d/ddev.list >/dev/null
# Update package information and install DDEV
RUN sudo apt-get update && sudo apt-get install -y ddev

# Install GitUI (terminal-ui for git)
ARG GITUI_VERSION=v0.26.3
RUN wget https://github.com/extrawurst/gitui/releases/download/${GITUI_VERSION}/gitui-linux-x86_64.tar.gz -P /tmp
RUN sudo tar xzf /tmp/gitui-linux-x86_64.tar.gz -C /usr/bin

# Install LazyGit (terminal-ui for git)
ARG LAZYGIT_VERSION=0.43.1
RUN wget https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz -P /tmp
RUN tar -C /tmp -xf /tmp/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz
RUN sudo install /tmp/lazygit /usr/local/bin

# (get latest Minio version from https://dl.min.io/client/mc/release/linux-amd64/)
# Install Minio client
ARG MINIO_CLIENT_VERSION=mcli_20240826104958.0.0_amd64.deb
RUN wget https://dl.min.io/client/mc/release/linux-amd64/${MINIO_CLIENT_VERSION}
RUN sudo dpkg -i ${MINIO_CLIENT_VERSION}
RUN sudo mv /usr/local/bin/mcli /usr/local/bin/mc

# End workspace-base

FROM scratch as drupalpod-gitpod-base
SHELL ["/bin/bash", "-c"]
COPY --from=workspace-base / /
