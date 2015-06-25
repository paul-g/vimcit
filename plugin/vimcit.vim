" TODO check all global variables used are defined
function! s:getPathAtPoint(dir, extension)
  let wordUnderCursor = expand("<cword>")
  return a:dir . "/" . wordUnderCursor . a:extension
endfunction

function! s:openFileAtPoint(dir, extension)
  let path = s:getPathAtPoint(a:dir, a:extension)
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

function! VimCitOpenBibEntry()
  let path = g:VimCitBibPath . "/" . "bibliography.bib"
  echom "Opening bib file " . path
  let wordUnderCursor = expand("<cword>")
  execute "split" . path . " | " . " /" . wordUnderCursor
endfunction

function! VimCitSearchBibWordAtPoint()
  let path = g:VimCitBibPath . "/" . "bibliography.bib"
  let wordUnderCursor = expand("<cword>")
  execute "split" . path . " | " . " /" . wordUnderCursor
endfunction

function! VimCitSearch()
  execute "CtrlPTag "
endfunction

function! VimCitBuildTags()
  "Requires ctags to be configured for Bibitex
  "E.g. https://gist.github.com/ptrv/4576213
  execute "! ctags " . g:VimCitBibPath . "/bibliography.bib"
endfunction

command! VimCitPdf call VimCitOpenPdf()
command! VimCitNotes call VimCitOpenNotes()
command! VimCitOpenBibEntry call VimCitOpenBibEntry()
command! VimCitSearchAtPoint call VimCitSearchBibWordAtPoint()
command! VimCitBuildTags call VimCitBuildTags()
command! VimCitSearch call VimCitSearch()
