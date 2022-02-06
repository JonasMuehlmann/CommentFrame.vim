"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                                 CommentFrame!                                "
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                      Public Domain, same license as Vim.                     "
"        see: http://vimdoc.sourceforge.net/htmldoc/uganda.html#license        "
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"~~~~~~~~~~~~~~~~ Copyright 2012 cometsong <benjamin at cometsong dot net> ~~~~"


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                          CommentFrame function                            {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Syntax: CommentFrame(comment char to start line,
"            comment char to end the line,
"            width of line,
"            character to fill space in frame border (e.g. '*', '-', '=', ' '),
"            character to fill space in title line,
"            number of spaces to leave around title string
"            title string in center of line)
function! s:CommentFrame(start_str, end_str, line_width, frame_fill, title_fill, spacing, titlestring)
  " check and mod arg vars
  let l:title_fill = s:CheckNotEmpty(' ', a:title_fill)
  let l:frame_fill = s:CheckNotEmpty(' ', a:frame_fill)

  " prepend/append spacing
  let l:titlestr = repeat(' ', a:spacing) . a:titlestring . repeat(' ', a:spacing)

  " combine and count
	let l:middle_length=a:line_width - len(a:start_str . a:end_str)
	let l:title_left_length=((l:middle_length / 2) - (len(l:titlestr) / 2))
  let l:title_left = repeat(l:title_fill, l:title_left_length)
	let l:title_right_length=l:middle_length - len(l:title_left) - len(l:titlestr)
  let l:title_right = repeat(l:title_fill, l:title_right_length)
  
  " build border lines
	let l:border=a:start_str . repeat(l:frame_fill, l:middle_length) . a:end_str
  " build title_line
	let l:title_line=a:start_str . l:title_left . l:titlestr . l:title_right . a:end_str

  " add comment lines to doc
	call append(line('.'), l:border)
	call append(line('.'), l:title_line)
	call append(line('.'), l:border)
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                          CommentRight function                            {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Syntax: CommentRight(comment char to start line,
"            comment char to end the line,
"            width of line,
"            width of right end of line (after title),
"            character to fill space (e.g. '*', '-', '=', ' '),
"            number of spaces to leave around title string
"            title string on right side of line)
function! s:CommentRight(start_str, end_str, line_width, title_fill, spacing, titlestring)
  " check and mod arg vars
  let l:title_fill = s:CheckNotEmpty(' ', a:title_fill)

  " prepend/append spacing
  let l:titlestr = repeat(' ', a:spacing) . a:titlestring . repeat(' ', a:spacing)

  " combine and count
	let l:middle_length=a:line_width - len(a:start_str . a:end_str)
	let l:title_left_length=((l:middle_length / 2) - (len(l:titlestr) / 2))
  let l:title_left = repeat(l:title_fill, l:title_left_length)
	let l:title_right_length=l:middle_length - len(l:title_left) - len(l:titlestr)
  let l:title_right = repeat(l:title_fill, l:title_right_length)
  
  " build title_line
	let l:title_line=a:start_str . l:title_left . l:titlestr . l:title_right . a:end_str

  " add comment lines to doc
	call append(line('.'), l:title_line)
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CheckNotEmpty function   {{{ ~~~~~
function! s:CheckNotEmpty(default_val, arg_val)
  if a:arg_val != ''
    return a:arg_val
  else
    return a:default_val
  endif
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MapKeys function   {{{ ~~~~~
function! s:MapKeys(modes, keys, target)
  " Build up a map command like
  " 'inoremap <Leader>keys target'
  let s:map_start = 'noremap <Leader>'
  for mode in (a:modes == '') ? [''] : split(a:modes, '\zs')
    if mode == 'i'
      let s:target = '<C-C>' . a:target . ' a'
    else
      let s:target = a:target
    endif
    if strlen(a:keys)
      execute mode . s:map_start . a:keys  . ' ' . s:target
    endif
  endfor
endfunction
" usage:  call s:MapKeys('nvi', 'do', 'doStuff')
"}}}


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                               General Use Setup                           {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Plugin Config {{{ ~~~~~
" Do they want to skip our default mappings?
let s:domaps = v:true
if exists('g:CommentFrame_SkipDefaultMappings')
  let s:domaps = v:false
endif

" config to set width of comment lines
let s:fw = 80
if exists('g:CommentFrame_TextWidth')
  let s:fw = g:CommentFrame_TextWidth
endif

""}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Custom Comment Functions {{{ ~~~~~
function! CommentFrame#Custom(start_str, end_str, line_width, 
                     \frame_fill, title_fill, numspaces, titlestring)
  call s:CommentFrame(a:start_str, a:end_str, a:line_width, 
                     \a:frame_fill, a:title_fill, a:numspaces, a:titlestring)
endfunction

function! CommentFrame#CustomRight(start_str, end_str, line_width,
                     \title_fill, numspaces, titlestring)
  call s:CommentRight(a:start_str, a:end_str, a:line_width,
                     \a:title_fill, a:numspaces, a:titlestring)
endfunction

function! CommentFrame#MapKeys(modes, keys, target)
  call s:MapKeys(a:modes, a:keys, a:target)
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Languages, CommentFrame {{{ ~~~~~
command! -nargs=+ CommentFrameSlashes     : call CommentFrame#Custom('//', '//', s:fw, '*', ' ', 0, <args>)
if s:domaps|call s:MapKeys('ni', 'fcs', ':CommentFrameSlashes ""<Left>')|endif

command! -nargs=+ CommentRightSlashes   : call CommentFrame#CustomRight('//', '//', s:fw, '*', 4, <args>)
if s:domaps|call s:MapKeys('ni', 'fcS', ':CommentRightSlashes ""<Left>')|endif


"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Plugin Menu Creation {{{ ~~~~~
amenu .170.1 &Plugin.Comment&Frames.&Frame\ Slashes       :CommentFrameSlashes ''<Left>
amenu .170.1 &Plugin.Comment&Frames.&Right\ Slashes       :CommentRightSlashes ''<Left>
"}}}
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}}}
