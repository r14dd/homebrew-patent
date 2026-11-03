class Patent < Formula
  desc "A prior-art search for your code ideas — has this dev tool already been shipped?"
  homepage "https://github.com/r14dd/patent"
  version "0.14.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/r14dd/patent/releases/download/v0.14.2/patent-aarch64-apple-darwin.tar.xz"
    sha256 "de8992145a2da31ec52fe1d3701139915c424a944b3422c1cf0d669264450f36"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/r14dd/patent/releases/download/v0.14.2/patent-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "209ab341b8e4a2127bb1f9e2ddeee5f61eb5adf115fba373db738460bb895511"
    end
    if Hardware::CPU.intel?
      url "https://github.com/r14dd/patent/releases/download/v0.14.2/patent-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "32b9f538eb099ac5398417615fd6df6df4d2f7778bda82bdae94d1379eb5f818"
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
