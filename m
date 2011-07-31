Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1GaVLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 17:11:25 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:54046 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1GaVLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 17:11:21 -0400
Date: Sun, 31 Jul 2011 23:11:17 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.1
Message-ID: <alpine.DEB.2.00.1107312306130.605@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:
  Linus Torvalds (1):
        Linux 3.0

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (13):
      m68k/amiga: Chip RAM - Use tabs for indentation
      m68k/amiga: Chip RAM - Convert from printk() to pr_*()
      m68k/amiga: Chip RAM - Always allocate from the start of memory
      m68k/amiga: Chip RAM - Change chipavail to an atomic_t
      m68k/amiga: Chip RAM - Use resource_size() to fix off-by-one error
      m68k/amiga: Chip RAM - Offset resource end by CHIP_PHYSADDR
      sparc: _sparc_find_resource() should check for exact matches
      resources: Add lookup_resource()
      m68k/amiga: Chip RAM - Use lookup_resource()
      sparc: iounmap() and *_free_coherent() - Use lookup_resource()
      m68k/atari: Prefix GPIO_{IN,OUT} with CODEC_
      m68k: Kill warning in setup_arch() when compiling for Sun3
      m68k/math-emu: Remove commented out old code

Greg Dietsche (1):
      m68k/math-emu: Remove unnecessary code

Michael Schmitz (1):
      m68k/atari: Reserve some ST-RAM early on for device buffer use

 arch/m68k/Kconfig.mmu               |    6 -
 arch/m68k/amiga/chipram.c           |  136 ++++-----
 arch/m68k/atari/stram.c             |  354 +++++-------------------
 arch/m68k/include/asm/atari_stram.h |    3 +-
 arch/m68k/include/asm/atarihw.h     |    4 +-
 arch/m68k/kernel/setup_mm.c         |    2 +
 arch/m68k/math-emu/fp_log.c         |    3 -
 arch/m68k/math-emu/multi_arith.h    |  530 -----------------------------------
 arch/m68k/mm/init_mm.c              |    5 -
 arch/sparc/kernel/ioport.c          |   32 +--
 include/linux/ioport.h              |    1 +
 kernel/resource.c                   |   21 ++
 12 files changed, 166 insertions(+), 931 deletions(-)

The changes to the sparc-code have been acked by David Miller.

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
