{% from 'registration/map.jinja' import registration with context %}

registration:
  cmd.run:
    - name: SUSEConnect --email {{ registration.email }} --regcode {{ registration.key }}
    - onlyif: SUSEConnect --status-text | grep -iq 'not registered'

