require 'pry'

class RobotError < StandardError
end

class RobotAlreadyDeadError < RobotError
end

class UnattackableEnemy < RobotError
end
    attr_reader :position, :items
    attr_accessor :health, :equipped_weapon
    def initialize
        @position = [0, 0]
        @items = []
        @health = 100
        @equipped_weapon = nil
    end

    def move_left
        @position[0] -= 1
    end

    def move_right
        @position[0] += 1
    end

    def move_up
        @position[1] += 1
    end

    def move_down
        @position[1] -= 1
    end

    def pick_up(item)
       if items_weight < 250
        self.items << item
       end
       if item.class <= Weapon
         @equipped_weapon = item
       end
    end

    def items_weight
      if self.items == []
        0
      else
        self.items.inject(0) {|sum, item| sum + item.weight}
      end
    end

    def wound(damage)
      if damage < @health
        @health -= damage
      else
        @health = 0
      end
    end

    def heal(healing)
      if (healing + @health) > 100
        @health = 100
      else
        @health += healing
      end
    end

    def attack(robot)
      if @equipped_weapon.nil?
        robot.wound(5)
      else
        self.equipped_weapon.hit(robot)
      end
    end

    def heal!(healing)
      if (healing + @health) > 100
        @health = 100
      elsif @health < 1
        raise RobotAlreadyDeadError, "Robot is dead"
        return
      else
        @health += healing
      end
    end

    def attack!(robot)
      if robot.class != Robot
        raise UnattackableEnemy, "Robots only attack other robots"
        return
      end
      if @equipped_weapon.nil?
        robot.wound(5)
      else
        self.equipped_weapon.hit(robot)
      end
    end
end
