# GDB利器

* Created since: 2009-9-25 *


gdb是GNU的调试工具（GNU Debugger）。

## GDB的特点
- 具有交互性
- 工作在字符模式
- X windows下的xxgdb具有前端图形界面

## GDB可以做的事情
- 设置断点（语句、函数、breakpoint, watchpoint等）
- 监视程序变量的值（print）
- 程序的单步执行（next, until-循环）
- 修改变量的值（set）

## 使用GDB
- 要使用gdb调试程序，必须在编译时加入gdb信息，方法是使用g++/gcc的-g选项，对源文件进行编译。
- makefile定义：CFLAGS=-g

### 启动gdb调试一个程序

```
gdb myprogram
```

### 查看gdb所有的命令

```
gdb help
```

### 查看某类命令的详细清单

```
gdb help 分类名
```

### gdb命令的分类
- aliases: 命令别名
- breakpoint: 断点定义
- data: 数据查看
- files: 指定并查看文件
- internals: 维护命令
- running: 程序执行
- stack: 调用栈查看
- status: 状态查看
- tracepoints: 跟踪程序执行。

## GDB常用命令

### 开始调试
```
gdb [ exe name ]
```

或

```
gdb
file [ exe name ] ：装载指定的可执行文件进行调试
```

run ：开始执行

run [arg1] [arg2] [arg3] ：输入命令行参数，一次输入后，本次gdb中如果重新run，仍保留第一次输入的命令行参数

set args ：修改发送给程序的参数

show args ：查看命令缺省参数的列表

quit : 退出gdb

### 断点break
break [line number] ：在指定的行上设置断点
默认是当前文件，也可以指定文件
break [file name] [line number] ：在指定文件的指定行设置断点
break [function]
break main ：在main函数处设置断点

常常在打开gdb之后先用break main，然后run
程序在main函数处中止，这时再ls查看代码

break line-or-function if condition 如果condition为真，程序到达指定行或函数时停止
break routine-name 在指定例程的入口处设置断点

设置条件断点，使用break if
(gdb) break 46 if testsize==100

查看已经设置的断点：
info break
所有断点都会有编号
(gdb) info b
Num Type Disp Enb Address What
1 breakpoint keep y 0200028bc in init_random at mytest.cpp:122

可以激活或休眠某个断点
disable b 5 //休眠第5个断点
enable b 3 //激活第3个断点
反复调试某段代码时常用到dis, ena断点的操作。
断点是否激活，也可以在info break的信息中看到

删除断点
delete breakpoint 1 // 删除编号为1的断点
delete breakpoint // 删除所有断点

清除原文件中某一行代码上的所有断点
clean [ line number]

从断点继续运行：continue
在断点命中时列出将要执行的命令：commands

watch 在程序中设置一个数据断点，作为监测点。一旦变量值发生变化，立刻中止程序运行。
watch [expr]


### 执行命令
list 显示源码
continue 执行正在调试的命令，直到遇到断点，或错误退出，或正常结束。
next 单步执行，执行下一条语句，不进入调用函数的内部。
step 单步执行，进入调用函数的内部。
finish 如果用s进入了某函数，想要退出该函数返回到主程序，使用命令finish
until [line number] 一直执行到某行，可用于跳过循环
jump 在源程序中另一点开始运行
kill 异常终止在当前运行命令

### 查看数据
print EXPR 显示表达式EXPR的值
print 可以显示被调试的语言中任何有效的表达式，包括变量、对函数的调用、数据结构等复杂对象。
print 也可以用来赋值

display EXPR 每次程序停止后显示表达式的值。表达式由程序定义的变量组成。

whatis : 显示某个变量的类型
(gdb) whatis p
type = int*

ptype: 比whatis的功能更强，可以显示结构体的定义，类的定义等

set [variable] : 修改某个变量的值

人为数组：显示存储块（数组节或动态分配的存储区）内容的方法。
语法是 base@length，查看变量base后面的length个变量内容。

//例如查看h@10，内存中在变量h后面的10个整数
(gdb)print h@10
$13=(-1,345,23,-234,0,0,0,98,345,10)

### 查看代码
list 显示当前行以后的源代码
search text ：显示在当前文件中包含text串的下一行
reverse-search text : 显示包含text的前一行

### 查看出错信息
where：查看程序出错的地方
bt (backtrace) : 调用栈中记录的错误信息，为堆栈提供向后追踪功能。bt命令会产生一张列表，包含从最近的过程开始的所有有效过程和调用这些过程的参数。

### 函数调用
call [function name] 调用和执行函数
(gdb) call gencfg(123,a)
(gdb) call printf(“abcd”)
$1=4 //$1保存历史变量值

finish 结束执行当前函数，显示其返回值（如果有）
down 下移栈帧，使下一个函数成为当前函数（在s中有用）
up 上移栈帧，使上一个函数成为当前函数（在s中有用）

### 调用unix shell
shell命令 启动unix shell
Ctrl+d 退出unix shell，返回到gdb

### 机器语言工具
一组专用的gdb变量用来检查和修改计算机的通用寄存器。
gdb提供4个寄存器的标准名字：
$pc ： 程序计数器 
$fp ： 帧指针（当前堆栈帧） 
$sp ： 栈指针 
$ps ： 处理器状态 

### 信号处理
handle命令可以控制信号的处理，两个参数：
(1) 信号名
(2) 接收到信号后的行为

nonstop : 接收到信号时，不要将它发送给程序，也不要停止程序
stop : 接收到信号时停止程序执行，从而允许程序调试
print : 接收到信号时显示一条小时
noprint : 接收到信号时不要显示消息（隐含着不停止程序运行）
pass : 将信号发送给程序
nopass : 停止程序运行，但不要将信号发送给程序

// 截获SIGPIPE信号，防止正在调试的程序接收到该信号
// 并且只要该信号到达，就要求程序停止，并发出通知
(gdb) handle SIGPIPE stop print

### 其它
set history expansion on ：允许使用历史命令

## 在Emacs中使用gdb
C+x gdb 即可在emacs命令行中调用gdb
