Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab2LTLJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:09:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2LTLJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:09:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, takata@linux-m32r.org
cc: dhowells@redhat.com, linux-m32r@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] UAPI disintegration for the M32R arch
Date: Thu, 20 Dec 2012 11:09:34 +0000
Message-ID: <26094.1356001774@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Could you pull my UAPI disintegration for the M32R arch branch please?  I
haven't been able to get hold of the maintainer to push it through their tree.

Thanks,
David
---
The following changes since commit 752451f01c4567b506bf4343082682dbb8fb30dd:

  Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux (2012-12-18 16:51:10 -0800)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-m32r-20121219

for you to fetch changes up to f7f4dc10e1eb04eb8426a192a314b64444a333f4:

  UAPI: (Scripted) Disintegrate arch/m32r/include/asm (2012-12-19 16:07:18 +0000)

----------------------------------------------------------------
UAPI Disintegration 2012-12-19

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
