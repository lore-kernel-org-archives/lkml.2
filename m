Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2JIJTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:19:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab2JIJPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:48 -0400
From: David Howells <dhowells@redhat.com>
To: ralf@linux-mips.org
Cc: dhowells@redhat.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for mips [ver #2]
Date: Tue, 09 Oct 2012 10:15:40 +0100
Message-ID: <21149.1349774140@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the mips tree please.

This is to complete part of the UAPI disintegration for which the preparatory
patches were pulled recently.

Now that the fixups and the asm-generic chunk have been merged, I've
regenerated the patches to get rid of those dependencies and to take account of
any changes made so far in the merge window.  If you have already pulled the
older version of the branch aimed at you, then please feel free to ignore this
request.

The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:

  Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-mips-20121009

for you to fetch changes up to 61730c538f8281efa7ac12596da9f3f9a31b9272:

  UAPI: (Scripted) Disintegrate arch/mips/include/asm (2012-10-09 09:47:14 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/mips/include/asm

 arch/mips/include/asm/Kbuild                   |    5 -
 arch/mips/include/asm/errno.h                  |  120 +--
 arch/mips/include/asm/ptrace.h                 |  107 +--
 arch/mips/include/asm/setup.h                  |    5 +-
 arch/mips/include/asm/sigcontext.h             |   66 +-
 arch/mips/include/asm/siginfo.h                |  104 +--
 arch/mips/include/asm/signal.h                 |  115 +--
 arch/mips/include/asm/socket.h                 |   83 +-
 arch/mips/include/asm/termios.h                |   73 +-
 arch/mips/include/asm/types.h                  |   16 +-
 arch/mips/include/asm/unistd.h                 | 1022 +----------------------
 arch/mips/include/uapi/asm/Kbuild              |   34 +
 arch/mips/include/{ => uapi}/asm/auxvec.h      |    0
 arch/mips/include/{ => uapi}/asm/bitsperlong.h |    0
 arch/mips/include/{ => uapi}/asm/byteorder.h   |    0
 arch/mips/include/{ => uapi}/asm/cachectl.h    |    0
 arch/mips/include/uapi/asm/errno.h             |  129 +++
 arch/mips/include/{ => uapi}/asm/fcntl.h       |    0
 arch/mips/include/{ => uapi}/asm/ioctl.h       |    0
 arch/mips/include/{ => uapi}/asm/ioctls.h      |    0
 arch/mips/include/{ => uapi}/asm/ipcbuf.h      |    0
 arch/mips/include/{ => uapi}/asm/kvm_para.h    |    0
 arch/mips/include/{ => uapi}/asm/mman.h        |    0
 arch/mips/include/{ => uapi}/asm/msgbuf.h      |    0
 arch/mips/include/{ => uapi}/asm/param.h       |    0
 arch/mips/include/{ => uapi}/asm/poll.h        |    0
 arch/mips/include/{ => uapi}/asm/posix_types.h |    0
 arch/mips/include/uapi/asm/ptrace.h            |  116 +++
 arch/mips/include/{ => uapi}/asm/resource.h    |    0
 arch/mips/include/{ => uapi}/asm/sembuf.h      |    0
 arch/mips/include/uapi/asm/setup.h             |    7 +
 arch/mips/include/{ => uapi}/asm/sgidefs.h     |    0
 arch/mips/include/{ => uapi}/asm/shmbuf.h      |    0
 arch/mips/include/uapi/asm/sigcontext.h        |   78 ++
 arch/mips/include/uapi/asm/siginfo.h           |  114 +++
 arch/mips/include/uapi/asm/signal.h            |  123 +++
 arch/mips/include/uapi/asm/socket.h            |   93 +++
 arch/mips/include/{ => uapi}/asm/sockios.h     |    0
 arch/mips/include/{ => uapi}/asm/stat.h        |    0
 arch/mips/include/{ => uapi}/asm/statfs.h      |    0
 arch/mips/include/{ => uapi}/asm/swab.h        |    0
 arch/mips/include/{ => uapi}/asm/sysmips.h     |    0
 arch/mips/include/{ => uapi}/asm/termbits.h    |    0
 arch/mips/include/uapi/asm/termios.h           |   80 ++
 arch/mips/include/uapi/asm/types.h             |   27 +
 arch/mips/include/uapi/asm/unistd.h            | 1035 ++++++++++++++++++++++++
 46 files changed, 1846 insertions(+), 1706 deletions(-)
 rename arch/mips/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/mips/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/mips/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/mips/include/{ => uapi}/asm/cachectl.h (100%)
 create mode 100644 arch/mips/include/uapi/asm/errno.h
 rename arch/mips/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/mips/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/mips/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/mips/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/mips/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/mips/include/{ => uapi}/asm/mman.h (100%)
 rename arch/mips/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/mips/include/{ => uapi}/asm/param.h (100%)
 rename arch/mips/include/{ => uapi}/asm/poll.h (100%)
 rename arch/mips/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/mips/include/uapi/asm/ptrace.h
 rename arch/mips/include/{ => uapi}/asm/resource.h (100%)
 rename arch/mips/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/mips/include/uapi/asm/setup.h
 rename arch/mips/include/{ => uapi}/asm/sgidefs.h (100%)
 rename arch/mips/include/{ => uapi}/asm/shmbuf.h (100%)
 create mode 100644 arch/mips/include/uapi/asm/sigcontext.h
 create mode 100644 arch/mips/include/uapi/asm/siginfo.h
 create mode 100644 arch/mips/include/uapi/asm/signal.h
 create mode 100644 arch/mips/include/uapi/asm/socket.h
 rename arch/mips/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/mips/include/{ => uapi}/asm/stat.h (100%)
 rename arch/mips/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/mips/include/{ => uapi}/asm/swab.h (100%)
 rename arch/mips/include/{ => uapi}/asm/sysmips.h (100%)
 rename arch/mips/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/mips/include/uapi/asm/termios.h
 create mode 100644 arch/mips/include/uapi/asm/types.h
 create mode 100644 arch/mips/include/uapi/asm/unistd.h
.
