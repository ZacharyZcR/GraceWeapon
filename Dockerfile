# 基础设置阶段
FROM ubuntu:22.04 as base

# 更新apt包管理器并安装zsh和curl
RUN apt-get update && \
    apt-get install -y zsh curl git net-tools

# 安装Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# 安装zsh-autosuggestions插件
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 安装zsh-syntax-highlighting插件
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 安装Powerlevel10k主题
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 环境配置阶段
FROM base as final

# 安装其他所需的软件
RUN apt-get install -y python3.10 nmap python3-pip

# 创建python符号链接
RUN ln -s /usr/bin/python3.10 /usr/bin/python

# 克隆OneForAll项目到用户主目录
RUN git clone https://github.com/shmilylty/OneForAll.git ~/OneForAll

# 安装OneForAll依赖
RUN python3 -m pip install -U pip setuptools wheel -i https://mirrors.aliyun.com/pypi/simple/ && \
    pip3 install -r ~/OneForAll/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

# 克隆sqlmap项目到用户主目录
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git ~/sqlmap-dev

# 为OneForAll和sqlmap设置别名
RUN echo 'alias oneforall="python3 ~/OneForAll/oneforall.py"' >> ~/.zshrc && \
    echo 'alias sqlmap="python3 ~/sqlmap-dev/sqlmap.py"' >> ~/.zshrc

# 更新.zshrc配置
RUN echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
RUN echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
RUN sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# 设置工作目录
WORKDIR /root

# 设置默认shell为zsh
SHELL ["/bin/zsh", "-c"]

# 当容器启动时，保持运行状态
CMD ["zsh"]
