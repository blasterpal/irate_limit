#pry -r ./rate_limit_test.rb
require './using_rate_limits'
require './rate_limitable'
f = UsingRateLimits.new
require'pry';binding.pry
f.some_method
