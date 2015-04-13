require_relative 'uta_lisp'
@ul = UtaLisp.new

def handle_input(input)
  result = @ul.eval(@ul.parse(input))
  puts("=> #{result}")
rescue StandardError => e
  print "An error occured. Here's the Ruby stack trace:\n"
  puts e
  puts e.backtrace
end

trap "SIGINT" do
  puts 'Exiting'
  exit 130
end

repl = -> prompt do
  print prompt
  handle_input(gets.chomp!)
end

loop do
  repl[">> "]
end
