class Plusminus::PlusminusFloat < Numeric

  DEFAULT_FMT = Nio::Fmt.default.dup

  def initialize value, delta
    @value = value.to_f
    @delta = delta.to_f.abs
  end

  attr_reader :value, :delta

  def to_pm
    self
  end

  def to_f
    @value
  end

  def coerce other
    case other
    when Numeric
      return self, other
    else
      raise ArgumentError "#{other} cannot be coerced to #{self.class}"
    end
  end

  def + other
    other = other.to_pm
    (self.value + other.value).pm(self.delta + other.delta)
  end

  def - other
    other = other.to_pm
    (self.value - other.value).pm(self.delta + other.delta)
  end

  def * other
    other = other.to_pm
    (self.value * other.value).pm(other.value.abs * self.delta + self.value.abs * other.delta)
  end
  
  def / other
    other = other.to_pm
    (self.value / other.value).pm(self.delta / other.value.abs + other.delta * self.value.abs / other.value.abs**2)
  end
  
  def ** other
    return 1 if other == 0
    return 0 if self == 0
    other = other.to_pm
    res = self.value ** other.value
    res.pm(
      (Math.log(self.value.abs) * res).abs * other.delta +
      (other.value * res / self.value).abs * self.delta
    )
  end

  def -@
    (-@value).pm @delta
  end

  def abs
    @value.abs
  end

  def == other
    @value == other
  end

  def eql? other
    return false unless other.is_a? self.class
    self.value == other.value and self.delta == other.delta
  end

  def <=> other
    self.value <=> other.to_pm.value
  end

  def === other
    other = other.to_pm.value
    @value-@delta < other and other < @value+@delta
  end

  # returns the Nio::Fmt to be used with the number. The returned object can be
  # modified with Nio::Fmt's bang methods 
  def fmt
    unless defined? @fmt
      @fmt = DEFAULT_FMT.dup
      case self
      when -0.01 ... 0.01 then 
        @fmt.mode!(:sci, sig_digits)
      else 
        @fmt.mode!(:sig, sig_digits)
      end
    end

    @fmt
  end

  # returns the number of significant digits
  def sig_digits 
    Math.log(@value.abs,10).to_i + 1 - Math.log(@delta,10) + Math.log(5,10)
  end

  # produces a string of the number with the appropriate number of decimal
  # digits
  def to_s
    @value.nio_write(fmt)
  end

  def inspect
    "#{@value.inspect}.pm(#{delta.inspect})"
  end

  def to_latex fmt = nil
    fmt ||= self.fmt
    s = @value.nio_write(fmt || self.fmt)
    percent = s =~ /%\z/
    s.sub!(/%\z/, "")
    mantissa, exponent = s.split("e")
    if exponent
      exponent.sub!(/\A-0*/, "-").sub!(/\A0*/, "")
      "#{mantissa}\\cdot 10^{#{exponent}}"
    else
      mantissa
    end << (percent ? "\\%" : "")
  end

  def to_latex_pm
    "#{to_latex} \\pm #{@delta.pm(1).to_latex}"
  end

  def to_latex_math_pm
    "$#{to_latex_pm}$"
  end

end

# modified version of sqrt that uses **, to be able to coerce PlusminusFloat
#
def Math.sqrt x
  x ** 0.5
end