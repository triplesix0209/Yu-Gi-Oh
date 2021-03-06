local IS_WIN = package.config:sub(1,1) == "\\"
if IS_WIN then os.execute("call :setESC > nul 2> nul") end
return {
  FG_BLACK = "\x1b[30m",
  FG_DRED = "\x1b[31m",
  FG_DGREEN = "\x1b[32m",
  FG_DYELLOW = "\x1b[33m",
  FG_DBLUE = "\x1b[34m",
  FG_PURPLE = "\x1b[35m",
  FG_AQUA = "\x1b[36m",
  FG_BGRAY = "\x1b[37m",
  FG_GRAY = "\x1b[90m",
  FG_RED = "\x1b[91m",
  FG_GREEN = "\x1b[92m",
  FG_YELLOW = "\x1b[93m",
  FG_BLUE = "\x1b[94m",
  FG_MAGENTA = "\x1b[95m",
  FG_CYAN = "\x1b[96m",
  FG_WHITE = "\x1b[97m",
  BG_BLACK = "\x1b[40m",
  BG_DRED = "\x1b[41m",
  BG_DGREEN = "\x1b[42m",
  BG_DYELLOW = "\x1b[43m",
  BG_DBLUE = "\x1b[44m",
  BG_PURPLE = "\x1b[45m",
  BG_AQUA = "\x1b[46m",
  BG_BGRAY = "\x1b[47m",
  BG_GRAY = "\x1b[100m",
  BG_RED = "\x1b[101m",
  BG_GREEN = "\x1b[102m",
  BG_YELLOW = "\x1b[103m",
  BG_BLUE = "\x1b[104m",
  BG_MAGENTA = "\x1b[105m",
  BG_CYAN = "\x1b[106m",
  BG_WHITE = "\x1b[107m",
  RESET = "\x1b[0m",
  BOLD = "\x1b[1m",
}
