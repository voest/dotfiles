" distro defaults
runtime! archlinux.vim
runtime! defaults.vim

lua << EOF

vim.pack.add({
  'https://github.com/dense-analysis/ale',
  'https://github.com/editorconfig/editorconfig-vim',
  'https://github.com/hashivim/vim-terraform',
  'https://github.com/junegunn/fzf.vim',
  'https://github.com/junegunn/vim-peekaboo',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/pedrohdz/vim-yaml-folds',
  'https://github.com/tpope/vim-commentary',
  'https://github.com/tpope/vim-fugitive',
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  'https://github.com/rafi/awesome-vim-colorschemes',
})

EOF

" syntax highlighting
if has("syntax")
  syntax on
endif

" disable bell
set vb t_vb=

" disable intro
set shortmess=filnxtToOI

" disable mouse
set mouse=

" neovim settings
if has('nvim')

  " disable cursor shapes
  set guicursor=

  " use mouse
  set mouse=nv

  " always use native clipboard
  set clipboard+=unnamedplus

endif

" autocommands
if has("autocmd")

  " jump to last position
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " fold
  augroup vimrc
    au BufReadPre * setlocal foldmethod=indent
    au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
    au BufReadPost * normal zR
  augroup END

endif

" colors
set background=dark
colorscheme catppuccin-mocha
hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE

" powerline lite
set laststatus=2
set statusline=%<[%n]\ %.90F\ %y\ %m%r%=%{exists('g:loaded_fugitive')?fugitive#statusline():''}\ %{&enc}[%{(&fenc!=&enc)?&fenc.':':''}%{&ff}]\ %13.(%c,%l/%L%)\ %6.((%p%%)%)

" lualine
lua << END
require('lualine').setup {
  options = {
    theme = 'nightfly',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  tabline = {
    lualine_a = {'buffers'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'tabs'}
  },
}
END

" nerdtree lite
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" line numbers
set number
set numberwidth=4
set cursorline

" tabstop
set tabstop=2
set shiftwidth=2
"set expandtab

" search stuff
set incsearch
set hlsearch

" key bindings
nmap <silent> <f5> :set paste! <CR>
nmap <C-B> :ToggleBlameLine <CR>
nmap <C-F> :BLines <CR>
nmap <C-L> :set list! \| exec &list!=""? "echo 'list'" : "echo 'nolist'" <CR>
nmap <C-N> :set invnumber \| :ALEToggle <CR>
nmap <C-X> :q <CR>
nmap <C-P> :set invpaste \| exec &paste!=""? "echo 'paste'" : "echo 'nopaste'" <CR>
nmap <C-T> :set expandtab list \| retab \| echo 'retabbed' <CR>
nmap <C-W> :set invwrap \| exec &wrap!="" ? "echo 'wrap'" : "echo 'nowrap'" <CR>
nmap <C-E> :exec bufname()!="" ? ":tabnew \| :Files" : ":Files" <CR>
nmap <C-G> :exec bufname()!="" ? ":tabnew \| :GFiles -co" : ":GFiles -co" <CR>

:let mapleader = "ö"
nmap <leader>b :ToggleBlameLine<CR>
nmap <leader>ff :exec bufname()!="" ? ":tabnew \| :Files" : ":Files" <CR>
nmap <leader>ff :tabnew \| :Files <CR>
nmap <leader>fe :Files <CR>
nmap <leader>fg :GFiles -co<CR>
nmap <leader>fa :Ag 
nmap <leader>fb :Buffers <CR>
nmap <leader>fc :Commits! <CR>
nmap <leader>fl :BLines <CR>
nmap <leader>tl :set list! \| exec &list!=""? "echo 'list'" : "echo 'nolist'" <CR>
nmap <leader>tn :set invnumber \| :ALEToggle <CR>
nmap <leader>tp :set invpaste \| exec &paste!=""? "echo 'paste'" : "echo 'nopaste'" <CR>
nmap <leader>ts :set invhlsearch \| exec &hlsearch!="" ? "echo 'hlsearch'" : "echo 'nohlsearch'" <CR>
nmap <leader>tw :set invwrap \| exec &wrap!="" ? "echo 'wrap'" : "echo 'nowrap'" <CR>
nmap <leader>rt :set expandtab list \| retab \| echo 'retabbed' <CR>
nmap <leader>qq :qa! <CR>

" indent
set autoindent
filetype plugin indent on

" ale
let g:syntastic_yaml_checkers = ['yamllint']
" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)

" easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" fzf
let $FZF_DEFAULT_COMMAND = 'fd --hidden --color=never --exclude=.git'

" vim-editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" vim-peekaboo
let g:peekaboo_compact = 1
let g:peekaboo_window = 'abo bo 20new'
