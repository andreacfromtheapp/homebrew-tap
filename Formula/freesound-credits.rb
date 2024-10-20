class FreesoundCredits < Formula
  desc "A simple command line utility to credit Freesound samples in a usable markdown file"
  homepage "https://andreacfromtheapp.github.io/apps/freesound-credits"
  version "0.2.19"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.19/freesound-credits-aarch64-apple-darwin.zip"
      sha256 "35831bf01a2bccc7124580c616f100661ea82acc096b062993f66fe13ecf71d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.19/freesound-credits-x86_64-apple-darwin.zip"
      sha256 "d61c6240a8a6794bd2571e140af57c3d98aca92987b8136ff22f4c2bfcf844ce"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/andreacfromtheapp/freesound-credits/releases/download/v0.2.19/freesound-credits-x86_64-unknown-linux-gnu.zip"
    sha256 "968aa9871df5b7a3ada7116fc7300fc5168bcbe1cd03deb594190f8c6cde8e32"
  end
  license any_of: ["MIT", "Apache-2.0"]

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
