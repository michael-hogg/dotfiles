function _inspec() {
    local curcontext="$curcontext" state line
    typeset -A opt_args

    local -a _top_level_commands _supermarket_commands

    _top_level_commands=(
        "help:Describe\ available\ commands\ or\ one\ specific\ command"
        "json:read\ all\ tests\ in\ PATH\ and\ generate\ a\ JSON\ summary"
        "check:verify\ all\ tests\ at\ the\ specified\ PATH"
        "vendor:Download\ all\ dependencies\ and\ generate\ a\ lockfile\ in\ a\ \`vendor\`\ directory"
        "archive:archive\ a\ profile\ to\ tar.gz\ \(default\)\ or\ zip"
        "exec:run\ all\ test\ files\ at\ the\ specified\ LOCATIONS."
        "detect:detect\ the\ target\ OS"
        "shell:open\ an\ interactive\ debugging\ shell"
        "env:Output\ shell-appropriate\ completion\ configuration"
        "schema:print\ the\ JSON\ schema"
        "version:prints\ the\ version\ of\ this\ tool"
        "supermarket:Supermarket\ commands"
    )

    _supermarket_commands=(
        "help:Describe\ subcommands\ or\ one\ specific\ subcommand"
        "profiles:list\ all\ available\ profiles\ in\ Chef\ Supermarket"
        "exec:execute\ a\ Supermarket\ profile"
        "info:display\ Supermarket\ profile\ details"
    )

    _arguments '1:::->toplevel' && return 0
    _arguments '2:::->subcommand' && return 0
    _arguments '3:::->subsubcommand' && return 0

    #
    # Are you thinking? "Jeez, whoever wrote this really doesn't get
    # zsh's completion system?" If so, you are correct. However, I
    # have goodnews! Pull requests are accepted!
    #
    case $state in
        toplevel)
            _describe -t commands "InSpec subcommands" _top_level_commands
            ;;
        subcommand)
            case "$words[2]" in
                archive|check|exec|json)
                    _alternative 'files:filenames:_files'
                    ;;
                help)
                    _describe -t commands "InSpec subcommands" _top_level_commands
                    ;;
                supermarket)
                    _describe -t supermarket_commands "InSpec supermarket subcommands" _supermarket_commands
                    ;;
            esac
            ;;
        subsubcommand)
            case "$words[2]-$words[3]" in
                compliance-upload)
                    _alternative 'files:filenames:_files'
                    ;;
                supermarket-help)
                    _describe -t supermarket_commands "InSpec supermarket subcommands" _supermarket_commands
                    ;;
            esac

    esac

}

compdef _inspec inspec
# To use this, eval it in your shell
#
#    eval \"$(inspec env zsh)\"
#
#
