#ویراستار

ویراستار نوشته‌های فارسی شما را ویرایش می‌کند.

-----
## Specifications

###Virastar
* should add persian_cleanup method to String class
* should replace Arabic kaf with its Persian equivalent
* should replace Arabic Yeh with its Persian equivalent
* should replace Arabic numbers with their Persian equivalent
* should replace English numbers with their Persian equivalent
* should replace English comma and semicolon with their Persian equivalent
* should correct :;,.?! spacing (one space after and no space before)
* should replace English quotes with their Persian equivalent
* should replace three dots with ellipsis
* should convert ه ی to هٔ
* should replace double dash to ndash and triple dash to mdash
* should replace more than one space with just a single one
* should remove unnecessary zwnj chars that are succeeded/preceded by a space
* should fix spacing for () [] {}  “” «» (one space outside, no space inside)
* should replace English percent sign to its Persian equivalent
* should replace more that one line breaks with just one
* should not replace line breaks
* should put zwnj between word and prefix/suffix (ha haye* tar* tarin mi* nemi*)
* should not replace English numbers in English phrases
  
#### aggressive editing
  * should replace more than one ! or ? mark with just one
  * should remove all kashidas
  
-----
## Install
## Use
use with options turned off
inspired by


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Allen A. Bargi. See LICENSE for details.