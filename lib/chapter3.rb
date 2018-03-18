
require 'base58'
require './common.rb'

public_key  = Pem.read('./keys/public_key.pem').to_der


digest =  OpenSSL::Digest::RIPEMD160.digest(
            OpenSSL::Digest::SHA256.new.digest(public_key)
          )
          .insert(
            0,
            ['6F'].pack('H2')  # ここで00を入れると公開鍵ハッシュになる
          )

check_sum = OpenSSL::Digest::SHA256.new.digest(
            OpenSSL::Digest::SHA256.new.digest(
              digest
            )
          ).unpack('H4').pack('H4') # 先頭４バイト

digest += check_sum
my_address = Base58.binary_to_base58(digest, :bitcoin) # Base58は複数の定義が存在する（bitcoin仕様とあわせる）

puts "公開鍵からアドレスを作成しました: #{my_address}"


