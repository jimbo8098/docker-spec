module Docker
  module Spec
    def self.docker_tests
      describe 'Running a docker container', test: :default do
        before(:all) do
          @container = DockerSpec.instance.container
          @image = @container.info["Image"]
          @config = DockerSpec.instance.config
          @lock = File.join('/tmp', @config[:account] + '-' + @config[:name] + '.lock')
          @f = File.open(@lock, 'w')
          if (not @f.flock(File::LOCK_EX | File::LOCK_NB))
            puts "INFO: Another build is already running"
          end
          @f.flock(File::LOCK_EX)
        end

        it 'should be available' do
          expect(@image).to_not be_nil
        end

        it 'should have state running' do
          expect(@container.json['State']['Running']).to be true
        end

        it 'Should stay running' do
          expect(@container.json['State']['Running']).to be true
        end

        it 'Should not have exit processes' do
          expect(@container.logs(stdout: true)).to_not match(/exit/)
        end

        it 'Services supervisor should be running' do
          expect(process('supervisord')).to be_running
        end
      end
    end
  end
end
