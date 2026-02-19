class C4Daemon < Formula
  desc "Claude Code Control Center Terminal Daemon - Processes hooks and consumes user commands via Kafka messages"
  homepage "https://github.com/Cordona/claude-code-agent"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.3.4/c4-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "d7182d4bd7478b244777cad3f0c0b214821b33ebaedc42a93eb7c47e3e02aa00"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.3.4/c4-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "86a964fa156541577bfc35d6e7eb8af3ed78f3b0eae9f42010a11669981aafad"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.3.4/c4-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a12a666540c6decb73ebc405b646ff56b90233971ebc12840c23cf46ee36d53b"
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
