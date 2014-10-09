module RateLimitable

  def self.included(base)
    base.extend RateLimitable
    include InstanceMethods
  end

  def initialize(*args)
    self._rate_limit_actions
    super(*args)
  end

  # register the methods
  def rate_limit(methud,options={})
    @_limits ||= {}
    @_limits[methud.to_sym] = options
  end

  def _rate_limit_actions
    limits = self.class.instance_variable_get(:@_limits) 
    p "rate limited actions for #{self} : #{limits}"
    limits.each do |methud,options|
      max = options.delete(:max)
      window = options.delete(:window)
      user_context = options.delete(:user_context)
      self.class.class_eval do
        alias_method "_rate_limit_#{methud}".to_sym, methud.to_sym
        define_method(methud.to_sym) do |*args| 
          p "checking rate limits..."
          #"_rate_limit_#{methud}"
          self.send "_rate_limit_#{methud}".to_sym(*args)
        end
      end
    end
    #alias_method "_rate_limit_#{methud}".to_sym, methud.to_sym

  end

  module InstanceMethods
    def limit_action(methud)
      p "limit_action: #{methud}"
    end
  end
end
