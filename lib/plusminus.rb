require "nio"

module Plusminus
end

class Numeric
  def pm delta
    Plusminus::PlusminusFloat.new self, delta
  end

  def pm_rel rel
    Plusminus::PlusminusFloat.new self, abs*rel
  end

  def to_pm
    Plusminus::PlusminusFloat.new self, 0
  end
end


class Float
  def to_pm
    Plusminus::PlusminusFloat.new self, 10.0**-Float::DIG
  end
end



require File.expand_path File.dirname(__FILE__) + "/plusminus/plusminus_float.rb"

