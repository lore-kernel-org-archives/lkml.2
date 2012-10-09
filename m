Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab2JIJQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:16:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab2JIJQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:16:11 -0400
From: David Howells <dhowells@redhat.com>
To: chris@zankel.net
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for xtensa [ver #2]
Date: Tue, 09 Oct 2012 10:16:09 +0100
Message-ID: <21232.1349774169@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the xtensa tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-xtensa-20121009

for you to fetch changes up to 91a0696e40414e9f1554cd91060f6b404d545cb3:

  UAPI: (Scripted) Disintegrate arch/xtensa/include/asm (2012-10-09 09:47:57 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/xtensa/include/asm

 arch/xtensa/include/asm/Kbuild                   |   1 -
 arch/xtensa/include/asm/param.h                  |  20 +-
 arch/xtensa/include/asm/ptrace.h                 |  66 +--
 arch/xtensa/include/asm/signal.h                 | 134 +----
 arch/xtensa/include/asm/termios.h                |  43 +-
 arch/xtensa/include/asm/types.h                  |  15 +-
 arch/xtensa/include/asm/unistd.h                 | 698 +---------------------
 arch/xtensa/include/uapi/asm/Kbuild              |  31 +
 arch/xtensa/include/{ => uapi}/asm/auxvec.h      |   0
 arch/xtensa/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/xtensa/include/{ => uapi}/asm/byteorder.h   |   0
 arch/xtensa/include/{ => uapi}/asm/errno.h       |   0
 arch/xtensa/include/{ => uapi}/asm/fcntl.h       |   0
 arch/xtensa/include/{ => uapi}/asm/ioctl.h       |   0
 arch/xtensa/include/{ => uapi}/asm/ioctls.h      |   0
 arch/xtensa/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/xtensa/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/xtensa/include/{ => uapi}/asm/mman.h        |   0
 arch/xtensa/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/xtensa/include/uapi/asm/param.h             |  30 +
 arch/xtensa/include/{ => uapi}/asm/poll.h        |   0
 arch/xtensa/include/{ => uapi}/asm/posix_types.h |   0
 arch/xtensa/include/uapi/asm/ptrace.h            |  77 +++
 arch/xtensa/include/{ => uapi}/asm/resource.h    |   0
 arch/xtensa/include/{ => uapi}/asm/sembuf.h      |   0
 arch/xtensa/include/{ => uapi}/asm/setup.h       |   0
 arch/xtensa/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/xtensa/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/xtensa/include/{ => uapi}/asm/siginfo.h     |   0
 arch/xtensa/include/uapi/asm/signal.h            | 148 +++++
 arch/xtensa/include/{ => uapi}/asm/socket.h      |   0
 arch/xtensa/include/{ => uapi}/asm/sockios.h     |   0
 arch/xtensa/include/{ => uapi}/asm/stat.h        |   0
 arch/xtensa/include/{ => uapi}/asm/statfs.h      |   0
 arch/xtensa/include/{ => uapi}/asm/swab.h        |   0
 arch/xtensa/include/{ => uapi}/asm/termbits.h    |   0
 arch/xtensa/include/uapi/asm/termios.h           |  56 ++
 arch/xtensa/include/uapi/asm/types.h             |  28 +
 arch/xtensa/include/uapi/asm/unistd.h            | 709 +++++++++++++++++++++++
 39 files changed, 1086 insertions(+), 970 deletions(-)
 rename arch/xtensa/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/errno.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/mman.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/msgbuf.h (100%)
 create mode 100644 arch/xtensa/include/uapi/asm/param.h
 rename arch/xtensa/include/{ => uapi}/asm/poll.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/xtensa/include/uapi/asm/ptrace.h
 rename arch/xtensa/include/{ => uapi}/asm/resource.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/sembuf.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/setup.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/xtensa/include/uapi/asm/signal.h
 rename arch/xtensa/include/{ => uapi}/asm/socket.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/stat.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/swab.h (100%)
 rename arch/xtensa/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/xtensa/include/uapi/asm/termios.h
 create mode 100644 arch/xtensa/include/uapi/asm/types.h
 create mode 100644 arch/xtensa/include/uapi/asm/unistd.h
.
