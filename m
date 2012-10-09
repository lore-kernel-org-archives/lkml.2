Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2JIJQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:16:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab2JIJQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:16:21 -0400
From: David Howells <dhowells@redhat.com>
To: liqin.chen@sunplusct.com
Cc: dhowells@redhat.com, lennox.wu@gmail.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for score [ver #2]
Date: Tue, 09 Oct 2012 10:15:55 +0100
Message-ID: <21190.1349774155@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the score tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-score-20121009

for you to fetch changes up to f2f8f65349ca712d47d50c58f37fb76bc56992e3:

  UAPI: (Scripted) Disintegrate arch/score/include/asm (2012-10-09 09:47:35 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/score/include/asm

 arch/score/include/asm/Kbuild                   |  1 -
 arch/score/include/asm/ptrace.h                 | 74 +-----------------------
 arch/score/include/asm/setup.h                  |  7 +--
 arch/score/include/uapi/asm/Kbuild              | 31 ++++++++++
 arch/score/include/{ => uapi}/asm/auxvec.h      |  0
 arch/score/include/{ => uapi}/asm/bitsperlong.h |  0
 arch/score/include/{ => uapi}/asm/byteorder.h   |  0
 arch/score/include/{ => uapi}/asm/errno.h       |  0
 arch/score/include/{ => uapi}/asm/fcntl.h       |  0
 arch/score/include/{ => uapi}/asm/ioctl.h       |  0
 arch/score/include/{ => uapi}/asm/ioctls.h      |  0
 arch/score/include/{ => uapi}/asm/ipcbuf.h      |  0
 arch/score/include/{ => uapi}/asm/kvm_para.h    |  0
 arch/score/include/{ => uapi}/asm/mman.h        |  0
 arch/score/include/{ => uapi}/asm/msgbuf.h      |  0
 arch/score/include/{ => uapi}/asm/param.h       |  0
 arch/score/include/{ => uapi}/asm/poll.h        |  0
 arch/score/include/{ => uapi}/asm/posix_types.h |  0
 arch/score/include/uapi/asm/ptrace.h            | 76 +++++++++++++++++++++++++
 arch/score/include/{ => uapi}/asm/resource.h    |  0
 arch/score/include/{ => uapi}/asm/sembuf.h      |  0
 arch/score/include/uapi/asm/setup.h             |  9 +++
 arch/score/include/{ => uapi}/asm/shmbuf.h      |  0
 arch/score/include/{ => uapi}/asm/sigcontext.h  |  0
 arch/score/include/{ => uapi}/asm/siginfo.h     |  0
 arch/score/include/{ => uapi}/asm/signal.h      |  0
 arch/score/include/{ => uapi}/asm/socket.h      |  0
 arch/score/include/{ => uapi}/asm/sockios.h     |  0
 arch/score/include/{ => uapi}/asm/stat.h        |  0
 arch/score/include/{ => uapi}/asm/statfs.h      |  0
 arch/score/include/{ => uapi}/asm/swab.h        |  0
 arch/score/include/{ => uapi}/asm/termbits.h    |  0
 arch/score/include/{ => uapi}/asm/termios.h     |  0
 arch/score/include/{ => uapi}/asm/types.h       |  0
 arch/score/include/{ => uapi}/asm/unistd.h      |  0
 35 files changed, 118 insertions(+), 80 deletions(-)
 rename arch/score/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/score/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/score/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/score/include/{ => uapi}/asm/errno.h (100%)
 rename arch/score/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/score/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/score/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/score/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/score/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/score/include/{ => uapi}/asm/mman.h (100%)
 rename arch/score/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/score/include/{ => uapi}/asm/param.h (100%)
 rename arch/score/include/{ => uapi}/asm/poll.h (100%)
 rename arch/score/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/score/include/uapi/asm/ptrace.h
 rename arch/score/include/{ => uapi}/asm/resource.h (100%)
 rename arch/score/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/score/include/uapi/asm/setup.h
 rename arch/score/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/score/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/score/include/{ => uapi}/asm/siginfo.h (100%)
 rename arch/score/include/{ => uapi}/asm/signal.h (100%)
 rename arch/score/include/{ => uapi}/asm/socket.h (100%)
 rename arch/score/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/score/include/{ => uapi}/asm/stat.h (100%)
 rename arch/score/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/score/include/{ => uapi}/asm/swab.h (100%)
 rename arch/score/include/{ => uapi}/asm/termbits.h (100%)
 rename arch/score/include/{ => uapi}/asm/termios.h (100%)
 rename arch/score/include/{ => uapi}/asm/types.h (100%)
 rename arch/score/include/{ => uapi}/asm/unistd.h (100%)
.
