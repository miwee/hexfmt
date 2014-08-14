defmodule HexfmtTest do
  use ExUnit.Case

  doctest Hexfmt

  test "encodes a binary to a hex binary" do
    assert Hexfmt.encode("This is a test.") == "54686973206973206120746573742E"
  end

  test "encodes a list to a hex binary" do
    assert Hexfmt.encode('This is a test.') == "54686973206973206120746573742E"
  end

  test "decodes to a binary from a hex binary" do
    assert Hexfmt.decode("54686973206973206120746573742E") == "This is a test."
  end

  test "decodes to a binary from a hex list" do
    assert Hexfmt.decode('54686973206973206120746573742E') == "This is a test."
  end

  test "encodes a list to a hex list" do
    assert Hexfmt.encode_to_list('This is a test.') == '54686973206973206120746573742E'
  end

  test "encodes a binary to a hex list" do
    assert Hexfmt.encode_to_list("This is a test.") == '54686973206973206120746573742E'
  end

  test "decodes to a list from a hex list" do
    assert Hexfmt.decode_to_list('54686973206973206120746573742E') == 'This is a test.'
  end

 test "decodes to a list from a hex binary" do
    assert Hexfmt.decode_to_list("54686973206973206120746573742E") == 'This is a test.'
  end

  test "converts hex list to an integer" do
    assert Hexfmt.to_integer('54686973206973206120746573742E') == 438270661302729020147902120434299950
  end

  test "converts hex binary to an integer" do
    assert Hexfmt.to_integer("54686973206973206120746573742E") == 438270661302729020147902120434299950
  end

  test "converts an integer to a hex binary" do
    assert Hexfmt.encode(123456) == "1E240"
  end

  test "converts an integer to a hex list" do
    assert Hexfmt.encode_to_list(123456) == '1E240'
  end
end
