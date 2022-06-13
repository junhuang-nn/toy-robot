module Toy
  module Steerable

    def right
      direction.degree -= 90 if position_valid?
    end

    def left
      direction.degree += 90 if position_valid?
    end

  end
end