# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2016 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fileutils'
require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/jre'

module JavaBuildpack
  module Jre

    # Encapsulates the detect, compile, and release functionality for the jvmkill agent
    class JvmkillAgent < JavaBuildpack::Component::VersionedDependencyComponent
      include JavaBuildpack::Util

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        download(@version, @uri) do |file|
          puts "FileUtils.mkdir_p : #{jvmkill_agent.parent}"
          FileUtils.mkdir_p jvmkill_agent.parent
          copy_agent file
          jvmkill_agent.chmod 0755
        end
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        # @droplet.java_opts.add_agentpath(jvmkill_agent)
        # @droplet.java_opts.add_agentpath_with_props(jvmkill_agent, 'printHeapHistogram' => '1')
        # @droplet.java_opts.add_agentpath_with_props(jvmkill_agent, {'printHeapHistogram' => '1', 'time' => '10'})
      end

      protected

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      def supports?
        true
      end

      private

      def copy_agent(file)
        puts "copy_agent from cache path : #{file.path}"
        puts "copy_agent to target path : #{jvmkill_agent}"
        puts "target jvmkill_agent bin/jvmkill-#{@version}"
        FileUtils.cp(file.path, jvmkill_agent)
      end

      def jvmkill_agent
        @droplet.sandbox + "bin/jvmkill-#{@version}"
      end

    end

  end
end
