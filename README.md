# zsh-workspace
🤯 Do you have ever annoyed by the management of multiple versions like Node.js, Python, etc. in your local machine? 

This zsh plugin is a simple solution to manage multiple versions based on the destination directory. 😎

## Quick Start
```bash
git clone https://github.com/iFurySt/zsh-workspace.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-workspace
cp ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-workspace/.zsh-workspace.versions $HOME/.zsh-workspace.versions
```

Add plugin name to `.zshrc`
```
plugins=(git zsh-workspace)
```

And edit the `$HOME/.zsh-workspace.versions` to configure your workspace.

## TODO
- [ ] Extract the commands to a separate file, like lazy_load_nvm and lazy_load_conda