# OPAM for fedora-23 with local switch of OCaml 4.04.0+trunk+flambda
# Autogenerated by OCaml-Dockerfile scripts
FROM ocaml/ocaml:fedora-23
LABEL distro_style="yum" distro="fedora" distro_long="fedora-23" arch="x86_64" ocaml_version="4.04.0+flambda" opam_version="1.2" operatingsystem="linux"
RUN rpm --rebuilddb && yum install -y sudo passwd bzip2 patch nano git which tar wget xz redhat-rpm-config && yum clean all && \
  rpm --rebuilddb && yum groupinstall -y "Development Tools" && yum clean all && \
  git clone -b 1.2 git://github.com/ocaml/opam /tmp/opam && \
  sh -c "cd /tmp/opam && make cold && make prefix=\"/usr\" install && rm -rf /tmp/opam" && \
  curl -o /usr/bin/aspcud 'https://raw.githubusercontent.com/avsm/opam-solver-proxy/8f162de1fe89b2e243d89961f376c80fde6de76d/aspcud.docker' && \
  chmod 755 /usr/bin/aspcud && \
  sed -i.bak '/LC_TIME LC_ALL LANGUAGE/aDefaults    env_keep += "OPAMYES OPAMJOBS OPAMVERBOSE"' /etc/sudoers && \
  echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam && \
  chmod 440 /etc/sudoers.d/opam && \
  chown root:root /etc/sudoers.d/opam && \
  sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers && \
  useradd -d /home/opam -m -s /bin/bash opam && \
  passwd -l opam && \
  chown -R opam:opam /home/opam
USER opam
ENV HOME /home/opam
WORKDIR /home/opam
RUN mkdir .ssh && \
  chmod 700 .ssh && \
  git config --global user.email "docker@example.com" && \
  git config --global user.name "Docker CI" && \
  sudo -u opam sh -c "git clone -b master git://github.com/ocaml/opam-repository" && \
  sudo -u opam sh -c "opam init -a -y --comp 4.04.0+trunk+flambda /home/opam/opam-repository" && \
  sudo -u opam sh -c "opam install -y camlp4" && \
  sudo -u opam sh -c "opam install -y depext travis-opam"
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "bash" ]