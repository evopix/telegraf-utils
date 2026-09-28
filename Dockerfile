# Partially based on https://github.com/nuntz/telegraf-snmp
# Pinned to the telegraf 1.x line: floating :latest once baked a 2020-era
# binary whose Docker client (API v1.21) modern daemons refuse (minimum v1.24).
# NOTE: no bare :1 major-only tag exists upstream, so pin the exact version
# and let Renovate (renovate.json) own the bumps: patches automerge, minors
# need a human (a minor jump can change input behavior — see the 1.15→1.40
# config-compat notes in the argon repo).
FROM telegraf:1.40.1

ARG DEBIAN_FRONTEND=noninteractive

# smartmontools (inputs.smart) lives outside main, so the base sources (which
# carry main only) need extending. Uses VERSION_CODENAME (bookworm/trixie/…)
# and the current -security suite layout; writes a dedicated list instead of
# editing the base sources, which are DEB822-format on modern images.
# Only contrib/non-free are added (main already present — re-adding it only
# produces duplicate-sources warnings). snmp-mibs-downloader is for
# snmptranslate convenience (telegraf's snmp input itself is pure Go).
# NOTE: lm-sensors and snmp already ship in the base image — only smartmontools
# (+ convenience MIBs) and nvme-cli (NVMe forensics alongside smartctl) need
# adding here.
RUN set -ex; \
    . /etc/os-release; \
    printf '%s\n' \
      "deb http://deb.debian.org/debian ${VERSION_CODENAME} contrib non-free" \
      "deb http://deb.debian.org/debian ${VERSION_CODENAME}-updates contrib non-free" \
      "deb http://security.debian.org/debian-security ${VERSION_CODENAME}-security contrib non-free" \
      > /etc/apt/sources.list.d/argon-utils.list; \
    apt-get update; \
    apt-get -y install snmp-mibs-downloader smartmontools nvme-cli; \
    rm -rf /var/lib/apt/lists/*
