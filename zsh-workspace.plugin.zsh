lazy_load_conda() {
    _conda() {}
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
}

lazy_load_nvm() {
    _nvm() {}
    # unset -f node nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
}

load-env-vars() {
    if [ -f "$HOME/.zsh-workspace.versions" ]; then
        # Read the file and initialize arrays
        local dirs=()
        local versions=()

        # Read the file line by line
        while IFS='|' read -r dir type version || [ -n "$dir" ]; do
            dirs+=("$dir")
            types+=("$type")
            versions+=("$version")
        done < "$HOME/.zsh-workspace.versions"

        # Set environment variables
        export IFURYST_DIRS="${dirs[*]}"
        export IFURYST_TYPES="${types[*]}"
        export IFURYST_VERSIONS="${versions[*]}"
    fi
}

load-env-vars

# auto load nvm according to ~/.zsh-workspace.versions
autoload -U add-zsh-hook
need-change-version() {
    local current_dir="$PWD"
    local index=1
    local versions=("${(@s: :)IFURYST_VERSIONS}")
    local types=("${(@s: :)IFURYST_TYPES}")
    local dirs=("${(@s: :)IFURYST_DIRS}")

    for dir in "${dirs[@]}"; do
        if [[ "$current_dir" == "$dir"* ]]; then
            case $types[$index] in
                "conda")
                    if command -v _conda &> /dev/null; then
                        break
                    else
                        lazy_load_conda
                        conda activate "${versions[$index]}"
                    fi
                    ;;
                "nvm")
                    if command -v _nvm &> /dev/null; then
                        break
                    else
                        lazy_load_nvm
                        nvm use "${versions[$index]}"
                    fi
                    ;;
                *)
                    ;;
            esac
        fi
        ((index++))
    done
}
add-zsh-hook chpwd need-change-version
need-change-version