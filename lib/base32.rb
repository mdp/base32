class Base32
  CHARS = "abcdefghijklmnopqrstuvwxyz234567".each_char.to_a
  PAD = ['', '======', '====', '===', '=']

  class << self
    def decode(str)
      output = ''
      str.scan(/.{8}/).each do |block|
        char_array = decode_block(block).map{|c| c.chr}
        output << char_array.join
      end
      output
    end

    def encode(str)
      #Not implemented
      output = ''
      str.scan(/.{5}/).each do |block|
        output <<  encode_block(block).join
      end
      output
    end

    private

    def decode_block(block)
      return 0 unless (block.length % 8 == 0) || (block.length == 0)
      length = block.scan(/[^=]/).length
      quints = block.each_char.map {|c| decode_quint(c)}
      bytes = []
      bytes[0] = (quints[0] << 3) + (quints[1] >> 2)
      return bytes if length < 3
      bytes[1] = ((quints[1] & 3) << 6) + (quints[2] << 1) + (quints[3] >> 4)
      return bytes if length < 5
      bytes[2] = ((quints[3] & 7) << 4) + (quints[4] >> 1)
      return bytes if length < 6
      bytes[3] = ((quints[4] & 1) << 7) + (quints[5] << 2) + (quints[6] >> 3)
      bytes[4] = ((quints[6] & 3) << 5) + quints[7]
      bytes
    end

    def encode_block(block)
      length = block.length
      padding = PAD[length % 5]
      bytes = block.each_byte.to_a
      quints = []
      quints[0] = bytes[0] >> 3
      quints[1] = bytes[0] & 7
      b[0] = (quints[0] << 3) + (quints[1] >> 2)
      return bytes if length < 3
      bytes[1] = ((quints[1] & 3) << 6) + (quints[2] << 1) + (quints[3] >> 4)
      return bytes if length < 5
      bytes[2] = ((quints[3] & 7) << 4) + (quints[4] >> 1)
      return bytes if length < 6
      bytes[3] = ((quints[4] & 1) << 7) + (quints[5] << 2) + (quints[6] >> 3)
      bytes[4] = ((quints[6] & 3) << 5) + quints[7]
      bytes
    end

    def decode_quint(q)
      CHARS.index(q.downcase)
    end

    def encode_quint(bits)
      CHARS[bits]
    end

  end

end
