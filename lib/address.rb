
gem 'openssl' # ruby標準のopensslを使わないため必要
require 'openssl'
# gem install base58 しておく
require 'base58'

# 現在はpubkey hash形式のアドレスのみ
class Address
  PREFIX = {
    pubkey_hash:      '00', #	Pubkey hash (P2PKH address)
    test_pubkey_hash: '6F', # Testnet pubkey hash
  }

  def initialize(public_key_in_binary, type: :test_pubkey_hash)
    @public_key = public_key_in_binary
    @type = type
  end

  def address
    Base58.binary_to_base58(address_in_binary, :bitcoin) # Base58は複数の定義が存在する（bitcoin仕様とあわせる）
  end

  class << self
    def prefix(type)
      [ PREFIX[type] ].pack('H2')
    end

    def hash160(arg)
      OpenSSL::Digest::RIPEMD160.digest(OpenSSL::Digest::SHA256.digest(arg))
    end

    def double_sha256(arg)
      OpenSSL::Digest::SHA256.digest(OpenSSL::Digest::SHA256.digest(arg))
    end
  end

  private

  def hash160
    self.class.hash160(@public_key)
  end

  def hash160_with_prefix
    hash160.insert(0, self.class.prefix(@type))
  end

  def check_sum
    self.class.double_sha256(hash160_with_prefix).unpack('H4').pack('H4') # 先頭４バイト
  end

  def address_in_binary
    hash160_with_prefix + check_sum
  end
end
