class LispEnvironment < Hash
  attr_accessor :outer

  def initialize(params=[], args=[], outer=nil)
    self.merge!(Hash[params.zip(args)])
    self.outer = outer
  end

  def find_env(var)
    return self if self[var]
    self.outer.find_env(var) if self.outer
  end
end
