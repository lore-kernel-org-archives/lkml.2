Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab2JJLyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 07:54:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab2JJLys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 07:54:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, egtvedt@samfundet.no, hskinnemoen@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] UAPI disintegration for MN10300, FRV and AVR32 arches
Date: Wed, 10 Oct 2012 12:54:37 +0100
Message-ID: <6025.1349870077@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Could you pull this please?  It contains the UAPI disintegration for the
MN10300 and FRV arches that I maintain and for the AVR32 arch the maintainers
for which have asked me to handle it for them.

David
---
The following changes since commit 42859eea96ba6beabfb0369a1eeffa3c7d2bd9cb:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal (2012-10-10 12:02:25 +0900)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-misc-arches-20121010

for you to fetch changes up to 7190632b78de594f3dabe174e9df373bfc790d89:

  Merge branch 'disintegrate-avr32' into disintegrate-misc-arches (2012-10-10 12:34:45 +0100)

----------------------------------------------------------------

UAPI Disintegration 2012-10-10

----------------------------------------------------------------
David Howells (5):
      UAPI: (Scripted) Disintegrate arch/avr32/include/asm
      UAPI: (Scripted) Disintegrate arch/frv/include/asm
      UAPI: (Scripted) Disintegrate arch/mn10300/include/asm
      Merge branch 'disintegrate-frv' into disintegrate-misc-arches
      Merge branch 'disintegrate-avr32' into disintegrate-misc-arches

 arch/avr32/include/asm/Kbuild                     |   3 -
 arch/avr32/include/asm/param.h                    |  18 +-
 arch/avr32/include/asm/ptrace.h                   | 115 +------
 arch/avr32/include/asm/setup.h                    |   5 +-
 arch/avr32/include/asm/signal.h                   | 121 +-------
 arch/avr32/include/asm/termios.h                  |  41 +--
 arch/avr32/include/asm/types.h                    |   6 +-
 arch/avr32/include/asm/unistd.h                   | 296 +-----------------
 arch/avr32/include/uapi/asm/Kbuild                |  32 ++
 arch/avr32/include/{ => uapi}/asm/auxvec.h        |   0
 arch/avr32/include/{ => uapi}/asm/bitsperlong.h   |   0
 arch/avr32/include/{ => uapi}/asm/byteorder.h     |   0
 arch/avr32/include/{ => uapi}/asm/cachectl.h      |   0
 arch/avr32/include/{ => uapi}/asm/errno.h         |   0
 arch/avr32/include/{ => uapi}/asm/fcntl.h         |   0
 arch/avr32/include/{ => uapi}/asm/ioctl.h         |   0
 arch/avr32/include/{ => uapi}/asm/ioctls.h        |   0
 arch/avr32/include/{ => uapi}/asm/ipcbuf.h        |   0
 arch/avr32/include/{ => uapi}/asm/kvm_para.h      |   0
 arch/avr32/include/{ => uapi}/asm/mman.h          |   0
 arch/avr32/include/{ => uapi}/asm/msgbuf.h        |   0
 arch/avr32/include/uapi/asm/param.h               |  18 ++
 arch/avr32/include/{ => uapi}/asm/poll.h          |   0
 arch/avr32/include/{ => uapi}/asm/posix_types.h   |   0
 arch/avr32/include/uapi/asm/ptrace.h              | 126 ++++++++
 arch/avr32/include/{ => uapi}/asm/resource.h      |   0
 arch/avr32/include/{ => uapi}/asm/sembuf.h        |   0
 arch/avr32/include/uapi/asm/setup.h               |  17 ++
 arch/avr32/include/{ => uapi}/asm/shmbuf.h        |   0
 arch/avr32/include/{ => uapi}/asm/sigcontext.h    |   0
 arch/avr32/include/{ => uapi}/asm/siginfo.h       |   0
 arch/avr32/include/uapi/asm/signal.h              | 128 ++++++++
 arch/avr32/include/{ => uapi}/asm/socket.h        |   0
 arch/avr32/include/{ => uapi}/asm/sockios.h       |   0
 arch/avr32/include/{ => uapi}/asm/stat.h          |   0
 arch/avr32/include/{ => uapi}/asm/statfs.h        |   0
 arch/avr32/include/{ => uapi}/asm/swab.h          |   0
 arch/avr32/include/{ => uapi}/asm/termbits.h      |   0
 arch/avr32/include/uapi/asm/termios.h             |  50 +++
 arch/avr32/include/uapi/asm/types.h               |   8 +
 arch/avr32/include/uapi/asm/unistd.h              | 305 +++++++++++++++++++
 arch/frv/include/asm/Kbuild                       |   3 -
 arch/frv/include/asm/ptrace.h                     |  51 +---
 arch/frv/include/asm/setup.h                      |   7 +-
 arch/frv/include/asm/signal.h                     |  33 +-
 arch/frv/include/asm/termios.h                    |  46 +--
 arch/frv/include/asm/types.h                      |   6 +-
 arch/frv/include/asm/unistd.h                     | 346 +--------------------
 arch/frv/include/uapi/asm/Kbuild                  |  32 ++
 arch/frv/include/{ => uapi}/asm/auxvec.h          |   0
 arch/frv/include/{ => uapi}/asm/bitsperlong.h     |   0
 arch/frv/include/{ => uapi}/asm/byteorder.h       |   0
 arch/frv/include/{ => uapi}/asm/errno.h           |   0
 arch/frv/include/{ => uapi}/asm/fcntl.h           |   0
 arch/frv/include/{ => uapi}/asm/ioctl.h           |   0
 arch/frv/include/{ => uapi}/asm/ioctls.h          |   0
 arch/frv/include/{ => uapi}/asm/ipcbuf.h          |   0
 arch/frv/include/{ => uapi}/asm/kvm_para.h        |   0
 arch/frv/include/{ => uapi}/asm/mman.h            |   0
 arch/frv/include/{ => uapi}/asm/msgbuf.h          |   0
 arch/frv/include/{ => uapi}/asm/param.h           |   0
 arch/frv/include/{ => uapi}/asm/poll.h            |   0
 arch/frv/include/{ => uapi}/asm/posix_types.h     |   0
 arch/frv/include/uapi/asm/ptrace.h                |  60 ++++
 arch/frv/include/{ => uapi}/asm/registers.h       |   0
 arch/frv/include/{ => uapi}/asm/resource.h        |   0
 arch/frv/include/{ => uapi}/asm/sembuf.h          |   0
 arch/frv/include/uapi/asm/setup.h                 |  18 ++
 arch/frv/include/{ => uapi}/asm/shmbuf.h          |   0
 arch/frv/include/{ => uapi}/asm/sigcontext.h      |   0
 arch/frv/include/{ => uapi}/asm/siginfo.h         |   0
 arch/frv/include/uapi/asm/signal.h                |  36 +++
 arch/frv/include/{ => uapi}/asm/socket.h          |   0
 arch/frv/include/{ => uapi}/asm/sockios.h         |   0
 arch/frv/include/{ => uapi}/asm/stat.h            |   0
 arch/frv/include/{ => uapi}/asm/statfs.h          |   0
 arch/frv/include/{ => uapi}/asm/swab.h            |   0
 arch/frv/include/{ => uapi}/asm/termbits.h        |   0
 arch/frv/include/uapi/asm/termios.h               |  46 +++
 arch/frv/include/uapi/asm/types.h                 |  11 +
 arch/frv/include/uapi/asm/unistd.h                | 348 +++++++++++++++++++++
 arch/mn10300/include/asm/Kbuild                   |   1 -
 arch/mn10300/include/asm/ptrace.h                 |  72 +----
 arch/mn10300/include/asm/setup.h                  |   4 +-
 arch/mn10300/include/asm/signal.h                 | 121 +-------
 arch/mn10300/include/asm/termios.h                |  81 +----
 arch/mn10300/include/asm/types.h                  |   5 +-
 arch/mn10300/include/asm/unistd.h                 | 342 +--------------------
 arch/mn10300/include/uapi/asm/Kbuild              |  31 ++
 arch/mn10300/include/{ => uapi}/asm/auxvec.h      |   0
 arch/mn10300/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/mn10300/include/{ => uapi}/asm/byteorder.h   |   0
 arch/mn10300/include/{ => uapi}/asm/errno.h       |   0
 arch/mn10300/include/{ => uapi}/asm/fcntl.h       |   0
 arch/mn10300/include/{ => uapi}/asm/ioctl.h       |   0
 arch/mn10300/include/{ => uapi}/asm/ioctls.h      |   0
 arch/mn10300/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/mn10300/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/mn10300/include/{ => uapi}/asm/mman.h        |   0
 arch/mn10300/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/mn10300/include/{ => uapi}/asm/param.h       |   0
 arch/mn10300/include/{ => uapi}/asm/poll.h        |   0
 arch/mn10300/include/{ => uapi}/asm/posix_types.h |   0
 arch/mn10300/include/uapi/asm/ptrace.h            |  84 +++++
 arch/mn10300/include/{ => uapi}/asm/resource.h    |   0
 arch/mn10300/include/{ => uapi}/asm/sembuf.h      |   0
 arch/mn10300/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/mn10300/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/mn10300/include/{ => uapi}/asm/siginfo.h     |   0
 arch/mn10300/include/uapi/asm/signal.h            | 131 ++++++++
 arch/mn10300/include/{ => uapi}/asm/socket.h      |   0
 arch/mn10300/include/{ => uapi}/asm/sockios.h     |   0
 arch/mn10300/include/{ => uapi}/asm/stat.h        |   0
 arch/mn10300/include/{ => uapi}/asm/statfs.h      |   0
 arch/mn10300/include/{ => uapi}/asm/swab.h        |   0
 arch/mn10300/include/{ => uapi}/asm/termbits.h    |   0
 arch/mn10300/include/uapi/asm/termios.h           |  83 +++++
 arch/mn10300/include/uapi/asm/types.h             |  11 +
 arch/mn10300/include/uapi/asm/unistd.h            | 354 ++++++++++++++++++++++
 119 files changed, 1950 insertions(+), 1702 deletions(-)
 rename arch/avr32/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/cachectl.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/errno.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/mman.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/msgbuf.h (100%)
 create mode 100644 arch/avr32/include/uapi/asm/param.h
 rename arch/avr32/include/{ => uapi}/asm/poll.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/avr32/include/uapi/asm/ptrace.h
 rename arch/avr32/include/{ => uapi}/asm/resource.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/avr32/include/uapi/asm/setup.h
 rename arch/avr32/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/avr32/include/uapi/asm/signal.h
 rename arch/avr32/include/{ => uapi}/asm/socket.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/stat.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/swab.h (100%)
 rename arch/avr32/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/avr32/include/uapi/asm/termios.h
 create mode 100644 arch/avr32/include/uapi/asm/types.h
 create mode 100644 arch/avr32/include/uapi/asm/unistd.h
 rename arch/frv/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/frv/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/frv/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/frv/include/{ => uapi}/asm/errno.h (100%)
 rename arch/frv/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/frv/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/frv/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/frv/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/frv/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/frv/include/{ => uapi}/asm/mman.h (100%)
 rename arch/frv/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/frv/include/{ => uapi}/asm/param.h (100%)
 rename arch/frv/include/{ => uapi}/asm/poll.h (100%)
 rename arch/frv/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/frv/include/uapi/asm/ptrace.h
 rename arch/frv/include/{ => uapi}/asm/registers.h (100%)
 rename arch/frv/include/{ => uapi}/asm/resource.h (100%)
 rename arch/frv/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/frv/include/uapi/asm/setup.h
 rename arch/frv/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/frv/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/frv/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/frv/include/uapi/asm/signal.h
 rename arch/frv/include/{ => uapi}/asm/socket.h (100%)
 rename arch/frv/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/frv/include/{ => uapi}/asm/stat.h (100%)
 rename arch/frv/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/frv/include/{ => uapi}/asm/swab.h (100%)
 rename arch/frv/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/frv/include/uapi/asm/termios.h
 create mode 100644 arch/frv/include/uapi/asm/types.h
 create mode 100644 arch/frv/include/uapi/asm/unistd.h
 rename arch/mn10300/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/errno.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/mman.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/param.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/poll.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/mn10300/include/uapi/asm/ptrace.h
 rename arch/mn10300/include/{ => uapi}/asm/resource.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/mn10300/include/uapi/asm/setup.h
 rename arch/mn10300/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/mn10300/include/uapi/asm/signal.h
 rename arch/mn10300/include/{ => uapi}/asm/socket.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/stat.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/swab.h (100%)
 rename arch/mn10300/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/mn10300/include/uapi/asm/termios.h
 create mode 100644 arch/mn10300/include/uapi/asm/types.h
 create mode 100644 arch/mn10300/include/uapi/asm/unistd.h
