local list_metatable = {
	__call = function (_table)
		for _k, _v in ipairs (_table) do
			io.write (_v,"  ")
		end
	end,
	__tostring = function (_table)
		local _str = ""
		for _k, _v in ipairs (_table) do
			if type (_v) == "string" then
				_str = _str.."\"".._v.."\","
			else
				_str = _str..tostring(_v)..","
			end
		end
		return "[".._str:sub(1, #_str-1).."]"
	end
}
local _list_base = {
	average = average,
	sum     = sum,
	min     = min,
	max     = max,
	length  = length,
	map     = map,
	filter  = function (self, func)
		return filter (func, self)
	end,
	head    = head,
	takeWhile = function (self, func)
		return filter (func, self)
	end,
	dropWhile = function (self, func)
		return filter (function (v) return not func (v) end, self)
	end
}
local _fmin = function (_a, _b)
	if _a > _b then
		return _b
	else
		return _a
	end
end
local _fmax = function (_a, _b)
	if _a < _b then
		return _b
	else
		return _a
	end
end
local tableConcat = function (tableA, tableB)
	local t = {}
	for k, v in pairs (tableA) do
		t[k] = v
	end
	for k, v in pairs (tableB) do
		t[k] = v
	end
	return t
end
local _isLegalParameters = function (msg, ...)
	local _argv = {...}
	if type (_argv[1]) == "table" then
		if #_argv > 1 then
			error (msg)
		else
			_argv = _argv[1]
		end
	end
	return setmetatable(tableConcat (_list_base, _argv), list_metatable)
end
local _isLegalFunctor = function (msg, func)
	if type (func) ~= "function" then
		error (msg)
	end
end
local _getEmptyList = function ()
	local execute = function (self, func)
		return func (self)
	end
	return setmetatable (_list_base, list_metatable)
end
average = function (_list)
	local _average = 0
	for _k, _v in ipairs(_list) do
		if type (_v) ~= "number" then
			error ("the list must be pure number")
		else
			_average = _average + _v
		end
	end
	return _average/#_list
end
mean = average
sum = function (_list)
	local _sum = 0
	for _k, _v in ipairs(_list) do
		if type (_v) ~= "number" then
			error ("the list must be pure number")
		else
			_sum = _sum + _v
		end
	end
	return _sum
end
prod = function (_list)
	local _prod = 1
	for _k, _v in ipairs(_list) do
		if type (_v) ~= "number" then
			error ("the list must be pure number")
		else
			_prod = _prod * _v
		end
	end
	return _prod
end
range = function (_start, _end, _duration)
	local _t = _getEmptyList ()
	_duration = _duration and _duration or 1
	if type(_start) == "number" and type(_end) == "number" and type (_duration) == "number" then
		for _i = _start, _end, _duration do
			table.insert (_t, _i)
		end
	end
	return _t
end
min = function (...)
	local _min, _argv = _isLegalParameters ("once you decide input a table into min, then you cant input any other value into the function, just a table or a boundent values.", ...)
	_min = _argv[1]
	for _k, _v in ipairs (_argv) do
		_min = _fmin (_v, _min)
	end
	return _min
end
max = function (...)
	local _max, _argv = _isLegalParameters ("once you decide input a table into max, then you cant input any other value into the function, just a table or a boundent values.", ...)
	_max = _argv[1]
	for _k, _v in ipairs (_argv) do
		_max = _fmax (_v, _max)
	end
	return _max
end
length = function (...)
	return #_isLegalParameters ("your parameter must be same, and only one table", ...)
end
strLength = function (str)
	return #str
end
map = function (func, ...)
	_isLegalFunctor ("func cant be execute", func)
	local _argv = _isLegalParameters ("your parameter must be same, and only one table", ...)
	local _result = _getEmptyList ()
	for k,v in ipairs (_argv) do
		_result[k] = func(v)
	end
	return _result
end
filter = function (func, ...)
	_isLegalFunctor ("func cant be execute", func)
	local _argv = _isLegalParameters ("emm", ...)
	local _result = _getEmptyList ()
	for k,v in ipairs (_argv) do
		if func (v, k) then table.insert (_result, v) end
	end
	return _result
end
findAll = filter
head = function (num, ...)
	num = num and num or 1
	return filter (function (v, k) return k <= num end, ...)
end
-- tail = function (num, ...)
-- 	return filter (function (v, k) return k > size, ... end)
-- end
isZero = function (num)
	if type (num) ~= "number" then error ("")
	else return num == 0 end
end
isEqual = function (a, b)
	return a == b
end
mod = function (func, num)
	return function (v)
		return func (num%v)
	end
end
div = function (numa, numb)
	return numa // numb
end
fdiv = function (numa, numb)
	return numa / numb
end
add = function (numa, numb)
	return numa + numb
end
sub = function (numa, numb)
	return numa - numb
end
pattern_word = "[%s%p%c]?(%a+)[%s%p%c]?"
split = function (pattern, str)
	if type (str) ~= "string" then
		error ("not string")
		return nil
	else
		local _list = _getEmptyList ()
		for word in str:gmatch(pattern) do
			table.insert (_list, word)
		end
		return _list
	end
end
unique = function (...)
	local _list = _getEmptyList ()
	local _argv = _isLegalParameters ("", ...)
	for k, v in ipairs (_argv) do
		local flag = true
		for _k, _v in ipairs(_list) do
			if v == _v then
				flag = false
				break
			end
		end
		if flag then table.insert (_list, v) end
		-- print (#__list)
	end
	return _list
end
list = function (...)
	return _isLegalParameters ("", ...)
end
find = function (func, ...)
	head (filter (func, ...))
end
reduce = function (func, ...)
	local _argv = _isLegalParameters ("", ...)
	_isLegalFunctor ("", func)
	local _result
	if type (_argv[1]) == "string" then
		_result = ""
	elseif type (_argv[1]) == "number" then
		_result = 0
	elseif type (_argv[1]) == "table" then
		_result = _getEmptyList ()
	end
	for k,v in ipairs (_argv) do
		_result = func (_result, v)
	end
	return _result
end


-- 计算完美数
-- filter (function (i) return isEqual (sum (filter (mod (isZero, i), range (1, div (i, 2)))), i) end, range (1,10000))

--[[
median = function ()  end -- 中位数
std = function ()  end -- 标准差
diff = function () end -- 相邻元素的差
sort = table.sort()
norm = function () end -- 欧式（euclidean）长度
cumsum = function () end -- 累计元素总和
cumprod = function () end -- 累计元素总乘积
dot = function () end --内积
cross = function () end --外积
-- lcm
-- gcd


module PreludeList (
    map, (++), filter, concat, concatMap, 
    head, last, tail, init, null, length, (!!), 
    foldl, foldl1, scanl, scanl1, foldr, foldr1, scanr, scanr1,
    iterate, repeat, replicate, cycle,
    take, drop, splitAt, takeWhile, dropWhile, span, break,
    lines, words, unlines, unwords, reverse, and, or,
    any, all, elem, notElem, lookup,
    sum, product, maximum, minimum, 
    zip, zip3, zipWith, zipWith3, unzip, unzip3)
  where




如何用matlab生成随机数函数
rand(1)
rand(n):生成0到1之间的n阶随机数方阵 rand(m,n):生成0到1之间的m×n的随机数矩阵 (现成的函数)
另外:
Matlab随机数生成函数
betarnd 贝塔分布的随机数生成器
binornd 二项分布的随机数生成器
chi2rnd 卡方分布的随机数生成器
exprnd 指数分布的随机数生成器
frnd f分布的随机数生成器
gamrnd 伽玛分布的随机数生成器
geornd 几何分布的随机数生成器
hygernd 超几何分布的随机数生成器
lognrnd 对数正态分布的随机数生成器
nbinrnd 负二项分布的随机数生成器
ncfrnd 非中心f分布的随机数生成器
nctrnd 非中心t分布的随机数生成器
ncx2rnd 非中心卡方分布的随机数生成器
normrnd 正态（高斯）分布的随机数生成器
poissrnd 泊松分布的随机数生成器
raylrnd 瑞利分布的随机数生成器
trnd 学生氏t分布的随机数生成器
unidrnd 离散均匀分布的随机数生成器
unifrnd 连续均匀分布的随机数生成器
weibrnd 威布尔分布的随机数生成器

向量、矩阵操作相关
函数	作用	备注
size(A)	返回矩阵的行数和列数	
size(C,1) / size(C,2)	返回矩阵的行数 / 列数	
length(A) 或 max(size(A))	返回长度最大的维度的长度	
numel(A)	返回矩阵元素的总个数	
sum(A)	返回矩阵所有元素的和	x = sum([1,2]) ⇨ x = 3
inv(A)	返回矩阵A的逆	
ndims(A)	返回矩阵A的维度	单个数值、向量和二维矩阵返回值均为2
iscolumn(x) / isrow(x)	判断是否为列向量 / 行向量	
isvector() / ismatrix()	判断是否为向量 / 矩阵	
isempty(x) / isscalar()	判断是否为空向量 /单个数值	
dot(a, b)	向量a点乘b，点积	
cross(a, b)	向量a叉乘b，叉乘	
repmat(A,m,n)	通过将A复制m行n列，返回m*n的矩阵	

解方程、符号表达式相关
函数	作用	备注
simplify(f)	化简公式f	
collect(f)	合并同类项	
expand(f)	展开公式	
horner(f)	将乘法嵌套	数值计算性能较好
factor(f)	因式分解	
pretty(f)	相对直观地显示公式	复杂的公式不行
[n,d] = numden(f)	通分，返回分母n，分子d	通分前会先自动化简表达式
]]