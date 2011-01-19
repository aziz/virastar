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
    #puts Diffy::Diff.new(test, result).to_s(:color) # TODO: char diff
    test.persian_cleanup.should == result
  end

  it "should replace English quotes with their Persian equivalent" do
    test  = "''تست''"
    test2 = "'تست'"
    test3 = "\"گفت: سلام\""
    test4 = "`تست`"
    test5 = "``تست``"
    result = result2 = result4 = result5 = "«تست»"
    result3 = "«گفت: سلام»"
    test.persian_cleanup.should  == result
    test2.persian_cleanup.should == result2
    test3.persian_cleanup.should == result3
    test4.persian_cleanup.should == result4
    test5.persian_cleanup.should == result5
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
    result = result2 = "خانهٔ ما"
    test.persian_cleanup.should   == result
    test2.persian_cleanup.should  == result2
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
    test  = "this is \n \n \n     \n a test"
    result = "this is \na test"
    test2  = "this is\n\n\n\na test"
    result2 = "this is \na test"
    test3  = "this is \n\n\n\n    a test"
    result3 = "this is \na test"

    test.persian_cleanup.should  == result
    test2.persian_cleanup.should  == result2
    test3.persian_cleanup.should  == result3
  end

  it "should not replace line breaks" do
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
    test4   = "بزرگ تر و قدرتمند ترین زبان های دنیا"
    result4 = "بزرگ‌تر و قدرتمند‌ترین زبان‌های دنیا"
    test.persian_cleanup.should == result
  end

  it "should not replace English numbers in English phrases" do
    test = "عزیز ATM74 در IBM-96 085 B 95BCS"
    result = "عزیز ATM74 در IBM-96 ۰۸۵ B 95BCS"
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