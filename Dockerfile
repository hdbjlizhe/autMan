FROM debian:bookworm-slim

WORKDIR /autMan

# 安装依赖项
RUN mkdir /app \
	&& cd /app \
	&& apt update \
    && apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git \
    && apt install -y curl jq wget tar python3 python3-pip nodejs npm \
    && apt install -y php php-cli php-fpm php-mysqli php-json \
    && mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.bk

# 安装 pyenv 并配置环境变量
RUN curl https://pyenv.run | bash \
    && echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> /etc/profile \
    && echo 'eval "$(pyenv init --path)"' >> /etc/profile \
    && echo 'eval "$(pyenv init -)"' >> /etc/profile \
    && echo 'eval "$(pyenv virtualenv-init -)"' >> /etc/profile

# 使用 SHELL 指令来改变默认的 shell
SHELL ["/bin/bash", "-c"]

# 安装 Go 1.23.3
RUN wget https://golang.org/dl/go1.23.3.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.23.3.linux-amd64.tar.gz \
    && rm go1.23.3.linux-amd64.tar.gz

# 设置 Go 环境变量
ENV PATH="/usr/local/go/bin:$PATH"

# 运行 source /etc/profile 并安装 Python 包和 Node.js 包
RUN source /etc/profile \
    && pip3 install requests PyExecJS aiohttp bs4 sseclient-py sseclient -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && npm install pnpm axios request require crypto-js global-agent got@11 dotenv base-64 jquery node-rsa fs png-js cheerio MD5 md5 -g

# 添加应用程序文件
ADD . /app/autMan/
COPY ./docker-entrypoint.sh /bin/
COPY ./MSYH.TTF /usr/share/fonts/MSYH.TTF

# 设置 golang 环境变量
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn \
    NODE_PATH=/usr/local/lib/node_modules

# 设置入口点脚本的执行权限
RUN chmod a+x /bin/docker-entrypoint.sh \
    && apt install -y ffmpeg chromium

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
