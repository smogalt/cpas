FROM debian

RUN apt-get update && apt-get install -y openssh-server sudo
RUN service ssh restart

RUN useradd -m admin -G users,sudo
RUN echo "admin:password" | chpasswd

RUN chsh -s /bin/bash admin

COPY src/bashrc /home/admin/.bashrc
COPY src/motd /etc/motd

COPY cpas/challenges.d /etc/cpas/challenges.d
COPY cpas/snippets.d /etc/cpas/snippets.d
COPY cpas/cpas /usr/bin
RUN touch /etc/cpas/total_score
RUN chmod +x /usr/bin/cpas

RUN bash -c '/usr/bin/cpas --make'
RUN echo "admin ALL=(ALL) NOPASSWD:/usr/bin/cpas --score" >> /etc/sudoers


EXPOSE 22
CMD [ "/usr/sbin/sshd", "-D" ]
