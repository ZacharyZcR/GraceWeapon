# 使用Ubuntu 22.04作为基础镜像
FROM ubuntu:22.04

# 更新apt包管理器并安装所需的软件
RUN apt-get update && \
    apt-get install -y python3.10 git nmap zsh curl

# 创建python符号链接
RUN ln -s /usr/bin/python3.10 /usr/bin/python

# 克隆sqlmap项目
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev

# 重命名sqlmap.py为sqlmap
RUN ln -s /sqlmap-dev/sqlmap.py /usr/bin/sqlmap

# 安装Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

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

# 设置工作目录
WORKDIR /root

# 设置默认shell为zsh
SHELL ["/bin/zsh", "-c"]

# 当容器启动时，保持运行状态
CMD ["zsh"]
