# 使用Ubuntu 22.04作为基础镜像
FROM ubuntu:22.04

# 更新apt包管理器并安装Python 3.10、Git和nmap
RUN apt-get update && \
    apt-get install -y python3.10 git nmap

# 创建python符号链接
RUN ln -s /usr/bin/python3.10 /usr/bin/python

# 克隆sqlmap项目
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev

# 重命名sqlmap.py为sqlmap
RUN ln -s /sqlmap-dev/sqlmap.py /usr/bin/sqlmap

# 设置工作目录
WORKDIR /root

# 当容器启动时，保持运行状态
CMD tail -f /dev/null
