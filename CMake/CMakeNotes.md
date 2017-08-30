# CMake in My Practice

*Created since: 2014-8-22*
*by Euccas*

## CMake特点
1. open source
2. 跨平台，并可生成native编译配置文件，在Linux/Unix平台，生成makefile，在MacOS平台，可以生成xcode，在Windows平台，可以生成MSVC的工程文件。

## CMake Usages

### Variable in CMake

variable: ${} -- 引用变量

Exception: IF

```IF A```, not ```IF ${A}```

### Common CMake Commands

#### PROJECT

```
PROJECT(projectname [CXX] [C] [Java])
```

pre-defined variable by cmake:
* PROJECT_BINARY_DIR
* PROJECT_SOURCE_DIR

#### SET

```
SET(VAR [VALUE] [CACHE TYPE DOCSTRING [FORCE]])
SET(SRC_LIST main.c)
SET(SRC_LIST main.c t1.c t2.c)
```

改变保存binary的目录:

```
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)
```

应该把这两条指令写在工程的CMakeLists.txt还是src目录下的CMakeLists.txt? 把握一个简单的原则，在哪里ADD_EXECUTABLE或ADD_LIBRARY，如果需要改变目标存放路径，就在哪里加入上述的定义。

#### ADD_EXECUTABLE

```
ADD_EXECUTABLE(hello ${SRC_LIST})
```

#### ADD_LIBRARY

```
ADD_LIBRARY(libname [SHARED|STATIC|MODULE] [EXCLUDE_FROM_ALL] source1 source2 ... sourceN)
```

不需要写全libhello.so，只需要填写hello即可，cmake系统会自动为你生成 libhello.X

类型有三种:
- SHARED，动态库
- STATIC，静态库
- MODULE，在使用dyld的系统有效，如果不支持dyld，则被当作SHARED对待。

#### MESSAGE

```
MESSAGE(<mode> "variable is:" ${myVariable})
MESSAGE(STATUS "variable is:" ${myVariable})
```

The ```mode``` keyword determines the type of message:

```
(none)	= Important information
STATUS	= Incidental information
WARNING	= CMake Warning, continue processing
AUTHOR_WARNING = CMake Warning (dev), continue processing
SEND_ERROR     = CMake Error, continue processing,
                 but skip generation
FATAL_ERROR    = CMake Error, stop processing and generation
```

STATUS messages are displayed on **stdout**. All other message types are displayed on **stderr**.

Mute messages:

```
SET(CLEAR_MESSAGE 1)
```

#### ADD_COMPILE_OPTIONS, ADD_DEFINITIONS

ADD_COMPILE_OPTIONS
- Add the options to all targets within the directory and its sub-directories. It's handy if you have a library in a directory and you want to add options to all the targets related to the library, but unrelated to all other targets.
- The options are added for the compiler. 

ADD_DEFINITIONS
- Add pre-processor definitions, such as -DFOO, -DNDEBUG
- This command can also be used to add compiler options, although CMake doesn't recommend it

Example: use CMake commands

```
ADD_COMPILE_OPTIONS(-O3 -s -DNDEBUG)
```

or

```
ADD_COMPILE_OPTIONS(-O3 -s)
ADD_DEFINITIONS(-DNDEBUG)
```

Generated flags.make file:

```
C_FLAGS =  -O3 -s
C_DEFINES =  -DNDEBUG
```

References:
- [Difference between add-compile-options and set CMAKE-CXX-FLAGS](https://stackoverflow.com/questions/39501481/difference-between-add-compile-options-and-setcmake-cxx-flags)

