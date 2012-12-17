Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2LQOQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:16:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2LQOQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:16:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, Matt Turner <mattst88@gmail.com>,
        Michael Cree <mcree@orcon.net.nz>, rth@twiddle.net,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] UAPI disintegration for Alpha
Date: Mon, 17 Dec 2012 14:15:21 +0000
Message-ID: <5672.1355753721@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

I've been asked to send the Alpha UAPI disintegration to you directly.  If
you'd prefer it to come later in the merge window, I can regenerate it later
and push it again.  The acks I have been given have been added into the patch.

David
---
The following changes since commit a4f1de176614f634c367e5994a7bcc428c940df0:

  mm: fix kernel BUG at huge_memory.c:1474! (2012-12-16 19:02:38 -0800)

are available in the git repository at:

  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-alpha-20121217

for you to fetch changes up to 96433f6ee49032d7a8bda76de2b05cfde2914354:

  UAPI: (Scripted) Disintegrate arch/alpha/include/asm (2012-12-17 14:12:19 +0000)

----------------------------------------------------------------
UAPI disintegration 2012-12-17

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/alpha/include/asm

 arch/alpha/include/asm/Kbuild                   |   9 -
 arch/alpha/include/asm/a.out.h                  |  89 +----
 arch/alpha/include/asm/compiler.h               | 115 +-----
 arch/alpha/include/asm/console.h                |  48 +--
 arch/alpha/include/asm/fpu.h                    | 124 +------
 arch/alpha/include/asm/pal.h                    |  50 +--
 arch/alpha/include/asm/param.h                  |  20 +-
 arch/alpha/include/asm/ptrace.h                 |  68 +---
 arch/alpha/include/asm/signal.h                 | 135 +------
 arch/alpha/include/asm/socket.h                 |  79 +---
 arch/alpha/include/asm/termios.h                |  68 +---
 arch/alpha/include/asm/types.h                  |  13 +-
 arch/alpha/include/asm/unistd.h                 | 469 +----------------------
 arch/alpha/include/uapi/asm/Kbuild              |  40 ++
 arch/alpha/include/uapi/asm/a.out.h             |  91 +++++
 arch/alpha/include/{ => uapi}/asm/auxvec.h      |   0
 arch/alpha/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/alpha/include/{ => uapi}/asm/byteorder.h   |   0
 arch/alpha/include/uapi/asm/compiler.h          | 117 ++++++
 arch/alpha/include/uapi/asm/console.h           |  50 +++
 arch/alpha/include/{ => uapi}/asm/errno.h       |   0
 arch/alpha/include/{ => uapi}/asm/fcntl.h       |   0
 arch/alpha/include/uapi/asm/fpu.h               | 123 +++++++
 arch/alpha/include/{ => uapi}/asm/gentrap.h     |   0
 arch/alpha/include/{ => uapi}/asm/ioctl.h       |   0
 arch/alpha/include/{ => uapi}/asm/ioctls.h      |   0
 arch/alpha/include/{ => uapi}/asm/ipcbuf.h      |   0
 arch/alpha/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/alpha/include/{ => uapi}/asm/mman.h        |   0
 arch/alpha/include/{ => uapi}/asm/msgbuf.h      |   0
 arch/alpha/include/uapi/asm/pal.h               |  52 +++
 arch/alpha/include/uapi/asm/param.h             |  21 ++
 arch/alpha/include/{ => uapi}/asm/poll.h        |   0
 arch/alpha/include/{ => uapi}/asm/posix_types.h |   0
 arch/alpha/include/uapi/asm/ptrace.h            |  70 ++++
 arch/alpha/include/{ => uapi}/asm/reg.h         |   0
 arch/alpha/include/{ => uapi}/asm/regdef.h      |   0
 arch/alpha/include/{ => uapi}/asm/resource.h    |   0
 arch/alpha/include/{ => uapi}/asm/sembuf.h      |   0
 arch/alpha/include/{ => uapi}/asm/setup.h       |   0
 arch/alpha/include/{ => uapi}/asm/shmbuf.h      |   0
 arch/alpha/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/alpha/include/{ => uapi}/asm/siginfo.h     |   0
 arch/alpha/include/uapi/asm/signal.h            | 135 +++++++
 arch/alpha/include/uapi/asm/socket.h            |  81 ++++
 arch/alpha/include/{ => uapi}/asm/sockios.h     |   0
 arch/alpha/include/{ => uapi}/asm/stat.h        |   0
 arch/alpha/include/{ => uapi}/asm/statfs.h      |   0
 arch/alpha/include/{ => uapi}/asm/swab.h        |   0
 arch/alpha/include/{ => uapi}/asm/sysinfo.h     |   0
 arch/alpha/include/{ => uapi}/asm/termbits.h    |   0
 arch/alpha/include/uapi/asm/termios.h           |  70 ++++
 arch/alpha/include/uapi/asm/types.h             |  16 +
 arch/alpha/include/uapi/asm/unistd.h            | 471 ++++++++++++++++++++++++
 54 files changed, 1349 insertions(+), 1275 deletions(-)
 create mode 100644 arch/alpha/include/uapi/asm/a.out.h
 rename arch/alpha/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/compiler.h
 create mode 100644 arch/alpha/include/uapi/asm/console.h
 rename arch/alpha/include/{ => uapi}/asm/errno.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/fcntl.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/fpu.h
 rename arch/alpha/include/{ => uapi}/asm/gentrap.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/mman.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/msgbuf.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/pal.h
 create mode 100644 arch/alpha/include/uapi/asm/param.h
 rename arch/alpha/include/{ => uapi}/asm/poll.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/ptrace.h
 rename arch/alpha/include/{ => uapi}/asm/reg.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/regdef.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/resource.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/sembuf.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/setup.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/signal.h
 create mode 100644 arch/alpha/include/uapi/asm/socket.h
 rename arch/alpha/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/stat.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/statfs.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/swab.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/sysinfo.h (100%)
 rename arch/alpha/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/alpha/include/uapi/asm/termios.h
 create mode 100644 arch/alpha/include/uapi/asm/types.h
 create mode 100644 arch/alpha/include/uapi/asm/unistd.h
