Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2LTLOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:14:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab2LTLOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:14:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, lennox.wu@gmail.com, liqin299@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] UAPI disintegration for the Score arch
Date: Thu, 20 Dec 2012 11:14:02 +0000
Message-ID: <26221.1356002042@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Could you pull my UAPI disintegration for the Score arch branch please?  I got
acks from the maintainers which have been folded into the patch.

Thanks,
David
---
The following changes since commit f01af9f85855e38fbd601e033a8eac204cc4cc1c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2012-12-19 20:31:02 -0800)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-score-20121220

for you to fetch changes up to d66d8c7187989cedae43cb349626a7f304c60ec6:

  UAPI: (Scripted) Disintegrate arch/score/include/asm (2012-12-20 10:55:33 +0000)

----------------------------------------------------------------
UAPI disintegration 2012-12-20

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
