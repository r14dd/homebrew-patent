class Patent < Formula
  desc "A prior-art search for your code ideas — has this dev tool already been shipped?"
  homepage "https://github.com/r14dd/patent"
  version "0.14.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/r14dd/patent/releases/download/v0.14.3/patent-aarch64-apple-darwin.tar.xz"
    sha256 "781fb3870ee29cee1921650fdbae6b4da44c71cf4de7d6f6769f42e3ce87524e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/r14dd/patent/releases/download/v0.14.3/patent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fb85ba7a7b894d3dd15498f2080d515eecf1df41c9a8440bae4ee0f49b7d402e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/r14dd/patent/releases/download/v0.14.3/patent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3af51932ae7935544b5e3352cf8493725772d821a518eae6a38fe8e706057658"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "patent"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "patent"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "patent"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
