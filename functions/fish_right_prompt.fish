function fish_right_prompt
    set -l status_copy $status
    set -l root_symbol ≡

    if test (jobs -l | wc -l) -gt 0
        set root_symbol "%"
    end

    if test "$CMD_DURATION" -gt 0
        set -l duration (echo $CMD_DURATION | awk '
            function hmTime(time, stamp) {
                split("h:m:s:ms", units, ":")

                for (i = 2; i >= -1; i--) {
                    if (t = int( i < 0 ? time % 1000 : time / (60 ^ i * 1000) % 60 )) {
                        stamp = stamp t units[sqrt((i - 2) ^ 2) + 1] " "
                    }
                }

                if (stamp ~ /^ *$/) {
                    return "0ms"
                }

                return substr(stamp, 1, length(stamp) - 1)
            }

            {
                print hmTime($0)
            }
        '
        )

        segment_right " $duration "  111 fc3
    end

    set -l status_color 111 fc3

    switch "$PWD"
        case "$HOME"\*
        case \*
            set status_color fff 30f
    end

    if test $status_copy -ne 0
        set status_color fff b00
        segment_right "" fff b00 "$status_copy "
    end

    segment_right "  "(date "+%H %M %S")"  " 555 1c1c1c
    segment_right " $root_symbol " $status_color

    printf (set_color $status_color[2] -b normal)""(set_color normal)

    segment_close
end
