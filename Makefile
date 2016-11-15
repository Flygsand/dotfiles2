.PHONY: install clean install-vim install-zsh
ECLIPSE_HOME ?= /Applications/Eclipse.app/Contents/Eclipse

install: install-vim install-zsh

clean:
	rm -rf cache


#
# Vim
#
install-vim: $(HOME)/.gvimrc $(HOME)/.vimrc

$(HOME)/.gvimrc: gvimrc
	cp gvimrc $@

$(HOME)/.vimrc: $(HOME)/.vim/autoload/plug.vim $(foreach s,$(wildcard UltiSnips/*.snippets),$(HOME)/.vim/$(s)) $(HOME)/.vim/eclim/plugin vimrc
	cp vimrc $@
	vim --not-a-term +PlugInstall +qall

$(HOME)/.vim/autoload/plug.vim:
	curl -fLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$(HOME)/.vim/UltiSnips/%.snippets: UltiSnips/%.snippets
	mkdir -p $(dir $@)
	cp $< $@

$(HOME)/.vim/eclim/plugin: cache/eclim.jar
	java -Dvim.files=$(HOME)/.vim -Declipse.home=$(ECLIPSE_HOME) -jar cache/eclim.jar install

cache/eclim.jar:
	curl -fLo $@ --create-dirs https://github.com/ervandew/eclim/releases/download/2.6.0/eclim_2.6.0.jar


#
# zsh
#
install-zsh: $(HOME)/.zshrc

$(HOME)/.zshrc: $(HOME)/.zsh/antigen.zsh zshrc
	cp zshrc $@
	zsh -c "source $@"

$(HOME)/.zsh/antigen.zsh:
	curl -fLo $@ --create-dirs https://github.com/zsh-users/antigen/releases/download/v1.2.1/antigen.zsh
