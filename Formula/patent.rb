class Patent < Formula
  desc "A prior-art search for your code ideas — has this dev tool already been shipped?"
  homepage "https://github.com/r14dd/patent"
  version "0.14.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/r14dd/patent/releases/download/v0.14.0/patent-aarch64-apple-darwin.tar.xz"
    sha256 "003a38a52e111ab9bd05fdfdf6dab3deff52acf7e0f89c5259435aca4314d730"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/r14dd/patent/releases/download/v0.14.0/patent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6e6b90cc6c460cb43ffcc1aaf876700bc86f3ab3b4da1c7ffb3f9c8e96ae76a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/r14dd/patent/releases/download/v0.14.0/patent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "375c20f9f552571bcc85df944c6cf5d3165034bec9f8a3a63de992211c88e4ea"
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
