# hexfmt
Hex formatter and ~h sigil for Elixir

Based on work by https://github.com/rjsamson/hex

Changed the name to avoid conflict with https://hex.pm

### Hex Formatter

Returns a hex encoded binary from a list, binary or integer.

```elixir 
iex> HexFmt.encode("12345678")
"3132333435363738"

iex> HexFmt.encode(12345678)
"bc614e"
```

Returns a decoded binary from a hex string

```elixir 
iex> HexFmt.decode("3132333435363738")
"12345678"
```

Returns a hex string visual representation of a given list or binary. No need to insert leading '0', just to see the contents of a list. 

```elixir 
iex> HexFmt.hexify(<<18, 52, 86, 120>>)
"<<0x12, 0x34, 0x56, 0x78>>"

iex> HexFmt.hexify('1!')
"[0x31, 0x21]"
```

### `~h` Sigil

```elixir 
iex> import HexSigil
nil
```

takes a String containing hex characters [0..9, A..F], 
and converts it into an Elixir binary of 8-bit hex numbers

```elixir 
iex> ~h{12345678}
<<18, 52, 86, 120>>
```

takes a String in form of comma seperated values, and converts it into an String containing hex characters [0..9, A..F] 

```elixir 
iex> ~h{18, 52, 86, 120}x
"12345678"
```



