class C4Daemon < Formula
  desc "Claude Code Control Center Terminal Daemon - Processes hooks and consumes user commands via Kafka messages"
  homepage "https://github.com/Cordona/claude-code-agent"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.4.3/c4-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "673075088f033d2d2a145760ba3e8ec2766b2ef0031390e7801ac019385cbb15"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cordona/claude-code-agent/releases/download/v0.4.3/c4-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "3d03a29781745aa62a940f05cce4ce9a897bed7078aaab616624a4e358aa3469"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Cordona/claude-code-agent/releases/download/v0.4.3/c4-daemon-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f2457da93c18a1b9737f742949fb03318b96ed006d473b67d8286a1b2cbb5313"
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
