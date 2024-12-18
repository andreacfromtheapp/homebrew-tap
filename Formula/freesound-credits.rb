class FreesoundCredits < Formula
  desc "A simple command line utility to credit Freesound samples in a usable markdown file"
  homepage "https://andreacfromtheapp.github.io/apps/freesound-credits"
  version "0.2.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.23/freesound-credits-aarch64-apple-darwin.zip"
      sha256 "8595681907ccbe89c45f7e7203ba9ffad48f46432750e99c46563b93057bbc48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.23/freesound-credits-x86_64-apple-darwin.zip"
      sha256 "c9be507a2514d78a5d89ef1e0cadc9dc3488334867b0e65777a42974a58a891c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.23/freesound-credits-x86_64-unknown-linux-gnu.zip"
    sha256 "8b2cddd52693750ebf886abf07bcf30f168d08092390132a94edafeb50343b1b"
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
