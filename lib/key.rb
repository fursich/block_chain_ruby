# 事前に gem install openssl しておく

gem 'openssl' # ruby標準のopensslを使わないため必要
require 'openssl'

class KeyGenerator
  def initialize
    generate_private_key!
  end

  def public_key
    @public_key ||= generate_public_key!
  end

  def save_private_key!(file)
    File.open(file, 'w') { |f| f.puts @private_key.to_pem}
  end

  def save_public_key!(file)
    File.open(file, 'w') { |f| f.puts public_key.to_pem}
  end

  private

  # 楕円曲線Secp256k1によるEC秘密鍵作成
  def generate_private_key!
    @private_key = OpenSSL::PKey::EC.new("secp256k1").generate_key
  end

  # 公開鍵は秘密鍵インスタンスと同じオブジェクトで、private_key = nilとすると作成できる
  def generate_public_key!
    @private_key
    public_key = @private_key.dup
    public_key.private_key = nil
    public_key
  end

end

module Pem
  module_function

  def read(file)
    ::OpenSSL::PKey::EC.new File.read(file)
  end
end
