class C4Daemon < Formula
  desc "Claude Code Control Center Terminal Daemon - Processes hooks and consumes user commands via Kafka messages"
  homepage "https://github.com/Cordona/claude-code-agent"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.4.4/c4-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "84d670ca98799c8f06b3036df9e0cd1f2771b712f402c9e50231fbf1051eb00f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.4.4/c4-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "3b703d2423d13579961e844e05ef2ee417dbfcdda5b2997558b7247c025a259d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Cordona/claude-code-agent/releases/download/v0.4.4/c4-daemon-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7ad6ca4e17ebf1e2feed609535f2592a8acee0a1e094ad7275933c674d6a596a"
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
