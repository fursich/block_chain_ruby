require './common.rb'
require 'fileutils'

FileUtils.mkdir_p './keys'

my_key = KeyGenerator.new
my_key.save_private_key!('keys/private_key.pem')
my_key.save_public_key!('keys/public_key.pem')

fake_key = KeyGenerator.new
fake_key.save_private_key!('keys/fake_private_key.pem')
fake_key.save_public_key!('keys/fake_public_key.pem')


