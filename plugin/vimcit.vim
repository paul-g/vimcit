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

fun! VimCitParseBib()
  let parsingEntry = 0
  let entryId = ''
  let entries = []
  for line in readfile(glob(g:VimCitBibPath . "/bibliography.bib"), '')
    " TODO set ignorecase
    if line =~ '@'
      if line =~? 'STRING'
        continue
      endif
      let parsingEntry = 1
      let id = substitute(line, '@.*{\|,', "", "g")
      continue
    endif
    if parsingEntry && line =~? 'title' && line !~? 'booktitle'
      let title = substitute(line, 'title\s*=\s\|,\|{\|}', "", "g")
      echom id . " -- " . title
      let parsingEntry = 0
      call add(entries, {'word': id, 'menu': title})
    endif
  endfor
  return entries
endfun

" Omni complete for citation keys
fun! VimCitComplete(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    " find months matching with "a:base"
    let res = []
    let completions = VimCitParseBib()
    for m in completions
      if m.word =~ '^' . a:base
        echom m.word
        let word = m.word
        let title = m.menu
        call add(res, {'word': word, 'menu': title })
      endif
    endfor
    return res
  endif
endfun

command! VimCitPdf call VimCitOpenPdf()
command! VimCitNotes call VimCitOpenNotes()
command! VimCitOpenBibEntry call VimCitOpenBibEntry()
command! VimCitSearchAtPoint call VimCitSearchBibWordAtPoint()
command! VimCitBuildTags call VimCitBuildTags()
command! VimCitSearch call VimCitSearch()
command! VimCitParseBib call VimCitParseBib()
