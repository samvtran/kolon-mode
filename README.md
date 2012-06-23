kolon-mode
==========

kolon-mode is an html-mode derived major mode for Text::Xslate's Kolon syntax.

Features
--------
kolon-mode will stay (mostly) out of your way with manual tabbing.

Kolon docs on CPAN are accessible by default with C-c C-k

Todo
----
* Syntax highlighting for everything here: http://search.cpan.org/dist/Text-Xslate/lib/Text/Xslate/Syntax/Kolon.pm
* Commenting and uncommenting that works well, especially via comment-or-uncomment-region (i.e., C-c C-c)

Issues
------
Commenting/uncommenting via kolon-comment-region and kolon-uncomment-region can be a little too greedy, especially if you're selectively uncommenting, so don't rely on those functions just yet.

Please report any other issues (or feature requests!) here on github. Thanks!

License, et al.
---------------
This code is free software; you can redistribute it and/or modify it under the terms of the Artistic License 2.0. For details, see http://www.perlfoundation.org/artistic_license_2_0

Some code originally from https://github.com/yoshiki/tx-mode and https://bitbucket.org/lattenwald/.emacs.d/src/347b18c4f834/site-lisp/kolon-mode.el
