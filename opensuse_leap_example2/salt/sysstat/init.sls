{% from 'sysstat/map.jinja' import sysstat with context %}

sysstat:
  pkg:
    - installed

  service.running:
    - enable: True
    - require:
      - pkg: sysstat

