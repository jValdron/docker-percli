# PERCCLI
FROM debian:bookworm AS perccli
RUN apt update && apt install wget -y
WORKDIR /tmp/
RUN wget https://dl.dell.com/FOLDER07815522M/1/PERCCLI_7.1910.00_A12_Linux.tar.gz --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" \
    && tar -xf /tmp/PERCCLI_7.1910.00_A12_Linux.tar.gz \
    && dpkg -i /tmp/PERCCLI_7.1910.00_A12_Linux/perccli_007.1910.0000.0000_all.deb

# MegaCLI
FROM debian:bookworm AS megacli
RUN apt update && apt install wget unzip alien -y
WORKDIR /tmp/
RUN wget https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/8-07-14_MegaCLI.zip \
    && unzip 8-07-14_MegaCLI.zip \
    && alien Linux/MegaCli-8.07.14-1.noarch.rpm \
    && dpkg -i megacli_8.07.14-2_all.deb

# Final stage
FROM debian:bookworm
ENV PATH="$PATH:/opt/MegaRAID/MegaCli/:/opt/MegaRAID/perccli/"
WORKDIR /tmp/

RUN apt update && apt install libncurses5 pciutils -y && apt-get clean

COPY --from=perccli /tmp/PERCCLI_7.1910.00_A12_Linux/perccli_007.1910.0000.0000_all.deb .
RUN dpkg -i perccli_007.1910.0000.0000_all.deb \
    && rm perccli_007.1910.0000.0000_all.deb

COPY --from=megacli /tmp/megacli_8.07.14-2_all.deb .
RUN dpkg -i megacli_8.07.14-2_all.deb \
    && rm megacli_8.07.14-2_all.deb
