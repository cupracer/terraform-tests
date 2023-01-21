{% from 'basic/map.jinja' import basic with context %}

install_packages:
  pkg.installed:
    - require:
      - cmd: registration
    - pkgs:
      - glibc-locale
      - man
      - man-pages
      - bash-completion
      - salt-bash-completion
      - psmisc
      - psmisc-lang
      - mlocate
      - mlocate-lang
