# -*- encoding: utf-8 -*-
if RUBY_VERSION.to_f < 1.9
  require 'jcode'
  $KCODE = 'u'
end

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

    # remove unnecessary zwnj char that are succeeded/preceded by a space
    self.gsub!(/\s+‌|‌\s+/,' ')

    # should fix spacing for () [] {}  “” «»
    self.gsub!(/\s*(\()\s*([^)]+?)\s*?(\))\s*/,' \1\2\3 ')
    self.gsub!(/\s*(\[)\s*([^)]+?)\s*?(\])\s*/,' \1\2\3 ')
    self.gsub!(/\s*(\{)\s*([^)]+?)\s*?(\})\s*/,' \1\2\3 ')
    self.gsub!(/\s*(“)\s*([^)]+?)\s*?(”)\s*/,' \1\2\3 ')
    self.gsub!(/\s*(«)\s*([^)]+?)\s*?(»)\s*/,' \1\2\3 ')

    # character replacement
    bad  = "1234567890,;كي٠١٢٣٤٥٦٧٨٩%"
    good = "۱۲۳۴۵۶۷۸۹۰،؛کی۰۱۲۳۴۵۶۷۸۹٪"
    self.tr!(bad,good)
    
    good_en = "1234567890"
    bad_fa  = "۱۲۳۴۵۶۷۸۹۰"
    # should not replace exnglish chars in english phrases
    self.gsub!(/([a-z\-_]+[۰-۹]+|[۰-۹]+[a-z\-_]+)/i) do |s|
      s.tr(bad_fa,good_en)
    end

    # -- Aggressive Editing ------------------------------------------

    # replace more than one ! or ? mark with just one
    self.gsub!(/(!){2,}/, '\1')
    self.gsub!(/(؟){2,}/, '\1')

    # should remove all kashida
    self.gsub!(/ـ+/,"")

    # ----------------------------------------------------------------

    # : ; , . ! ? and their persian equivalents should have one space after and no space before
    self.gsub!(/\s*([:;,؛،.؟!]{1})\s*/, '\1 ')

    # should replace more than one space with just a single one
    self.gsub!(/[ ]+/,' ')
    self.gsub!(/\s*[\n]+\s*/," \n")

    # remove spaces, tabs, and new lines from the beginning and enf of file
    self.strip!

    self
  end
end

String.send(:include, Virastar)