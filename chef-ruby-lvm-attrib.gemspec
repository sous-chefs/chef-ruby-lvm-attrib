$:.unshift(File.expand_path("../lib/", __FILE__))
require "lvm/attributes"

Gem::Specification.new do |gem|
  gem.authors       = ["Chef Software"]
  gem.email         = ["oss@chef.io"]
  gem.description   = "A list of attributes for LVM objects"
  gem.license       = "MIT"
  gem.summary       = "A list of attributes for LVM objects"
  gem.homepage      = "https://github.com/chef/chef-ruby-lvm-attrib"
  gem.executables   = ["generate_field_data"]

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "chef-ruby-lvm-attrib"
  gem.require_paths = ["lib"]
  gem.version       = LVM::Attributes::VERSION
end
