Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2LTLIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:08:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2LTLHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:07:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, ysato@users.sourceforge.jp
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] UAPI disintegration for H8/300 arch
Date: Thu, 20 Dec 2012 11:07:41 +0000
Message-ID: <26067.1356001661@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Could you pull my UAPI disintegration for the H8/300 arch branch please?  I
haven't been able to get hold of the maintainer to push it through their tree.

Thanks,
David
---
The following changes since commit 752451f01c4567b506bf4343082682dbb8fb30dd:

  Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux (2012-12-18 16:51:10 -0800)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-h8300-20121219

for you to fetch changes up to 1ec94e75def550548725a0bd77312ed6c266687a:

  UAPI: (Scripted) Disintegrate arch/h8300/include/asm (2012-12-19 16:07:13 +0000)

----------------------------------------------------------------
UAPI Disintegration 2012-12-19

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
