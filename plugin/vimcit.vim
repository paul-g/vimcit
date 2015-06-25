" TODO check all global variables used are defined
function! s:getPathAtPoint(dir, extension)
  let wordUnderCursor = expand("<cword>")
  return a:dir . "/" . wordUnderCursor . a:extension
endfunction

function! s:openFileAtPoint(dir, extension)
  let path = s:getPathAtPoint(dir, extension)
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
  let path = s:getPathAtPoint(g:VimCitNotesPath, ".md")
  echom "Opening notes file " . path
  execute "split " . path
endfunction

command! VimCitPdf call VimCitOpenPdf()
command! VimCitNotes call VimCitOpenNotes()
