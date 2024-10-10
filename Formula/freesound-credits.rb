class FreesoundCredits < Formula
  desc "A simple command line utility to credit Freesound samples in a usable markdown file"
  homepage "https://gacallea.github.io/apps/freesound-credits"
  version "0.2.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gacallea/freesound-credits/releases/download/v0.2.17/freesound-credits-aarch64-apple-darwin.zip"
      sha256 "88d95522733143c04f866378d08e57aad55d16ed0f139c76565f23fec39d88ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gacallea/freesound-credits/releases/download/v0.2.17/freesound-credits-x86_64-apple-darwin.zip"
      sha256 "4a047c90ec156da532099aa408140dd507865425ba36ed1889cc842cf93a5a64"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/gacallea/freesound-credits/releases/download/v0.2.17/freesound-credits-x86_64-unknown-linux-gnu.zip"
      sha256 "175b2b619fc62c2e0da7715b6387f0252d8d1421235ff4e11fe8ec7acb056be5"
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
