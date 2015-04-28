require 'byebug'
require_relative 'lisp_environment'

class UtaLisp
  def initialize
    @global_env = add_globals(LispEnvironment.new)
  end

  def eval(x, env=@global_env)

    p x

    if x.is_a?(String)
      return env.find_env(x)[x] if env.find_env(x)
    end
    unless x.is_a?(Array)
      return x
    end

    case x[0]
    when 'quote', 'q'
      x[1]
    when 'atom?'
      !eval(x[1], env).is_a?(Array)
    when 'eq?'
      v1 = eval(x[1], env)
      v2 = eval(x[2], env)
      !v1.is_a?(Array) && (v1 == v2)
    when 'car'
      eval(x[1], env)[0]
    when 'cdr'
      _first, *rest = eval(x[1], env)
      rest
    when 'cons'
      [eval(x[1],env)] + [eval(x[2],env)]
    when 'cond'
      x[1..-1].each do |condition, exp|
        return eval(exp,env) if eval(condition,env)
      end
    when 'null?'
      eval(x[1],env) == []
    when 'if' # (if test conseq alt)
      _, test, conseq, alt = x
      eval((eval(test, env) ? conseq : alt),env)
    when 'set!'
      var_in_env = env.find_env(x[1])[x[1]] if env.find_env(x[1])
      var_in_env = eval(x[2],env)
    when 'define'
      File.open('user_definition.txt', 'a+'){|f| f.print "#{to_s(x)}\n" }
      env[x[1]] = eval(x[2],env)
    when 'lambda'
      _, vars, exp = x
      lambda{ |*args| eval(exp, LispEnvironment.new(vars,args,env))}
    when 'begin'
      v = nil
      x[1..-1].each do |expr|
        v = eval(expr, env)
      end
      return v
    else
      binding_name = x[0]
      rambda = user_definition(binding_name)
      expressions = x.map{ |expr| eval(expr,env) }
      procedure = expressions.shift
      if rambda.nil?
        procedure.call(*expressions)
      else
        rambda.call(*expressions)
      end
    end
  end

  def user_definition(binding_name)
    user_definitions = []
    File.open('user_definition.txt', 'r') do |file|
      user_definitions = file.readlines
    end
    lambda_def = user_definitions.reverse.detect do |l|
      parse(l)[1] == binding_name
    end rescue nil
    eval(parse(lambda_def)[2]) if lambda_def
  end

  def parse(s)
    read_from(tokenize(s))
  end

  def to_s(tokenized)
    return tokenized.to_s unless tokenized.is_a?(Array)
    '(' + tokenized.map{|token| to_s(token)}.join(' ') + ')'
  end

  private

  def tokenize(str)
    str.gsub('(',' ( ')
       .gsub(')',' ) ')
       .split
  end

  def read_from(tokens)
    raise 'unexpected EOF while reading' if tokens.length == 0
    token = tokens.shift
    case token
    when '('
      lisp_list = []
      while tokens.first != ')'
        lisp_list << read_from(tokens)
      end
      tokens.shift
      lisp_list
    when ')'
      raise 'unexpected closing parenthesis )'
    else
      atom(token)
    end
  end

  def atom(token)
    Integer(token)
  rescue ArgumentError
    begin
      Float(token)
    rescue ArgumentError
      token
    end
  end

  def add_globals(env)
    env.merge!({
      '+' => lambda{ |a,b| a + b },
      '-' => lambda{ |a,b| a - b },
      '*' => lambda{ |a,b| a * b },
      '/' => lambda{ |a,b| a / b },
      '>' => lambda{ |a,b| a > b },
      '<' => lambda{ |a,b| a < b },
      '>=' => lambda{ |a,b| a >= b },
      '<=' => lambda{ |a,b| a <= b },
      '=' => lambda{ |a,b| a == b }
    })
    env.merge!({'True' => true, 'False' => false})
  end
end
