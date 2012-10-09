Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2JIJPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:15:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2JIJPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:16 -0400
From: David Howells <dhowells@redhat.com>
To: rth@twiddle.net
Cc: dhowells@redhat.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for alpha [ver #2]
Date: Tue, 09 Oct 2012 10:15:08 +0100
Message-ID: <21103.1349774108@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the alpha tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-alpha-20121009

for you to fetch changes up to 55492254705f10d67f4225a0840156f856971519:

  UAPI: (Scripted) Disintegrate arch/alpha/include/asm (2012-10-09 09:46:29 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/alpha/include/asm

 arch/alpha/include/asm/Kbuild                   |  10 -
 arch/alpha/include/asm/a.out.h                  |  89 +----
 arch/alpha/include/asm/compiler.h               | 115 +-----
 arch/alpha/include/asm/console.h                |  48 +--
 arch/alpha/include/asm/fpu.h                    | 124 +------
 arch/alpha/include/asm/pal.h                    |  50 +--
 arch/alpha/include/asm/param.h                  |  20 +-
 arch/alpha/include/asm/ptrace.h                 |  68 +---
 arch/alpha/include/asm/signal.h                 | 135 +------
 arch/alpha/include/asm/socket.h                 |  78 +---
 arch/alpha/include/asm/termios.h                |  68 +---
 arch/alpha/include/asm/types.h                  |  13 +-
 arch/alpha/include/asm/unistd.h                 | 469 +----------------------
 arch/alpha/include/uapi/asm/Kbuild              |  40 ++
 arch/alpha/include/uapi/asm/a.out.h             |  91 +++++
 arch/alpha/include/{ => uapi}/asm/auxvec.h      |   0
 arch/alpha/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/alpha/include/{ => uapi}/asm/byteorder.h   |   0
 arch/alpha/include/uapi/asm/compiler.h          | 117 ++++++
 arch/alpha/include/uapi/asm/console.h           |  50 +++
 arch/alpha/include/{ => uapi}/asm/errno.h       |   0
 arch/alpha/include/{ => uapi}/asm/fcntl.h       |   0
 arch/alpha/include/uapi/asm/fpu.h               | 123 +++++++
 arch/alpha/include/{ => uapi}/asm/gentrap.h     |   0
 arch/alpha/include/{ => uapi}/asm/ioctl.h       |   0
 arch/alpha/include/{ => uapi}/asm/ioctls.h      |   0
 arch/alpha/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/alpha/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/alpha/include/{ => uapi}/asm/mman.h        |   0
 arch/alpha/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/alpha/include/uapi/asm/pal.h               |  52 +++
 arch/alpha/include/uapi/asm/param.h             |  21 ++
 arch/alpha/include/{ => uapi}/asm/poll.h        |   0
 arch/alpha/include/{ => uapi}/asm/posix_types.h |   0
 arch/alpha/include/uapi/asm/ptrace.h            |  70 ++++
 arch/alpha/include/{ => uapi}/asm/reg.h         |   0
 arch/alpha/include/{ => uapi}/asm/regdef.h      |   0
 arch/alpha/include/{ => uapi}/asm/resource.h    |   0
 arch/alpha/include/{ => uapi}/asm/sembuf.h      |   0
 arch/alpha/include/{ => uapi}/asm/setup.h       |   0
 arch/alpha/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/alpha/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/alpha/include/{ => uapi}/asm/siginfo.h     |   0
 arch/alpha/include/uapi/asm/signal.h            | 135 +++++++
 arch/alpha/include/uapi/asm/socket.h            |  80 ++++
 arch/alpha/include/{ => uapi}/asm/sockios.h     |   0
 arch/alpha/include/{ => uapi}/asm/stat.h        |   0
 arch/alpha/include/{ => uapi}/asm/statfs.h      |   0
 arch/alpha/include/{ => uapi}/asm/swab.h        |   0
 arch/alpha/include/{ => uapi}/asm/sysinfo.h     |   0
 arch/alpha/include/{ => uapi}/asm/termbits.h    |   0
 arch/alpha/include/uapi/asm/termios.h           |  70 ++++
 arch/alpha/include/uapi/asm/types.h             |  16 +
 arch/alpha/include/uapi/asm/unistd.h            | 471 ++++++++++++++++++++++++
 54 files changed, 1348 insertions(+), 1275 deletions(-)
 create mode 100644 arch/alpha/include/uapi/asm/a.out.h
 rename arch/alpha/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/compiler.h
 create mode 100644 arch/alpha/include/uapi/asm/console.h
 rename arch/alpha/include/{ => uapi}/asm/errno.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/fcntl.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/fpu.h
 rename arch/alpha/include/{ => uapi}/asm/gentrap.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/mman.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/msgbuf.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/pal.h
 create mode 100644 arch/alpha/include/uapi/asm/param.h
 rename arch/alpha/include/{ => uapi}/asm/poll.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/ptrace.h
 rename arch/alpha/include/{ => uapi}/asm/reg.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/regdef.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/resource.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/sembuf.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/setup.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/signal.h
 create mode 100644 arch/alpha/include/uapi/asm/socket.h
 rename arch/alpha/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/stat.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/swab.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/sysinfo.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/termios.h
 create mode 100644 arch/alpha/include/uapi/asm/types.h
 create mode 100644 arch/alpha/include/uapi/asm/unistd.h
.
