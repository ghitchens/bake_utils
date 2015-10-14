defmodule BakeUtils do
  @working_dir File.cwd! <> "/_bake"
  @bake_home "~/.bake"

  def create_working_dir do
    File.mkdir @working_dir
  end

  def working_dir do
    @working_dir
  end

  def bake_home do
    Path.expand(System.get_env("BAKE_HOME") || @bake_home)
  end

  def daemon_pid do
    bake_home <> "/daemon.pid"
  end

  def oven_dir do
    bake_home <> "/oven"
  end
end
