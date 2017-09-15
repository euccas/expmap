
# About

This is the notes I took when reading the book "125 Tips to Improve Your C Program". The notes are written in Chinese 中文.

# Chapter 1: Data Types 数据类型

## 2-1: char 类型变量的值应该限制在signed char与unsigned char的交集范围内

默认的char类型可以是signed char类型（取值范围 -127 ~ 127），也可以是unsigned char类型（取值范围 0 ~ 255），具体取决于编译器。为了使程序保持良好的可移植性，我们所声明的char类型变量的值应该限制在signed char与unsigned char的交集范围内，也就是 0 ~ 127. 例如，ASCII字符集中的字符都在这个范围内。

在一个把字符当做整数值的处理程序中，可以显式地把这类变量声明为signed char或者unsigned char，从而确保不同的机器中在字符是否为有符号值方面保持一致。



