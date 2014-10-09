module RateLimitable

  def self.included(base)
    base.extend RateLimitable
  end

  def initialize(*args)
    self._collect_limits if @deferred
    super(*args)
  end

  ## register the methods
  def rate_limit(methud,options={})
    @deferred = true 
    @_limits ||= {}
    @_limits[methud.to_sym] = options
    p "limits supplied: #{options}"
  end
  
  # non-deferred, in-line
  def in_line_rate_limit(methud,options={})
      @deferred = false
      max = options.delete(:max)
      window = options.delete(:window)
      scope = options.delete(:scope) || 'global'
      _setup_limit(methud,max,window,scope)
  end
  
  def _collect_limits
    limits = self.class.instance_variable_get(:@_limits) 
    p "rate limited actions for #{self} : #{limits}"
    limits.each do |methud,options|
      max = options.delete(:max)
      window = options.delete(:window)
      scope = options.delete(:scope) || 'global'
      _setup_limit(methud,max,window,scope)
    end if limits
  end

  def _setup_limit(methud,max,window,scope)
      self.class.class_eval do
        alias_method "_rate_limit_#{methud}".to_sym, methud.to_sym
        define_method(methud.to_sym) do |*args| 
          p "checking rate limits..."
          #"_rate_limit_#{methud}"
          self.send "_rate_limit_#{methud}".to_sym(*args)
        end
      end
  rescue NameError => e
    p "Unable to setup limit, method not found: #{e}"
  end

end
