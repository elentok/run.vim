if !exists('g:run_key')
  let g:run_key = ',r'
end

let g:run_commands = {
      \  "rb": "ruby %",
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
  endif

  exec "silent !clear"
  exec "silent !echo '================================='"
  silent exec "!echo '$ " . expand(exec_cmd) . "'"
  exec "silent !echo '================================='"
  exec "!" . exec_cmd
endfunc

exec 'noremap ' . g:run_key . ' :w<cr>:call RunCurrentFile()<cr>'
