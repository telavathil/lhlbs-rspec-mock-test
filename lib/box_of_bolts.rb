class BoxOfBolts < Item

  def initialize
    super("Box of bolts",25)
  end

  def feed(robot)
    # binding.pry
    robot.heal(20)
  end

end
