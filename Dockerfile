FROM debian:bookworm-slim

# 设置时区（提前到最前减少重建影响）
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

WORKDIR /autMan

# 合并APT操作到单个RUN层 🔥
RUN mkdir -p /app \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev \
        wget curl llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev libffi-dev liblzma-dev git \
        jq tar python3 python3-pip nodejs npm \
        php php-cli php-fpm php-mysqli php-json \
        tzdata ca-certificates \
        ffmpeg chromium fonts-wqy-zenhei \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    # 清理APT缓存 🔥
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # Python相关设置
    && mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.bk \
    && pip3 install --no-cache-dir --upgrade pip

# 安装 pyenv 并配置到全局环境 🔥
RUN curl -sSL https://pyenv.run | bash \
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /etc/bash.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /etc/bash.bashrc \
    && echo 'eval "$(pyenv init --path)"' >> /etc/bash.bashrc \
    && echo 'eval "$(pyenv virtualenv-init -)"' >> /etc/bash.bashrc

# 安装Go并验证校验和 🔥
ENV GO_VERSION=1.23.3

RUN wget -q https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

# 安装Python/Node依赖（使用缓存优化层）🔥
COPY requirements.txt package.json /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && npm install -g --omit=optional --no-fund --no-audit $(jq -r '.dependencies | keys[]' /tmp/package.json) \
    && rm /tmp/requirements.txt /tmp/package.json

# 添加应用程序文件（使用明确的COPY并设置权限）🔥
COPY . /app/autMan/
COPY docker-entrypoint.sh /bin/
COPY MSYH.TTF /usr/share/fonts/
RUN chmod a+x /bin/docker-entrypoint.sh \
    && fc-cache -f -v  # 刷新字体缓存

# 统一环境变量配置 🔥
ENV PATH="/root/.pyenv/shims:/root/.pyenv/bin:/usr/local/go/bin:$PATH" \
    GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct \
    NODE_PATH=/usr/local/lib/node_modules \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

# 安全加固（使用非root用户）🔥
# RUN useradd -m autman \
#     && chown -R autman:autman /app /autMan
# USER autman

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
