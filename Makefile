.PHONY: install install-vim install-zsh

install: install-vim install-zsh


#
# Vim
#
install-vim: $(HOME)/.gvimrc $(HOME)/.vimrc

$(HOME)/.gvimrc: gvimrc
	cp gvimrc $@

$(HOME)/.vimrc: $(HOME)/.vim/autoload/plug.vim vimrc
	cp vimrc $@
	vim +PlugInstall +qall

$(HOME)/.vim/autoload/plug.vim:
	curl -fLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


#
# zsh
#
install-zsh: $(HOME)/.zshrc

$(HOME)/.zshrc: $(HOME)/.zsh/antigen.zsh zshrc
	cp zshrc $@
	zsh -c "source $@"

$(HOME)/.zsh/antigen.zsh:
	curl -fLo $@ --create-dirs https://github.com/zsh-users/antigen/releases/download/v1.2.1/antigen.zsh
