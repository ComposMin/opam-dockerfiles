# OPAM for debian-stable with local switch of OCaml 4.02.3
# Autogenerated by OCaml-Dockerfile scripts
FROM ocaml/ocaml:debian-stable
LABEL distro_style="apt" distro="debian" distro_long="debian-stable" arch="x86_64" ocaml_version="4.02.3" opam_version="1.2.2" operatingsystem="linux"
RUN apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install aspcud && \
  git clone -b 1.2 git://github.com/ocaml/opam /tmp/opam && \
  sh -c "cd /tmp/opam && make cold && make install && rm -rf /tmp/opam" && \
  echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam && \
  chmod 440 /etc/sudoers.d/opam && \
  chown root:root /etc/sudoers.d/opam && \
  adduser --disabled-password --gecos '' opam && \
  passwd -l opam && \
  chown -R opam:opam /home/opam
USER opam
ENV HOME /home/opam
WORKDIR /home/opam
RUN mkdir .ssh && \
  chmod 700 .ssh && \
  git config --global user.email "docker@example.com" && \
  git config --global user.name "Docker CI" && \
  sudo -u opam sh -c "mkdir /home/opam/src" && \
  sudo -u opam sh -c "git clone git://github.com/ocaml/opam-repository" && \
  sudo -u opam sh -c "opam init -a -y --comp 4.02.3 /home/opam/opam-repository" && \
  sudo -u opam sh -c "opam install -y camlp4" && \
  sudo -u opam sh -c "opam pin add depext https://github.com/ocaml/opam-depext.git" && \
  sudo -u opam sh -c "opam install -y depext travis-opam"
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "bash" ]