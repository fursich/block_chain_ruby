require_relative 'lib/key.rb'

private_key = Pem.read('./keys/private_key.pem')
public_key = Pem.read('./keys/public_key.pem')

# 正しいメッセージ

message   = '正しいメッセージだよ'
digest    = OpenSSL::Digest::SHA256.new.digest(message) # メッセージからハッシュを計算
signature = private_key.dsa_sign_asn1(digest) # ハッシュに秘密鍵をかける


# 受信者は送信者より下記のものを受け取る
# public_key 公開鍵（事前に受け取っている）
# message メッセージ本体
# signature 本人のメッセージであることを証明する署名

digest              = OpenSSL::Digest::SHA256.new.digest(message) # 受信者側でメッセージからハッシュを計算
verification_result = public_key.dsa_verify_asn1(digest, signature) # メッセージの真偽を確認

puts "メッセージ（正） 　　署名検証結果: #{verification_result}"


# 誰かがメッセージを改変した場合

message             += 'ケケケ'

# 受信者は送信者より下記のものを受け取る
# public_key 公開鍵（事前に受け取っている）
# message 改変されたメッセージ
# signature 本人のメッセージであることを証明する署名（そのまま）

digest              = OpenSSL::Digest::SHA256.new.digest(message) # 受信者側でメッセージからハッシュを計算
verification_result = public_key.dsa_verify_asn1(digest, signature) # メッセージの真偽を確認

puts "メッセージ（改変）　 署名検証結果: #{verification_result}"


# メッセージだけでなく署名を差し替えた場合

fake_private_key    = Pem.read('./keys/fake_private_key.pem') # 署名を作るために鍵を作成しなければならない
fake_public_key     = Pem.read('./keys/fake_public_key.pem')

fake_message        = '嘘メッセージだよん'

fake_digest         = OpenSSL::Digest::SHA256.new.digest(fake_message)
fake_signature      = fake_private_key.dsa_sign_asn1(fake_digest)


# 受信者は送信者より下記のものを受け取る
# public_key 公開鍵（事前に受け取っている）
# fake_message 偽造メッセージ本体
# fake_signature 偽造署名

digest              = OpenSSL::Digest::SHA256.new.digest(fake_message) # 受信者側でメッセージからハッシュを計算
verification_result = public_key.dsa_verify_asn1(digest, fake_signature) # メッセージの真偽を確認

puts "メッセージ（偽署名） 署名検証結果: #{verification_result}"

# 公開鍵も差し替えられた場合

# なお、公開鍵が送信者本人のものであるかどうかは別の手段で検証することが必要
# 公開鍵自体をすり替えられてしまった場合、偽メッセージを真だと判定しまう
# この方法は、メッセージが公開鍵（に対応する秘密鍵）の持ち主から発信されていることを検証しているだけにすぎない

# 受信者は送信者より下記のものを受け取る
# fake_public_key 公開鍵（すり替えられたもの）
# fake_message 偽造メッセージ本体
# fake_signature 偽造署名

digest               = OpenSSL::Digest::SHA256.new.digest(fake_message) # 受信者側でメッセージからハッシュを計算
verification_result  = fake_public_key.dsa_verify_asn1(digest, fake_signature) # メッセージの真偽を確認

puts "メッセージ（偽造鍵） 署名検証結果: #{verification_result}"
