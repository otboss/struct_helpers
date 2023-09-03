defmodule StructHelpersTest do
  use ExUnit.Case
  doctest StructHelpers

  test "greets the world" do
    assert StructHelpers.hello() == :world
  end
end
