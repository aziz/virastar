require "rubygems"
require "diffy"

require 'jcode'
$KCODE = 'u'

module Virastar
  
  # TODO: make a class and then extend string with another module that initialize that class
  
  def persian_cleanup
    bad  = "1234567890,;كي٠١٢٣٤٥٦٧٨٩"
    good = "۱۲۳۴۵۶۷۸۹۰،؛کی۰۱۲۳۴۵۶۷۸۹"

    # character replacement
    self.tr!(bad,good)

    # semicolon and colon should have one space after and no space before
    self.gsub!(/\s*([:؛،.؟!])\s*/, '\1 ')

    self
  end
end

String.send(:include, Virastar)