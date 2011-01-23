# -*- encoding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Virastar do

  it "should add persian_cleanup method to String class" do
    test = "test string"
    test.should respond_to(:persian_cleanup)
  end

  it "should replace Arabic kaf with its Persian equivalent" do
    test = "ك"
    test2 = "كمك"
    result = "ک"
    result2 = "کمک"
    test.persian_cleanup.should == result
    test2.persian_cleanup.should == result2
  end

  it "should replace Arabic Yeh with its Persian equivalent" do
    test = "ي"
    test2 = "بيني"
    result = "ی"
    result2 = "بینی"
    test.persian_cleanup.should == result
    test2.persian_cleanup.should == result2
  end

  it "should replace Arabic numbers with their Persian equivalent" do
    test   = "٠١٢٣٤٥٦٧٨٩"
    result = "۰۱۲۳۴۵۶۷۸۹"
    test.persian_cleanup.should == result
  end

  it "should replace English numbers with their Persian equivalent" do
    test   = "0123456789"
    result = "۰۱۲۳۴۵۶۷۸۹"
    test.persian_cleanup.should == result
  end

  it "should replace English comma and semicolon with their Persian equivalent" do
    test   = ";,"
    result = "؛ ،"
    test.persian_cleanup.should == result
  end

  it "should correct :;,.?! spacing (one space after and no space before)" do
    test   = "گفت : سلام"
    result = "گفت: سلام"
    test2 = "salam.\n\nkhoobi"
    result2 = "salam. \n\nkhoobi"
    test.persian_cleanup.should == result
    test2.persian_cleanup.should == result2
  end

  it "should replace English quotes with their Persian equivalent" do
    test  = "''تست''"
    test2 = "'تست'"
    test3 = "\"گفت: سلام\""
    test4 = "`تست`"
    test5 = "``تست``"
    result = result2 = result4 = result5 = "«تست»"
    result3 = "«گفت: سلام»"
    # not greedy
    test6 = '"this" or "that"'
    result6 = '«this» or «that»'
    test.persian_cleanup.should  == result
    test2.persian_cleanup.should == result2
    test3.persian_cleanup.should == result3
    test4.persian_cleanup.should == result4
    test5.persian_cleanup.should == result5
    test6.persian_cleanup.should == result6
  end

  it "should replace three dots with ellipsis" do
    test    = "..."
    result  = "…"
    test2   = "...."
    result2 = "…"
    test3   = "خداحافظ ... به به"
    result3 = "خداحافظ… به به"
    test4   = "........."
    result4 = "…"
    test.persian_cleanup.should   == result
    test2.persian_cleanup.should  == result2
    test3.persian_cleanup.should  == result3
    test4.persian_cleanup.should  == result4
  end

  it "should convert ه ی to هٔ"  do
    test = "خانه ی ما"
    test2 = "خانه ی ما"
    test3 = "خانه ي ما"
    result = result2 = result3 = "خانهٔ ما"
    test.persian_cleanup.should   == result
    test2.persian_cleanup.should  == result2
    test3.persian_cleanup.should  == result3
  end

  it "should replace double dash to ndash and triple dash to mdash" do
    test    = "--"
    test2   = "---"
    result  = "–"
    result2 = "—"
    test.persian_cleanup.should   == result
    test2.persian_cleanup.should  == result2
  end

  it "should replace more than one space with just a single one" do
    test   = "  hello   world!  I'm virastar   "
    result = "hello world! I'm virastar"
    test.persian_cleanup.should   == result
  end

  it "should remove unnecessary zwnj chars that are succeeded/preceded by a space" do
    test = "سلام‌ دنیا" # before
    result = "سلام دنیا"
    test2 = "سلام ‌دنیا" #after
    result2 = "سلام دنیا"
    test.persian_cleanup.should == result
    test2.persian_cleanup.should == result2
  end

  it "should fix spacing for () [] {}  “” «» (one space outside, no space inside)" do
    [ ["(",")"],["[","]"],["{","}"],["“","”"],["«","»"] ].each do |b|
      test  = "this is#{b[0]} a test#{b[1]}"
      test2 = "this is #{b[0]} a test  #{b[1]}"
      test3 = "this is  #{b[0]}  a test #{b[1]}  yeah!"
      test4 = "this is   #{b[0]}a test #{b[1]}  yeah!"
      result  = "this is #{b[0]}a test#{b[1]}"
      result2 = "this is #{b[0]}a test#{b[1]}"
      result3 = "this is #{b[0]}a test#{b[1]} yeah!"
      result4 = "this is #{b[0]}a test#{b[1]} yeah!"
      test.persian_cleanup.should   == result
      test2.persian_cleanup.should  == result2
      test3.persian_cleanup.should  == result3
      test4.persian_cleanup.should  == result4
    end
  end

  it "should replace English percent sign to its Persian equivalent" do
    test = "%"
    result = "٪"
    test.persian_cleanup.should == result
  end

  it "should replace more that one line breaks with just one" do
    test    = "this is \n \n \n     \n a test"
    result  = "this is \n\n\n\na test"
    test2   = "this is\n\n\n\na test"
    result2 = "this is\n\n\n\na test"
    test3   = "this is \n\n\n    a test"
    result3 = "this is \n\n\na test"

    test.persian_cleanup.should  == result
    test2.persian_cleanup.should  == result2
    test3.persian_cleanup.should  == result3
  end

  it "should not replace line breaks and should remove spaces after line break" do
    test  = "this is \n  a test"
    result = "this is \na test"
    test.persian_cleanup.should  == result
  end

  it "should put zwnj between word and prefix/suffix (ha haye* tar* tarin mi* nemi*)" do
    test    = "ما می توانیم"
    result  = "ما می‌توانیم"
    test2   = "ما نمی توانیم"
    result2 = "ما نمی‌توانیم"
    test3   = "این بهترین کتاب ها است"
    result3 = "این بهترین کتاب‌ها است"
    test4   = "بزرگ تری و قدرتمند ترین زبان های دنیا"
    result4 = "بزرگ‌تری و قدرتمند‌ترین زبان‌های دنیا"
    test.persian_cleanup.should == result
  end

  it "should not replace English numbers in English phrases" do
    test = "عزیز ATM74 در IBM-96 085 B 95BCS"
    result = "عزیز ATM74 در IBM-96 ۰۸۵ B 95BCS"
    test.persian_cleanup.should  == result
  end

  it "should not create spacing for something like (,)" do
    test = "this is (,) comma"
    result = "this is (،) comma"
    test.persian_cleanup.should  == result
  end

  it "should not puts space after time colon separator" do
    test = "12:34"
    result = "۱۲:۳۴"
    test.persian_cleanup.should  == result
  end

  it "should not destroy URLs" do
      test = "http://virastar.heroku.com"
      result = "http://virastar.heroku.com"
      test2 = "http://virastar.heroku.com\nhttp://balatarin.com"
      result2 = "http://virastar.heroku.com\nhttp://balatarin.com"
      test.persian_cleanup.should  == result
      test2.persian_cleanup.should  == result2
   end

  it "should not replace line breaks when the line ends with quotes" do
    test = "salam \"khoobi\" \n chetori"
    result = "salam «khoobi» \nchetori"
    test.persian_cleanup.should  == result
  end

  it "should not put space after quotes, {}, () or [] if there's ,.; just after that" do
    test = "«This», {this}, (this), [this] or {this}. sometimes (this)."
    result = "«This»، {this}، (this)، [this] or {this}. sometimes (this)."
    test.persian_cleanup.should  == result
  end

  it "should be able to convert numbers with dashes" do
    test = "1- salam"
    result = "۱- salam"
    test.persian_cleanup.should  == result
  end

  context "aggressive editing" do
    it "should replace more than one ! or ? mark with just one" do
      test    = "salam!!!"
      result  = "salam!"
      test2   = "چطور؟؟؟"
      result2 = "چطور؟"
      test.persian_cleanup.should == result
      test2.persian_cleanup.should == result2
    end

    it "should remove all kashida" do
      test   = "سلامـــت"
      result = "سلامت"
      test.persian_cleanup.should == result
    end

    it "should correct wrong connections like in میشود or میدهد"
  end

end