defmodule EchoTest do
  use ExUnit.Case

  def send_msg(pid, mesg) do
    send(pid, mesg)
  end

  test "echo" do
    assert send_msg(self(), "bla") == "bla"
  end
end
