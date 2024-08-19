class FreesoundCredits < Formula
  desc "A simple command line utility to credit Freesound samples in a usable markdown file"
  homepage "https://gacallea.github.io/apps/freesound-credits"
  version "0.2.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gacallea/freesound-credits/releases/download/v0.2.15/freesound-credits-aarch64-apple-darwin.zip"
      sha256 "bc7082d28c8434e70f2565dc2a64eda1cb43d5f5b686230dd754c06118ebfed3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gacallea/freesound-credits/releases/download/v0.2.15/freesound-credits-x86_64-apple-darwin.zip"
      sha256 "6a26ed4681e81edb3dc0f832bd3ab185e0a0ea97218645ebd825ce8a3fdcb5a0"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/gacallea/freesound-credits/releases/download/v0.2.15/freesound-credits-x86_64-unknown-linux-gnu.zip"
      sha256 "6a3132c78c03b9e7dc2734d65c80acc66ecfa62fe0ea2c108704a17c10d729a0"
    end
  end
  license "MIT OR Apache-2.0"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "aarch64-pc-windows-gnu": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}, "x86_64-unknown-linux-musl-dynamic": {}, "x86_64-unknown-linux-musl-static": {}}

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
      bin.install "freesound-credits"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "freesound-credits"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "freesound-credits"
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
