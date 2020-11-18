function! SetTerminalBuffer()
python3 << EOF
import vim
tbuf = -1
if 'terminal_buffer' in vim.vars: 
  tbuf = int(vim.vars['terminal_buffer'])
have_buffer = len([b for b in vim.buffers if b.number == tbuf]) > 0
if not have_buffer:
  # print("setting buffer")
  for b in vim.buffers:
    if b.options['buftype'] == b'terminal':
      vim.vars['terminal_buffer']=b.number
      # print("set g:terminal_buffer = ", b.number)
EOF
endfunction


function s:ensure_terminal_buffer()
  call SetTerminalBuffer()
  " get terminal buffer
  let g:terminal_buffer = get(g:, 'terminal_buffer', -1)
  " open new terminal if it doesn't exist
  if g:terminal_buffer == -1 || !bufexists(g:terminal_buffer)
    terminal
    let g:terminal_buffer = bufnr('')
    wincmd p
  " split a new window if terminal buffer hidden
  elseif bufwinnr(g:terminal_buffer) == -1
    exec 'sbuffer ' . g:terminal_buffer
    wincmd p
  endif
endfunction


function s:exec_on_ipython(lnum1, lnum2)
  call s:ensure_terminal_buffer()
  call term_sendkeys(g:terminal_buffer, "%cpaste\<cr>")
  sleep 100m
  call term_sendkeys(g:terminal_buffer, join(getline(a:lnum1, a:lnum2), "\<cr>") . "\<cr>")
  call term_sendkeys(g:terminal_buffer, "\<c-d>")
endfunction

function s:exec_on_term(lnum1, lnum2)
  call s:ensure_terminal_buffer()
  " joins non-blank lines and sends them to the terminal
  call term_sendkeys(g:terminal_buffer, "\<c-o>" . join(filter(getline(a:lnum1, a:lnum2), 'v:val != ""'), "\<cr>") . "\<cr>")
  call term_sendkeys(g:terminal_buffer, "\<cr>")
endfunction

command! -range ExecOnIpython call s:exec_on_ipython(<line1>, <line2>)
nnoremap <leader>ei :ExecOnIpython<cr>
vnoremap <leader>ei :ExecOnIpython<cr>

command! -range ExecOnTerm call s:exec_on_term(<line1>, <line2>)
nnoremap <leader>ex :ExecOnTerm<cr>
vnoremap <leader>ex :ExecOnTerm<cr>

" executes cell in terminal by finding previous ## and next ## and sending
" that content to terminal
nnoremap <leader>ec ?##<cr>v/##<cr>:ExecOnTerm<cr><C-o><C-o>
