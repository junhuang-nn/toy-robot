module Toy
  class Direction

    attr_reader :facing

    DEGREE_MAP = {NORTH: 90, SOUTH: 270, EAST: 0, WEST: 180}

    def initialize(facing)
      @facing = facing
    end

    def degree
      DEGREE_MAP.fetch(facing)
    end

    def degree=(degree)
      d = (degree + 360) % 360
      @facing = DEGREE_MAP.key(d) if DEGREE_MAP.value? d
    end

    def to_s
      facing.to_s
    end

  end
end