# gem install base58 しておく

require 'base58'
require_relative 'lib/key.rb'
require_relative 'lib/address.rb'

public_key_in_binary  = Pem.read('./keys/public_key.pem').to_der
my_address = Address.new(public_key_in_binary).address

puts "公開鍵からアドレスを作成しました　　　: #{my_address}"

# 計算コストが安いため、いくらでも生成できる
10.times do
  another_public_key  = KeyGenerator.new.public_key.to_der
  another_address = Address.new(another_public_key).address

  puts "公開鍵から新たなアドレスを作成しました: #{another_address}"
end
