$:.unshift(File.expand_path("../lib/", __FILE__))
require "lvm/attributes"

Gem::Specification.new do |gem|
  gem.authors       = ["Tim Smith", "Greg Symons", "Elan Ruusamäe", "Matthew Kent"]
  gem.email         = ["tsmith@chef.io", "mkent@magoazul.com", "gsymons@gsconsulting.biz"]
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
