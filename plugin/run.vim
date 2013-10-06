if !exists('g:run_key')
  let g:run_key = '<Leader>r'
end

if !exists('g:run_with_vimux')
  let g:run_with_vimux = 0
end

let g:ruby_command = "ruby"
if exists("$HOME/.rvm/bin/ruby")
  let g:ruby_command = "$HOME/.rvm/bin/ruby"
end

let g:run_commands = {
      \  "rb": g:ruby_command . " {file}",
      \  "py": "python {file}",
      \  "js": "node {file}",
      \  "coffee": "coffee {file}",
      \  "md": "bluecloth {file} > /tmp/markdown-output.html && google-chrome /tmp/markdown-output.html",
      \  "applescript": "osascript {file}"
      \}

func! RunCurrentFile()
  let fullpath = expand("%")
  let filename = expand("%:t")
  let extension = tolower(expand("%:e"))
  let exec_cmd = '{file}'

  if filename =~ ".vim$"
    exec "source " . fullpath
    return

  " rspec
  elseif filename =~ "_spec.rb"
    let exec_cmd = "rspec --drb -f documentation -c {file}"

  " cucumber features
  elseif filename =~ "\.feature$"
    let exec_cmd = "cucumber"
  elseif has_key(g:run_commands, extension)
    let exec_cmd = g:run_commands[extension]

  " executable file
  elseif IsExecutable(fullpath)
    let exec_cmd = "./" . fullpath
  endif

  let exec_cmd = substitute(exec_cmd, '{file}', fullpath, 'g')

  let cmd = "clear && "
    \ . "echo '=================================' && "
    \ . "echo '$ " . expand(exec_cmd) . "' && "
    \ . "echo '================================='"

  if g:run_with_vimux
    call VimuxRunCommand("clear\n" . exec_cmd)
  else
    exec "silent !(" . cmd . ")"
    exec "!" . exec_cmd
  end

  "let exec_cmd = substitute(exec_cmd, "%", expand("%"), 'g')
  "call conque_term#open(expand(exec_cmd), ['below split', 'resize 20'], 0)
endfunc

func! IsExecutable(filename)
  let perm = getfperm(a:filename)
  "rwxrwxrwx
  "012345678
  if perm[2] == 'x' || perm[5] == 'x' || perm[8] == 'x'
    return 1
  else
    return 0
  endif
endfunc

exec 'noremap ' . g:run_key . ' :w<cr>:call RunCurrentFile()<cr>'
