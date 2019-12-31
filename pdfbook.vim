" Copy this to your vimrc

""" PDF book
function! PDFBookStartFn(paperPerPart, startPage)
    let l:endPage = a:startPage - 1 + a:paperPerPart * 4 - 6
    exec 'norm! A "'.a:startPage.',1,1,1,1,1,'.a:startPage.'-'.l:endPage.'"'
endfunction

function! PDFBookNextFn(paperPerPart)
  norm! yypf"f-l
  let l:previousPage = str2nr(expand("<cword>"))
  exec 'norm! ci"' . (l:previousPage + 1) . '-' . (l:previousPage + 4 * a:paperPerPart)
endfunction

function! PDFBookEndFn(paperPerPart, notePapers)
  norm! yypf"f-l
  let l:previousPage = str2nr(expand("<cword>"))
  let l:offset = 2 * a:notePapers + 6
  exec 'norm! ci"' . (l:previousPage + 1) . '-' . (l:previousPage + 4 * a:paperPerPart - l:offset)
  if (a:notePapers > 0)
    exec 'norm! ' . (a:notePapers * 2) . 'a,2'
  endif
  norm! 6a,1
  call PDFBookNextBookFn(a:paperPerPart)
endfunction

function! PDFBookNextBookFn(paperPerPart)
    norm! vipygPO
    norm! jvipkojdf"f-l
    let l:previousPage = str2nr(expand("<cword>"))
    exec "norm! dd{j0f\"f-T,vt-c" . (l:previousPage + 1) . "\<esc>f-lce" . (l:previousPage + (4 * a:paperPerPart) - 6)
endfunction

function! PDFBookFinalFn(papersPerPart, lastPage, notePapers)
    norm! yyp0f"f-l"
    let l:previousPage = str2nr(expand("<cword>"))
    let l:expectedLast = l:previousPage + (4 * a:papersPerPart) - 6 - (2 * a:notePapers)
    if (a:lastPage >= l:previousPage && a:lastPage <= l:expectedLast)
        let l:offset = l:expectedLast - a:lastPage
        let l:actualNotePages = l:offset + a:notePapers * 2
        exec 'norm! ci"' . (l:previousPage + 1) . '-' . a:lastPage
        if (l:actualNotePages > 0)
            exec 'norm! ' . l:actualNotePages . 'a,2'
        endif
        norm! 6a,1
    else
        echoerr 'last page' . a:lastPage . ' out of range ('. l:previousPage . ', ' . l:expectedLast . ']'
        delete
    endif
endfunction

command! -nargs=* PDFBookStart :call PDFBookStartFn(<f-args>)
command! -nargs=* PDFBookNext :call PDFBookNextFn(<f-args>)
command! -nargs=* PDFBookEnd :call PDFBookEndFn(<f-args>)
command! -nargs=* PDFBookNextBook :call PDFBookNextBookFn(<f-args>)
command! -nargs=* PDFBookFinal :call PDFBookFinalFn(<f-args>)
