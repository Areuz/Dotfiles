FROM archlinux:latest

RUN pacman -Syu --noconfirm --needed base base-devel git
RUN useradd -d /home/build build
RUN mkdir -p /home/build
RUN chown -R build:build /home/build

COPY sudoers /etc/sudoers
