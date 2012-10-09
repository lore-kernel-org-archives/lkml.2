Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab2JIJQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:16:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab2JIJQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:16:12 -0400
From: David Howells <dhowells@redhat.com>
To: jejb@parisc-linux.org
Cc: dhowells@redhat.com, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for parisc [ver #2]
Date: Tue, 09 Oct 2012 10:15:45 +0100
Message-ID: <21164.1349774145@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the parisc tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-parisc-20121009

for you to fetch changes up to 7869b46c99d8de719f7543d6ba432a7fcc3c78b3:

  UAPI: (Scripted) Disintegrate arch/parisc/include/asm (2012-10-09 09:47:22 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/parisc/include/asm

 arch/parisc/include/asm/Kbuild                   |   2 -
 arch/parisc/include/asm/pdc.h                    | 423 +-----------
 arch/parisc/include/asm/ptrace.h                 |  46 +-
 arch/parisc/include/asm/signal.h                 | 113 +--
 arch/parisc/include/asm/termios.h                |  41 +-
 arch/parisc/include/asm/unistd.h                 | 835 +---------------------
 arch/parisc/include/uapi/asm/Kbuild              |  32 +
 arch/parisc/include/{ => uapi}/asm/auxvec.h      |   0
 arch/parisc/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/parisc/include/{ => uapi}/asm/byteorder.h   |   0
 arch/parisc/include/{ => uapi}/asm/errno.h       |   0
 arch/parisc/include/{ => uapi}/asm/fcntl.h       |   0
 arch/parisc/include/{ => uapi}/asm/ioctl.h       |   0
 arch/parisc/include/{ => uapi}/asm/ioctls.h      |   0
 arch/parisc/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/parisc/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/parisc/include/{ => uapi}/asm/mman.h        |   0
 arch/parisc/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/parisc/include/{ => uapi}/asm/param.h       |   0
 arch/parisc/include/uapi/asm/pdc.h               | 427 ++++++++++++
 arch/parisc/include/{ => uapi}/asm/poll.h        |   0
 arch/parisc/include/{ => uapi}/asm/posix_types.h |   0
 arch/parisc/include/uapi/asm/ptrace.h            |  47 ++
 arch/parisc/include/{ => uapi}/asm/resource.h    |   0
 arch/parisc/include/{ => uapi}/asm/sembuf.h      |   0
 arch/parisc/include/{ => uapi}/asm/setup.h       |   0
 arch/parisc/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/parisc/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/parisc/include/{ => uapi}/asm/siginfo.h     |   0
 arch/parisc/include/uapi/asm/signal.h            | 118 ++++
 arch/parisc/include/{ => uapi}/asm/socket.h      |   0
 arch/parisc/include/{ => uapi}/asm/sockios.h     |   0
 arch/parisc/include/{ => uapi}/asm/stat.h        |   0
 arch/parisc/include/{ => uapi}/asm/statfs.h      |   0
 arch/parisc/include/{ => uapi}/asm/swab.h        |   0
 arch/parisc/include/{ => uapi}/asm/termbits.h    |   0
 arch/parisc/include/uapi/asm/termios.h           |  43 ++
 arch/parisc/include/{ => uapi}/asm/types.h       |   0
 arch/parisc/include/uapi/asm/unistd.h            | 837 +++++++++++++++++++++++
 39 files changed, 1511 insertions(+), 1453 deletions(-)
 rename arch/parisc/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/errno.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/mman.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/param.h (100%)
 create mode 100644 arch/parisc/include/uapi/asm/pdc.h
 rename arch/parisc/include/{ => uapi}/asm/poll.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/parisc/include/uapi/asm/ptrace.h
 rename arch/parisc/include/{ => uapi}/asm/resource.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/sembuf.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/setup.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/parisc/include/uapi/asm/signal.h
 rename arch/parisc/include/{ => uapi}/asm/socket.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/stat.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/swab.h (100%)
 rename arch/parisc/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/parisc/include/uapi/asm/termios.h
 rename arch/parisc/include/{ => uapi}/asm/types.h (100%)
 create mode 100644 arch/parisc/include/uapi/asm/unistd.h
.
