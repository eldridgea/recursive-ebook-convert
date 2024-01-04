## Recursive Ebook Convert ##
A bash script (dependent on a working `docker` command) that will iterate through a directory tree and in each directory, will take any `.mobi` or `.azw3` files and convert them to an epub file UNLESS there is already epub file in the same directory. 

### Caveat ###
The script expects each book to have its own directory so any epub file in the directory will cause it to skip that directory. However if there are multiple ebooks in a directory with no epub file it should convert all of them to epub.

This script calls the [linuxserver.io Calibre](https://github.com/linuxserver/docker-calibre) container with `docker run` for conversion, so you need to have a working `docker` install. It also means that any conversion should be the same as it would be with Desktop Calibre. 
