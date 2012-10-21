Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab2JUSrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:47:35 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:58823 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2JUSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:47:33 -0400
Date: Sun, 21 Oct 2012 20:47:28 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.7 (take 2)
Message-ID: <alpine.DEB.2.00.1210212039120.6767@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:
  Linus Torvalds (1):
        Linux 3.7-rc2

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

David Howells (1):
      UAPI: (Scripted) Disintegrate arch/m68k/include/asm

Geert Uytterhoeven (3):
      Merge tag 'disintegrate-m68k-20121009' of git://git.infradead.org/users/dhowells/linux-headers into for-linus
      m68k: Remove empty #ifdef/#else/#endif block
      m68k: Wire up kcmp

Just the expected UAPI disintegration and the "new" kcmp syscall.

Thanks for pulling!

 arch/m68k/include/asm/Kbuild                   |    2 -
 arch/m68k/include/asm/ptrace.h                 |   75 +-----
 arch/m68k/include/asm/setup.h                  |   82 +------
 arch/m68k/include/asm/signal.h                 |  118 +--------
 arch/m68k/include/asm/termios.h                |   44 +---
 arch/m68k/include/asm/unistd.h                 |  356 +-----------------------
 arch/m68k/include/uapi/asm/Kbuild              |   23 ++
 arch/m68k/include/{ => uapi}/asm/a.out.h       |    0
 arch/m68k/include/{ => uapi}/asm/auxvec.h      |    0
 arch/m68k/include/{ => uapi}/asm/byteorder.h   |    0
 arch/m68k/include/{ => uapi}/asm/cachectl.h    |    0
 arch/m68k/include/{ => uapi}/asm/fcntl.h       |    0
 arch/m68k/include/{ => uapi}/asm/ioctls.h      |    0
 arch/m68k/include/{ => uapi}/asm/msgbuf.h      |    0
 arch/m68k/include/{ => uapi}/asm/param.h       |    0
 arch/m68k/include/{ => uapi}/asm/poll.h        |    0
 arch/m68k/include/{ => uapi}/asm/posix_types.h |    0
 arch/m68k/include/uapi/asm/ptrace.h            |   79 ++++++
 arch/m68k/include/{ => uapi}/asm/sembuf.h      |    0
 arch/m68k/include/uapi/asm/setup.h             |  103 +++++++
 arch/m68k/include/{ => uapi}/asm/shmbuf.h      |    0
 arch/m68k/include/{ => uapi}/asm/sigcontext.h  |    0
 arch/m68k/include/uapi/asm/signal.h            |  118 ++++++++
 arch/m68k/include/{ => uapi}/asm/socket.h      |    0
 arch/m68k/include/{ => uapi}/asm/sockios.h     |    0
 arch/m68k/include/{ => uapi}/asm/stat.h        |    0
 arch/m68k/include/{ => uapi}/asm/swab.h        |    0
 arch/m68k/include/{ => uapi}/asm/termbits.h    |    0
 arch/m68k/include/uapi/asm/termios.h           |   44 +++
 arch/m68k/include/uapi/asm/unistd.h            |  357 ++++++++++++++++++++++++
 arch/m68k/kernel/syscalltable.S                |    1 +
 31 files changed, 731 insertions(+), 671 deletions(-)
 rename arch/m68k/include/{ => uapi}/asm/a.out.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/cachectl.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/fcntl.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/msgbuf.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/param.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/poll.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/m68k/include/uapi/asm/ptrace.h
 rename arch/m68k/include/{ => uapi}/asm/sembuf.h (100%)
 create mode 100644 arch/m68k/include/uapi/asm/setup.h
 rename arch/m68k/include/{ => uapi}/asm/shmbuf.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/sigcontext.h (100%)
 create mode 100644 arch/m68k/include/uapi/asm/signal.h
 rename arch/m68k/include/{ => uapi}/asm/socket.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/stat.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/swab.h (100%)
 rename arch/m68k/include/{ => uapi}/asm/termbits.h (100%)
 create mode 100644 arch/m68k/include/uapi/asm/termios.h
 create mode 100644 arch/m68k/include/uapi/asm/unistd.h

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
