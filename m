Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab2LTMof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:44:35 -0500
Received: from anubis.se.axis.com ([195.60.68.12]:40771 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2LTMo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:44:28 -0500
Date: Thu, 20 Dec 2012 13:44:25 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Subject: [GIT PULL] CRIS updates for 3.8
Message-ID: <20121220124423.GT14172@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull for CRIS 3.8 updates.

Thanks, och God Jul!

The following changes since commit f01af9f85855e38fbd601e033a8eac204cc4cc1c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2012-12-19 20:31:02 -0800)

are available in the git repository at:

  git://jni.nu/cris.git tags/cris-for-linus-3.8

for you to fetch changes up to 77c8006d8df4d5bafeb1d15eafa0886ae96e9b17:

  UAPI: Fix up empty files in arch/cris/ (2012-12-20 12:51:25 +0100)

----------------------------------------------------------------
CRIS changes for 3.8

----------------------------------------------------------------
David Howells (4):
      UAPI: (Scripted) Disintegrate arch/cris/include/arch-v10/arch
      UAPI: (Scripted) Disintegrate arch/cris/include/arch-v32/arch
      UAPI: (Scripted) Disintegrate arch/cris/include/asm
      UAPI: Fix up empty files in arch/cris/

James Hogan (1):
      CRIS: use kbuild.h instead of defining macros in asm-offset.c

Jesper Nilsson (1):
      Merge tag 'disintegrate-cris-20121009' of git://git.infradead.org/users/dhowells/linux-headers into for-linus2

Wei Yongjun (1):
      CRIS: locking: fix the return value of arch_read_trylock()

 arch/cris/include/arch-v10/arch/Kbuild             |   5 +-
 arch/cris/include/arch-v32/arch/Kbuild             |   3 +-
 arch/cris/include/arch-v32/arch/cryptocop.h        | 116 +------
 arch/cris/include/arch-v32/arch/spinlock.h         |   2 +-
 arch/cris/include/asm/Kbuild                       |   5 -
 arch/cris/include/asm/ptrace.h                     |   5 +-
 arch/cris/include/asm/signal.h                     | 121 +-------
 arch/cris/include/asm/swab.h                       |   3 +-
 arch/cris/include/asm/termios.h                    |  43 +--
 arch/cris/include/asm/types.h                      |   5 +-
 arch/cris/include/asm/unistd.h                     | 342 +-------------------
 arch/cris/include/uapi/arch-v10/arch/Kbuild        |   4 +
 .../include/{ => uapi}/arch-v10/arch/sv_addr.agh   |   0
 .../include/{ => uapi}/arch-v10/arch/sv_addr_ag.h  |   0
 .../cris/include/{ => uapi}/arch-v10/arch/svinto.h |   0
 arch/cris/include/{ => uapi}/arch-v10/arch/user.h  |   0
 arch/cris/include/uapi/arch-v32/arch/Kbuild        |   2 +
 arch/cris/include/uapi/arch-v32/arch/cryptocop.h   | 122 ++++++++
 arch/cris/include/{ => uapi}/arch-v32/arch/user.h  |   0
 arch/cris/include/uapi/asm/Kbuild                  |  34 ++
 arch/cris/include/{ => uapi}/asm/auxvec.h          |   0
 arch/cris/include/{ => uapi}/asm/bitsperlong.h     |   0
 arch/cris/include/{ => uapi}/asm/byteorder.h       |   0
 arch/cris/include/{ => uapi}/asm/errno.h           |   0
 arch/cris/include/{ => uapi}/asm/ethernet.h        |   0
 arch/cris/include/{ => uapi}/asm/etraxgpio.h       |   0
 arch/cris/include/{ => uapi}/asm/fcntl.h           |   0
 arch/cris/include/{ => uapi}/asm/ioctl.h           |   0
 arch/cris/include/{ => uapi}/asm/ioctls.h          |   0
 arch/cris/include/{ => uapi}/asm/ipcbuf.h          |   0
 arch/cris/include/{ => uapi}/asm/mman.h            |   0
 arch/cris/include/{ => uapi}/asm/msgbuf.h          |   0
 arch/cris/include/{ => uapi}/asm/param.h           |   0
 arch/cris/include/{ => uapi}/asm/poll.h            |   0
 arch/cris/include/{ => uapi}/asm/posix_types.h     |   0
 arch/cris/include/uapi/asm/ptrace.h                |   1 +
 arch/cris/include/{ => uapi}/asm/resource.h        |   0
 arch/cris/include/{ => uapi}/asm/rs485.h           |   0
 arch/cris/include/{ => uapi}/asm/sembuf.h          |   0
 arch/cris/include/{ => uapi}/asm/setup.h           |   0
 arch/cris/include/{ => uapi}/asm/shmbuf.h          |   0
 arch/cris/include/{ => uapi}/asm/sigcontext.h      |   0
 arch/cris/include/{ => uapi}/asm/siginfo.h         |   0
 arch/cris/include/uapi/asm/signal.h                | 122 ++++++++
 arch/cris/include/{ => uapi}/asm/socket.h          |   0
 arch/cris/include/{ => uapi}/asm/sockios.h         |   0
 arch/cris/include/{ => uapi}/asm/stat.h            |   0
 arch/cris/include/{ => uapi}/asm/statfs.h          |   0
 arch/cris/include/uapi/asm/swab.h                  |   3 +
 arch/cris/include/{ => uapi}/asm/sync_serial.h     |   0
 arch/cris/include/{ => uapi}/asm/termbits.h        |   0
 arch/cris/include/uapi/asm/termios.h               |  45 +++
 arch/cris/include/uapi/asm/types.h                 |   1 +
 arch/cris/include/uapi/asm/unistd.h                | 344 +++++++++++++++++++++
 arch/cris/kernel/asm-offsets.c                     |   6 +-
 55 files changed, 689 insertions(+), 645 deletions(-)
 rename arch/cris/include/{ => uapi}/arch-v10/arch/sv_addr.agh (100%)
 rename arch/cris/include/{ => uapi}/arch-v10/arch/sv_addr_ag.h (100%)
 rename arch/cris/include/{ => uapi}/arch-v10/arch/svinto.h (100%)
 rename arch/cris/include/{ => uapi}/arch-v10/arch/user.h (100%)
 create mode 100644 arch/cris/include/uapi/arch-v32/arch/cryptocop.h
 rename arch/cris/include/{ => uapi}/arch-v32/arch/user.h (100%)
 rename arch/cris/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/cris/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/cris/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/cris/include/{ => uapi}/asm/errno.h (100%)
 rename arch/cris/include/{ => uapi}/asm/ethernet.h (100%)
 rename arch/cris/include/{ => uapi}/asm/etraxgpio.h (100%)
 rename arch/cris/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/cris/include/{ => uapi}/asm/ioctl.h (100%)
 rename arch/cris/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/cris/include/{ => uapi}/asm/ipcbuf.h (100%)
 rename arch/cris/include/{ => uapi}/asm/mman.h (100%)
 rename arch/cris/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/cris/include/{ => uapi}/asm/param.h (100%)
 rename arch/cris/include/{ => uapi}/asm/poll.h (100%)
 rename arch/cris/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/cris/include/uapi/asm/ptrace.h
 rename arch/cris/include/{ => uapi}/asm/resource.h (100%)
 rename arch/cris/include/{ => uapi}/asm/rs485.h (100%)
 rename arch/cris/include/{ => uapi}/asm/sembuf.h (100%)
 rename arch/cris/include/{ => uapi}/asm/setup.h (100%)
 rename arch/cris/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/cris/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/cris/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/cris/include/uapi/asm/signal.h
 rename arch/cris/include/{ => uapi}/asm/socket.h (100%)
 rename arch/cris/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/cris/include/{ => uapi}/asm/stat.h (100%)
 rename arch/cris/include/{ => uapi}/asm/statfs.h (100%)
 create mode 100644 arch/cris/include/uapi/asm/swab.h
 rename arch/cris/include/{ => uapi}/asm/sync_serial.h (100%)
 rename arch/cris/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/cris/include/uapi/asm/termios.h
 create mode 100644 arch/cris/include/uapi/asm/types.h
 create mode 100644 arch/cris/include/uapi/asm/unistd.h
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
