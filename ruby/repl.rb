require_relative 'uta_lisp'
@ul = UtaLisp.new

def handle_input(input)
  result = @ul.eval(@ul.parse(input))
  puts("=> #{result}")
  user_definitions = []
  File.open('user_definition.txt', 'r') do |file|
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

repl = ->(prompt){
  print prompt
  handle_input(gets.chomp!)
}

# sq_definition = "(define sq(lambda(x) (* x x)))"
# handle_input(sq_definition)

loop do
  repl[">> "]
end
