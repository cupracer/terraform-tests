{% from 'sysstat/map.jinja' import sysstat with context %}

sysstat:
  pkg:
    - require:
      - cmd: registration
    - installed

  service.running:
    - enable: True
    - require:
      - pkg: sysstat

