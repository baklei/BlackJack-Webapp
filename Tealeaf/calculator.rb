puts "What's the first number?"

num1 = gets.chomp

puts "What's the second number?"

num2 = gets.chomp

puts "Your first number is #{num1} and your second number is #{num2}."

puts "What operation would you like to perfrom? 1) add, 2) subtract, 3) multiply and 4) divide"

operation = gets.chomp
  
puts "You chose to #{operation}."

result = nil

if operation == '1'
  result = num1.to_i + num2.to_i
end
  if operation == '2'
  result = num1.to_i - num2.to_i
  end
  if operation == '3'
  result = num1.to_i * num2.to_i
  end
  if operation == '4'
  result = num1.to_f / num2.to_f
  end
puts "The result is #{result}"