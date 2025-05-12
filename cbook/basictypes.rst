Basic Types and Operators
*************************

C provides a standard, though minimal, set of basic data types.  Sometimes these are called "primitive" types. This chapter focuses on defining and showing examples of using the various types, including operators and expressions that can be used. More complex data structures can be built up from the basic types described below, as we will see in later chapters.

.. index::
   single: int; char; short; long; long long
   double: integer; types
   double: integer; char
   double: integer; int
   double: integer; short
   double: integer; long
   double: integer; long long
   double: integer; signed
   double: integer; unsigned

Integer types
=============

There are several integer types in C, differing primarily in their bit widths and thus the range of values they can accommodate.  Each integer type can also be *signed* or *unsigned*.  Signed integer types have a range :math:`-2^{width-1}..2^{width-1}-1`, and unsigned integers have a range :math:`0..2^{width}-1`.  There are five basic integer types:

``char``: One ASCII character
    The size of a ``char`` is almost always 8 bits, or 1 byte.  8 bits provides a signed range of -128..127 or an unsigned range is 0..255, which is enough to hold a single ASCII character [#f1]_. ``char`` is also required to be the "smallest addressable unit" for the machine --- each byte in memory has its own address.

``short``: A "small" integer
    A ``short`` is typically 16 bits, which provides a signed range of -32768..32767.  It is less common to use a ``short`` than a ``char``, ``int``, or something larger.

``int``: A "default" integer size
    An ``int`` is typically 32 bits (4 bytes), though it is only guaranteed to be at least 16 bits.  In typical microcontroller environments, an ``int`` is almost always 16 bits!  It is defined to be the "most comfortable" size for the computer architecture for which the compiler is targetted.  If you do not really care about the range for an integer variable, declare it ``int`` since that is likely to be an appropriate size which works well for that machine.

``long``: A large integer
    A least 32 bits.  On a 32-bit machine, it will usually be 32 bits, but on a 64 bit machine, it will usually be 64 bits.  
    
``long long``
    Modern C compilers also support ``long long`` as an integer type, which is a 64-bit integer.

The integer types can be preceded by the qualifier ``unsigned`` which disallows representing negative numbers and doubles the largest positive number representable. For example, a 16 bit implementation of short can store numbers in the range -32768..32767, while ``unsigned short`` can store 0..65535.

Although it may be tempting to use ``unsigned`` integer types in various situations, you should generally just use signed integers unless you really need an unsigned type.  Why?  The main reason is that it is common to write comparisons like ``x < 0``, but if ``x`` is unsigned, this expression *can never be true*!  A good compiler will warn you in such a situation, but it's best to avoid it to begin with.  So, unless you really need an unsigned type (e.g., for creating a bitfield), just use a signed type.  

.. sidebar:: Integers in Python and Java compared with C

   In Python, an integer can be arbitrarily large (negative or positive).  Any limit on the maximum size of an int is due to available memory, not restrictions related to processor architecture.  C is, of course, very much *unlike* that.  Issues of overflow and underflow come into play with C, and can be very tricky to detect and debug (a sidebar below discusses the overflow issue).

   Java contains (almost) the same basic integer types as in C.  It has ``short``, ``int``, and ``long``, which are 2 bytes, 4 bytes, and 8 bytes respectively (i.e., generally as they are in C).  Java also has a ``byte`` type, which is like ``char`` in C: a 1-byte integer.  A ``char`` in Java is **not** treated as an integer: it is a single Unicode character. Also, all integer types in Java are signed; unsigned integer types don't exist.


The ``sizeof`` keyword
----------------------

There is a keyword in C called ``sizeof`` that works like a function and returns the number of bytes occupied by a type or variable.  If there is ever a need to know the size of something, just use ``sizeof``.  Here is an example of how ``sizeof`` can be used to print out the sizes of the various integer types on any computer system.  Note that the ``%lu`` format placeholder in each of the format strings to ``printf`` means "unsigned long integer", which is what ``sizeof`` returns.  (As an exercise, change ``%lu`` to ``%d`` and recompile with :command:`clang`.  It will helpfully tell you that something is fishy with the ``printf`` call.)

.. literalinclude:: code/sizes.c
   :linenos:
   :language: c

..

When the above program is run on a 32-bit machine [#f2]_, the output is::

    A char is 1 bytes
    A short is 2 bytes
    An int is 4 bytes
    A long is 4 bytes
    A long long is 8 bytes

and when the program is run on a 64-bit machine, the output is::

    A char is 1 bytes
    A short is 2 bytes
    An int is 4 bytes
    A long is 8 bytes
    A long long is 8 bytes

Notice that the key difference above is that on a 64-bit platform, the ``long`` type is 8 bytes (64 bits), but only 4 bytes (32 bits) on a 32-bit platform.

.. sidebar:: Integer sizes and source code portability

    Instead of defining the exact sizes of the integer types, C defines lower bounds. This makes it easier to implement C compilers on a wide range of hardware. Unfortunately it occasionally leads to bugs where a program runs differently on a 32-bit machine than it runs on a 64-bit machine.  In particular, if you are designing a function that will be implemented on several different machines, it is best to explicitly specify the sizes of integral types.  If you ``#include <stdint.h>``, you can use types that explicitly indicate their bit-widths: ``int8_t``, ``int16_t``, ``int32_t``, and ``int64_t``.  There are also ``unsigned`` variants of these types: ``uint8_t``, ``uint16_t``, ``uint32_t``, and ``uint64_t``.   

    For some operating systems-related functions it is extremely important to be sure that a variable is *exactly* of a given size. These types come in handy in those situations, too.


.. _character-literals:

.. index:: 
   single: char
   double: char; literals
   double: char; null character

``char`` literals
-----------------

A ``char`` literal is written with single quotes (') like ``'A'`` or ``'z'``.  The char constant ``'A'`` is really just a synonym for the ordinary integer value 65, which is the ASCII value for uppercase 'A'. There are also special case ``char`` constants for certain characters, such as ``'\t'`` for tab, and ``'\n'`` for newline.

``'A'``
    Uppercase 'A' character

``'\n'``
    Newline character

``'\t'``
    Tab character

``'\0'``
    The "null" character --- integer value 0 (totally different from the char digit '0'!).  Remember that this is the special character used to terminal strings in C.

``'\012'``
    The character with value 12 in octal, which is decimal 10 (and corresponds to the newline character).  Octal representations of chars and integers shows up here and there, but is not especially common any more.

``0x20``
    The character with hexadecimal value 20, which is 32 in decimal (and corresponds to the space ``' '`` character).  Hexadecimal representations of chars and integers is fairly common in operating systems code.

``int`` literals
----------------

Numbers in the source code such as 234 default to type int. They may be followed by an 'L' (upper or lower case) to designate that the constant should be a long, such as 42L.  Similarly, an integer literal may be followed by 'LL' to indicate that it is of type ``long long``.  Adding a 'U' before 'L' or 'LL' can be used to specify that the value is unsigned, e.g., 42ULL is an ``unsigned long long`` type.

An integer constant can be written with a leading ``0b`` to indicate that it is expressed in binary (base 2).  For example ``0b00010000`` is the way to express the decimal number 16 in binary.  Similarly, a leading ``0x`` is used to indicate that a value is expressed in hexadecimal (base 16) --- ``0x10`` is way of expressing the decimal number 16.  Lastly, a constant may be written in octal (base 8) by preceding it with ``0`` (single zero) --- ``012`` is a way of expressing the decimal number 10.  A pitfall related to octal notation is that if you accidentally write a decimal value with a leading ``0``, the C compiler will interpret it as a base-8 value!

Type combination and promotion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The integral types may be mixed together in arithmetic expressions since they are all basically just integers.  That includes the ``char`` type (unlike Java, in which the ``byte`` type would need to be used to specify a single-byte integer). For example, ``char`` and ``int`` can be combined in arithmetic expressions such as (``'b' + 5``). How does the compiler deal with the different widths present in such an expression?  In such a case, the compiler "promotes" the smaller type (``char``) to be the same size as the larger type (``int``) before combining the values.  Promotions are determined at compile time based purely on the types of the values in the expressions. Promotions do not lose information --- they always convert from one type to a compatible, larger type to avoid losing information.  However, an assignment (or explicit cast) from a larger type to smaller type (e.g., assigning an ``int`` value to a ``short`` variable) may indeed lose information.  


.. sidebar:: Pitfall: ``int`` overflow

   .. index:: overflow, undefined values

   Remember that wonderful algorithm called "binary search"?  As an engineer at Google discovered some time ago, nearly all implementations of binary search are coded incorrectly [#f3]_.  The problem is usually on the line that computes the midpoint of an array, which often looks like this::

       int mid = (low + high) / 2;

   So what's the problem?  The issue is that for very large arrays, the expression ``low + high`` may exceed the size of a 32-bit integer, resulting in "overflow", and the value resulting from an overflow is *undefined*!  There is no guarantee that the high-order bit(s) will simply be truncated.  In C, the result is that the array index (``mid``) overflows to an undefined value, resulting in undefined and likely incorrect program behavior.  See the footnote reference ([#f2]_) for ways to fix the code in both Java and C/C++.


Floating point types
====================

``float``
    Single precision floating point number typical size: 32 bits (4 bytes)

``double``
    Double precision floating point number typical size: 64 bits (8 bytes)

``long double``
    A "quad-precision" floating point number.  128 bits on modern Linux and MacOS X machines (16 bytes).
    Possibly even bigger floating point number (somewhat obscure)

Constants in the source code such as 3.14 default to type ``double`` unless they are suffixed with an 'f' (``float``) or 'l' (``long double``). Single precision equates to about 6 digits of precision and double is about 15 digits of precision.  Most C programs use ``double`` for their computations, since the additional precision is usually well worth the additional 4 bytes of memory usage.  The only reason to use ``float`` is to save on memory consumption, but in normal user programs the tradeoff just isn't worth it.

The main thing to remember about floating point computations is that they are *inexact*. For example, what is the value of the following double expression?

.. code-block:: c

   (1.0/3.0 + 1.0/3.0 + 1.0/3.0) // is this equal to 1.0 exactly?

The sum may or may not be 1.0 exactly, and it may vary from one type of machine to another. For this reason, you should never compare floating numbers to each other for equality (``==``) --- use inequality (``<``) comparisons instead.  Realize that a correct C program run on different computers may produce slightly different outputs in the rightmost digits of its floating point computations.


.. index:: 
   double: types; bool
   single: bool
   single: stdbool.h 

Boolean type
============

In C prior to the C99 standard, there was no distinct Boolean type.  Instead, integer values were used to indicate true or false: zero (0) means false, and anything non-zero means true.  So, the following code:

.. code-block:: c

    int i = 0;
    while (i - 10) {

        // ...

    }

will execute until the variable ``i`` takes on the value 10 at which time the expression (i - 10) will become false (i.e., 0).  

In the C99 revision, a ``bool`` type was added to the language, but the vast majority of existing C code uses integers as quasi-Boolean values. In C99, you must add ``#include <stdbool.h>`` to your code to gain access to the ``bool`` type.  Using the C99 ``bool`` type, we could modify the above code to use a Boolean flag variable as follows:

.. code-block:: c

    #include <stdbool.h> 

    // ...

    int i = 0;
    bool done = false;
    while (!done) {

        // ...

        done = i - 10 == 0
    }


Basic syntactic elements
========================

.. index:: comments, /* */, //

Comments
--------

Comments in C are enclosed by slash/star pairs::

    /* .. comments .. */ 

which may cross multiple lines. C++ introduced a form of comment started by two slashes and extending to the end of the line::
    // comment until the line end

The ``//`` comment form is so handy that many C compilers now also support it, although it is not technically part of the C language.

Along with well-chosen function names, comments are an important part of well written code.  Comments should not just repeat what the code says.  Comments should describe what the code accomplishes which is much more interesting than a translation of what each statement does.  Comments should also narrate what is tricky or non-obvious about a section of code.

Variables
---------

As in most languages, a variable declaration reserves and names an area in memory at run time to hold a value of particular type.  Syntactically, C puts the type first followed by the name of the variable.  The following declares an ``int`` variable named "num" and the 2nd line stores the value 42 into num::

   int num = 42;

..

.. figure:: figures/numbox.*
   :align: center
   :alt: Memory box diagram

   A simple memory diagram for ``int num = 42;``.

A variable corresponds to an area of memory which can store a value of the given type. Making a drawing is an excellent way to think about the variables in a program. Draw each variable as box with the current value inside the box. This may seem like a "newbie" technique,  but when you are buried in some horribly complex programming problem, it will almost certainly help to draw things out as a way to think through the problem.  Embrace your inner noob.

.. sidebar:: Initial values in variables and *undefined* values

   .. index:: initialization, =, undefined values

   Unlike Java, **variables in C do not have their memory cleared or set in any way when they are allocated at run time**.  The value in a variable at the time it is declared is *undefined*: it is likely to be filled with what ever variable or value previously occupied that particular location in memory.  Or it might be zeroes.  Or it might be filled with fuzzy pink pandas.  The point is that you should never assume that a variable has any value stored in it at the time of declaration.  As a result, you should almost always *explicitly initialize variables* at the point of declaration.  A good compiler will (usually) tell you when you're playing with fire with respect to variable initialization, but it is good to get into the habit of explicitly initializing variables to avoid this pitfall.

   Undefined values in C come up in a few other places.  For example, although you'd like to *think* that the following assignment results in ``-128`` being stored in ``c``::
       
       char c = 127 + 1; 

   you cannot assume that it has any particular value since the result of an overflow is *undefined*.  Although the ``gcc`` has a special flag ``-fwrapv`` which forces overflow to result in two's complement wraparound, there's no guarantee of this behavior in the absence of the flag.  

   For lots of good discussion on undefined behaviors in C, see [Regehr]_ and [Lattner]_.


Names in C are *case sensitive* so "x" and "X" refer to different variables. Names can contain digits and underscores (_), but may not begin with a digit. Multiple variables can be declared after the type by separating them with commas.  C is a classical "compile time" language --- the names of the variables, their types, and their implementations are all flushed out by the compiler at compile time (as opposed to figuring such details out at run time like an interpreter).

.. index:: assignment, =

Assignment Operator ``=``
-------------------------

The assignment operator is the single equals sign (``=``):

.. code-block:: c

    i = 6;
    i = i + 1;

The assignment operator copies the value from its right hand side to the variable on its left hand side. The assignment also acts as an expression which returns the newly assigned value. Some programmers will use that feature to write things like the following:

.. code-block:: c

    y = x = 2 * x;  // double x, and also put x's new value in y

.. index:: truncation

Demotion on assignment
^^^^^^^^^^^^^^^^^^^^^^

The opposite of promotion, demotion moves a value from a type to a smaller type.  This is a situation to be avoided, because strictly speaking the result is *implementation and compiler-defined*.  In other words, there's no guarantee what will happen, and it may be different depending on the compiler used.  A common behavior is for any extra bits to be truncated, but you should not depend on that.  At least a good compiler (like ``clang``) will generate a compile time warning in this type of situation.  

The assignment of a floating point type to an integer type will *truncate* the fractional part of the number. The following code will set ``i`` to the value 3. This happens when assigning a floating point number to an integer or passing a floating point number to a function which takes an integer.  If the integer portion of a floating point number is too big to be represented in the integer being assigned to, the result is the ghastly *undefined* (see [#f4]_).  Most modern compilers will warn about implicit conversions like in the code below, but not all.

.. code-block:: c

    int i;
    i = 3.14159; // truncation of a float value to int


.. index:: +, -, /, *, %, arithmetic operations

Arithmetic operations
---------------------

C includes the usual binary and unary arithmetic operators.  It is good practice to use parentheses if there is ever any question or ambiguity surrounding order of operations.  The compiler will optimize the expression anyway, so as a programmer you should always strive for *maximum readability* rather than some perceived notion of what is efficient or not.  The operators are sensitive to the type of the operands. So division (``/``) with two integer arguments will do integer division.  If either argument is a float, it does floating point division. So (``6/4``) evaluates to 1 while (``6/4.0``) evaluates to 1.5 --- the 6 is promoted to 6.0 before the division.

========= ===============
Operator  Meaning
========= ===============
``+``     Addition
``-``     Subtraction
``/``     Division
``*``     Multiplication
``%``     Remainder (mod)
========= ===============

.. index:: 
   double: arithmetic operations; int versus float arithmetic
       
.. sidebar:: Pitfall: int vs. float Arithmetic


    Here's an example of the sort of code where ``int`` vs. ``float`` arithmetic can cause problems.  Suppose the following code is supposed to scale a homework score in the range 0..20 to be in the range 0..100::

        {
            int score;
            ...  // suppose score gets set in the range 0..20 somehow
            score = (score / 20) * 100;         // NO -- score/20 truncates to 0
            ...
        }

    Unfortunately, score will almost always be set to 0 for this code because the integer division in the expression (score/20) will be 0 for every value of score less than 20. The fix is to force the quotient to be computed as a floating point number::

        score = ((double)score / 20) * 100; // OK -- floating point division from cast
        score = (score / 20.0) * 100;       // OK -- floating point division from 20.0
        score = (int)(score / 20.0) * 100;  // NO -- the (int) truncates the floating
                                            // quotient back to 0

    Note that these problems are similar to ``int`` versus ``float`` problems in Python (version 2).  In Python 3, division using ``/`` *always* returns a floating point type, which eliminates the problem.  (If integer division is desired in Python 3, the ``//`` operator can be used.)


.. index:: ++, --, postincrement, preincrement, postdecrement, predecrement

Unary Increment Operators: ``++`` and ``--``
--------------------------------------------

The unary ``++`` and ``--`` operators increment or decrement the value in a variable. There are "pre" and "post" variants for both operators which do slightly different things (explained below).

========= ==========================
Operator  Meaning
========= ==========================
``var++`` increment "post" variant
``++var`` increment "pre" variant
``var--`` decrement "post" variant
``--var`` decrement "pre" variant
========= ==========================

An example using post increment/decrement:

.. code-block:: c

    int i = 42;
    i++;     // increment on i
    // i is now 43
    i--;     // decrement on i
    // i is now 42


Pre- and post- variations
^^^^^^^^^^^^^^^^^^^^^^^^^

The pre-/post- variation has to do with nesting a variable with the increment or decrement operator inside an expression --- should the entire expression represent the value of the variable *before* or *after* the change?  These operators can be confusing to read in code and are often best avoided, but here is an example:

.. code-block:: c

    int i = 42;
    int j;
    j = (i++ + 10);
    // i is now 43
    // j is now 52 (NOT 53)
    j = (++i + 10)
    // i is now 44
    // j is now 54


.. index:: relational operators, ==, !=, <, >, <=, >=

Relational Operators
--------------------
These operate on integer or floating point values and return a 0 or 1 boolean value. 

========= ==========================
Operator  Meaning
========= ==========================
``==``    Equal
``!=``    Not Equal
``>``     Greater Than
``<``     Less Than
``>=``    Greater or Equal
``<=``    Less or Equal
========= ==========================

To see if ``x`` equals three, write something like ``if (x==3) ...``.

.. sidebar:: pitfall: ``= != ==``

    An absolutely classic pitfall is to write assignment (``=``) when you mean comparison (``==``). This would not be such a problem, except the incorrect assignment version compiles fine because the compiler assumes you mean to use the value returned by the assignment.  This is rarely what you want: ``if (x=3) ...``.

    This does not test if ``x`` is 3!  It sets ``x`` to the value 3, and then returns the 3 to the ``if statement`` for testing.  3 is not 0, so it counts as "true" every time.  

    Some compilers will emit warnings for these types of expressions, but a better technique that many C programmers use to avoid such problems is to put the literal value on the *left hand side* of the expression as in: ``if (3=x)...``

    In this case, a compile-time error would result (you can't assign anything to a literal).  

.. index:: logical operators, !, &&, ||

Logical Operators
-----------------

The value 0 is false, anything else is true. The operators evaluate left to right and stop as soon as the truth or falsity of the expression can be deduced. (Such operators are called "short circuiting") In ANSI C, these are furthermore guaranteed to use 1 to represent true, and not just some random non-zero bit pattern. However, there are many C programs out there which use values other than 1 for true (non-zero pointers for example), so when programming, do not assume that a true boolean is necessarily 1 exactly.

========= ==========================
Operator  Meaning
========= ==========================
``!``     Boolean not (unary)
``&&``    Boolean and
``||``    Boolean or
========= ==========================

.. index:: bitwise operations, ~, &, |, ^, <<, >>

Bitwise Operators
-----------------
C includes operators to manipulate memory at the bit level. This is useful for writing low-level hardware or operating system code where the ordinary abstractions of numbers, characters, pointers, etc... are insufficient.  Using bitwise operators is very common in microcontroller programming environments and in some "systems" software.

Bit manipulation code tends to be less "portable". Code is "portable" if with no programmer intervention it compiles and runs correctly on different types of processors. The bitwise operations are typically used with unsigned types. In particular, the shift operations are guaranteed to shift zeroes into the newly vacated positions when used on unsigned values.

========= =============================================================
Operator  Meaning
========= =============================================================
``~``     Bitwise NOT (unary) – flip 0 to 1 and 1 to 0 throughout
``&``     Bitwise AND
``|``     Bitwise OR
``^``     Bitwise XOR (Exclusive OR)
``>>``    Right Shift by right hand side (RHS) (divide by power of 2)
``<<``    Left Shift by RHS (multiply by power of 2)
========= =============================================================

Do not confuse the bitwise operators with the logical operators. The bitwise connectives are one character wide (``&``, ``|``) while the boolean connectives are two characters wide (``&&``, ``||``). The bitwise operators have higher precedence than the boolean operators.  The compiler will not typically help you out with a type error if you use ``&`` when you meant ``&&``.  

Bitwise operation example
^^^^^^^^^^^^^^^^^^^^^^^^^

Say we want to set certain bits in a byte.  In particular, say that (starting at 1, on the far right) we want to set the 2nd and 5th bits so that the byte is equal to ``0b00010010`` (hex 0x12).  The following program would do that:

.. literalinclude:: code/enumbits.c
   :language: c
   :linenos:

Lines 3 and 4 in the code segment above create two *macro substitutions* (``#define`` is a C preprocessor directive).  During the preprocessing phase of compilation, anywhere ``SECOND`` appears will be replaced with the value ``1``; similarly for the text ``FIFTH``.  So why is ``SECOND`` defined as 1 and not 2 (and similar for ``FIFTH``)?  We will come to that shortly.

In ``main``, the variable ``flags`` is assigned all zeroes (notice the binary literal) on line 7, then on line 8 we assign to ``flags`` by *shifting* a 1 ``SECOND`` places to the left.  Since ``SECOND`` is assigned 1, we shift ``0b00000001`` one place to the left, giving ``0b00000010``.  So perhaps that's an answer to the question above: the value for ``SECOND`` and ``FIFTH`` define *the number of positions to shift a 1 to the left*.  On line 9, we do the same thing for ``FIFTH`` but we also perform a bitwise OR with the existing value of ``flags``.  The bitwise OR operation provides a way to combine (or *union*) two or more values together.  For example ``0x01 | 0xF0`` is ``0xF1``.  

Although not shown in the example above, if we wanted to check whether the fifth bit in a byte (again, starting at 1 counting from the right), we might use the following expression: ``fifth_is_set = flags & (1<<FIFTH);``.  Doing a bitwise AND is referred to as *masking* since ``AND``ing anything with ``0b00010000`` will mask (unset) any bits that may have been set other than the fifth bit.  Similarly, if we wanted to *unset* a particular bit but leave all others unchanged, we could create a mask like this: ``~(1<<FIFTH)`` which has a bit-level representation of ``0b11101111``.  Performing an ``AND`` with that mask and any byte would leave all bits except the 5th as-is while setting the 5th to 0.


.. index:: assignment, +=, -=, *=, /=

Other Assignment Operators
--------------------------

In addition to the plain ``=`` operator, C includes many shorthand operators which represents variations on the basic ``=``. For example ``+=`` adds the right hand side to the left hand side. ``x = x + 10`` can be reduced to ``x += 10``.   Note that these operators are much like similar operators in other languages, like Python and Java.
Here is the list of assignment shorthand operators:

============== =============================================================
Operator       Meaning
============== =============================================================
``+=, -=``     Increment or decrement by RHS
``*=, /=``     Multiply or divide by RHS
``%=``         Mod by RHS
``>>=``        Bitwise right shift by RHS (divide by power of 2)
``<<=``        Bitwise left shift by RHS (multiply by power of 2)
``&=, |=, ^=`` Bitwise and, or, xor by RHS
============== =============================================================


.. rubric:: Exercises

The theme for the following exercises is *dates and times*, which often involve lots of interesting calculations (sometimes using truncating integer arithmetic, sometimes using modular arithmetic, sometimes both), and thus good opportunities to use various types of arithmetic operations, comparisons, and assignments.

#. Write a C program that asks for a year and prints whether the year is a leap year.  See the Wikipedia page on `leap year <https://en.wikipedia.org/wiki/Leap_year>`_ for how to test whether a given year is a leap year.  Study the first program in the :ref:`tutorial <tutorial>` chapter for how to collect a value from keyboard input, and use the ``atoi`` function to convert a C string (char array) value to an integer.

#. Write a program that asks for year, month, and day values and compute the corresponding Julian Day value.  See the Wikipedia page on `Julian Day <https://en.wikipedia.org/wiki/Julian_day>`_ for an algorithm for doing that.  (See specifically the expression titled "Converting Gregorian calendar date to Julian Day Number".)

#. Extend the previous program to compute the Julian date value (a floating point value), using the computation described in "Finding Julian date given Julian day number and time of day" on the Wikipedia page linked in the previous problem.  Note that you'll need to additionally ask for the current hour, minute and second from the keyboard.

#. Write a program that asks for a year value and computes and prints the month and day of Easter in that year.  The Wikipedia page on `Computus <https://en.wikipedia.org/wiki/Computus>`_ provides more than one algorithm for doing so.  Try using the "Anonymous Gregorian algorithm" or the "Gauss algorithm", which is a personal favorite.  

.. #. Last one: write a program that asks for a year in the Gregorian calendar (i.e., the calendar typically used in the Western world), and compute and print the date (month and day) of the first day of the Jewish holiday Hanukkah.  Although the first day of Hanukkah is always the 25th day of Kislev according to the Hebrew calendar, it can vary between November and December in the Gregorian calendar.  You'll need to first compute 


.. rubric:: References

.. [Regehr] J. Regehr.  A Guide to Undefined Behavior in C and C++, Part 1.  https://blog.regehr.org/archives/213

.. [Lattner]  C. Lattner.  What Every C Programmer Should Know About Undefined Behavior #1/3.  http://blog.llvm.org/2011/05/what-every-c-programmer-should-know.html


.. rubric:: Footnotes

.. [#f1] Non-ASCII characters can also be represented in C, such as characters in Cyrillic, Hangul, Simplified Chinese, and Emoji, but not in a single 8-bit data type.  See http://en.wikipedia.org/wiki/Wide_character for some information on data types to support these character types.

.. [#f2] To find out whether your machine is 64 bit or 32 bit, you can do the following.  On Linux, just type ``uname -p`` at a terminal.  If the output is ``i386``, you have a 32-bit OS.  If it is ``x86_64``, it is 64 bits.  All recent versions of MacOS X are 64 bits, so unless you're running something extremely old, you've got 64.

.. [#f3] https://ai.googleblog.com/2006/06/extra-extra-read-all-about-it-nearly.html

.. [#f4] See the C11 standard: https://port70.net/~nsz/c/c11/
