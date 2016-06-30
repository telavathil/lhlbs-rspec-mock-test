# Since grenades have a range of 2, if the robot has one equipped,
# it can attack an enemy robot that is 2 tiles away instead of just 1 tile away
# That said, it will also discard/unequip the grenade
require_relative 'spec_helper'


describe Robot do
  before :each do
    @robot = Robot.new
  end

  describe "#shield" do
    it "starts off with 50 sheild points" do
      expect(@robot.shields).to be == 50
    end
  end

  describe '#attack' do

    it "hits other robot with default attack (5 hitpoints) and the sheilds are damaged" do
      robot2 = Robot.new
      @robot.attack(robot2)
      expect(robot2.shields).to be == 45
    end
  end
end
