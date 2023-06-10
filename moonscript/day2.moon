-- Two dashes start a comment. Comments can go until the end of the line.
-- MoonScript transpiled to Lua does not keep comments.

-- As a note, MoonScript does not use 'do', 'then', or 'end' like Lua would and
-- instead uses an indented syntax, much like Python.

--------------------------------------------------
-- 1. Assignment
--------------------------------------------------

hello = "world"
a, b, c = 1, 2, 3
hello = 123

x = 0
x += 10                 --> x = x + 10

s = "hello"
s ..= "world"           --> s = s.."world"

b = false
b and= true or false    --> b = b and (true or false)

--------------------------------------------------
-- 2. Literals and Operators
--------------------------------------------------

-- Literals work almost exactly as they would in Lua. Strings can be broken in
-- the middle of a line without requiring a \.

some_string = "exa
mple"   --> some_string = "exa\nmple"

another_string = "This is and #{some_string}"

--------------------------------------------------
-- 2.1. Function Literals
--------------------------------------------------

-- Functions are written using arrows:

my_function = ->     --> function my_function() end

func_a = -> print "fuck"

func_b = ->
    value = 100
    print "The value: #{value}"
    
func_a!
func_b()

sum = (x, y) -> x + y
print sum 1,2

a_function = (name = "something", height=100)->
	print "Hello, I am #{name}.\nMy height is #{height}."

a_function()
