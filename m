Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab1ESRHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:07:02 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:52108 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab1ESRHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:07:00 -0400
Date: Thu, 19 May 2011 19:06:58 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 2.6.40
Message-ID: <alpine.DEB.2.00.1105191904450.26486@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf:
  Linus Torvalds (1):
        Linux 2.6.39

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (8):
      m68k: bitops - offset == ((long)p - (long)vaddr) * 8
      m68k: bitops - Never step beyond the end of the bitmap
      MAINTAINERS: Roman Zippel has been MIA for several years.
      m68k: Merge mmu and non-mmu versions of sys_call_table
      m68k: Really wire up sys_pselect6 and sys_ppoll
      m68k: unistd - Comment out definitions for unimplemented syscalls
      m68k/atari: Do not use "/" in interrupt names
      input/atari: Fix mouse movement and button mapping

Michael Schmitz (2):
      input/atari: Use the correct mouse interrupt hook
      input/atari: Fix atarimouse init

 MAINTAINERS                       |    9 +-
 arch/m68k/atari/atakeyb.c         |    9 +-
 arch/m68k/atari/stdma.c           |    2 +-
 arch/m68k/include/asm/atarikb.h   |    2 -
 arch/m68k/include/asm/bitops_mm.h |   87 ++++++----
 arch/m68k/include/asm/unistd.h    |   46 +++---
 arch/m68k/kernel/Makefile_mm      |    2 +-
 arch/m68k/kernel/entry_mm.S       |  348 -------------------------------------
 arch/m68k/kernel/syscalltable.S   |  195 ++++++++++-----------
 drivers/input/keyboard/atakbd.c   |    5 +-
 drivers/input/mouse/atarimouse.c  |   15 +-
 drivers/net/atarilance.c          |    2 +-
 drivers/video/atafb.c             |    2 +-
 13 files changed, 200 insertions(+), 524 deletions(-)

It was OK for Dmitry to let the input changes go in through the m68k tree.

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
