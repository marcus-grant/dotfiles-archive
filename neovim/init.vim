" init.vimrc
" All config files are segmented into categories, and loaded in order
" init: is for configs that need to be loaded first, and for loading plugins
" plugins: plugin-specific configurations
" keys: keymap configurations
" themes: colorscheme configurations, could also be a link to different schemes
" line: status line configurations

" A segmented vim config file that initializes plugins.
" Also, performs actions that should come first

" Start by defining which plugins to use
let g:airline_enabled = 1 " my custom var to enable airline
let g:my_snippet_manager = 'ultisnips' "specify which snippet engine
let g:my_markdown_engine = 'vim-markdown' " which markdown, pandoc? markdown?

" Start by loading pluguns
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" Begin plugin loading {{{
"================================
" begin plugin list, NOTHING BUT PLUGINS UNTIL plug#end() call
" TODO make this reference to the plugin folder dynamic based dotfile location
call plug#begin("~/.config/nvim/plugged/")
" Plugins list, ONLY USE SINGLE QUOTES for references

" TMUX {{{
"================================
" vim-tmux-navigator to integrate panes with tmux
Plug 'christoomey/vim-tmux-navigator'
" }}}

" Completion & Snippets {{{
"================================
" deoplete autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ervandew/supertab'

" Snippets
" Implements a global var to determine if ultisnips should be used
if g:my_snippet_manager ==? 'ultisnips'
  Plug 'sirver/ultisnips' "| Plug 'honza/vim-snippets'
elseif g:my_snippet_manager ==? 'neosnippet'
  Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets' | Plug 'honza/vim-snippets'
endif

" TernJS
Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'do': { 'mac': 'npm install -g tern', 'unix': 'npm install -g tern' }}
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install -g tern' }

" JSPC - Parameter Completion
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }

" }}}

" Status Line {{{
if g:airline_enabled
  Plug 'powerline/fonts', { 'do': './install.sh' }
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
endif
" Plug 'mkitt/tabline.vim'
" }}}

" NERD {{{
"================================
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" NERD commenter for better filetype comments
Plug 'scrooloose/nerdcommenter'
" }}}

" fzf {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" }}}

" Javascript Plugins{{{
"================================
" Improved JS & JSX support
" load only for *.js & *.jsx extensions
" TODO: accomplish some kind of lazy loading for this plugin for JS & JSX
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
" }}}

" Go {{{
"================================
" vim-go for syntax and basic regognition
" swiss army knife for go (compile, install, test, run, debug, complettion,
" gotodef, docs, rename/refactor, test/coverage, taggs, lint)
Plug 'fatih/vim-go'

" Delve - go debugging
Plug 'sebdah/vim-delve'
" }}}

" Linting {{{
" ALE - Asynchronous Lint Engine
Plug 'w0rp/ale'
" }}}

" Git {{{
"================================
" fuGITive - Best git wrapper ever
" TODO: Find out if there's a good on-demand way to load this
Plug 'tpope/vim-fugitive'

" Vim-git - syntax highlighting for git integrators
" TODO: Find out if there's a good on-demand way to load this
Plug 'tpope/vim-git'
" }}}

" Still experimenting {{{
" Python virtual env workaround
" Plug 'plytophogy/vim-virtualenv'
" }}}

" markdown{{{

" vim-pandoc 
" TODO try out vim-markdown at some point
if g:my_markdown_engine ==? 'pandoc'
  Plug 'vim-pandoc/vim-pandoc-syntax'
  Plug 'vim-pandoc/vim-pandoc'
  " Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': ['markdown', 'pandoc'] }
  " Plug 'vim-pandoc/vim-pandoc', { 'for': ['markdown', 'pandoc'] }
elseif g:my_markdown_engine ==? 'vim-markdown'
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
endif

" Code to execute when the plugin is lazily loaded on demand
Plug 'junegunn/goyo.vim', { 'for': ['markdown', 'pandoc'] }
" autocmd! User goyo.vim echom 'Goyo is now loaded!'

" euclio/vim-markdown-composer a rust-based web server that live-renders markdown
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
"}}}

" End plugin loading
"================================
" }}}


" Initialize plugin system
call plug#end()


" load each config file in order
so $HOME/.config/nvim/general.vim
so $HOME/.config/nvim/keys.vim
so $HOME/.config/nvim/plugins.vim
" so $HOME/.config/nvim/theme.vim
so $HOME/.config/nvim/appearance.vim
"so line.vim
