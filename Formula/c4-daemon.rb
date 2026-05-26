class C4Daemon < Formula
  desc "Claude Code Control Center Terminal Daemon - Processes hooks and consumes user commands via Kafka messages"
  homepage "https://github.com/Cordona/claude-code-agent"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.4.2/c4-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "98c6ca87de709e6715242e24538ff36280017d0f42b2e47b10ae2568d873cac4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.4.2/c4-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "cdeb6e76317b430b303af7471e7d14052e407cca2818644e5ab4796bfefb350d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Cordona/claude-code-agent/releases/download/v0.4.2/c4-daemon-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "abd44d70bcb6064922bcc62f9e8d556dd18068226751ea9efa2d585a1e2d8949"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "c4-daemon" if OS.mac? && Hardware::CPU.arm?
    bin.install "c4-daemon" if OS.mac? && Hardware::CPU.intel?
    bin.install "c4-daemon" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
