{%- from "node/map.jinja" import node with context %}

{%- if salt['pillar.get']('node:install_from_ppa') %}
nodejs.ppa:
  pkg.installed:
    - name: apt-transport-https
    - require_in:
      - pkgrepo: nodejs.ppa
  pkgrepo.managed:
    - humanname: NodeSource Node.js Repository
    - name: deb {{ salt['pillar.get']('node:ppa:repository_url', 'https://deb.nodesource.com/node_0.12') }} {{ grains['oscodename'] }} main
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/nodesource.list
    - keyid: "68576280"
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - keyserver: keyserver.ubuntu.com
    - require_in:
      pkg: nodejs
{%- else %}
npm:
  pkg.installed:
    - name: {{ node.npm_pkg }}
    - reload_modules: true
    - require:
      - pkg: nodejs
{%- if grains['os'] == 'Debian' and grains['oscodename'] == 'wheezy' %}
    - dist: wheezy-backports
{%- endif %}
{%- endif %}
nodejs:
  pkg.installed:
    - name: {{ node.node_pkg }}
    - reload_modules: true
