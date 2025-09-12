
#!/bin/bash

# Mostra uso de CPU/RAM do processo ollama
CPU=$(ps -C ollama -o %cpu= | awk '{sum+=$1} END {print sum}')
RAM=$(ps -C ollama -o %mem= | awk '{sum+=$1} END {print sum}')
MODEL=$(pgrep -a ollama | grep serve | awk '{print $NF}' | tail -n1)

if [ -z "$CPU" || "$CPU" = "0" ]; then
  echo " 🤖  idle"
else
  echo " 🤖 CPU:${CPU}% RAM:${RAM}% $MODEL"
fi

# MODEL=$(pgrep -a ollama | grep serve | awk '{print $NF}' | tail -n1)
# if [ -z "$MODEL" ]; then
#   echo "🤖 idle"
# else
#   echo "🤖 $MODEL"
# fi
