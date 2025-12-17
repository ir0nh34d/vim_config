" Last Modified: 2025-12-17 11:03:06
scriptencoding utf-8

function GuiTabLabel()
  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)

  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let label = '+'
      break
    endif
  endfor

  " Append the number of windows in the tab page if more than one
  let wincount = tabpagewinnr(v:lnum, '$')
  if wincount > 1
    let label ..= wincount
  endif
  if label != ''
    let label ..= ' '
  endif

  let buffername = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
  if buffername == ''
      if &buftype == 'quickfix'
        let buffername = '[Quickfix List]'
      else
        let buffername = '[No Name]'
      endif
  endif
  let label ..= buffername

  " Append the buffer name
  return label
endfunction

set guitablabel=%{GuiTabLabel()}

set guifont=-monospace-Thin:h15
set columns=150
set lines=50
set guioptions+=!
if has ('mac')
    set transparency=2
endif
