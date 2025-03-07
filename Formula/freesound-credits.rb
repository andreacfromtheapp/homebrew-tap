class FreesoundCredits < Formula
  desc "A simple command line utility to credit Freesound samples in a usable markdown file"
  homepage "https://andreacfromtheapp.github.io/apps/freesound-credits"
  version "0.2.28"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.28/freesound-credits-aarch64-apple-darwin.zip"
      sha256 "0561d20e8da423cb09f3cc6080d0d0ce491b2f063243cb4e4fe10cc4ef4f7612"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.28/freesound-credits-x86_64-apple-darwin.zip"
      sha256 "fa3cf3e3fc431909c9e2e935d30264a52c1afb875ce9d11624c5ee28579cce88"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.28/freesound-credits-x86_64-unknown-linux-gnu.zip"
    sha256 "1dda3362e0b39cb2b3f47d979e0fb24033c63c464c783404562d29ce72058995"
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
