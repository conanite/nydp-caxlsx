lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nydp/caxlsx/version"

Gem::Specification.new do |spec|
  spec.name          = "nydp-caxlsx"
  spec.version       = Nydp::Caxlsx::VERSION
  spec.authors       = ["conanite"]
  spec.email         = ["conan@conandalton.net"]

  spec.summary       = %q{nydp wrapper for caxlsx gem}
  spec.description   = %q{provides ability to generate excel/xls/xlsx spreadsheets from your lisp code}
  spec.homepage      = "https://github.com/conanite/nydp-caxlsx"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency             'nydp'
  spec.add_dependency             'caxlsx',   '~> 3'

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
