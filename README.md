# Utalisp
Utalisp is a Lisp(Scheme) interpreter with user-defined function lookups in its Repl.
It started out as a port of Tiddlylisp to Ruby. (TiddlyLisp: http://www.michaelnielsen.org/ddi/lisp-as-the-maxwells-equations-of-software/)

## How it works
(WIP)
It currenty saves user-defined function to another file, whenever one calls 'define'.

## How to use it
In your terminal, go to ruby directory. There, type `ruby repl.rb` to run REPL environment.

Right now, it detects the end of function by a blank line, so make sure to provide a blank line when you finish typing in REPL.

## Why I'm making this
Having enjoyed reading through [The Little Schemer](http://mitpress.mit.edu/books/little-schemer), I wanted to exercise my knowledge on re-reading the book with my interpreter.

During this process, I felt you're motivated more when there's a constant reminder of your progress. So, that's when I decided to tweak this.
