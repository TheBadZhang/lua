formAHuman = function (names)
    return setmetatable ({
        name = names,
        love = function (someone, another)
            io.write (string.format ("%s love %s\n", tostring (someone), tostring (another)))
        end
    }, {
        __tostring = function (self)
            return self.name
        end
    })
end

i   = formAHuman ("i")
you = formAHuman ("you")
me  = i

i:love (you)      --> i love you
you:love (me)     --> you love i
