class Patent < Formula
  desc "A prior-art search for your code ideas — has this dev tool already been shipped?"
  homepage "https://github.com/r14dd/patent"
  version "0.14.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/r14dd/patent/releases/download/v0.14.1/patent-aarch64-apple-darwin.tar.xz"
    sha256 "6703fc8a0830b82704ef75f598442103e285641c2c9ce3de6926a993f3e41dac"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/r14dd/patent/releases/download/v0.14.1/patent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0901410df7d48147ba0e38fd2abe935aa8bf2d713e1814f33d821a4e0db92917"
    end
    if Hardware::CPU.intel?
      url "https://github.com/r14dd/patent/releases/download/v0.14.1/patent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8157a81f8390d3815ee233e9640ec6c4224ab65ca98b8bfb0fcbd560dbc3998d"
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
