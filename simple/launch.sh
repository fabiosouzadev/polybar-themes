#!/usr/bin/env bash


POLYBAR_DIR="$HOME/.config/polybar/simple"
THEME="my-colorblocks"

EXTERNAL_MODE=false
[[ "${1:-}" == "--external" ]] && EXTERNAL_MODE=true

killall -q polybar || true
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.5; done

if $EXTERNAL_MODE; then
  MONITOR="$(xrandr | awk '/ connected/{print $1}' | grep -E '^(?!eDP|LVDS)' | head -n1)"
  [[ -z "$MONITOR" ]] && MONITOR="$(xrandr | awk '/ connected/{print $1}' | head -n1)"

  MONITOR=$MONITOR TRAY_POS=right polybar -r -c "$POLYBAR_DIR/$THEME/config.ini" -q main &
else
  while read -r line; do
    mon=$(awk '{print $1}' <<< "$line")
    primary=$(grep -q "primary" <<< "$line" && echo "right" || echo "")
    MONITOR=$mon TRAY_POS=$primary polybar -r -c "$POLYBAR_DIR/$THEME/config.ini" -q main &
  done < <(xrandr --query | grep " connected")
fi


#=============================================
# POLYBAR_DIR="$HOME/.config/polybar/simple"
# # POLYBAR_DIR="$HOME/Projects/Personal/polybar-themes/simple"
# THEME=""

# launch_bar() {
	
#     # Terminate already running bar instances
#     #killall -q polybar
#     pkill polybar

#     # Wait until the processes have been shut down
# 	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

#     # Launch new polybar(s)                                                            
#     if type "xrandr"; then                                                             
#         IFS=$'\n'  # must set internal field separator to avoid dumb                   
#         for entry in $(xrandr --query | grep " connected"); do                         
#             mon=$(cut -d" " -f1 <<< "$entry")                                          
#             status=$(cut -d" " -f3 <<< "$entry")                                       
                                                                                       
#             tray_pos=""                                                                
#             if [ "$status" == "primary" ]; then                                        
#                 tray_pos="right"                                                       
#             fi                                                                         
                                                                                       
#             MONITOR=$mon TRAY_POS=$tray_pos polybar -r -c "$POLYBAR_DIR/$THEME/config.ini" -q main 2>&1 | tee -a /tmp/polybar-monitor-"$mon".log &
#             #sleep 1
#         done                                                                          
#         unset IFS  # avoid mega dumb by resetting the IFS                              
#     else                                                                               
#         polybar -r -c "$POLYBAR_DIR/$THEME/config.ini" -q main 2>&1 | tee -a /tmp/polybar.log
#     fi
# }

# if [[ "$1" == "--one" ]]; then
# 	THEME="one"
# 	launch_bar

# elif [[ "$1" == "--two" ]]; then
# 	THEME="two"
# 	launch_bar

# elif [[ "$1" == "--my-colorblocks" ]]; then
# 	THEME="my-colorblocks"
# 	launch_bar

# elif [[ "$1" == "--material" ]]; then
# 	THEME="material"
# 	launch_bar

# elif [[ "$1" == "--shades" ]]; then
# 	THEME="shades"
# 	launch_bar

# elif [[ "$1" == "--hack" ]]; then
# 	THEME="hack"
# 	launch_bar

# elif [[ "$1" == "--docky" ]]; then
# 	THEME="docky"
# 	launch_bar

# elif [[ "$1" == "--cuts" ]]; then
# 	THEME="cuts"
# 	launch_bar

# elif [[ "$1" == "--shapes" ]]; then
# 	THEME="shapes"
# 	launch_bar

# elif [[ "$1" == "--grayblocks" ]]; then
# 	THEME="grayblocks"
# 	launch_bar

# elif [[ "$1" == "--blocks" ]]; then
# 	THEME="blocks"
# 	launch_bar

# elif [[ "$1" == "--colorblocks" ]]; then
# 	THEME="colorblocks"
# 	launch_bar

# elif [[ "$1" == "--forest" ]]; then
# 	THEME="forest"
# 	launch_bar

# elif [[ "$1" == "--pwidgets" ]]; then
# 	THEME="pwidgets"
# 	launch_bar

# elif [[ "$1" == "--panels" ]]; then
# 	THEME="panels"
# 	launch_bar
# else
# 	cat <<- EOF
# 	Usage : launch.sh --theme
		
# 	Available Themes :
# 	--one       --two            --my-colorblocks
# 	--blocks    --colorblocks    --cuts      --docky
# 	--forest    --grayblocks     --hack      --material
# 	--panels    --pwidgets       --shades    --shapes
# 	EOF
# fi
