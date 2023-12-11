#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

main_menu() {
    choice=$(zenity --list --title="Music Player" --width=400 --height=400 --text="Select an option:" --column="Options" Play Pause Stop "Skip Track" "Adjust Volume" Resume Quit)
    case $choice in
        "Play")
            play_audio ;;
        "Pause")
            pause_audio ;;
        "Resume")
            resume_audio ;;
        "Stop")
            stop_audio ;;
        "Skip Track")
            skip_track ;;
        "Adjust Volume")
            adjust_volume ;;
        "Quit")
            exit ;;
        *)
            zenity --error --text="Invalid option selected." ;; 
    esac
}

display_song_info() {
    local audio_file="$1"
    local song_name
    local song_duration
    local start_time
    local current_time
    local elapsed_time
    local remaining_time
    local dialog_content
    local dialog_file
    local paused_state

    #echo "DEBUG: Starting display_song_info function"

    song_name=$(basename "$audio_file")
    echo "Song name: $song_name"

    song_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio_file" | cut -d. -f1)
    echo "Song duration: $song_duration seconds"

    start_time=$(date +%s)

    dialog_file=$(mktemp)
    #echo "DEBUG: Temporary file created: $dialog_file"

    /usr/bin/mpv "$audio_file" &
    
    pid=$!

    while true; do
        current_time=$(date +%s)
        
        elapsed_time=$((current_time - start_time))
        #echo "DEBUG: Time elapsed: $elapsed_time seconds"
        
        remaining_time=$((song_duration - elapsed_time))
        if [ "$remaining_time" -lt 0 ]; then
            remaining_time=0
        fi
        #echo "DEBUG: Remaining duration: $remaining_time seconds"
        
        dialog_content="Song: $song_name\nTime Elapsed: $elapsed_time seconds\nRemaining: $remaining_time seconds"
        
        echo "$dialog_content" > "$dialog_file"
        
        zenity --text-info --title="Now Playing" --width=400 --height=200 --filename="$dialog_file" --timeout=1 --ok-label="Close" || break

        if ! ps -p $pid > /dev/null; then
            break
        fi

        sleep 1
    done

    paused_state=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio_file")

    rm -f "$dialog_file"
}

play_audio() {
   audio_file=$(zenity --file-selection --title="Select Audio File to Play")
    
   if [ -n "$audio_file" ]; then 
       display_song_info "$audio_file"
   fi 
}

pause_audio() {
   pkill -STOP mpv 
   main_menu 
}

resume_audio() {
   pkill -CONT mpv 
   main_menu 
}

stop_audio() {
   pkill -9 mpv 
   main_menu 
}

skip_track() {
    mpv_pid=$(pgrep mpv)

    if [ -n "$mpv_pid" ]; then
        kill -TERM "$mpv_pid"

        while ps -p "$mpv_pid" > /dev/null; do
            sleep 1
        done

        current_directory=$(dirname "$audio_file")

        mp3_files=("$current_directory"/*.mp3)

        if [ "${#mp3_files[@]}" -gt 0 ]; then
            current_index=-1
            for i in "${!mp3_files[@]}"; do
                if [[ "${mp3_files[$i]}" == "$audio_file" ]]; then
                    current_index=$i
                    break
                fi
            done
            echo $current_index
            next_index=$(( (current_index + 1) % ${#mp3_files[@]} ))
            current_index=$next_index
            
            echo $next_index
            display_song_info "${mp3_files[$next_index]}"
        else
            main_menu
        fi
    fi

    main_menu
}

adjust_volume() {
    volume=$(zenity --scale --title="Adjust Volume" --text="Drag to adjust volume:" --min-value=0 --max-value=100 --value=50)
    if command -v pactl &> /dev/null; then
        pactl set-sink-volume @DEFAULT_SINK@ "${volume}%"
    elif command -v amixer &> /dev/null; then
        amixer set Master "${volume}%" > /dev/null
    else
        zenity --error --text="Volume adjustment not supported on this system."
    fi
    main_menu
}


main() {
   while true; do 
       main_menu 
   done 
}

main
