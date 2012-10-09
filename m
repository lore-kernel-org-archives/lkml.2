Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2JIJP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab2JIJPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:24 -0400
From: David Howells <dhowells@redhat.com>
To: hskinnemoen@gmail.com
Cc: dhowells@redhat.com, egtvedt@samfundet.no, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for avr32 [ver #2]
Date: Tue, 09 Oct 2012 10:15:15 +0100
Message-ID: <21113.1349774115@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the avr32 tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-avr32-20121009

for you to fetch changes up to b9ba6b52cfb7f564c205bc42fed3297d623fc50f:

  UAPI: (Scripted) Disintegrate arch/avr32/include/asm (2012-10-09 09:46:37 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/avr32/include/asm

 arch/avr32/include/asm/Kbuild                   |   3 -
 arch/avr32/include/asm/param.h                  |  18 +-
 arch/avr32/include/asm/ptrace.h                 | 115 +--------
 arch/avr32/include/asm/setup.h                  |   5 +-
 arch/avr32/include/asm/signal.h                 | 121 +---------
 arch/avr32/include/asm/termios.h                |  41 +---
 arch/avr32/include/asm/types.h                  |   6 +-
 arch/avr32/include/asm/unistd.h                 | 296 +----------------------
 arch/avr32/include/uapi/asm/Kbuild              |  32 +++
 arch/avr32/include/{ => uapi}/asm/auxvec.h      |   0
 arch/avr32/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/avr32/include/{ => uapi}/asm/byteorder.h   |   0
 arch/avr32/include/{ => uapi}/asm/cachectl.h    |   0
 arch/avr32/include/{ => uapi}/asm/errno.h       |   0
 arch/avr32/include/{ => uapi}/asm/fcntl.h       |   0
 arch/avr32/include/{ => uapi}/asm/ioctl.h       |   0
 arch/avr32/include/{ => uapi}/asm/ioctls.h      |   0
 arch/avr32/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/avr32/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/avr32/include/{ => uapi}/asm/mman.h        |   0
 arch/avr32/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/avr32/include/uapi/asm/param.h             |  18 ++
 arch/avr32/include/{ => uapi}/asm/poll.h        |   0
 arch/avr32/include/{ => uapi}/asm/posix_types.h |   0
 arch/avr32/include/uapi/asm/ptrace.h            | 126 ++++++++++
 arch/avr32/include/{ => uapi}/asm/resource.h    |   0
 arch/avr32/include/{ => uapi}/asm/sembuf.h      |   0
 arch/avr32/include/uapi/asm/setup.h             |  17 ++
 arch/avr32/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/avr32/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/avr32/include/{ => uapi}/asm/siginfo.h     |   0
 arch/avr32/include/uapi/asm/signal.h            | 128 ++++++++++
 arch/avr32/include/{ => uapi}/asm/socket.h      |   0
 arch/avr32/include/{ => uapi}/asm/sockios.h     |   0
 arch/avr32/include/{ => uapi}/asm/stat.h        |   0
 arch/avr32/include/{ => uapi}/asm/statfs.h      |   0
 arch/avr32/include/{ => uapi}/asm/swab.h        |   0
 arch/avr32/include/{ => uapi}/asm/termbits.h    |   0
 arch/avr32/include/uapi/asm/termios.h           |  50 ++++
 arch/avr32/include/uapi/asm/types.h             |   8 +
 arch/avr32/include/uapi/asm/unistd.h            | 305 ++++++++++++++++++++++++
 41 files changed, 692 insertions(+), 597 deletions(-)
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
.
