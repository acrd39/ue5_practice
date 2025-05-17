# Lua是什么?
脚本语言
特点
1. 动态类型
2. 自动垃圾回收
3. 一等函数、闭包支持良好
4. 唯一的数据结构是table 又是数组又是字典

# 基础语法
```lua
a = 10          -- 全局变量
local b =20     -- 局部变量

-- 数据类型
num = 3.14      -- number
str = "hello"   -- string
bool = true     -- boolean
tbl = {1, 2, 3} -- table
func = function() print("hi") end -- function
```

# 控制结构
```lua
-- if else
if x > 0 then
    print("positive")
elseif x < 0 then
    print("negative")
else
    print("zero")
end

-- for
for i = 1, 5 do
    print(i)
end

-- 泛型支持
for k, v in pairs({a=1, b=2}) do
    print(k, v)         -- 输出 a   1   b   2
end

-- while
while x < 5 do
    x = x + 1
end

-- repeat-until
repeat
    x = x - 1
until x == 0            -- 等价C++的do-while(!exp)

```

# Table
```lua
-- 作数组用
arr = {10, 20, 30}
print(arr[1])       -- 10 很特别，因为lua从1开始下标

-- 作字典用
person = {name = "Alice", age = 30}
print(person.name)
print(person["age"])        -- 两种语法都可以
-- 也能正常修改
person.name = "Bob"
person["age"] = 31

--遍历
for k, v in pairs(person) do
    print(k, v)
end

-- ipairs()
local arr = {"a", "b", "c"}

for i, v in ipairs(arr) do
    print(i, v)         -- 输出 1   a   2   b   3   c
end                     -- ps: 如果有nil会停止
```

# 一等函数与闭包
```lua
function add(x, y)
    return x + y
end

-- 匿名函数
square = function(x) return x * x end

-- 高阶函数
function apply(f, x)
    return f(x)
end
print(apply(square, 4))     -- 16

-- 闭包
function make_counter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end

c = make_counter()
print(c())      -- 1
print(c())      -- 2

-- 闭包扩展
function make_counter()
    local self = {}
    local count = 0

    function self:increment()
        count = count + 1
        return count
    end

    function self:reset()
        count = 0
    end

    function self:get()
        return count
    end

    return self
end

local c = make_counter()
print(c:increment())  -- 1
print(c:increment())  -- 2
print(c:get())        -- 2
c:reset()
print(c:get())        -- 0

-- ps: 这里的self:increment是语法糖 等价于 self.increment(self)
```

# 模块化
```lua
-- mymath.lua
local mymath = {}

function mymath.add(a, b)
    return a + b
end

return mymath

-- main.lua
local mymath = require("mymath")
print(mymath.add(1, 2))


---相当于我自己封装了一个包，里面有许多方法，然后我要用require来import这个包给我的变量，然后我这个变量就能直接用.来调用我包里的方法了
```

# 元表语面向对象
```lua
-- 模拟面向对象
Person = {}
Person.__index = Person                 -- 表示如果找不到方法就去Person表里找

function Person:new(name)
    local obj = {name = name}           -- 注意 这里的name左值是map的key 是变量名
    setmetatable(obj, Person)           -- 给obj指定了元表Person，如果obj里没有的字段就会去Person里找，类似Person是obj的说明书，相当于面向对象的继承
    -- 只能有一层元表，如果要继承多个元表需先创建一个具有多个表的新表
    return obj
end

function Person:greet()
    print("Hi, I'm " .. self.name)
end

p = Person:new("Lua")
p:greet()  --> Hi, I'm Lua

-- 多层元表示例
local A = { foo = function() print("foo from A") end }
local B = { bar = function() print("bar from B") end }

local combined_mt = {
  __index = function(t, key)
    return A[key] or B[key]
  end
}

local obj = {}
setmetatable(obj, combined_mt)

obj:foo()  -- 打印 foo from A
obj:bar()  -- 打印 bar from B
```