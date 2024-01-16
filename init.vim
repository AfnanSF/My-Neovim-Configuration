" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.

  Plug 'neovim/nvim-lspconfig'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'jiangmiao/auto-pairs'
  Plug 'SirVer/ultisnips'
  Plug 'preservim/nerdtree'
  Plug 'tpope/vim-commentary'
  Plug 'neoclide/coc.nvim', {'branch': 'release'} 


" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Configuration for clangd with nvim-lspconfig
let g:clangd_args = ['--background-index']
autocmd FileType c,cpp lua require('lspconfig').clangd.setup{}


" Configuration for coc.nvim
" Enable coc.nvim for C++
let g:coc_global_extensions = [
  \ 'coc-clangd'
  \ ]



let g:UltiSnipsSnippetDirectories=["~/.vim/UltiSnips"]
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
"""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set tabstop=2
set shiftwidth=2
set expandtab
set encoding=utf-8
set relativenumber

" Automatically save the buffer when it loses focus or on CursorHold
au FocusLost,CursorHold * silent! wall

filetype plugin indent on
" Set C++ file type
autocmd BufNewFile,BufRead *.cpp set filetype=cpp

" Compile and run C++

" Compile and run C++ program in subshell

function! CompileAndRun()
  let fileName = expand('%')
  if fileName =~ '\.cpp$'
    let exeName = substitute(fileName, '\.cpp$', '', '')
    execute 'w | !g++ -std=c++20  -O2 -o ' . exeName . ' ' . fileName
    if v:shell_error == 0
      let cmd = "x-terminal-emulator -e bash -c './" . exeName . "; read -p \"Press enter to exit...\"'"
      call system(cmd)
      redraw!
    endif
  else
    echo 'Not a C++ file'
  endif
endfunction


" Compile and run C++ program in subshell with testcases

function! CompileAndRunWithTestCases()
  let filename = expand('%')
  if filename =~ '\.cpp$'
    let exe_name = substitute(filename, '\.cpp$', '', '')
    let test_file = exe_name . '.txt'

    " Check if the test case file exists
    if filereadable(test_file)
      " Compile the C++ code
      execute 'w | !g++ -std=c++20 -O2 -o ' . exe_name . ' ' . filename
      if v:shell_error == 0
        " Run the program with test cases
        let cmd = "x-terminal-emulator -e bash -c './" . exe_name . " < " . test_file . "; read -p \"Press enter to exit...\"'"
        call system(cmd)
        redraw!
      else
        echo 'Compilation failed'
      endif
    else
      echo 'Test case file not found: ' . test_file
    endif
  else
    echo 'Not a C++ file'
  endif
endfunction


command! -nargs=0 MySnippetExpand call MySnippetExpandFunction()

function! MySnippetExpandFunction()
    execute "normal! gg50Gzt"
    call UltiSnips#ExpandSnippet()
    normal! zz
endfunction



 
" Map keys to compile and run current file
map <F5> :call CompileAndRun()<CR>
map <F6> :call CompileAndRunWithTestCases()<CR>
map <F9> :w<CR>:!clear<CR>:call CompileAndRun()<CR>
noremap <C-p> :FZF<CR>
nnoremap <Leader>c :!g++ % -o %< && ./%< <CR>
nnoremap <C-a> :NERDTreeToggle<CR>
nnoremap <leader>e :MySnippetExpand<CR>


" Format current buffer using Astyle
nnoremap <F3> :%!astyle --style=stroustrup -q<CR>
