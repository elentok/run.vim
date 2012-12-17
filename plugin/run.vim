if !exists('g:run_key')
  let g:run_key = ',r'
end

let g:ruby_command = "ruby"
if exists("$HOME/.rvm/bin/ruby")
  let g:ruby_command = "$HOME/.rvm/bin/ruby"
end

let g:run_commands = {
      \  "rb": g:ruby_command . " %",
      \  "py": "python %",
      \  "js": "node %",
      \  "coffee": "coffee %",
      \  "md": "bluecloth % > /tmp/markdown-output.html && google-chrome /tmp/markdown-output.html"
      \}

func! RunCurrentFile()
  let filename = expand("%:t")
  let extension = tolower(expand("%:e"))
  let exec_cmd = "%"

  " rspec
  if filename =~ "_spec.rb"
    let exec_cmd = "rspec --drb -f documentation -c %"

  " cucumber features
  elseif filename =~ "\.feature$"
    let exec_cmd = "cucumber"
  elseif has_key(g:run_commands, extension)
    let exec_cmd = g:run_commands[extension]

  " executable file
  elseif IsExecutable(filename)
    let exec_cmd = "./" . filename
  endif


  let cmd = "clear && "
    \ . "echo '=================================' && "
    \ . "echo '$ " . expand(exec_cmd) . "' && "
    \ . "echo '================================='"

  exec "silent !(" . cmd . ")"
  exec "!" . exec_cmd
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
