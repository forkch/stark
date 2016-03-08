function fish_prompt


    set -l status_copy $status

    set -l root (
        set -l root (dirname $PWD)

        if test "$PWD" != "$HOME" -a "$root" != /
            echo $root | sed -E "s|$HOME||;s|(^/)?([^/.])[^/]*|\2|g;s|/| |g"
        end
        )

    set -l base (
        if test "$PWD" != / -a "$PWD" != "$HOME"
            basename $PWD
        end
        )

    set -l branch_name

    if set branch_name (git_branch_name)
        set -l repo_status_color ffffff 30f
        set -l repo_status
        set -l branch_ref ➦

        if git symbolic-ref HEAD ^ /dev/null > /dev/null
            set branch_ref 
        end

        if git_is_staged
            set repo_status ✚
        end

        if git_is_dirty
            set repo_status $repo_status ●
            set repo_status_color fff c03

            if git_is_stashed
                set repo_status[-1] •••
            end
        else if git_is_stashed
            set repo_status $repo_status ••
            set repo_status_color ffffff 30f
        end

        if set -q repo_status[1]
            set repo_status $repo_status ""
        end

        segment " $branch_ref $branch_name $repo_status" $repo_status_color
        segment "" 111 111

        if test ! -z "$base"
            segment " $base " 111 fc3
            segment "" 111 111
        end
    else
        if test ! -z "$base"
            set -l color fc3 333

            if test ! -z "$root"
                set color 111 fc3
            end

            segment "  $base  " $color
            segment "" 111 111
        end
    end

    if test ! -z "$root"
        segment " $root " fc3 333
        segment "" 111 111
    end

    set -l segment_colors 111 fc3

    switch "$PWD"
        case "$HOME"\*
        case \*
            set segment_colors ffffff 30f
    end

    if test "$status_copy" -ne 0
        set segment_colors ffffff b00
    end

    segment " ≡ " $segment_colors

    set segment (set_color $segment_colors[2])$segment(set_color normal)

    segment_close
end
