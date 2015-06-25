" TODO check all global variables used are defined

function! VimCitOpenPdf()
  let wordUnderCursor = expand("<cword>")
  let path = g:VimCitPdfPath . "/" . wordUnderCursor . ".pdf"
  if !filereadable(path)
    echo "File not found or not readable " . path
    return
  endif

  echom "Opening pdf " . path
  execute "!" . g:VimCitPdfViewer . " " . path
endfunction

command! VimCitOpenAtPoint call VimCitOpenPdf()
