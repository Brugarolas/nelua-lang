require 'busted.runner'()

local assert = require 'spec.tools.assert'
local bn = require 'nelua.utils.bn'

local n = bn.new
local d = bn.fromdec
local h = bn.fromhex
local b = bn.frombin

describe("Nelua BN should work for", function()

it("regular number conversion", function()
  assert.is.same(n(0):tonumber(), 0)
  assert.is.same(n(1):tonumber(), 1)
  assert.is.same(n(-1):tonumber(), -1)
  assert.is.same(n(123456789):tonumber(), 123456789)
  assert.is.same(n(0.123456789):tonumber(), 0.123456789)
  assert.is.same(n(12345.6789):tonumber(), 12345.6789)
end)

it("decimal number conversion", function()
  assert.is.same(d'0', n(0))
  assert.is.same(d'1', n(1))
  assert.is.same(d'-1', n(-1))
  assert.is.same(d'4096', n(4096))
  assert.is.same(d'65536', n(65536))
  assert.is.same(d'12345.6789':todec(), '12345.6789')
  assert.is.same(d'-12345.6789':todec(), '-12345.6789')

  assert.is.equal('0', n(0):todec())
  assert.is.equal('0', n(-0):todec())
  assert.is.equal('1', n(1):todec())
  assert.is.equal('-1',n(-1):todec())
  assert.is.equal('0.5', n(0.5):todec())
  assert.is.equal('-0.5', n(-0.5):todec())
  assert.is.equal('0.30000000000000004', n(.1+.2):todec())
  assert.is.equal('0.30000000000000002', (n(.1)+n(.2)):todec())
  assert.is.equal('0.3',(n('.1')+n('.2')):todec())
  assert.is.equal('1000', n(1000):todec())
end)

it("hexadecimal conversion", function()
  assert.is.same(h'0', n(0))
  assert.is.same(h'-0', n(0))
  assert.is.same(h'1', n(1))
  assert.is.same(h'-1', n(-1))
  assert.is.same(h'1234567890', n(0x1234567890))
  assert.is.same(h'abcdef', n(0xabcdef))
  assert.is.same(h'ffff', n(0xffff))
  assert.is.same(h'-ffff', n(-0xffff))
  assert.is.same(h'ffffffffffffffff', d'18446744073709551615')
  assert.is.same(h'-ffffffffffffffff', d'-18446744073709551615')

  assert.is.same(h'1234567890abcdef':tohex(), '1234567890abcdef')
  assert.is.same(h'0':tohex(), '0')
  assert.is.same(h'ffff':tohex(), 'ffff')
  assert.is.same(h'-ffff':tohex(), '-ffff')
end)

it("binary conversion", function()
  assert.is.same(b'0', n(0))
  assert.is.same(b'1', n(1))
  assert.is.same(b'10', n(2))
  assert.is.same(b'11', n(3))
  assert.is.same(b'-11', n(-3))
  assert.is.same(b'11111111', n(255))
  assert.is.same(b'100000000', n(256))
end)

it("scientific notation", function()
  assert.is.equal('0.14285714285714285', (n(1)/ n(7)):todecsci(17))
  assert.is.equal('1.4285714285714285', (n(10)/ n(7)):todecsci(17))
  assert.is.equal('-0.14285714285714285', (n(-1)/ n(7)):todecsci(17))
  assert.is.equal('-1.4285714285714285', (n(-10)/ n(7)):todecsci(17))
  assert.is.equal('14.285714285714285', (n(100)/ n(7)):todecsci(17))
  assert.is.equal('-14.285714285714285', (n(-100)/ n(7)):todecsci(17))
  assert.is.equal('0.014285714285714285', (n('0.1')/ n(7)):todecsci(17))
  assert.is.equal('-0.014285714285714285', (n('-0.1')/ n(7)):todecsci(17))
  assert.is.equal('0.0001', n(0.0001):todecsci())
  assert.is.equal('1.0000000000000001e-05', n('0.00001'):todecsci())
  assert.is.equal('0.0001', n(0.0001):todecsci())
  assert.is.equal('1.4285714285714285e-05', (n(1) / n(70000)):todecsci())
  assert.is.equal('1.4285714285714285e-05', n(1 / 70000):todecsci())
end)

it("floor operation", function()
  assert.is.same(d'0', d'0':floor())
  assert.is.same(d'0', d'0.1':floor())
  assert.is.same(d'0', d'0.9':floor())
  assert.is.same(d'0', d'-0':floor())
  assert.is.same(d'-1', d'-0.1':floor())
  assert.is.same(d'-1', d'-0.9':floor())
  assert.is.same(d'1', d'1.1':floor())
  assert.is.same(d'1', d'1.9':floor())
  assert.is.same(d'-2', d'-1.1':floor())
  assert.is.same(d'-2', d'-1.9':floor())
end)

it("bor operation", function()
  local bop = bn.bor
  assert.is.same(b'0',  bop(b'0', b'0', 1))
  assert.is.same(b'1',  bop(b'0', b'1', 1))
  assert.is.same(b'1',  bop(b'1', b'0', 1))
  assert.is.same(b'1',  bop(b'1', b'1', 1))

  assert.is.same(b'00', bop(b'00',b'00', 2))
  assert.is.same(b'01', bop(b'00',b'01', 2))
  assert.is.same(b'10', bop(b'00',b'10', 2))
  assert.is.same(b'11', bop(b'00',b'11', 2))
  assert.is.same(b'01', bop(b'01',b'00', 2))
  assert.is.same(b'01', bop(b'01',b'01', 2))
  assert.is.same(b'11', bop(b'01',b'10', 2))
  assert.is.same(b'11', bop(b'01',b'11', 2))
  assert.is.same(b'10', bop(b'10',b'00', 2))
  assert.is.same(b'11', bop(b'10',b'01', 2))
  assert.is.same(b'10', bop(b'10',b'10', 2))
  assert.is.same(b'11', bop(b'10',b'11', 2))
  assert.is.same(b'11', bop(b'11',b'00', 2))
  assert.is.same(b'11', bop(b'11',b'01', 2))
  assert.is.same(b'11', bop(b'11',b'10', 2))
  assert.is.same(b'11', bop(b'11',b'11', 2))

  assert.is.same(b'0', bop(b'0',b'0',2))
  assert.is.same(b'1', bop(b'0',b'1',2))
  assert.is.same(b'10', bop(b'0',b'10',2))
  assert.is.same(b'11', bop(b'0',b'11',2))
  assert.is.same(b'1', bop(b'1',b'0',2))
  assert.is.same(b'1', bop(b'1',b'1',2))
  assert.is.same(b'11', bop(b'1',b'10',2))
  assert.is.same(b'11', bop(b'1',b'11',2))
  assert.is.same(b'10', bop(b'10',b'0',2))
  assert.is.same(b'11', bop(b'10',b'1',2))
  assert.is.same(b'10', bop(b'10',b'10',2))
  assert.is.same(b'11', bop(b'10',b'11',2))
  assert.is.same(b'11', bop(b'11',b'0',2))
  assert.is.same(b'11', bop(b'11',b'1',2))
  assert.is.same(b'11', bop(b'11',b'10',2))
  assert.is.same(b'11', bop(b'11',b'11',2))

  assert.is.same(b'11111111', bop(b'10101010',b'01010101',8))
  assert.is.same(b'11110101', bop(b'11110000',b'01010101',8))
end)

it("band operation", function()
  local bop = bn.band
  assert.is.same(b'0',  bop(b'0', b'0', 1))
  assert.is.same(b'0',  bop(b'0', b'1', 1))
  assert.is.same(b'0',  bop(b'1', b'0', 1))
  assert.is.same(b'1',  bop(b'1', b'1', 1))

  assert.is.same(b'00', bop(b'00',b'00', 2))
  assert.is.same(b'00', bop(b'00',b'01', 2))
  assert.is.same(b'00', bop(b'00',b'10', 2))
  assert.is.same(b'00', bop(b'00',b'11', 2))
  assert.is.same(b'00', bop(b'01',b'00', 2))
  assert.is.same(b'01', bop(b'01',b'01', 2))
  assert.is.same(b'00', bop(b'01',b'10', 2))
  assert.is.same(b'01', bop(b'01',b'11', 2))
  assert.is.same(b'00', bop(b'10',b'00', 2))
  assert.is.same(b'00', bop(b'10',b'01', 2))
  assert.is.same(b'10', bop(b'10',b'10', 2))
  assert.is.same(b'10', bop(b'10',b'11', 2))
  assert.is.same(b'00', bop(b'11',b'00', 2))
  assert.is.same(b'01', bop(b'11',b'01', 2))
  assert.is.same(b'10', bop(b'11',b'10', 2))
  assert.is.same(b'11', bop(b'11',b'11', 2))

  assert.is.same(b'0', bop(b'0',b'0',2))
  assert.is.same(b'0', bop(b'0',b'1',2))
  assert.is.same(b'0', bop(b'0',b'10',2))
  assert.is.same(b'0', bop(b'0',b'11',2))
  assert.is.same(b'0', bop(b'1',b'0',2))
  assert.is.same(b'1', bop(b'1',b'1',2))
  assert.is.same(b'0', bop(b'1',b'10',2))
  assert.is.same(b'1', bop(b'1',b'11',2))
  assert.is.same(b'0', bop(b'10',b'0',2))
  assert.is.same(b'0', bop(b'10',b'1',2))
  assert.is.same(b'10', bop(b'10',b'10',2))
  assert.is.same(b'10', bop(b'10',b'11',2))
  assert.is.same(b'0', bop(b'11',b'0',2))
  assert.is.same(b'1', bop(b'11',b'1',2))
  assert.is.same(b'10', bop(b'11',b'10',2))
  assert.is.same(b'11', bop(b'11',b'11',2))

  assert.is.same(b'00000000', bop(b'10101010',b'01010101',8))
  assert.is.same(b'01010000', bop(b'11110000',b'01010101',8))
end)

it("bxor operation", function()
  local bop = bn.bxor
  assert.is.same(b'0',  bop(b'0', b'0', 1))
  assert.is.same(b'1',  bop(b'0', b'1', 1))
  assert.is.same(b'1',  bop(b'1', b'0', 1))
  assert.is.same(b'0',  bop(b'1', b'1', 1))

  assert.is.same(b'00', bop(b'00',b'00', 2))
  assert.is.same(b'01', bop(b'00',b'01', 2))
  assert.is.same(b'10', bop(b'00',b'10', 2))
  assert.is.same(b'11', bop(b'00',b'11', 2))
  assert.is.same(b'01', bop(b'01',b'00', 2))
  assert.is.same(b'00', bop(b'01',b'01', 2))
  assert.is.same(b'11', bop(b'01',b'10', 2))
  assert.is.same(b'10', bop(b'01',b'11', 2))
  assert.is.same(b'10', bop(b'10',b'00', 2))
  assert.is.same(b'11', bop(b'10',b'01', 2))
  assert.is.same(b'00', bop(b'10',b'10', 2))
  assert.is.same(b'01', bop(b'10',b'11', 2))
  assert.is.same(b'11', bop(b'11',b'00', 2))
  assert.is.same(b'10', bop(b'11',b'01', 2))
  assert.is.same(b'01', bop(b'11',b'10', 2))
  assert.is.same(b'00', bop(b'11',b'11', 2))

  assert.is.same(b'0', bop(b'0',b'0', 2))
  assert.is.same(b'1', bop(b'0',b'1', 2))
  assert.is.same(b'10', bop(b'0',b'10', 2))
  assert.is.same(b'11', bop(b'0',b'11', 2))
  assert.is.same(b'1', bop(b'1',b'0', 2))
  assert.is.same(b'0', bop(b'1',b'1', 2))
  assert.is.same(b'11', bop(b'1',b'10', 2))
  assert.is.same(b'10', bop(b'1',b'11', 2))
  assert.is.same(b'10', bop(b'10',b'0', 2))
  assert.is.same(b'11', bop(b'10',b'1', 2))
  assert.is.same(b'0', bop(b'10',b'10', 2))
  assert.is.same(b'1', bop(b'10',b'11', 2))
  assert.is.same(b'11', bop(b'11',b'0', 2))
  assert.is.same(b'10', bop(b'11',b'1', 2))
  assert.is.same(b'1', bop(b'11',b'10', 2))
  assert.is.same(b'0', bop(b'11',b'11', 2))

  assert.is.same(b'11111111', bop(b'10101010',b'01010101',8))
  assert.is.same(b'10100101', bop(b'11110000',b'01010101',8))
end)

it("bnot operation", function()
  local bop = bn.bnot
  assert.is.same(b'1',  bop(b'0', 1))
  assert.is.same(b'0',  bop(b'1', 1))
  assert.is.same(b'11',  bop(b'00', 2))
  assert.is.same(b'10',  bop(b'01', 2))
  assert.is.same(b'01',  bop(b'10', 2))
  assert.is.same(b'00',  bop(b'11', 2))
end)

it("lshift operation", function()
  local bop = bn.lshift
  assert.is.same(b'0',  bop(b'0', 0, 8))
  assert.is.same(b'0',  bop(b'0', 1, 8))
  assert.is.same(b'01',  bop(b'1', 0, 8))
  assert.is.same(b'10',  bop(b'1', 1, 8))
  assert.is.same(b'100',  bop(b'1', 2, 8))
  assert.is.same(b'11',  bop(b'11', 0, 8))
  assert.is.same(b'110',  bop(b'11', 1, 8))
  assert.is.same(b'1100',  bop(b'11', 2, 8))
  assert.is.same(b'101',  bop(b'101', 0, 8))
  assert.is.same(b'1010',  bop(b'101', 1, 8))
  assert.is.same(b'10100',  bop(b'101', 2, 8))
end)

it("rshift operation", function()
  local bop = bn.rshift
  assert.is.same(b'0',  bop(b'0', 0, 8))
  assert.is.same(b'0',  bop(b'0', 1, 8))
  assert.is.same(b'1',  bop(b'1', 0, 8))
  assert.is.same(b'0',  bop(b'1', 1, 8))
  assert.is.same(b'0',  bop(b'1', 2, 8))
  assert.is.same(b'11',  bop(b'11', 0, 8))
  assert.is.same(b'1',  bop(b'11', 1, 8))
  assert.is.same(b'0',  bop(b'11', 2, 8))
  assert.is.same(b'101',  bop(b'101', 0, 8))
  assert.is.same(b'10',  bop(b'101', 1, 8))
  assert.is.same(b'1',  bop(b'101', 2, 8))
end)

it("revert shift operations", function()
  local bop = bn.rshift
  assert.is.same(b'0',  bop(b'0', -0, 8))
  assert.is.same(b'0',  bop(b'0', -1, 8))
  assert.is.same(b'01',  bop(b'1', -0, 8))
  assert.is.same(b'10',  bop(b'1', -1, 8))
  assert.is.same(b'100',  bop(b'1', -2, 8))
  assert.is.same(b'11',  bop(b'11', -0, 8))
  assert.is.same(b'110',  bop(b'11', -1, 8))
  assert.is.same(b'1100',  bop(b'11', -2, 8))
  assert.is.same(b'101',  bop(b'101', -0, 8))
  assert.is.same(b'1010',  bop(b'101', -1, 8))
  assert.is.same(b'10100',  bop(b'101', -2, 8))
  bop = bn.lshift
  assert.is.same(b'0',  bop(b'0', -0, 8))
  assert.is.same(b'0',  bop(b'0', -1, 8))
  assert.is.same(b'1',  bop(b'1', -0, 8))
  assert.is.same(b'0',  bop(b'1', -1, 8))
  assert.is.same(b'0',  bop(b'1', -2, 8))
  assert.is.same(b'11',  bop(b'11', -0, 8))
  assert.is.same(b'1',  bop(b'11', -1, 8))
  assert.is.same(b'0',  bop(b'11', -2, 8))
  assert.is.same(b'101',  bop(b'101', -0, 8))
  assert.is.same(b'10',  bop(b'101', -1, 8))
  assert.is.same(b'1',  bop(b'101', -2, 8))
end)

it("binary normalization operation", function()
  local bop = bn.bnorm
  -- wrap arround
  assert.is.same(b'0',  bop(b'00', 1))
  assert.is.same(b'1',  bop(b'01', 1))
  assert.is.same(b'0',  bop(b'10', 1))
  assert.is.same(b'1',  bop(b'11', 1))
  assert.is.same(d'1',  bop(d'257', 8))
  assert.is.same(d'2',  bop(d'258', 8))
  assert.is.same(h'ffff',  bop(h'ffffffff', 16))

  -- two complements
  assert.is.same(b'1',  bop(b'1', 8))
  assert.is.same(b'0',  bop(b'0', 8))
  assert.is.same(b'1100',  bop(b'-0100', 4))
  assert.is.same(b'0100',  bop(b'-1100', 4))
  assert.is.same(b'11111111',  bop(b'-1', 8))
  assert.is.same(b'00000001',  bop(b'-11111111', 8))
  assert.is.same(d'161',  bop(d'-95', 8))
  assert.is.same(d'95',  bop(d'-161', 8))
  assert.is.same(h'ffffffff',  bop(d'-1', 32))
  assert.is.same(h'ffffffffffffffff',  bop(d'-1', 64))
end)

end)
