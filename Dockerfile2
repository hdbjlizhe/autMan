FROM debian:bookworm-slim

WORKDIR /autMan

RUN mkdir /app \
	&& cd /app \
	&& apt update \
        && apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git \
	&& apt install -y curl jq wget tar python3 python3-pip nodejs npm golang \
	&& apt install -y php php-cli php-fpm php-mysqli php-json \
        && mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.bk \
	&& curl https://pyenv.run | bash \
        && echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> /etc/profile \
	&& echo 'eval "$(pyenv init --path)"' >> /etc/profile \
	&& echo 'eval "$(pyenv init -)"' >> /etc/profile \
	&& echo 'eval "$(pyenv virtualenv-init -)"' >> /etc/profile
 

RUN pip3 install requests PyExecJS aiohttp bs4 sseclient-py sseclient -i https://pypi.tuna.tsinghua.edu.cn/simple \
	&&npm install pnpm axios request require crypto-js global-agent got@11 dotenv base-64 jquery node-rsa fs png-js cheerio MD5 md5 -g

ADD . /app/autMan/
COPY ./docker-entrypoint.sh /bin/
COPY ./MSYH.TTF /usr/share/fonts/MSYH.TTF

#设置golang环境变量
ENV GO111MODULE=on \
	GOPROXY=https://goproxy.cn \
	NODE_PATH=/usr/local/lib/node_modules

RUN chmod a+x /bin/docker-entrypoint.sh \
	&& apt install -y git bash ffmpeg chromium

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
