def gen_UUID()
  prng = Random.new
  s = ""

  8.times { s << prng.rand(16).to_s(16) }
  s << '-'

  3.times do
    4.times { s << prng.rand(16).to_s(16) }
    s << '-'
  end

  12.times { s << prng.rand(16).to_s(16)}

  p s
end

gen_UUID()
  