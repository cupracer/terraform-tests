{% from 'timezone/map.jinja' import timezone with context %}

set_timezone:
  timezone.system:
    - name: {{ timezone.timezone }}
    - utc: {{ timezone.use_utc }}

