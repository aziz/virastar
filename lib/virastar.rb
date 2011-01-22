# -*- encoding: utf-8 -*-
if RUBY_VERSION.to_f < 1.9
  require 'jcode'
  $KCODE = 'u'
end

module Virastar

  class PersianEditor
    def initialize(text,options)
      @text = text
      @fix_dashes = options[:fix_dashes] || true
      @fix_three_dots = options[:fix_three_dots] || true
      @fix_english_quotes = options[:fix_english_quotes] || true
      @fix_hamzeh = options[:fix_hamzeh] || true
      @cleanup_zwnj = options[:cleanup_zwnj] || true
      @fix_spacing_for_braces_and_quotes = options[:fix_spacing_for_braces_and_quotes] || true
      @fix_arabic_numbers = options[:fix_arabic_numbers] || true
      @fix_english_numbers = options[:fix_english_numbers] || true
      @fix_misc_non_persian_chars = options[:fix_misc_non_persian_chars] || true
      @fix_perfix_spacing = options[:fix_perfix_spacing] || true
      @fix_suffix_spacing = options[:fix_suffix_spacing] || true
      @aggresive = options[:aggresive] || true
      @cleanup_kashidas = options[:cleanup_kashidas] || true
      @cleanup_extra_marks = options[:cleanup_extra_marks] || true
      @cleanup_spacing = options[:cleanup_spacing] || true
      @cleanup_begin_and_end = options[:cleanup_begin_and_end] || true
    end

    def cleanup
      text = @text
      # replace double dash to ndash and triple dash to mdash
      if @fix_dashes
        text.gsub!(/-{3}/,'—')
        text.gsub!(/-{2}/,'–')
      end

      # replace three dots with ellipsis
      text.gsub!(/\s*\.{3,}/,'…') if @fix_three_dots

      # replace English quotes with their Persian equivalent
      text.gsub!(/(["'`]+)(.+?)(\1)/, '«\2»') if @fix_english_quotes

      # should convert ه ی to ه
      text.gsub!(/(\S)(ه[\s‌]+[یي])(\s)/, '\1هٔ\3') if @fix_hamzeh

      # remove unnecessary zwnj char that are succeeded/preceded by a space
      text.gsub!(/\s+‌|‌\s+/,' ') if @cleanup_zwnj

      # character replacement
      persian_numbers = "۱۲۳۴۵۶۷۸۹۰"
      arabic_numbers  = "١٢٣٤٥٦٧٨٩٠"
      english_numbers = "1234567890"
      bad_chars  = ",;كي%"
      good_chars = "،؛کی٪"
      text.tr!(english_numbers,persian_numbers) if @fix_english_numbers
      text.tr!(arabic_numbers,persian_numbers) if @fix_arabic_numbers
      text.tr!(bad_chars,good_chars) if @fix_misc_non_persian_chars

      # should not replace exnglish chars in english phrases
      text.gsub!(/([a-z\-_]+[۰-۹]+|[۰-۹]+[a-z\-_]+)/i) do |s|
        s.tr(persian_numbers,english_numbers)
      end

      # put zwnj between word and prefix (mi* nemi*)
      # there's a possible bug here: می and نمی could be separate nouns and not prefix
      if @fix_perfix_spacing
        text.gsub!(/\s+(ن?می)\s+/,' \1‌')
      end

      # put zwnj between word and suffix (*tar *tarin *ha *haye)
      # there's a possible bug here: های and تر could be separate nouns and not suffix
      if @fix_suffix_spacing
        text.gsub!(/\s+(تر(ی(ن)?)?|ها(ی)?)\s+/,'‌\1 ') # in case you can not read it: \s+(tar(i(n)?)?|ha(ye)?)\s+
      end

      # -- Aggressive Editing ------------------------------------------
      if @aggresive

        # replace more than one ! or ? mark with just one
        if @cleanup_extra_marks
          text.gsub!(/(!){2,}/, '\1')
          text.gsub!(/(؟){2,}/, '\1')
        end

        # should remove all kashida
        text.gsub!(/ـ+/,"") if @cleanup_kashidas

      end
      # ----------------------------------------------------------------

      # : ; , . ! ? and their persian equivalents should have one space after and no space before
      if @fix_spacing_for_braces_and_quotes
        text.gsub!(/[ ‌	]*([:;,؛،.؟!]{1})[ ‌	]*/, '\1 ')
        # do not put space after colon that separates time parts
        text.gsub!(/([۰-۹]+):\s+([۰-۹]+)/, '\1:\2')
      end
      
      

      # should fix spacing for () [] {}  “” «»
      if @fix_spacing_for_braces_and_quotes
        text.gsub!(/[ 	‌]*(\()\s*([^)]+?)\s*?(\))[ 	‌]*/,' \1\2\3 ')
        text.gsub!(/[ 	‌]*(\[)\s*([^)]+?)\s*?(\])[ 	‌]*/,' \1\2\3 ')
        text.gsub!(/[ 	‌]*(\{)\s*([^)]+?)\s*?(\})[ 	‌]*/,' \1\2\3 ')
        text.gsub!(/[ 	‌]*(“)\s*([^)]+?)\s*?(”)[ 	‌]*/,' \1\2\3 ')
        text.gsub!(/[ 	‌]*(«)\s*([^)]+?)\s*?(»)[ 	‌]*/,' \1\2\3 ')
      end

      # should replace more than one space with just a single one
      if @cleanup_spacing
        text.gsub!(/[ ]+/,' ')
        text.gsub!(/([\n]+)[ 	‌]*/,'\1')
      end

      # remove spaces, tabs, and new lines from the beginning and enf of file
      text.strip! if @cleanup_begin_and_end

      text
    end

  end
end

module VirastarStingExtensions
  def persian_cleanup(options = {})
    editor = Virastar::PersianEditor.new(self.dup,options)
    return editor.cleanup
  end
end

String.send(:include, VirastarStingExtensions)