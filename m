Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2JOGgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 02:36:08 -0400
Received: from linux-sh.org ([111.68.239.195]:45785 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab2JOGgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 02:36:06 -0400
Date: Mon, 15 Oct 2012 15:35:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 3.7-rc2
Message-ID: <20121015063557.GB32566@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://github.com/pmundt/linux-sh tags/sh-for-linus

for you to fetch changes up to 0dd4d5cbe4c38165dc9b3ad329ebb23f24d74fdb:

  sh: Fix up more fallout from pointless ARM __iomem churn. (2012-10-15 14:08:48 +0900)

----------------------------------------------------------------
SuperH updates for 3.7-rc2

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/sh/include/asm

Paul Mundt (3):
      Merge tag 'disintegrate-sh-20121009' of git://git.infradead.org/users/dhowells/linux-headers into sh-latest
      sh: Wire up kcmp syscall.
      sh: Fix up more fallout from pointless ARM __iomem churn.

 arch/sh/include/asm/Kbuild                      | 11 ----
 arch/sh/include/asm/hw_breakpoint.h             |  4 +-
 arch/sh/include/asm/posix_types.h               |  8 ---
 arch/sh/include/asm/ptrace.h                    | 34 +----------
 arch/sh/include/asm/ptrace_32.h                 | 75 +-----------------------
 arch/sh/include/asm/ptrace_64.h                 | 12 +---
 arch/sh/include/asm/setup.h                     |  5 +-
 arch/sh/include/asm/types.h                     |  5 +-
 arch/sh/include/asm/unistd.h                    |  9 +--
 arch/sh/include/uapi/asm/Kbuild                 | 22 +++++++
 arch/sh/include/{ => uapi}/asm/auxvec.h         |  0
 arch/sh/include/{ => uapi}/asm/byteorder.h      |  0
 arch/sh/include/{ => uapi}/asm/cachectl.h       |  0
 arch/sh/include/{ => uapi}/asm/cpu-features.h   |  0
 arch/sh/include/{ => uapi}/asm/ioctls.h         |  0
 arch/sh/include/uapi/asm/posix_types.h          |  7 +++
 arch/sh/include/{ => uapi}/asm/posix_types_32.h |  0
 arch/sh/include/{ => uapi}/asm/posix_types_64.h |  0
 arch/sh/include/uapi/asm/ptrace.h               | 34 +++++++++++
 arch/sh/include/uapi/asm/ptrace_32.h            | 77 +++++++++++++++++++++++++
 arch/sh/include/uapi/asm/ptrace_64.h            | 14 +++++
 arch/sh/include/uapi/asm/setup.h                |  1 +
 arch/sh/include/{ => uapi}/asm/sigcontext.h     |  0
 arch/sh/include/{ => uapi}/asm/signal.h         |  0
 arch/sh/include/{ => uapi}/asm/sockios.h        |  0
 arch/sh/include/{ => uapi}/asm/stat.h           |  0
 arch/sh/include/{ => uapi}/asm/swab.h           |  0
 arch/sh/include/uapi/asm/types.h                |  1 +
 arch/sh/include/uapi/asm/unistd.h               |  7 +++
 arch/sh/include/{ => uapi}/asm/unistd_32.h      |  3 +-
 arch/sh/include/{ => uapi}/asm/unistd_64.h      |  3 +-
 arch/sh/kernel/syscalls_32.S                    |  1 +
 arch/sh/kernel/syscalls_64.S                    |  1 +
 drivers/sh/intc/access.c                        | 45 +++++++++------
 drivers/sh/intc/chip.c                          |  4 +-
 drivers/tty/serial/sh-sci.c                     |  3 +-
 36 files changed, 210 insertions(+), 176 deletions(-)
 rename arch/sh/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/sh/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/sh/include/{ => uapi}/asm/cachectl.h (100%)
 rename arch/sh/include/{ => uapi}/asm/cpu-features.h (100%)
 create mode 100644 arch/sh/include/uapi/asm/hw_breakpoint.h
 rename arch/sh/include/{ => uapi}/asm/ioctls.h (100%)
 create mode 100644 arch/sh/include/uapi/asm/posix_types.h
 rename arch/sh/include/{ => uapi}/asm/posix_types_32.h (100%)
 rename arch/sh/include/{ => uapi}/asm/posix_types_64.h (100%)
 create mode 100644 arch/sh/include/uapi/asm/ptrace.h
 create mode 100644 arch/sh/include/uapi/asm/ptrace_32.h
 create mode 100644 arch/sh/include/uapi/asm/ptrace_64.h
 create mode 100644 arch/sh/include/uapi/asm/setup.h
 rename arch/sh/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/sh/include/{ => uapi}/asm/signal.h (100%)
 rename arch/sh/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/sh/include/{ => uapi}/asm/stat.h (100%)
 rename arch/sh/include/{ => uapi}/asm/swab.h (100%)
 create mode 100644 arch/sh/include/uapi/asm/types.h
 create mode 100644 arch/sh/include/uapi/asm/unistd.h
 rename arch/sh/include/{ => uapi}/asm/unistd_32.h (99%)
 rename arch/sh/include/{ => uapi}/asm/unistd_64.h (99%)
