Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2JIJP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:15:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab2JIJPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:48 -0400
From: David Howells <dhowells@redhat.com>
To: takata@linux-m32r.org
Cc: dhowells@redhat.com, linux-m32r@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for m32r [ver #2]
Date: Tue, 09 Oct 2012 10:15:32 +0100
Message-ID: <21140.1349774132@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the m32r tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-m32r-20121009

for you to fetch changes up to 90fc366ea41f3595286f18e15b49d3cef8b85ceb:

  UAPI: (Scripted) Disintegrate arch/m32r/include/asm (2012-10-09 09:47:03 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/m32r/include/asm

 arch/m32r/include/asm/Kbuild                   |   1 -
 arch/m32r/include/asm/ptrace.h                 | 110 +-------
 arch/m32r/include/asm/setup.h                  |   9 +-
 arch/m32r/include/asm/signal.h                 | 123 +--------
 arch/m32r/include/asm/termios.h                |  42 +---
 arch/m32r/include/asm/types.h                  |   5 +-
 arch/m32r/include/asm/unistd.h                 | 333 +-----------------------
 arch/m32r/include/uapi/asm/Kbuild              |  30 +++
 arch/m32r/include/{ => uapi}/asm/auxvec.h      |   0
 arch/m32r/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/m32r/include/{ => uapi}/asm/byteorder.h   |   0
 arch/m32r/include/{ => uapi}/asm/errno.h       |   0
 arch/m32r/include/{ => uapi}/asm/fcntl.h       |   0
 arch/m32r/include/{ => uapi}/asm/ioctl.h       |   0
 arch/m32r/include/{ => uapi}/asm/ioctls.h      |   0
 arch/m32r/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/m32r/include/{ => uapi}/asm/mman.h        |   0
 arch/m32r/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/m32r/include/{ => uapi}/asm/param.h       |   0
 arch/m32r/include/{ => uapi}/asm/poll.h        |   0
 arch/m32r/include/{ => uapi}/asm/posix_types.h |   0
 arch/m32r/include/uapi/asm/ptrace.h            | 117 +++++++++
 arch/m32r/include/{ => uapi}/asm/resource.h    |   0
 arch/m32r/include/{ => uapi}/asm/sembuf.h      |   0
 arch/m32r/include/uapi/asm/setup.h             |  11 +
 arch/m32r/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/m32r/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/m32r/include/{ => uapi}/asm/siginfo.h     |   0
 arch/m32r/include/uapi/asm/signal.h            | 123 +++++++++
 arch/m32r/include/{ => uapi}/asm/socket.h      |   0
 arch/m32r/include/{ => uapi}/asm/sockios.h     |   0
 arch/m32r/include/{ => uapi}/asm/stat.h        |   0
 arch/m32r/include/{ => uapi}/asm/statfs.h      |   0
 arch/m32r/include/{ => uapi}/asm/swab.h        |   0
 arch/m32r/include/{ => uapi}/asm/termbits.h    |   0
 arch/m32r/include/uapi/asm/termios.h           |  43 ++++
 arch/m32r/include/uapi/asm/types.h             |   1 +
 arch/m32r/include/uapi/asm/unistd.h            | 335 +++++++++++++++++++++++++
 38 files changed, 668 insertions(+), 615 deletions(-)
 rename arch/m32r/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/errno.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/mman.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/param.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/poll.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/m32r/include/uapi/asm/ptrace.h
 rename arch/m32r/include/{ => uapi}/asm/resource.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/m32r/include/uapi/asm/setup.h
 rename arch/m32r/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/m32r/include/uapi/asm/signal.h
 rename arch/m32r/include/{ => uapi}/asm/socket.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/stat.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/swab.h (100%)
 rename arch/m32r/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/m32r/include/uapi/asm/termios.h
 create mode 100644 arch/m32r/include/uapi/asm/types.h
 create mode 100644 arch/m32r/include/uapi/asm/unistd.h
.
