# C++ Notes 

Created since: 2017-7-24 by Euccas

## Contents

* unsigned int types 

## unsigned int types

### unsigned int

```unsigned int``` is an unsigned integer and the compiler decides its bits. The C++ standard requires the minimum range is 0-65535, which is uint16.

Like ```int```, ```unsigned int``` typically is an integer that is fast to manipulate for the current architecture (normally it fits into a register), so it's to be used when a "normal", fast integer is required.

```unsigned``` and ```unsigned int``` are synonymous.

### uint{bit}_t

The uint{bit}_t types are used when you need an exact-width ingeter, such as writing to hardware registers.

- uint64_t: 64bit unsigned integer. Range: 0 - 0xFFFFFFFFFFFFFFFF (2^64-1 18,446,744,073,709, 551,615)
- uint32_t: 32bit unsigned integer. Range: 0 - 0xFFFFFFFF (2^32-1 4,294,967,295)
- uint16_t: 16bit unsigned integer. Range: 0 - 0xFFFF (2^16-1 65,535)
- uint8_t: 8bit unsigned integer. Range: 0 - 0xFF (2^8-1 255)

```unsigned int``` types are cross-platform, but ```uint{bit}_t``` types are not.
