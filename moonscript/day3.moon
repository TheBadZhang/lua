cmd = ""
args = {
    1, 2, 3, 4, 5, 6, 7, 8, 9
}
cmd ..= string.format (" %d,%d", args[i*2-1], args[i*2]) for i = 1, #argsLength//2