Introduction: The C Language
****************************

C is a professional programmer's language.  It is a *systems implementation language*, and was originally designed by Dennis Ritchie at Bell Labs in the 1960s.  Prior to the development of C, most operating systems were developed in assembly language [#f1]_\ !  The C language (and its predecessor, the B language) were designed to provide some level of portability of the operating system source code (i.e., it could be recompiled for a new processor architecture), while still allowing a programmer to manipulate low-level resources such as memory and I/O devices.  If you are interested in some the history behind the development of UNIX, see [Evolution]_ by Dennis Ritchie.

C was designed to get in one's way as little as possible.  It is a high-level programming language (i.e., not assembly), but is quite minimal in design and scope.  Its minimalism can make it feel difficult to work with.  Its syntax is somewhat terse, and its runtime environment does not contain the sort of "guardrails" available in other programming languages such as Python or Java.  There are no classes, objects, or methods, only functions.  C's type system and error checks exist only at compile-time.  The compiled code runs with no safety checks for bad type casts, bad array indexes, or bad memory accesses.  There is no garbage collector to manage memory as in Java and Python.  Instead, the programmer must manage heap memory manually.  All this makes C fast but fragile.

Some languages, like Python, are forgiving.  The programmer needs only a basic sense of how things work.  Errors in the code are flagged by the compile-time or run-time system, and a programmer can muddle through and eventually fix things up to work correctly.  The C language is not like that.  The C programming model assumes that the programmer knows exactly what he or she wants to do, and how to use the language constructs to achieve that goal. The language lets the expert programmer express what they want in the minimum time by staying out of their way.

As a result, C can be hard to work with at first.  A feature can work fine in one context, but crash in another. The programmer needs to understand how the features work and use them correctly.  On the other hand, the number of features is pretty small, and the simplicity of C has a certain beauty to it.  What seem like limitations at first can feel liberating as you gain more experience with the language.

As you start to learn and use C, a good piece of advice is to just *be careful*.  Don't write code that you don't understand.  Debugging can be challenging in C, and the language is unforgiving.  Create a mental (or real) picture of how your program is using memory.  That's good advice for writing code in any language, but in C it is critical.

.. sidebar:: C's popularity

   Although introduced over 40 years ago, C is one of the most popular programming languages in use today [#f2]_\ .Moreover, C's syntax has highly influenced the design of other programming languages (Java syntax is largely based on C).  All modern operating systems today are written largely in C (or a combination of C and C++) due to the fact that low-level resources (memory and I/O devices) can be directly manipulated with a minimum of assembly.  


This book is intended to be a short, though mostly complete introduction to the C programming language.  A (generally) C99-capable compiler assumed since the book introduces various features from the C99 revision of the language [C99]_.
For an in-depth treatment of the language and language features, there are two other books to recommend.  The mostly widely used C book is one simply referred to as "K&R", written by the designers of the language, Brian Kernighan and Dennis Ritchie [KR]_\ .  It is an excellent (though somewhat dated) reference to the language.  Another excellent, if lengthy, introduction to C can be found in Stephen Prata's *C Primer Plus* [CPP]_\ .  It contains a more modern treatment of C than K&R, with lots of detail and exercises.  

.. rubric:: References

.. [KR] B. Kernighan and D. Ritchie.  *The C Programming Language, 2nd ed.*.  Prentice-Hall, 1988.  https://en.wikipedia.org/wiki/The_C_Programming_Language

.. [CPP] S. Prata.  *C Primer Plus (6th ed.)*.  S. Prata.  SAMS Publishing (2014).

.. [C99] The home of C standards documents can be found here: http://www.open-std.org/jtc1/sc22/wg14/www/projects#9899.  Specific new features in C99 are detailed (http://www.open-std.org/jtc1/sc22/wg14/www/newinc9x.htm), and the full language standard is also available (http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf).  Although there is an even more recent standard (C11), we largely focus on C99 (and earlier) features in this text.

.. [Evolution] D. Ritchie. *The Evolution of the Unix Time-sharing System*, AT&T Bell Laboratories Technical Journal 63 No. 6 Part 2, October 1984, pp. 1577-93.  Available at: http://cm.bell-labs.co/who/dmr/hist.pdf

.. rubric:: Footnotes

.. [#f1] Take a moment and consider how difficult it must have been to develop a new OS!

.. [#f2] See https://www.tiobe.com/tiobe-index/ for one ranking of programming language popularity.
