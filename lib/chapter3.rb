
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

# 検証用
# https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses#How_to_create_Bitcoin_Address

public_key = ['0450863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B23522CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6'].pack('H*')

digest =  OpenSSL::Digest::SHA256.new.digest(public_key)

puts "digest: #{digest.unpack('H*').inspect}"

digest =  OpenSSL::Digest::RIPEMD160.digest(
            digest
          )

puts "digest: #{digest.unpack('H*').inspect}"

digest.insert(
            0,
            ['00'].pack('H2')  # ここで00を入れると公開鍵ハッシュになる
          )


puts "digest with version byte: #{digest.unpack('H*').inspect}"

check_sum = OpenSSL::Digest::SHA256.new.digest(
            OpenSSL::Digest::SHA256.new.digest(
              digest
            )
          ).unpack('H8').pack('H8') # 先頭４バイト

puts "check sum: #{check_sum.unpack('H*').inspect}"

digest += check_sum
my_address = Base58.binary_to_base58(digest, :bitcoin) # Base58は複数の定義が存在する（bitcoin仕様とあわせる）

puts "公開鍵からアドレスを作成しました: #{my_address}"


