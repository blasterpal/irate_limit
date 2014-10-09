require './rate_limitable'
class UsingRateLimits
  include RateLimitable
  rate_limit :some_method, {max: 15, window: 900, user_context: lambda { self.user } }
  def some_method
     p "I'm original #{__method__} called!"
  end
end


