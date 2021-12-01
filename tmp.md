# Pure Functions in Programming 

> **Date:** 2021-11-08
> 
> **Summary:** An attempted overview on what is meant by pure functions
>
> **Keywords:** #pure #functions #functional #programming 

## Notes

The definition of pure is somewhat of a moving target.
Pure can mean many things and when applied to programming functions - even more so.
Based on querying the [Julia community](https://discourse.julialang.org/t/can-programming-in-julia-be-pure/71165), here was what I understood pure functions to be.

Based on Milewski's definition, "A pure function is one in which the same result is always produced with no side effects given the same input." [@milewskiCategoryTheoryProgrammers2019]
[Cameron Bieganek](https://github.com/CameronBieganek) explained how, in Julia specifically, you can write functions that are "probably" pure.
However, there is no real guarantee that a function is actually pure, because it depends on the various methods that have been implemented.
I like the notion of "probably" pure as it encapsulates a more pragmatic approach to the internals of a given language.
It lets one get away without having to necessarily be completely aware of all the internals when discussing purity.

Finally, pure functions are different from mathematical functions for the reason that mathematical functions map a value to another value.
Pure functions written in a programming language involve more than just a mapping. [@milewskiCategoryTheoryProgrammers2019]

## References:

