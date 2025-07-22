#!/bin/bash

target_address="google.com"
ping_limit_ms=100
fail_threshold=3
fail_count=0

while true; do
      ping_result=$(ping -c 1 -W 1 "$target_address")
      ping_time=$(echo "$ping_result" | grep 'time=' | sed -n 's/.*time=\([0-9.]*\).*/\1/p')

 if [[ -n "$ping_time" ]]; then
      echo "Пинг $target_address успешен: $ping_time ms"

      if (( $(echo "$ping_time > $ping_limit_ms" | bc -l) )); then
      echo "Пинг превышает $ping_limit_ms mc: $ping_time ms"
      fi

      fail_count=0

 else
      echo "Пинг $target_address не удался"
      ((fail_count++))
 fi

 if (( fail_count >= fail_threshold )); then
      echo "Превышено количество неудачных попыток: $fail_count"
      fail_count=0
 fi

 sleep 1

done
