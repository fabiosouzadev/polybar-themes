#!/usr/bin/env bash
POLYBAR_DIR="$HOME/.config/polybar/simple"
THEME=""

EXTERNAL_MODE=false
[[ "${2:-}" == "--external" ]] && EXTERNAL_MODE=true

launch_bar() {
	
    # Terminate already running bar instances
    #killall -q polybar
    killall -q polybar || true

    # Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

	if $EXTERNAL_MODE; then
	MONITOR="$(xrandr | awk '/ connected/{print $1}' | grep -E '^(?!eDP|LVDS)' | head -n1)"
	[[ -z "$MONITOR" ]] && MONITOR="$(xrandr | awk '/ connected/{print $1}' | head -n1)"

	MONITOR=$MONITOR TRAY_POS=right polybar -r -c "$POLYBAR_DIR/$THEME/config.ini" -q main &
	else
	IFS=$'\n'
	for entry in $(xrandr --query | grep " connected"); do
		mon=$(cut -d" " -f1 <<< "$entry")
		status=$(cut -d" " -f3 <<< "$entry")

		tray_pos=""
		[[ "$status" == "primary" ]] && tray_pos="right"

		MONITOR=$mon TRAY_POS=$tray_pos polybar -r -c "$POLYBAR_DIR/$THEME/config.ini" -q main &
	done
	unset IFS
	fi
}

if [[ "$1" == "--one" ]]; then
	THEME="one"
	launch_bar

elif [[ "$1" == "--two" ]]; then
	THEME="two"
	launch_bar

elif [[ "$1" == "--my-colorblocks" ]]; then
	THEME="my-colorblocks"
	launch_bar

elif [[ "$1" == "--material" ]]; then
	THEME="material"
	launch_bar

elif [[ "$1" == "--shades" ]]; then
	THEME="shades"
	launch_bar

elif [[ "$1" == "--hack" ]]; then
	THEME="hack"
	launch_bar

elif [[ "$1" == "--docky" ]]; then
	THEME="docky"
	launch_bar

elif [[ "$1" == "--cuts" ]]; then
	THEME="cuts"
	launch_bar

elif [[ "$1" == "--shapes" ]]; then
	THEME="shapes"
	launch_bar

elif [[ "$1" == "--grayblocks" ]]; then
	THEME="grayblocks"
	launch_bar

elif [[ "$1" == "--blocks" ]]; then
	THEME="blocks"
	launch_bar

elif [[ "$1" == "--colorblocks" ]]; then
	THEME="colorblocks"
	launch_bar

elif [[ "$1" == "--forest" ]]; then
	THEME="forest"
	launch_bar

elif [[ "$1" == "--pwidgets" ]]; then
	THEME="pwidgets"
	launch_bar

elif [[ "$1" == "--panels" ]]; then
	THEME="panels"
	launch_bar
else
	cat <<- EOF
	Usage : launch.sh --theme
		
	Available Themes :
	--one       --two            --my-colorblocks
	--blocks    --colorblocks    --cuts      --docky
	--forest    --grayblocks     --hack      --material
	--panels    --pwidgets       --shades    --shapes
	EOF
fi
