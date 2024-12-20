class FreesoundCredits < Formula
  desc "A simple command line utility to credit Freesound samples in a usable markdown file"
  homepage "https://andreacfromtheapp.github.io/apps/freesound-credits"
  version "0.2.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.24/freesound-credits-aarch64-apple-darwin.zip"
      sha256 "91b934ad60cbd5b6009b7f30cad05dc03a6ef608967578b612c0f15e70d2cbec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.24/freesound-credits-x86_64-apple-darwin.zip"
      sha256 "656f7649b2a91830c508e9575456ce67492e1dd825859e40d557a5ec8d7d1a6c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.24/freesound-credits-x86_64-unknown-linux-gnu.zip"
    sha256 "a0d0f2ad48947bcad02d49dad108375618e02b60d7581c09057ee9bb0359c684"
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
