function fish_right_prompt
    set -l status_copy $status
    set -l status_color fc0

    if test "$status_copy" -ne 0
        set status_color c00
    end

    if test "$CMD_DURATION" -gt 100
        set -l duration_copy $CMD_DURATION
        set -l duration (echo $CMD_DURATION | humanize_duration)

        printf (set_color $status_color)" $duration  "(set_color normal)
    end

    printf (set_color -b $status_color)" "(set_color normal)
end
