require 'rake'
require 'rake/testtask'
require 'rake/gempackagetask'

task :default => :test

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  t.libs += ['test', 'lib']
end

Gem::manage_gems

specification = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
	s.name   = "test_warning"
  s.summary = "Adds support for warnings (non-fatal errors) to test unit"
	s.version = "0.1.0"
	s.author = "David Vollbracht"
	s.description = s.summary
	s.email = "david.vollbracht@gmail.com"
  s.homepage = "http://test-warning.rubyforge.org"
  s.rubyforge_project = "test_warning"
  s.files = FileList['{lib,test}/**/*.{rb}', 'Rakefile'].to_a
end

Rake::GemPackageTask.new(specification) do |package|
  package.need_zip = true
  package.need_tar = true
end

Rake::Task[:gem].prerequisites.unshift :test

task :tar do
  system "tar zcf pkg/test_warning.tar.gz --exclude=.git --exclude='*.tar.gz' --exclude='*.gem' --directory=.. test_warning"
end
