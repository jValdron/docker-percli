FROM debian:bookworm

RUN apt update && apt install wget -y

WORKDIR /tmp/
RUN wget https://dl.dell.com/FOLDER07815522M/1/PERCCLI_7.1910.00_A12_Linux.tar.gz --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
RUN tar -xf PERCCLI_7.1910.00_A12_Linux.tar.gz
RUN cd PERCCLI_7.1910.00_A12_Linux
RUN ls
RUN dpkg -i perccli_007.1910.0000.0000_all.deb

RUN apt-get clean