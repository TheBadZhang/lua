sqlite = {}


-- 仅支持 读 和 写 操作 flag，数据库不存在时自动创建
sqlite.READONLY  = 0x001
sqlite.WRIETONLY = 0x010

sqlite.open = function (fileName)

	assert (fileName, "傻*么你，文件名都不给")

	local __database = {
		dbName = fileName,
		close  = sqlite.close,
		create = sqlite.create,
		drop   = sqlite.drop,
		insert = sqlite.insert,
		select = sqlite.select,
		update = sqlite.update,
		delete = sqlite.delete,
		sql    = sqlite.sql
	}

	local __ret = os.execute (string.format ([[sqlite %s '']], fileName))

	if __ret then
		return __database
	else
		return nil, "出了点差错，你自己解决吧"
	end
end

sqlite.close = function (self)
	self = nil
end
--
sqlite.create = function (self, _tableName, _tableContents)
	local _ret = os.execute (string.format ([[sqlite %s "CREATE TABLE %s(%s)"]], self.dbName, _tableName, _tableContents))
	assert (_ret, io.popen (string.format ([[sqlite %s "CREATE TABLE %s(%s)"]], self.dbName, _tableName, _tableContents)):read('*a'))
end
--
sqlite.drop = function (self, _tableName)
	local _ret = os.execute (string.format ([[sqlite %s "DROP TABLE %s"]], self.dbName, _tableName))
	assert (_ret, "删除表的时候出错了！可能这个表不存在？")
end
--
sqlite.insert = function (self, _tableName, ...)
	local _value = select (1, ...)
	local _num = select ("#", ...)
	local v
	for i = 2, _num, 1 do
		v = select (i, ...)
		if type (v) == "string" then v = '\\\"'..v:gsub ('"', "\\\"")..'\\\"' end
		_value = _value..','..v
	end

	-- print (_value)
	local _cmd = string.format ([[sqlite %s "INSERT INTO %s VALUES (%s)"]], self.dbName, _tableName, _value)
	-- print (_cmd)
	local _ret = os.execute (_cmd)
	assert (_ret, io.popen (_cmd):read("*a"))
end

sqlite.select = function (self, _table, _SQL)
	local _cmd = string.format ([[sqlite %s "SELECT %s FROM %s"]], self.dbName, _SQL, _table)
	local _ret = os.execute (_cmd)
	-- assert (_ret, "查询数据库错误！请再检查一遍你的 SQL 语句")

end

sqlite.delete = function (self, _table, _WHERE, ...)

	assert (_table, "主人，表名记得要填字符串呀")
	assert (_WHERE, "主人，你还没告诉我要删哪里呢")

	local _value
	local flag = true
	for k, v in pairs ({...}) do
		if type (v) == string then
			v = k..'=\\\"'..v:gsub ('"', "\\\"")..'\\\" '
		else
			v = k..'='..v
		end
		if flag then
			_value = _value..v
		else
			_value = _value..","..v
		end
	end

	local _cmd = string.format ([[sqlite %s "UPDATE %s SET %s WHERE %s"]], self.dbName, _table, _value, _WHERE)

	local _ret = os.execute (_cmd)
	assert (_ret, "主人，语句执行好像有错呢")
end

sqlite.delete = function (self, _table, _WHERE)

	assert (_table, "主人，表名记得要填字符串呀")
	assert (_WHERE, "主人，你还没告诉我要删哪里呢")

	local _cmd = string.format ([[sqlite %s "DELETE FROM %s WHRER %s"]], self.dbName, _table, _WHERE)

	local _ret = os.execute (_cmd)
	assert (_ret, "主人，语句执行好像有错呢")
end

sqlite.sql = function (self, _sql)
	assert (_sql, "对不起，您还没有输入任何 SQL 语句")
	local _ret = os.execute (string.format ([[sqlite %s "%s"]], self.dbName, _sql:gsub('"','\\\"')))
	assert (_ret, "SQL 语句执行错误！请仔细检查")
end