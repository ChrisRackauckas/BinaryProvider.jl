using BinaryProvider

# BinaryProvider support
const prefix = Prefix(joinpath(dirname(@__FILE__),"usr"))
 
# These are the two binary objects we care about
libfoo = LibraryProduct(prefix, "libfoo")
fooifier = ExecutableProduct(prefix, "fooifier")

# This is where we download things from, for different platforms
const bin_prefix = "https://github.com/staticfloat/small_bin/raw/74b7fd81e3fbc8963b14b0ebbe5421e270d8bdcf"
const download_info = Dict(
    :linux32 =>      ("$bin_prefix/libfoo.i686-linux-gnu.tar.gz", "1398353bcbbd88338189ece9c1d6e7c508df120bc4f93afbaed362a9f91358ff"),
    :linux64 =>      ("$bin_prefix/libfoo.x86_64-linux-gnu.tar.gz", "b9d57a6e032a56b1f8641771fa707523caa72f1a2e322ab99eeeb011f13ad9f3"),
    :linuxaarch64 => ("$bin_prefix/libfoo.aarch64-linux-gnu.tar.gz", "19d9da0e6e7fb506bf4889eb91e936fda43493a39cd4fd7bd5d65506cede6f95"),
    :linuxarmv7l =>  ("$bin_prefix/libfoo.arm-linux-gnueabihf.tar.gz", "8e33c1a0e091e6e5b8fcb902e5d45329791bb57763ee9cbcde49c1ec9bd8532a"),
    :linuxppc64le => ("$bin_prefix/libfoo.powerpc64le-linux-gnu.tar.gz", "b48a64d48be994ec99b1a9fb60e0af7f4415a57596518cb90a340987b79fad81"),
    :mac64 =>        ("$bin_prefix/libfoo.x86_64-apple-darwin14.tar.gz", "661b71edb433ab334b0fef70db3b5c45d35f2b3bee0d244f54875f1ec899c10f"),
    :win32 =>        ("$bin_prefix/libfoo.i686-w64-mingw32.tar.gz", "3d4a8d4bf0169007a42d809a1d560083635b1540a1bc4a42108841dcb6d2aaea"),
    :win64 =>        ("$bin_prefix/libfoo.x86_64-w64-mingw32.tar.gz", "2d08fbc9a534cd021f36b6bbe86ddabb2dafbedeb589581240aa4a8c5b896055"),
)
if platform_key() in keys(download_info)
    # First, check to see if we're all satisfied
    if any(!satisfied(p) for p in [libfoo, fooifier])
        # If we're not, download and install this puppy
        url, tarball_hash = download_info[platform_key()]
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
    end
    @write_deps_file libfoo fooifier
else
    error("Your platform $(Sys.MACHINE) is not recognized, we cannot install Libfoo!")
end

