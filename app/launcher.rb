$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'toy/robot'

puts "Start to control a robot\n"
r = Toy::Robot.new
puts "Please give your instructions.\n"
command = ''
until command.eql?('station')
  command = gets.strip
  r.execute(command.to_s)
end


