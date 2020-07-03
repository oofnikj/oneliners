### This file is intended to be sourced from ~/.bashrc ###

# quickly switch between AWS profiles with auto-completion
# uses https://github.com/Nike-Inc/gimme-aws-creds to obtain credentials
# if using static credentials, just comment out lines 13-15

awsp() {
    if [[ -n $1 ]] ; then
        # validate input
        grep -q -w "\[profile ${1}\]" ~/.aws/config || { echo "No such profile $1"; return 1; }
        export AWS_PROFILE=$1
        # check if we already have valid creds
        if ! aws sts get-caller-identity >&- 2>&-; then
            gimme-aws-creds --profile $1
        fi
        # set the prompt
        OLD_PS1=${OLD_PS1:-${PS1}}
        PS1="\e[31;1m${AWS_PROFILE}\e[0m ${OLD_PS1}"
    else 
        echo 'no AWS account provided'
        return 2
    fi
}

## basic bash completion, use fzf completion below instead if available
# _awsp() {
#     COMPREPLY=()
#     local word="${COMP_WORDS[COMP_CWORD]}"
#     if [ "$COMP_CWORD" -eq 1 ]; then
#         COMPREPLY=( $(compgen -W "$(aws configure list-profiles)" -- "$word") )
#     else
#         COMPREPLY=()
#     fi
# }
# complete -F _awsp awsp

_fzf_complete_awsp() {
    _fzf_complete --multi --reverse -- "$@" < <(
        grep -E '\[profile .+]' ~/.aws/config \
        | sed -E 's/\[profile (.+)\]/\1/g' \
        | sort
    )
}
complete -F _fzf_complete_awsp awsp
