Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2JIJPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:15:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab2JIJPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:37 -0400
From: David Howells <dhowells@redhat.com>
To: ysato@users.sourceforge.jp
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for h8300 [ver #2]
Date: Tue, 09 Oct 2012 10:15:25 +0100
Message-ID: <21131.1349774125@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the h8300 tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-h8300-20121009

for you to fetch changes up to c0c32782cbbd986aa2b309bca1dc6eb418ef1014:

  UAPI: (Scripted) Disintegrate arch/h8300/include/asm (2012-10-09 09:46:54 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/h8300/include/asm

 arch/h8300/include/asm/Kbuild                   |   1 -
 arch/h8300/include/asm/param.h                  |  15 +-
 arch/h8300/include/asm/ptrace.h                 |  40 +--
 arch/h8300/include/asm/signal.h                 | 121 +--------
 arch/h8300/include/asm/termios.h                |  44 +---
 arch/h8300/include/asm/types.h                  |   5 +-
 arch/h8300/include/asm/unistd.h                 | 328 +----------------------
 arch/h8300/include/uapi/asm/Kbuild              |  31 +++
 arch/h8300/include/{ => uapi}/asm/auxvec.h      |   0
 arch/h8300/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/h8300/include/{ => uapi}/asm/byteorder.h   |   0
 arch/h8300/include/{ => uapi}/asm/errno.h       |   0
 arch/h8300/include/{ => uapi}/asm/fcntl.h       |   0
 arch/h8300/include/{ => uapi}/asm/ioctl.h       |   0
 arch/h8300/include/{ => uapi}/asm/ioctls.h      |   0
 arch/h8300/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/h8300/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/h8300/include/{ => uapi}/asm/mman.h        |   0
 arch/h8300/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/h8300/include/uapi/asm/param.h             |  16 ++
 arch/h8300/include/{ => uapi}/asm/poll.h        |   0
 arch/h8300/include/{ => uapi}/asm/posix_types.h |   0
 arch/h8300/include/uapi/asm/ptrace.h            |  44 ++++
 arch/h8300/include/{ => uapi}/asm/resource.h    |   0
 arch/h8300/include/{ => uapi}/asm/sembuf.h      |   0
 arch/h8300/include/{ => uapi}/asm/setup.h       |   0
 arch/h8300/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/h8300/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/h8300/include/{ => uapi}/asm/siginfo.h     |   0
 arch/h8300/include/uapi/asm/signal.h            | 121 +++++++++
 arch/h8300/include/{ => uapi}/asm/socket.h      |   0
 arch/h8300/include/{ => uapi}/asm/sockios.h     |   0
 arch/h8300/include/{ => uapi}/asm/stat.h        |   0
 arch/h8300/include/{ => uapi}/asm/statfs.h      |   0
 arch/h8300/include/{ => uapi}/asm/swab.h        |   0
 arch/h8300/include/{ => uapi}/asm/termbits.h    |   0
 arch/h8300/include/uapi/asm/termios.h           |  44 ++++
 arch/h8300/include/uapi/asm/types.h             |   1 +
 arch/h8300/include/uapi/asm/unistd.h            | 330 ++++++++++++++++++++++++
 39 files changed, 595 insertions(+), 546 deletions(-)
 rename arch/h8300/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/errno.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/mman.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/msgbuf.h (100%)
 create mode 100644 arch/h8300/include/uapi/asm/param.h
 rename arch/h8300/include/{ => uapi}/asm/poll.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/h8300/include/uapi/asm/ptrace.h
 rename arch/h8300/include/{ => uapi}/asm/resource.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/sembuf.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/setup.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/h8300/include/uapi/asm/signal.h
 rename arch/h8300/include/{ => uapi}/asm/socket.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/stat.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/swab.h (100%)
 rename arch/h8300/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/h8300/include/uapi/asm/termios.h
 create mode 100644 arch/h8300/include/uapi/asm/types.h
 create mode 100644 arch/h8300/include/uapi/asm/unistd.h
.
