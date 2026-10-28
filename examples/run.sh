#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_tentacle_equip info
PYTHONPATH=src python -m gbt_tentacle_equip check --payload '{}'
PYTHONPATH=src python -m gbt_tentacle_equip run   --payload '{}'
