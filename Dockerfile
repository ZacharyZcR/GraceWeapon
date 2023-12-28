# 基础设置阶段
FROM ubuntu:22.04 as base

# 替换为清华大学的APT镜像源，并安装ca-certificates以修复证书问题
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    echo "\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse\n\
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse\n" > /etc/apt/sources.list && \
    apt-get update

# 安装其他所需软件
RUN apt-get install -y zsh curl git net-tools golang python3.10 python3-pip make gcc

# 设置Git参数以使用加速源
RUN git config --global url."https://mirror.ghproxy.com/".insteadOf https://

# 设置Go代理以加速go get
ENV GOPROXY=https://goproxy.io,direct

# 安装Oh My Zsh
RUN sh -c "$(curl -fsSL https://install.ohmyz.sh/)"

# 安装zsh-autosuggestions插件
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 安装zsh-syntax-highlighting插件
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 安装Powerlevel10k主题
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 更新.zshrc配置
RUN echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
RUN echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
RUN sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# 安装nmap阶段
FROM base as nmap-install

RUN apt-get install -y nmap

# 安装masscan阶段
FROM base as masscan-install

# 克隆masscan项目到用户主目录并编译
RUN git clone https://github.com/robertdavidgraham/masscan ~/masscan && \
    cd ~/masscan && \
    make

# 安装sqlmap阶段
FROM base as sqlmap-install

RUN ln -s /usr/bin/python3.10 /usr/bin/python && \
    git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git ~/sqlmap-dev

# 安装OneForAll阶段
FROM base as oneforall-install

RUN git clone https://github.com/shmilylty/OneForAll.git ~/OneForAll

# 安装ffuf阶段
FROM base as ffuf-install

RUN git clone https://github.com/ffuf/ffuf ~/ffuf
RUN cd ~/ffuf && \
    go get && \
    go build

# 安装dirsearch阶段
FROM base as dirsearch-install

# 克隆dirsearch项目到用户主目录
RUN git clone https://github.com/maurosoria/dirsearch.git ~/dirsearch

# 安装JSFinder阶段
FROM base as jsfinder-install

# 克隆JSFinder项目到用户主目录
RUN git clone https://github.com/Threezh1/JSFinder.git ~/JSFinder

# 最终阶段
FROM base as final

# 从各个阶段复制工具
COPY --from=nmap-install /usr/bin/nmap /usr/bin/nmap
COPY --from=sqlmap-install /root/sqlmap-dev /root/sqlmap-dev
COPY --from=oneforall-install /root/OneForAll /root/OneForAll
COPY --from=ffuf-install /root/ffuf /root/ffuf
COPY --from=dirsearch-install /root/dirsearch /root/dirsearch
COPY --from=jsfinder-install /root/JSFinder /root/JSFinder

# 安装依赖
RUN python3 -m pip install -U pip setuptools wheel -i https://mirrors.aliyun.com/pypi/simple/
RUN pip3 install -r ~/OneForAll/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
RUN pip3 install -r ~/dirsearch/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

# 设置别名
RUN echo 'alias oneforall="python3 ~/OneForAll/oneforall.py"' >> ~/.zshrc && \
    echo 'alias sqlmap="python3 ~/sqlmap-dev/sqlmap.py"' >> ~/.zshrc && \
    echo 'alias ffuf="~/ffuf/ffuf"' >> ~/.zshrc && \
    echo 'alias dirsearch="python3 ~/dirsearch/dirsearch.py"' >> ~/.zshrc && \
    echo 'alias jsfinder="python3 ~/JSFinder/JSFinder.py"' >> ~/.zshrc && \

# 设置工作目录
WORKDIR /root

# 设置默认shell为zsh
SHELL ["/bin/zsh", "-c"]

# 当容器启动时，保持运行状态
CMD ["zsh"]
