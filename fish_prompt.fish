function fish_prompt
    set -l status_copy $status
    set -l root_glyph (set_color -o)"  ▾  "(set_color normal)
    set -l root_color fff c00
    set -l pwd_info (pwd_info /)

    if pwd_is_home
        if test "$PWD" != ~
            set root_glyph "  ▸  "
        end
    else
        if test "$PWD" = /
            set root_color black fc0
        else
            set root_glyph
        end
    end

    if set -l last_job_id (last_job_id -l)
        segment fc0 222 " ٪$last_job_id "
        segment black black
    end

    if test ! -z "$pwd_info[3]"
        segment black fc0 " $pwd_info[3] "
        segment black black
    end

    if set branch_name (git_branch_name)
        set root_glyph ""
        set -l git_color fff c00
        set -l git_glyph 

        if git_is_touched
            set git_color black fc0

            if git_is_staged
                if git_is_dirty
                    set branch_name $branch_name ▸▸
                else
                    set branch_name $branch_name ▾
                end
            else if git_is_dirty
                set branch_name $branch_name ▸
            end

        else if git_is_stashed
            set branch_name $branch_name ≡
        end

        if git_is_detached_head
            set git_glyph ➤
            segment $git_color " $git_glyph $branch_name "
            segment black black
        else
            segment $git_color " $git_glyph $branch_name "
        end
    end

    if test -z "$pwd_info[2]"
        if test ! -z "$pwd_info[1]"
            segment black fc0 " $pwd_info[1] "
        end
    else
        segment black fc0 " $pwd_info[1] "
        segment black black
        segment black fc0 " $pwd_info[2] "
    end

    if test 0 -eq (id -u $USER) -o ! -z "$SSH_CLIENT"
        if test ! -z "$pwd_info[2]" -o ! -z "$pwd_info[1]"
            segment 333 222
        end

        segment fc0 333 (host_info " usr@host ")
        segment 333 222
    end

    if test "$status_copy" -ne 0
        segment fff c00 (echo "$status_copy" | awk '{
            printf(length($0) == 3 ? " %s \n" : "  %s  \n", $0)
        }')
    else
        segment $root_color $root_glyph
    end

    segment_close
end
