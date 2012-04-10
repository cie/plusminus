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

  def delta
    0
  end
end


class Float
  def to_pm
    Plusminus::PlusminusFloat.new self, 10.0**-Float::DIG
  end

  def delta
    10**-Float::DIG
  end
end


module Plusminus

  FORMATTING_METHODS = %w(
    sep
    mode
    prec
    grouping
    show_all_digits
    approx_mode
    insignificant_digits
    sci_digits
    show_plus
    show_exp_plus
    rep
    width
    pad0s
    base
    percent
  )

  # define formatting methods
  FORMATTING_METHODS.each do |m|
    instance_eval <<-EOT
      def #{m}! *args
        Plusminus::PlusminusFloat::DEFAULT_FMT.#{m}! *args
        self
      end
    EOT
  end
end


require File.expand_path File.dirname(__FILE__) + "/plusminus/plusminus_float.rb"

