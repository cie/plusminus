require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Plusminus::PMFloat" do
  specify "#nio_write" do
    25.0. pm(1.0    /2).nio_write.should == "25"
    25.5. pm(0.5    /2).nio_write.should == "25.5"
    25.4. pm(0.2    /2).nio_write.should == "25.4"
    25.4. pm(0.1    /2).nio_write.should == "25.4"
    25.45.pm(0.05   /2).nio_write.should == "25.45"
    25.44.pm(0.02   /2).nio_write.should == "25.44"
    25.43.pm(0.01   /2).nio_write.should == "25.43"
    25.435.pm(0.005 /2).nio_write.should == "25.435"
    25.436.pm(0.002 /2).nio_write.should == "25.436"
    25.435.pm(0.001 /2).nio_write.should == "25.435"
    25.435.pm(0.0005/2).nio_write.should == "25.4350"
    25.435.pm(0.0002/2).nio_write.should == "25.4350"
    25.435.pm(0.0001/2).nio_write.should == "25.4350"
    5.0. pm(1.0     /2).nio_write.should == "5"
    5.5. pm(0.5     /2).nio_write.should == "5.5"
    5.4. pm(0.2     /2).nio_write.should == "5.4"
    5.4. pm(0.1     /2).nio_write.should == "5.4"
    5.45.pm(0.05    /2).nio_write.should == "5.45"
    5.44.pm(0.02    /2).nio_write.should == "5.44"
    5.43.pm(0.01    /2).nio_write.should == "5.43"
    5.435.pm(0.005  /2).nio_write.should == "5.435"
    5.436.pm(0.002  /2).nio_write.should == "5.436"
    5.435.pm(0.001  /2).nio_write.should == "5.435"
    5.435.pm(0.0005 /2).nio_write.should == "5.4350"
    5.435.pm(0.0002 /2).nio_write.should == "5.4350"
    5.435.pm(0.0001 /2).nio_write.should == "5.4350"
    0.5. pm(0.5     /2).nio_write.should == "0.5"
    0.4. pm(0.2     /2).nio_write.should == "0.4"
    0.4. pm(0.1     /2).nio_write.should == "0.4"
    0.45.pm(0.05    /2).nio_write.should == "0.45"
    0.44.pm(0.02    /2).nio_write.should == "0.44"
    0.43.pm(0.01    /2).nio_write.should == "0.43"
    0.435.pm(0.005  /2).nio_write.should =="0.435"
    0.436.pm(0.002  /2).nio_write.should =="0.436"
    0.435.pm(0.001  /2).nio_write.should =="0.435"
    0.435.pm(0.0005 /2).nio_write.should =="0.4350"
    0.435.pm(0.0002 /2).nio_write.should =="0.4350"
    0.435.pm(0.0001 /2).nio_write.should =="0.4350"
    0.05.pm(0.05    /2).nio_write.should == "0.05"
    0.04.pm(0.02    /2).nio_write.should == "0.04"
    0.03.pm(0.01    /2).nio_write.should == "0.03"
    0.035.pm(0.005  /2).nio_write.should =="0.035"
    0.036.pm(0.002  /2).nio_write.should =="0.036"
    0.035.pm(0.001  /2).nio_write.should =="0.035"
    0.035.pm(0.0005 /2).nio_write.should =="0.0350"
    0.035.pm(0.0002 /2).nio_write.should =="0.0350"
    0.035.pm(0.0001 /2).nio_write.should =="0.0350"
  end

  specify "#pm_rel" do
    (5.43.pm_rel 0.1).delta.should == 0.543
  end


end
