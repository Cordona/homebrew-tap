class C4Daemon < Formula
  desc "Claude Code Control Center Terminal Daemon - Processes hooks and consumes user commands via Kafka messages"
  homepage "https://github.com/Cordona/claude-code-agent"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.3.2/c4-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "7d6ffd657fb4cd9dafb674dbc9e13324f49f1ae83d2772cc2f6f44fce2f8c395"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.3.2/c4-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "ec77d2cabdc2465ace741c7f7d78213d67470807c6090540ce56d8abcb01f30c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.3.2/c4-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "348be6e0526e196e83c6ece2874414a7202af2fa2b2b8321afcde081495fd2fc"
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
