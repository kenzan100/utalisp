require 'readline'
require_relative 'uta_lisp'

# you could pass in definition file path and debug mode option
@ul = UtaLisp.new

def handle_input(input)
  result = @ul.eval(@ul.parse(input))
  puts("=> #{@ul.to_s(result)}")
  user_definitions = []
  File.open(@ul.definition_path, 'r') do |file|
    user_definitions = file.readlines
  end
  puts user_definitions
rescue StandardError => e
  print "An error occured. Here's the Ruby stack trace:\n"
  puts e
  puts e.backtrace
end

trap "SIGINT" do
  puts 'Exiting'
  exit 130
end

Readline.completion_proc = ->(s){ print "\t" }

repl = ->(prompt){
  all_text = ''
  while (text = Readline.readline(prompt,true)) != ""
    all_text << text
  end
  handle_input(all_text)
}

loop do
  repl.(">> ")
end
