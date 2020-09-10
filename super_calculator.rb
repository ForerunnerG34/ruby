def precedence?(left, right)
  precedence = {}
  precedence['*'] = 3
  precedence['/'] = 3
  precedence['+'] = 2
  precedence['-'] = 2
  precedence['('] = 1

  precedence[left] >= precedence[right]
end

def calculate(num1, num2, opr)
  case opr
  when '*'
    num1 * num2
  when '/'
    num1 / num2
  when '+'
    num1 + num2
  when '-'
    num1 - num2
  end
end

def convert_to_postfix(input)
  numbers = '1234567890.'
  expression_stack = []
  operators_stack = []
  literal = ''

  input.each_char do |c|
    if numbers.include? c
      # capture the whole number before pushing it into the stack
      literal += c
    elsif c == '('
      # push previous number
      expression_stack.push literal unless literal.empty?
      literal = ''

      operators_stack.push(c)
    elsif c == ')'
      # push previous number
      expression_stack.push literal unless literal.empty?
      literal = ''

      # push the operator into the result stack and then remove the inserted '('
      expression_stack.push operators_stack.pop
      operators_stack.pop
    else
      # push previous number
      expression_stack.push literal unless literal.empty?
      literal = ''

      # push the operator based on the precedence
      while !operators_stack.empty? && precedence?(operators_stack.last, c) do expression_stack.push operators_stack.pop end

      operators_stack.push(c)
    end
  end

  expression_stack.push literal unless literal.empty?

  # push the remaining operators at the end
  until operators_stack.empty? do expression_stack.push operators_stack.pop end

  expression_stack
end

def calculate_postfix(expression_stack)
  expression_stack.reverse!

  return 'Nothing to calculate' unless expression_stack.length >= 3

  until expression_stack.length <= 1
    n1 = expression_stack.pop
    n2 = expression_stack.pop
    op = expression_stack.pop

    result = calculate(n1.to_f, n2.to_f, op)

    expression_stack.push result
  end

  expression_stack.pop
end

title = 'WELCOME TO SUPER CALCULATOR'
puts title
title.length.times { print '=' }
puts
puts 'What do you want to calculate?.'
# puts 'Examples:'
# puts  '5+9'
# puts  '3*12.3/67'
# puts  '((4+5)/6)*5.4'

input = gets.chomp.downcase

# convert expression to postfix format for easier calculation. (example: 4+3 => 43+)
postfix = convert_to_postfix(input)
result = calculate_postfix(postfix)
puts result