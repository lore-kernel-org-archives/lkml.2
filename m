Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2JIJPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:15:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab2JIJPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:40 -0400
From: David Howells <dhowells@redhat.com>
To: geert@linux-m68k.org
Cc: dhowells@redhat.com, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for m68k [ver #2]
Date: Tue, 09 Oct 2012 10:15:35 +0100
Message-ID: <21143.1349774135@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the m68k tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-m68k-20121009

for you to fetch changes up to 10b3a979347d4aba7de19e8d33eb8b87fe2a11dd:

  UAPI: (Scripted) Disintegrate arch/m68k/include/asm (2012-10-09 09:47:06 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/m68k/include/asm

 arch/m68k/include/asm/Kbuild                   |   2 -
 arch/m68k/include/asm/ptrace.h                 |  72 +----
 arch/m68k/include/asm/setup.h                  |  82 +-----
 arch/m68k/include/asm/signal.h                 | 118 +-------
 arch/m68k/include/asm/termios.h                |  44 +--
 arch/m68k/include/asm/unistd.h                 | 354 +-----------------------
 arch/m68k/include/uapi/asm/Kbuild              |  23 ++
 arch/m68k/include/{ => uapi}/asm/a.out.h       |   0
 arch/m68k/include/{ => uapi}/asm/auxvec.h      |   0
 arch/m68k/include/{ => uapi}/asm/byteorder.h   |   0
 arch/m68k/include/{ => uapi}/asm/cachectl.h    |   0
 arch/m68k/include/{ => uapi}/asm/fcntl.h       |   0
 arch/m68k/include/{ => uapi}/asm/ioctls.h      |   0
 arch/m68k/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/m68k/include/{ => uapi}/asm/param.h       |   0
 arch/m68k/include/{ => uapi}/asm/poll.h        |   0
 arch/m68k/include/{ => uapi}/asm/posix_types.h |   0
 arch/m68k/include/uapi/asm/ptrace.h            |  79 ++++++
 arch/m68k/include/{ => uapi}/asm/sembuf.h      |   0
 arch/m68k/include/uapi/asm/setup.h             | 103 +++++++
 arch/m68k/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/m68k/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/m68k/include/uapi/asm/signal.h            | 118 ++++++++
 arch/m68k/include/{ => uapi}/asm/socket.h      |   0
 arch/m68k/include/{ => uapi}/asm/sockios.h     |   0
 arch/m68k/include/{ => uapi}/asm/stat.h        |   0
 arch/m68k/include/{ => uapi}/asm/swab.h        |   0
 arch/m68k/include/{ => uapi}/asm/termbits.h    |   0
 arch/m68k/include/uapi/asm/termios.h           |  44 +++
 arch/m68k/include/uapi/asm/unistd.h            | 356 +++++++++++++++++++++++++
 30 files changed, 728 insertions(+), 667 deletions(-)
 rename arch/m68k/include/{ => uapi}/asm/a.out.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/cachectl.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/param.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/poll.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/m68k/include/uapi/asm/ptrace.h
 rename arch/m68k/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/m68k/include/uapi/asm/setup.h
 rename arch/m68k/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/sigcontext.h (100%)
 create mode 100644 arch/m68k/include/uapi/asm/signal.h
 rename arch/m68k/include/{ => uapi}/asm/socket.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/stat.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/swab.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/m68k/include/uapi/asm/termios.h
 create mode 100644 arch/m68k/include/uapi/asm/unistd.h
.
