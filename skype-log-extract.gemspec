Gem::Specification.new do |s|
  s.name          = 'skype-log-extract'
  s.version       = '0.0.1'
  s.license       = 'MIT'
  s.summary       = 'Extract logs from skype conversations'
  s.description   = 'skype-log-extract let\'s you extract conversation from the main.db file saved on your machine. The logs are saved as plain text files for easy processing.'

  s.authors       = ['Malte Rohde']
  s.email         = 'malte.rohde@inf.fu-berlin.de'
  s.homepage      = 'http://github.com/maltoe/skype-log-extract'

  s.require_paths = ['lib']
  s.files         = Dir.glob('lib/**/*.rb')
  s.executables   = ['skype-log-extract']

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'sqlite3', '~> 1.3'
  s.add_dependency 'highline', '~> 1.6'
  s.add_dependency 'nokogiri', '~> 1.6'
end
