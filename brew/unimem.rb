# Homebrew Formula for Unimem CLI tool
# To release:
# 1. Tag and release Unimem on GitHub (e.g. v0.1.0).
# 2. Get the tarball URL and calculate its SHA256 using: curl -sL <url> | shasum -a 256
# 3. Update the url and sha256 fields below.
# 4. Copy this file into your tap repository (e.g., github.com/korrakiran/homebrew-unimem/Formula/unimem.rb).

class Unimem < Formula
  include Language::Python::Virtualenv

  desc "Universal Project Memory Layer for AI Coding Agents"
  homepage "https://github.com/korrakiran/collector"
  url "https://github.com/korrakiran/collector/archive/refs/tags/v0.1.0.tar.gz"
  # Note: Replace this placeholder SHA256 with the actual release archive SHA256
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"
  head "https://github.com/korrakiran/collector.git", branch: "main"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  def post_install
    home_dir = Dir.home
    rules_content = <<~EOS
      # Global Unimem Automation Rules

      Unimem is active in this project. You are resuming work from a previous session.

      Before you begin coding:
      1. Read the project memory file at `.unimem/memory.md` to get your full context:
         - Current Goal & Task focus
         - Completed and In-Progress features
         - Architectural decisions
         - Important files to locate
      2. Trust `.unimem/memory.md` as the source of truth for the project state.

      When you finish or pause work:
      - Update the Unimem state (e.g. by running `unimem summary` or updating `.unimem/state.json`) so the next agent can seamlessly take over.
    EOS

    begin
      File.write(File.join(home_dir, ".cursorrules"), rules_content)
      File.write(File.join(home_dir, ".clauderules"), rules_content)
      ohai "Successfully configured global agent rules in ~/.cursorrules and ~/.clauderules"
    rescue => e
      opoo "Could not write global agent rules: #{e.message}"
    end
  end

  test do
    # Check if CLI displays version correctly
    assert_match "version", shell_output("#{bin}/unimem --version")
  end
end
