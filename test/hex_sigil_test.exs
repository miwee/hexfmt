defmodule HexSigilTest do
  use ExUnit.Case

  import HexSigil

  test "~h converts hex to binary" do
    assert ~h{12345678} == <<0x12, 0x34, 0x56, 0x78>>
  end

  test "~h{}l converts hex to list" do
    assert ~h{12345678}l == [0x12, 0x34, 0x56, 0x78]
  end

  test "~h converts hex to binary. handles spaces also" do
    assert ~h{12 34 56 78} == <<0x12, 0x34, 0x56, 0x78>>
  end

  test "~h{}x encodes decimal number sequence to binary" do
    assert ~h{18, 52, 86, 120}x == "12345678"
  end

  test "~h{}x encodes hex number sequence to binary" do
    assert ~h{0x12, 0x34, 0x56, 0x78}x == "12345678"
  end

end
