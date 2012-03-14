module Plusminus
  def pm delta
    @delta = delta.abs.to_f
    self
  end

  def pm_rel rel
    @delta = abs*rel.abs
    self
  end

  attr_reader :delta

  def fmt fmt
    @fmt = fmt
    self
  end

  def first_digit
    Math.log(abs, 10)
  end

  def last_digit
    (@delta && @delta > 0) ? Math.log(@delta,10) : 12
  end

  def precision digits = nil
    [digits ? -first_digit+digits : -last_digit+1, 0].max.to_i
  end

  alias original_to_s to_s

  def inspect
    return original_to_s if not @delta or @delta <= 0
    "#{crop}.pm(#{@delta.crop(1)})"
  end

  def crop digits=nil
    return "0" if self == 0
    raise ArgumentError if not digits and not @delta
    fmt = @fmt || case self
    when -0.01 ... 0.01
      :e
    else
      :f
    end
    case fmt
    when :e
      "%0.#{digits ? digits-1 : (first_digit-last_digit+1).to_i}e" % self
    when :f
      "%0.#{precision(digits)}f" % self
    when :%
      "%0.#{[0,precision(digits)-2].max}f%%" % (self*100)
    else
      original_to_s
    end
  end

  def to_latex digits=nil
    s = crop(digits)
    percent = s =~ /%\z/
    s.sub!(/%\z/, "")
    mantissa, exponent = s.split("e")
    if exponent
      exponent.sub!(/\A-0*/, "-").sub!(/\A0*/, "")
      "#{mantissa}\\cdot 10^{#{exponent}}"
    else
      mantissa
    end.gsub(".", decimal_separator) << 
      (percent ? "\\%" : "")
  end


  def to_latex_pm
    "#{to_latex} \\pm #{@delta.to_latex(1)}"
  end

  def to_latex_math_pm
    "$#{to_latex_pm}$"
  end


  def decimal_separator
    ","
  end
end

class Float
  include Plusminus
end

