class Snag < Formula
  desc "Automatic build tool for all your needs"
  homepage "https://github.com/Tonkpils/snag"
  url "https://github.com/Tonkpils/snag/archive/v1.2.0.tar.gz"
  sha256 "37bf661436edf4526adf5428ac5ff948871c613ff4f9b61fbbdfe1fb95f58b37"
  license "MIT"
  head "https://github.com/Tonkpils/snag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "008cc64d1a65693bf1773affb86ed185d5c91382f80f252877a5a6334986527a" => :catalina
    sha256 "3821de3f4b916afd116f9f55c549f1bdec7b2c448994e784baf23eef96d65520" => :mojave
    sha256 "ae031acea4e10639f15a1598bf99e45eb8bed08222e31db9e1152a4a1de0dc14" => :high_sierra
    sha256 "692ce892c40f38cb39e77b464efa531b27004a9bbaf0096fb5876b570086cf82" => :sierra
    sha256 "18a6d589a0b416ee502a8dacd6f919959d25cc08d9bbaad152fdade4c72634dc" => :el_capitan
    sha256 "00edba081c3a56f6cda3a4fc5bb1125d8ce93a8239c3cae89346b1893df12025" => :yosemite
    sha256 "df63529c6ec2ff4f38f0fb7900687b9362ce710a13013d4bac4bb9cdea5190da" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/Tonkpils/").mkpath
    ln_s buildpath, buildpath/"src/github.com/Tonkpils/snag"

    system "go", "build", "-o", bin/"snag", "./src/github.com/Tonkpils/snag"
  end

  test do
    (testpath/".snag.yml").write <<~EOS
      build:
        - touch #{testpath}/snagged
      verbose: true
    EOS
    begin
      pid = fork do
        exec bin/"snag"
      end
      sleep 0.5
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
    assert_predicate testpath/"snagged", :exist?
  end
end
