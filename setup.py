#!/usr/bin/python

import platform, os, sys, getopt, subprocess

# Update these files as needed
DOTFILES = [
  'agignore',
  'bash_profile',
  'ctags',
  'editrc',
  'gitconfig',
  'gitignore',
  'inputrc',
  'jsbeautifyrc',
  'jshintrc',
  'tmux.conf',
  'uncrustify.cfg',
  'vim',
  'vimrc',
  'xinitrc',
]
LINKS = [
  'bin',
]
PACKAGES = [
  'bash',
  'ctags',
  'git',
  'hexedit',
  'mysql',
  'node',
  'openssl',
  'python',
  'python3',
  'readline',
  'sdl2',
  'tmux',
  'vim',
  'yarn',
]
COMMANDS = [
  'vim +PlugUpgrade +PlugInstall +qall',
]


# Should not need to edit below this line
#----------------------------------------------

def usage():
  print """usage: setup.py [-h | --help] [-v | --verbose]
                [-d | --dryrun] [-f | --force]"""

def rename(src, dst, opts):
  if opts['verbose']:
    print("Linking '%s' to '%s'" % (src, dst))
  if not opts['dryrun']:
    if os.path.exists(dst) or os.path.islink(dst):
      if opts['force']:
        if os.path.exists(dst) and not os.path.islink(dst):
          rename = "%s.old" % dst
          if opts.verbose:
            print("Renamed '%s' to '%s'" % (dst, rename))
          os.rename(dst, rename)
        else:
          os.unlink(dst)
      else:
        print("Skipping '%s' as it already exists. Use --force to link anyway" % dst)
        return
    os.symlink(src, dst)

def install(package, opts):
    if opts['verbose']:
      print("Installing '%s'" % package)

    if opts['system'] == 'Darwin':
      shellResult = subprocess.call('brew ls --versions "%s" > /dev/null' % package, shell=True)
      if shellResult:
        shellResult = subprocess.call('HOMEBREW_NO_AUTO_UPDATE=1 brew install "%s"' % package, shell=True)
      else:
        shellResult = subprocess.call('HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "%s"' % package, shell=True)
      if shellResult:
        print("Error installing '%s'" % package)

def main(argv):
  try:
    opts, args = getopt.getopt(argv, "hvdf", ["help", "verbose", "dryrun", "force"])
  except getopt.GetoptError as err:
    print str(err)
    usage()
    sys.exit(2)

  HOME = os.environ.get('HOME')

  options = {
    'verbose': False,
    'dryrun': False,
    'force': False,
    'system': platform.system()
  }

  for o, a in opts:
    if o in ("-v", "--verbose"): options['verbose'] = True
    elif o in ("-d", "--dryrun"): options['dryrun'] = True
    elif o in ("-f", "--force"): options['force'] = True
    elif o in ("-h", "--help"):
      usage()
      sys.exit()
    else:
      assert False, "unhandled option"

  if HOME == None:
    print("$HOME must be defined to setup symlinks.")
    sys.exit(1)

  # Link dotfiles
  for f in DOTFILES:
    src = "%s/%s" % (os.getcwd(), f)
    dst = "%s/.%s" % (HOME, f)
    rename(src, dst, options)

  # Link regular files
  for f in LINKS:
    src = "%s/%s" % (os.getcwd(), f)
    dst = "%s/%s" % (HOME, f)
    rename(src, dst, options)

  for p in PACKAGES:
    install(p, options)

  # Run commands
  for c in COMMANDS:
    if options['verbose']:
      print("Running '%s'" % c)
    result = subprocess.call(c, shell=True)
    if result:
      print("Error running '%s'" %c)

  print("Setup Complete")


if __name__ == "__main__":
  main(sys.argv[1:])
