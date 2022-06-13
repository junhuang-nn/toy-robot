module Toy
  module Movable

    def move
      send("go_#{direction.to_s.downcase}") if position_valid?
    end

    def go_north
      @y_coordinate = [y_coordinate + step, y_range.max].min
    end

    def go_south
      @y_coordinate = [y_coordinate - step, y_range.min].max
    end

    def go_west
      @x_coordinate = [x_coordinate - step, x_range.min].max
    end

    def go_east
      @x_coordinate =[x_coordinate + step, x_range.max].min
    end

  end
end