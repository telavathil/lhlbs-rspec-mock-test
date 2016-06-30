require 'pry'

class RobotError < StandardError
end

class RobotAlreadyDeadError < RobotError
end

class UnattackableEnemy < RobotError
end

class Robot
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
      if (item.class == BoxOfBolts && self.health < 81)
        #binding.pry
        item.feed(self)
      end
        items << item if items_weight < 250
        @equipped_weapon = item if item.class <= Weapon
    end

    def items_weight
        if items == []
            0
        else
            items.inject(0) { |sum, item| sum + item.weight }
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
      #binding.pry
      #if robot is more than one space away, no attack occurs
      weapon_range =  self.equipped_weapon.nil? ? 0 : self.equipped_weapon.range
      pos_greater_than_range=[]
      robot.position.each_index {|index| pos_greater_than_range <<
       ((robot.position[index] - @position[index]).abs > weapon_range )}
       #binding.pry
        unless (pos_greater_than_range.include? (true))
          if @equipped_weapon.nil?
              robot.wound(5)
          else
              equipped_weapon.hit(robot)
              if self.equipped_weapon.name == "Grenade"
                self.equipped_weapon = nil
              end
          end
        end

    end

        def heal!(healing)
            if (healing + @health) > 100
                @health = 100
            elsif @health < 1
                raise RobotAlreadyDeadError, 'Robot is dead'
                return
            else
                @health += healing
            end
        end

        def attack!(robot)
            if robot.class != Robot
                raise UnattackableEnemy, 'Robots only attack other robots'
                return
            end
            if @equipped_weapon.nil?
                robot.wound(5)
            else
                equipped_weapon.hit(robot)
            end
        end
end
