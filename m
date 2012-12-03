Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2LCNkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:40:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab2LCNks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:40:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Ingo Molnar <mingo.kernel.org@gmail.com>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>
cc: dhowells@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] UAPI: Disintegrate arch/x86/include/asm
Date: Mon, 03 Dec 2012 13:40:35 +0000
Message-ID: <26921.1354542035@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo, Peter, Thomas,

Could you merge the x86 arch include disintegration into the tip git tree now
that the perf stuff has been dealt with?

Many thanks,
David
---
The following changes since commit 7e5530af11be68f3109672aed59243f82e1272f0:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-12-02 16:39:00 -0800)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-x86-20121203

for you to fetch changes up to 7c258580403f18c0b326290253a04a8e38379663:

  UAPI: (Scripted) Disintegrate arch/x86/include/asm (2012-12-03 12:32:55 +0000)

----------------------------------------------------------------
UAPI disintegration 2012-12-03

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/x86/include/asm

 arch/x86/include/asm/Kbuild                       |  26 ---
 arch/x86/include/asm/boot.h                       |   9 +-
 arch/x86/include/asm/debugreg.h                   |  79 +-------
 arch/x86/include/asm/e820.h                       |  74 +-------
 arch/x86/include/asm/hw_breakpoint.h              |   5 +-
 arch/x86/include/asm/ist.h                        |  17 +-
 arch/x86/include/asm/kvm_para.h                   |  99 +---------
 arch/x86/include/asm/mce.h                        | 119 +-----------
 arch/x86/include/asm/msr.h                        |  11 +-
 arch/x86/include/asm/mtrr.h                       |  93 +--------
 arch/x86/include/asm/posix_types.h                |  10 -
 arch/x86/include/asm/processor-flags.h            |  97 +---------
 arch/x86/include/asm/ptrace.h                     |  75 +-------
 arch/x86/include/asm/setup.h                      |   5 +-
 arch/x86/include/asm/sigcontext.h                 | 216 +--------------------
 arch/x86/include/asm/signal.h                     | 140 +-------------
 arch/x86/include/asm/svm.h                        | 132 +------------
 arch/x86/include/asm/unistd.h                     |  14 +-
 arch/x86/include/asm/vm86.h                       | 128 +------------
 arch/x86/include/asm/vmx.h                        |  89 +--------
 arch/x86/include/asm/vsyscall.h                   |  16 +-
 arch/x86/include/uapi/asm/Kbuild                  |  58 ++++++
 arch/x86/include/{ => uapi}/asm/a.out.h           |   0
 arch/x86/include/{ => uapi}/asm/auxvec.h          |   0
 arch/x86/include/{ => uapi}/asm/bitsperlong.h     |   0
 arch/x86/include/uapi/asm/boot.h                  |  10 +
 arch/x86/include/{ => uapi}/asm/bootparam.h       |   0
 arch/x86/include/{ => uapi}/asm/byteorder.h       |   0
 arch/x86/include/uapi/asm/debugreg.h              |  80 ++++++++
 arch/x86/include/uapi/asm/e820.h                  |  75 ++++++++
 arch/x86/include/{ => uapi}/asm/errno.h           |   0
 arch/x86/include/{ => uapi}/asm/fcntl.h           |   0
 arch/x86/include/{ => uapi}/asm/hyperv.h          |   0
 arch/x86/include/{ => uapi}/asm/ioctl.h           |   0
 arch/x86/include/{ => uapi}/asm/ioctls.h          |   0
 arch/x86/include/{ => uapi}/asm/ipcbuf.h          |   0
 arch/x86/include/uapi/asm/ist.h                   |  29 +++
 arch/x86/include/{ => uapi}/asm/kvm.h             |   0
 arch/x86/include/uapi/asm/kvm_para.h              | 100 ++++++++++
 arch/x86/include/{ => uapi}/asm/ldt.h             |   0
 arch/x86/include/uapi/asm/mce.h                   | 121 ++++++++++++
 arch/x86/include/{ => uapi}/asm/mman.h            |   0
 arch/x86/include/{ => uapi}/asm/msgbuf.h          |   0
 arch/x86/include/{ => uapi}/asm/msr-index.h       |   0
 arch/x86/include/uapi/asm/msr.h                   |  15 ++
 arch/x86/include/uapi/asm/mtrr.h                  | 117 ++++++++++++
 arch/x86/include/{ => uapi}/asm/param.h           |   0
 arch/x86/include/{ => uapi}/asm/perf_regs.h       |   0
 arch/x86/include/{ => uapi}/asm/poll.h            |   0
 arch/x86/include/uapi/asm/posix_types.h           |   9 +
 arch/x86/include/{ => uapi}/asm/posix_types_32.h  |   0
 arch/x86/include/{ => uapi}/asm/posix_types_64.h  |   0
 arch/x86/include/{ => uapi}/asm/posix_types_x32.h |   0
 arch/x86/include/{ => uapi}/asm/prctl.h           |   0
 arch/x86/include/uapi/asm/processor-flags.h       |  99 ++++++++++
 arch/x86/include/{ => uapi}/asm/ptrace-abi.h      |   0
 arch/x86/include/uapi/asm/ptrace.h                |  78 ++++++++
 arch/x86/include/{ => uapi}/asm/resource.h        |   0
 arch/x86/include/{ => uapi}/asm/sembuf.h          |   0
 arch/x86/include/{ => uapi}/asm/shmbuf.h          |   0
 arch/x86/include/uapi/asm/sigcontext.h            | 221 ++++++++++++++++++++++
 arch/x86/include/{ => uapi}/asm/sigcontext32.h    |   0
 arch/x86/include/{ => uapi}/asm/siginfo.h         |   0
 arch/x86/include/uapi/asm/signal.h                | 145 ++++++++++++++
 arch/x86/include/{ => uapi}/asm/socket.h          |   0
 arch/x86/include/{ => uapi}/asm/sockios.h         |   0
 arch/x86/include/{ => uapi}/asm/stat.h            |   0
 arch/x86/include/{ => uapi}/asm/statfs.h          |   0
 arch/x86/include/uapi/asm/svm.h                   | 132 +++++++++++++
 arch/x86/include/{ => uapi}/asm/swab.h            |   0
 arch/x86/include/{ => uapi}/asm/termbits.h        |   0
 arch/x86/include/{ => uapi}/asm/termios.h         |   0
 arch/x86/include/{ => uapi}/asm/types.h           |   0
 arch/x86/include/{ => uapi}/asm/ucontext.h        |   0
 arch/x86/include/uapi/asm/unistd.h                |  17 ++
 arch/x86/include/uapi/asm/vm86.h                  | 129 +++++++++++++
 arch/x86/include/uapi/asm/vmx.h                   | 109 +++++++++++
 arch/x86/include/uapi/asm/vsyscall.h              |  17 ++
 78 files changed, 1587 insertions(+), 1428 deletions(-)
 rename arch/x86/include/{ => uapi}/asm/a.out.h (100%)
 rename arch/x86/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/x86/include/{ => uapi}/asm/bitsperlong.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/boot.h
 rename arch/x86/include/{ => uapi}/asm/bootparam.h (100%)
 rename arch/x86/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/debugreg.h
 create mode 100644 arch/x86/include/uapi/asm/e820.h
 rename arch/x86/include/{ => uapi}/asm/errno.h (100%)
 rename arch/x86/include/{ => uapi}/asm/fcntl.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/hw_breakpoint.h
 rename arch/x86/include/{ => uapi}/asm/hyperv.h (100%)
 rename arch/x86/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/x86/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/x86/include/{ => uapi}/asm/ipcbuf.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/ist.h
 rename arch/x86/include/{ => uapi}/asm/kvm.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/kvm_para.h
 rename arch/x86/include/{ => uapi}/asm/ldt.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/mce.h
 rename arch/x86/include/{ => uapi}/asm/mman.h (100%)
 rename arch/x86/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/x86/include/{ => uapi}/asm/msr-index.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/msr.h
 create mode 100644 arch/x86/include/uapi/asm/mtrr.h
 rename arch/x86/include/{ => uapi}/asm/param.h (100%)
 rename arch/x86/include/{ => uapi}/asm/perf_regs.h (100%)
 rename arch/x86/include/{ => uapi}/asm/poll.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/posix_types.h
 rename arch/x86/include/{ => uapi}/asm/posix_types_32.h (100%)
 rename arch/x86/include/{ => uapi}/asm/posix_types_64.h (100%)
 rename arch/x86/include/{ => uapi}/asm/posix_types_x32.h (100%)
 rename arch/x86/include/{ => uapi}/asm/prctl.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/processor-flags.h
 rename arch/x86/include/{ => uapi}/asm/ptrace-abi.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/ptrace.h
 rename arch/x86/include/{ => uapi}/asm/resource.h (100%)
 rename arch/x86/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/setup.h
 rename arch/x86/include/{ => uapi}/asm/shmbuf.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/sigcontext.h
 rename arch/x86/include/{ => uapi}/asm/sigcontext32.h (100%)
 rename arch/x86/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/signal.h
 rename arch/x86/include/{ => uapi}/asm/socket.h (100%)
 rename arch/x86/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/x86/include/{ => uapi}/asm/stat.h (100%)
 rename arch/x86/include/{ => uapi}/asm/statfs.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/svm.h
 rename arch/x86/include/{ => uapi}/asm/swab.h (100%)
 rename arch/x86/include/{ => uapi}/asm/termbits.h (100%)
 rename arch/x86/include/{ => uapi}/asm/termios.h (100%)
 rename arch/x86/include/{ => uapi}/asm/types.h (100%)
 rename arch/x86/include/{ => uapi}/asm/ucontext.h (100%)
 create mode 100644 arch/x86/include/uapi/asm/unistd.h
 create mode 100644 arch/x86/include/uapi/asm/vm86.h
 create mode 100644 arch/x86/include/uapi/asm/vmx.h
 create mode 100644 arch/x86/include/uapi/asm/vsyscall.h
