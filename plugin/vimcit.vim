" TODO check all global variables used are defined

function! s:openFileAtPoint(dir, extension)
  let wordUnderCursor = expand("<cword>")
  let path = a:dir . "/" . wordUnderCursor . a:extension
  if !filereadable(path)
    throw "File not found or not readable " . path
  endif
  return path
endfunction

function! VimCitOpenPdf()
  let path = s:openFileAtPoint(g:VimCitPdfPath, ".pdf")
  echom "Opening pdf " . path
  execute "!" . g:VimCitPdfViewer . " " . path
endfunction

function! VimCitOpenNotes()
  let path = s:openFileAtPoint(g:VimCitNotesPath, ".md")
  echom "Opening notes file " . path
  execute "split " . path
endfunction

command! VimCitPdf call VimCitOpenPdf()
command! VimCitNotes call VimCitOpenNotes()
