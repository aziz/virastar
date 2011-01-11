require "rubygems"
require "diffy"

# TODO test in ruby 1.9
# TODO do not replace /n
require 'jcode'
$KCODE = 'u'

module Virastar

  # TODO: make a class and then extend string with another module that initialize that class

  def persian_cleanup
    # replace double dash to ndash and triple dash to mdash
    self.gsub!(/-{3}/,'—')
    self.gsub!(/-{2}/,'–')

    # replace three dots with ellipsis
    self.gsub!(/\s*\.{3,}/,'…')

    # replace English qoutes with their Persian equivalent
    self.gsub!(/(["'`]+)(.+)(\1)/, '«\2»')

    # should convert ه ی to ه
    self.gsub!(/(\S)(ه[\s‌]+ی)(\s)/, '\1هٔ\3')

    # should fix spacing for () [] {}  “” «» `` '' ""
    self.gsub!(/\s*(\()\s*([^}]+)\s*(\))\s*/,' \1\2\3 ')

    # character replacement
    bad  = "1234567890,;كي٠١٢٣٤٥٦٧٨٩"
    good = "۱۲۳۴۵۶۷۸۹۰،؛کی۰۱۲۳۴۵۶۷۸۹"
    self.tr!(bad,good)


    # == Aggressive Editing ===========================================

    # replace more than one ! or ? mark with just one
    self.gsub!(/(!){2,}/, '\1')
    self.gsub!(/(؟){2,}/, '\1')

    # should remove all kashida
    self.gsub!(/ـ+/,"")

    # =================================================================

    # : ; , . ! ? and their persian equivalents should have one space after and no space before
    self.gsub!(/\s*([:;,؛،.؟!]{1})\s*/, '\1 ')

    # should replace more than one space with just a single one
    self.gsub!(/[ ]+/,' ')

    # remove spaces, tabs, and new lines from the beginning and enf of file
    self.strip!

    self
  end
end

String.send(:include, Virastar)