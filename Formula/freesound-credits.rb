class FreesoundCredits < Formula
  desc "A simple command line utility to credit Freesound samples in a usable markdown file"
  homepage "https://andreacfromtheapp.github.io/apps/freesound-credits"
  version "0.2.27"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.27/freesound-credits-aarch64-apple-darwin.zip"
      sha256 "5fd64e4c11857bf8acb3b7607f88aecfbce56ce58a24c007bd545b60c907a47a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.27/freesound-credits-x86_64-apple-darwin.zip"
      sha256 "ce9465d0e4d09256e98ee8cd846313a15924523cb4219316943a9596c669e92d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.27/freesound-credits-x86_64-unknown-linux-gnu.zip"
    sha256 "807b5f175950b24fb9fcd51b9f2c73dc72bd0edd8a4f4ce45b100b8cda76ddfb"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "freesound-credits" if OS.mac? && Hardware::CPU.arm?
    bin.install "freesound-credits" if OS.mac? && Hardware::CPU.intel?
    bin.install "freesound-credits" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
