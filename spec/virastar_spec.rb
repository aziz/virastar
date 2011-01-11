require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Virastar do
  it "should add persian_cleanup method to String class" do
    test = "test string"
    test.methods.should include("persian_cleanup")
  end

  it "should replace Arabic kaf with its Persian equivalent" do
    test = "ك"
    test2 = "كمك"
    result = "ک"
    result2 = "کمک"
    test.persian_cleanup.should == result
    test2.persian_cleanup.should == result2
  end

  it "should replace Arabic Yah with its Persian equivalent" do
    test = "ي"
    test2 = "بيني"
    result = "ی"
    result2 = "بینی"
    test.persian_cleanup.should == result
    test2.persian_cleanup.should == result2
  end

  it "should replace Arabic numbers (4,5,6) with their Persian equivalent" do
    test   = "٠١٢٣٤٥٦٧٨٩"
    result = "۰۱۲۳۴۵۶۷۸۹"
    test.persian_cleanup.should == result
  end

  it "should replace English numbers with their Persian equivalent" do
    test   = "0123456789"
    result = "۰۱۲۳۴۵۶۷۸۹"
    test.persian_cleanup.should == result
  end

  it "should replace English comma and semicolon to their Persian equivalent" do
    test   = ";,"
    result = "؛ ، "
    test.persian_cleanup.should == result
  end

  it "should correct :;,.?! spacing (one space after and no space before)" do
    test   = "گفت : سلام"
    result = "گفت: سلام"
    puts Diffy::Diff.new(test, result).to_s(:color)
    test.persian_cleanup.should == result
  end

  # it "should replace English qoutes with their Persian equivalent" do
  #   test  = "''تست''"
  #   test2 = "'تست'"
  #   test3 = "\"گفت: سلام\""
  #   test4 = "``تست''"
  #   test5 = "`تست`"
  #   test6 = "``تست``"
  #   result = result2 = result4 = result5 = result6 = "«تست»"
  #   result3 = "«گفت: سلام»"
  #   test.persian_cleanup.should  == result
  #   test2.persian_cleanup.should == result2
  #   test3.persian_cleanup.should == result3
  #   test4.persian_cleanup.should == result4
  #   test5.persian_cleanup.should == result5
  #   test6.persian_cleanup.should == result6
  # end
  # 
  # it "should replace three dots with ellipsis" do
  #   test    = "..."
  #   result  = "…"
  #   test2   = "...."
  #   result2 = "...."
  #   test3   = "خداحافظ ... به به"
  #   result3 = "خداحافظ… به به"
  #   test4   = "........."
  #   result4 = "........."
  #   test.persian_cleanup.should   == result
  #   test2.persian_cleanup.should  == result2
  #   test3.persian_cleanup.should  == result3
  #   test4.persian_cleanup.should  == result4
  # end
  # 
  # it "should convert ه ی to هٔ" do
  #   test = "خانه ی ما"
  #   test2 = "خانه ی ما"
  #   result = result2 = "خانهٔ ما"
  #   test.persian_cleanup.should   == result
  #   test2.persian_cleanup.should  == result2
  # end
  # 
  # it "should replace double dash to ndash and triple dash to mdash"
  # 
  # it "should put zwnj between word and prefix/suffix (ha haye tar tarin mi)"
  # 
  # it "should handle specific word آنها"

end