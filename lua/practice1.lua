-- 题目1【简单】统计字符串中每个字符出现的次数
-- 写一个函数 count_chars(s)，输入字符串 s，返回一个表，记录每个字符出现的次数。
function count_chars(s)
    local cnt = {}
    for i = 1, #s do
        local c = s:sub(i, i)           -- s[i]
        cnt[c] = (cnt[c] or 0) + 1
    end

    local freq_list = {}
    for k, v in pairs(cnt) do
        table.insert(freq_list, {char = k, count = v})
    end

    table.sort(freq_list, function(a, b)
        if a.count == b.count then
            return a.char < b.char
        else
            return a.count > b.count
        end
    end)

    return freq_list
end

local result = count_chars("testing for first question")

for _, entry in ipairs(result) do
    print(entry.char, entry.count)
end
