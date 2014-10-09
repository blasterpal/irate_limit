require './rate_limitable'
class UsingRateLimits
  include RateLimitable
  
  # USING initialize and deferred Class instance variable with all limits works
  rate_limit :some_method, {max: 15, window: 900, scope: lambda { self.user } }
  def some_method
     p "I'm original #{__method__} called!"
  end

  def another_method
    p "I'm original #{__method__} called!"
  end
  # DOES NOT WORK
  in_line_rate_limit :another_method, {max: 15, window: 900, scope: lambda { self.user } }
end


