#!/usr/bin/env bash
set -euo pipefail

POLYBAR_DIR="$HOME/.config/polybar/simple"
THEME=""

EXTERNAL_MODE=false
[[ "${2:-}" == "--external" ]] && EXTERNAL_MODE=true

info() { echo "[POLYBAR] $*"; }

detect_external_monitor() {
  # Prioriza monitor vindo do ambiente (modo clamshell)
  if [[ -n "${MONITOR:-}" ]]; then
    echo "$MONITOR"
    return 0
  fi

  # Detecta qualquer externo que não seja eDP/LVDS
  local ext
  ext="$(xrandr --query | awk '/ connected/{print $1}' | grep -Ev '^(eDP|LVDS)' | head -n1 || true)"

  if [[ -n "$ext" ]]; then
    echo "$ext"
    return 0
  fi

  # Fallback: primeiro conectado
  xrandr --query | awk '/ connected/{print $1; exit}'
}

launch_bar() {
  info "Finalizando instâncias antigas do polybar..."
  pkill -x polybar || true

  while pgrep -u "$UID" -x polybar >/dev/null; do
    sleep 0.5
  done

  if $EXTERNAL_MODE; then
    MONITOR="$(detect_external_monitor)"
    info "Modo EXTERNAL → Monitor: $MONITOR"

    if [[ -z "$MONITOR" ]]; then
      info "Nenhum monitor detectado para modo external."
      exit 1
    fi

    TRAY_POS="right"

    MONITOR="$MONITOR" TRAY_POS="$TRAY_POS" \
      polybar -r -c "$POLYBAR_DIR/$THEME/config.ini" -q main \
      2>&1 | tee -a "/tmp/polybar-monitor-$MONITOR.log" &

  else
    info "Modo MULTI-MONITOR"

    while IFS= read -r mon; do
      tray_pos=""

      if xrandr --query | awk -v m="$mon" '$1 == m && $3 == "primary" { found=1 } END { exit !found }'; then
        tray_pos="right"
      fi

      info "Iniciando polybar em $mon (tray: ${tray_pos:-none})"

      MONITOR="$mon" TRAY_POS="$tray_pos" \
        polybar -r -c "$POLYBAR_DIR/$THEME/config.ini" -q main \
        2>&1 | tee -a "/tmp/polybar-monitor-$mon.log" &

    done < <(xrandr --query | awk '/ connected/{print $1}')
  fi
}

case "${1:-}" in
  --one)            THEME="one" ;;
  --two)            THEME="two" ;;
  --my-colorblocks) THEME="my-colorblocks" ;;
  --material)       THEME="material" ;;
  --shades)         THEME="shades" ;;
  --hack)           THEME="hack" ;;
  --docky)          THEME="docky" ;;
  --cuts)           THEME="cuts" ;;
  --shapes)         THEME="shapes" ;;
  --grayblocks)     THEME="grayblocks" ;;
  --blocks)         THEME="blocks" ;;
  --colorblocks)    THEME="colorblocks" ;;
  --forest)         THEME="forest" ;;
  --pwidgets)       THEME="pwidgets" ;;
  --panels)         THEME="panels" ;;
  *)
    cat <<EOF
Usage: launch.sh --theme [--external]

Available Themes:
  --one       --two            --my-colorblocks
  --blocks    --colorblocks    --cuts      --docky
  --forest    --grayblocks     --hack      --material
  --panels    --pwidgets       --shades    --shapes
EOF
    exit 1
    ;;
esac

launch_bar
