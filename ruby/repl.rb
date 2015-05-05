require 'readline'
require_relative 'uta_lisp'

# you could pass in definition file path and debug mode option
@ul = UtaLisp.new

def handle_input(input)
  if input != ''
    result = @ul.eval(@ul.parse(input))
    puts("=> #{@ul.to_s(result)}")
  end
  user_definitions = []
  File.open(@ul.definition_path, 'r') do |file|
    user_definitions = file.readlines
  end
  puts
  puts user_definitions
rescue StandardError => e
  print "An error occured. Here's the Ruby stack trace:\n"
  puts e
  puts e.backtrace
end

def closing_paren_needed(texts)
  texts.count('(') - texts.count(')')
end

trap "SIGINT" do
  puts 'Exiting'
  exit 130
end

Readline.completion_proc = ->(s){ print "\t" }

repl = ->(prompt){
  all_text = ''
  prompt_plus_info = "- #{prompt}"
  while (text = Readline.readline(prompt_plus_info,true)) != ""
    all_text << text
    prompt_plus_info = "#{closing_paren_needed(all_text)} #{prompt}"
  end
  handle_input(all_text)
}

loop do
  repl.(">> ")
end
