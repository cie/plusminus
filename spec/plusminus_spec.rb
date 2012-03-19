require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Plusminus" do
  specify "#pm" do
    (5.43.pm 1.1).crop.should == "5"
    (5.43.pm 0.9).crop.should == "5.4"
    (5.43.pm 0.11).crop.should == "5.4"
    (5.43.pm 0.09).crop.should == "5.43"
    (5.43.pm 0.011).crop.should == "5.43"
    (5.43.pm 0.009).crop.should == "5.430"
    (5.43.pm 0.0011).crop.should == "5.430"

    (5.43.pm 0.0011).delta.should == 0.0011
  end

  specify "#pm_rel" do
    (5.43.pm_rel 0.1).delta.should == 0.543
  end

  specify "precision" do
    (15.43.pm 1.1).precision.should == 0
    (15.43.pm 0.9).precision.should == 1
    (15.43.pm 0.11).precision.should == 1
    (15.43.pm 0.09).precision.should == 2
    (15.43.pm 0.011).precision.should == 2
    (15.43.pm 0.009).precision.should == 3
    (15.43.pm 0.0011).precision.should == 3
  end

  specify ""

end
