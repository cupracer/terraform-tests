{% from 'basic/map.jinja' import basic with context %}

set_timezone:
  timezone.system:
    - name: {{ basic.timezone }}
    - utc: {{ basic.use_utc }}

install_packages:
  pkg.installed:
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
