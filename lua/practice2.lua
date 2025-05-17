-- 实现一个单词频率统计器（WordCounter 模拟类）
-- 写一个模块/表 WordCounter，支持以下功能：
-- WordCounter:new(text)：初始化，传入字符串 text
-- wc:get(word)：返回某个单词出现的次数
-- wc:most_common(n)：返回出现频率最高的前 n 个单词，按频率降序排列
-- 忽略标点符号，仅统计由字母组成的单词，大小写不敏感（例如 "Hello" 和 "hello" 视为同一个词）

local WordCounter = {}
WordCounter.__index = WordCounter

function WordCounter:new(text)
    local self = setmetatable({}, WordCounter)
    self.freq = {}

    for word in string.gmatch(text, "%w+") do
        word = word:lower()
        self.freq[word] = (self.freq[word] or 0) + 1
    end

    return self
end

function WordCounter:get(word)
    word = word:lower()
    return self.freq[word] or 0
end

function WordCounter:most_common(n)
    local list = {}
    for word, count in pairs(self.freq) do
        table.insert(list, {word = word, count = count})
    end

    table.sort(list, function (a, b)
        return a.count > b.count
    end)

    local result = {}
    for i = 1, math.min(n, #list) do
        table.insert(result, list[i])
    end
    
    return result
end

local wc = WordCounter:new("Hello, world! Hello Lua. Lua is fun, Lua is fast.")

print(wc:get("hello"))  --> 2
print(wc:get("lua"))    --> 3

local top = wc:most_common(2)
for _, entry in ipairs(top) do
    print(entry.word, entry.count)
end