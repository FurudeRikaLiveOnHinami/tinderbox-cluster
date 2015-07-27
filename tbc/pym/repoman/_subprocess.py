

import codecs
import subprocess
import sys

# import our initialized portage instance
from tbc.repoman._portage import portage

from portage import os
from portage.process import find_binary
from portage import _encodings, _unicode_encode


def repoman_getstatusoutput(cmd):
	"""
	Implements an interface similar to getstatusoutput(), but with
	customized unicode handling (see bug #310789) and without the shell.
	"""
	args = portage.util.shlex_split(cmd)

	if sys.hexversion < 0x3020000 and sys.hexversion >= 0x3000000 and \
		not os.path.isabs(args[0]):
		# Python 3.1 _execvp throws TypeError for non-absolute executable
		# path passed as bytes (see http://bugs.python.org/issue8513).
		fullname = find_binary(args[0])
		if fullname is None:
			raise portage.exception.CommandNotFound(args[0])
		args[0] = fullname

	encoding = _encodings['fs']
	args = [
		_unicode_encode(x, encoding=encoding, errors='strict') for x in args]
	proc = subprocess.Popen(
		args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
	output = portage._unicode_decode(
		proc.communicate()[0], encoding=encoding, errors='strict')
	if output and output[-1] == "\n":
		# getstatusoutput strips one newline
		output = output[:-1]
	return (proc.wait(), output)


class repoman_popen(portage.proxy.objectproxy.ObjectProxy):
	"""
	Implements an interface similar to os.popen(), but with customized
	unicode handling (see bug #310789) and without the shell.
	"""

	__slots__ = ('_proc', '_stdout')

	def __init__(self, cmd):
		args = portage.util.shlex_split(cmd)

		if sys.hexversion < 0x3020000 and sys.hexversion >= 0x3000000 and \
			not os.path.isabs(args[0]):
			# Python 3.1 _execvp throws TypeError for non-absolute executable
			# path passed as bytes (see http://bugs.python.org/issue8513).
			fullname = find_binary(args[0])
			if fullname is None:
				raise portage.exception.CommandNotFound(args[0])
			args[0] = fullname

		encoding = _encodings['fs']
		args = [
			_unicode_encode(x, encoding=encoding, errors='strict')
			for x in args]
		proc = subprocess.Popen(args, stdout=subprocess.PIPE)
		object.__setattr__(
			self, '_proc', proc)
		object.__setattr__(
			self, '_stdout', codecs.getreader(encoding)(proc.stdout, 'strict'))

	def _get_target(self):
		return object.__getattribute__(self, '_stdout')

	__enter__ = _get_target

	def __exit__(self, exc_type, exc_value, traceback):
		proc = object.__getattribute__(self, '_proc')
		proc.wait()
		proc.stdout.close()
