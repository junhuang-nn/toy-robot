require 'toy/robot'

module Toy
  RSpec.describe(Robot) do

    subject do
      described_class.new
    end

    it 'should be off the table initially' do
      expect(subject.position_valid?).to be false
    end

    describe 'report' do
      it 'should print out current position and facing' do
        allow(subject).to receive(:position_valid?) { true }
        expect(subject).to receive(:current_post).once
        subject.report
      end

      it 'should show error message if position is invalid' do
        allow(subject).to receive(:position_valid?) { false }
        expect(subject.report).to eq('Robot is not on the table yet.')
      end
    end

    describe 'to_s' do
      it 'should return current position and facing correctly' do
        subject.place 1, 1, 'WEST'
        expect(subject.to_s).to eq('1,1,WEST')
        subject.to_s
      end
    end

    describe 'maneuver' do

      describe 'place' do
        it 'can place at a valid position' do
          subject.place 1, 1, 'WEST'
          expect(subject.current_post).to eq('1,1,WEST')
        end

        it 'should ignore out of bound new position' do
          subject.place 6, 1, 'NORTH'
          expect(subject.current_post).to eq('-1,-1,')
        end
      end

      describe 'move' do
        it 'should be able to move toward North' do
          subject.place 2, 2, 'NORTH'
          subject.move
          expect(subject.current_post).to eq('2,3,NORTH')
        end

        it 'should be able to move toward West' do
          subject.place 2, 2, 'WEST'
          subject.move
          expect(subject.current_post).to eq('1,2,WEST')
        end

        it 'should be able to move toward East' do
          subject.place 2, 2, 'EAST'
          subject.move
          expect(subject.current_post).to eq('3,2,EAST')
        end

        it 'should be able to move toward South' do
          subject.place 2, 2, 'SOUTH'
          subject.move
          expect(subject.current_post).to eq('2,1,SOUTH')
        end

        describe 'prevent it from falling off' do
          it 'stops facing North' do
            subject.place 5, 5, 'NORTH'
            subject.move
            expect(subject.current_post).to eq('5,5,NORTH')
          end

          it 'stops facing South' do
            subject.place 5, 0, 'SOUTH'
            subject.move
            expect(subject.current_post).to eq('5,0,SOUTH')
          end

          it 'stops facing West' do
            subject.place 0, 5, 'WEST'
            subject.move
            expect(subject.current_post).to eq('0,5,WEST')
          end

          it 'stops facing East' do
            subject.place 5, 5, 'EAST'
            subject.move
            expect(subject.current_post).to eq('5,5,EAST')
          end
        end
      end

      describe 'turn right' do
        it 'wont turn right if current position is invalid' do
          expect(subject.right).to be_nil
        end

        it 'turn right when facing North' do
          subject.place 1, 1, 'NORTH'
          subject.right
          expect(subject.direction.to_s).to eq('EAST')
        end

        it 'turn right when facing South' do
          subject.place 1, 1, 'SOUTH'
          subject.right
          expect(subject.direction.to_s).to eq('WEST')
        end

        it 'turn right when facing West' do
          subject.place 1, 1, 'WEST'
          subject.right
          expect(subject.direction.to_s).to eq('NORTH')
        end

        it 'turn right when facing East' do
          subject.place 1, 1, 'EAST'
          subject.right
          expect(subject.direction.to_s).to eq('SOUTH')
        end
      end

      describe 'turn left' do
        it 'wont turn left if current position is invalid' do
          expect(subject.left).to be_nil
        end

        it 'turn left when facing North' do
          subject.place 1, 1, 'NORTH'
          subject.left
          expect(subject.direction.to_s).to eq('WEST')
        end

        it 'turn left when facing South' do
          subject.place 1, 1, 'SOUTH'
          subject.left
          expect(subject.direction.to_s).to eq('EAST')
        end

        it 'turn left when facing West' do
          subject.place 1, 1, 'WEST'
          subject.left
          expect(subject.direction.to_s).to eq('SOUTH')
        end

        it 'turn left when facing East' do
          subject.place 1, 1, 'EAST'
          subject.left
          expect(subject.direction.to_s).to eq('NORTH')
        end
      end
    end

    describe 'execute command' do
      it 'should validate command line first' do
        expect(subject).not_to receive(:move)
        subject.execute 'move1'
      end

      it 'move correctly' do
        expect(subject).to receive(:move).once.with(no_args())
        subject.execute 'move'
      end

      it 'turn right correctly' do
        expect(subject).to receive(:right).once.with(no_args())
        subject.execute 'right'
      end

      it 'turn left correctly' do
        expect(subject).to receive(:left).once.with(no_args())
        subject.execute 'left'
      end

      it 'report correctly' do
        expect(subject).to receive(:report).once.with(no_args())
        subject.execute 'report'
      end

      it 'place correctly' do
        expect(subject).to receive(:place).once.with('1', '1', 'NORTH')
        subject.execute 'place 1,1,NORTH'
      end

      it 'should also accept uppercase command' do
        expect(subject).to receive(:report).once.with(no_args())
        subject.execute 'REPORT'
      end
    end

    describe 'validate command' do
      it 'should return true for valid command' do
        expect(subject.valid_command?('move')).to be true
      end

      it 'should return false for invalid command' do
        expect(subject.valid_command?('wrong command')).to be false
      end

      describe 'command line regex' do
        it 'should be true for valid command' do
          expect('move'=~Robot::COMMAND_REGEX).not_to be_nil
          expect('right'=~Robot::COMMAND_REGEX).not_to be_nil
          expect('left'=~Robot::COMMAND_REGEX).not_to be_nil
          expect('report'=~Robot::COMMAND_REGEX).not_to be_nil
          expect('place 1,1,south'=~Robot::COMMAND_REGEX).not_to be_nil
        end

        it 'should be false if the command is invalid' do
          expect('1move'=~Robot::COMMAND_REGEX).to be_nil
          expect('right1'=~Robot::COMMAND_REGEX).to be_nil
          expect('left 1'=~Robot::COMMAND_REGEX).to be_nil
          expect('report 1'=~Robot::COMMAND_REGEX).to be_nil
          expect('place 6,-1,north'=~Robot::COMMAND_REGEX).to be_nil
        end
      end

    end

    describe 'valid position' do
      it 'should return true if current x position is within range' do
        expect(subject.position_valid?(0, 1)).to be true
      end

      it 'should return false if current x position is out of range' do
        expect(subject.position_valid?(6, 1)).to be false
      end

      it 'should return true if current y position is within range' do
        expect(subject.position_valid?(1, 5)).to be true
      end

      it 'should return false if current y position is out of range' do
        expect(subject.position_valid?(1, -1)).to be false
      end

      it 'should validate current position if no new position is given' do
        subject.place(0, 0, 'WEST')
        expect(subject.position_valid?).to be true
      end

      it 'can handle string x and y values' do
        expect(subject.position_valid?('1', '5')).to be true
      end
    end

  end
end
