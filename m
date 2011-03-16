Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1CPSrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:47:47 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:45250 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1CPSrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:47:39 -0400
Date: Wed, 16 Mar 2011 19:47:31 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 2.6.39
Message-ID: <alpine.DEB.2.00.1103161945360.19171@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 521cb40b0c44418a4fd36dc633f575813d59a43d:
  Linus Torvalds (1):
        Linux 2.6.38

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Andreas Schwab (1):
      m68k: Allow all kernel traps to be handled via exception fixups

Geert Uytterhoeven (3):
      m68k/amiga: Reclaim Chip RAM for PPC exception handlers
      m68k: Kconfig - Remove unneeded "default n"
      m68k/block: amiflop - Remove superfluous amiga_chip_alloc() cast

Milan Jurik (1):
      m68k/atari: ARAnyM - Add support for network access

Petr Stehlik (1):
      m68k/atari: Initial ARAnyM support

Roman Zippel (4):
      m68k: Add helper function handle_kernel_fault()
      m68k: Use base_trap_init() to initialize vectors
      m68k/atari: ARAnyM - Add support for block access
      m68k/atari: ARAnyM - Add support for console access

matt mooney (1):
      m68k: Makefiles - Change to new flags variables

 arch/m68k/Kconfig                 |   33 +++++-
 arch/m68k/Makefile                |    1 +
 arch/m68k/amiga/chipram.c         |    4 -
 arch/m68k/emu/Makefile            |    9 ++
 arch/m68k/emu/natfeat.c           |   78 +++++++++++
 arch/m68k/emu/nfblock.c           |  195 ++++++++++++++++++++++++++
 arch/m68k/emu/nfcon.c             |  162 ++++++++++++++++++++++
 arch/m68k/emu/nfeth.c             |  270 +++++++++++++++++++++++++++++++++++++
 arch/m68k/include/asm/natfeat.h   |   22 +++
 arch/m68k/include/asm/processor.h |    2 +
 arch/m68k/kernel/setup.c          |    5 +
 arch/m68k/kernel/signal.c         |   24 +++-
 arch/m68k/kernel/traps.c          |   20 ++-
 arch/m68k/math-emu/Makefile       |    4 +-
 arch/m68k/mm/fault.c              |   16 +--
 drivers/block/amiflop.c           |    4 +-
 16 files changed, 815 insertions(+), 34 deletions(-)
 create mode 100644 arch/m68k/emu/Makefile
 create mode 100644 arch/m68k/emu/natfeat.c
 create mode 100644 arch/m68k/emu/nfblock.c
 create mode 100644 arch/m68k/emu/nfcon.c
 create mode 100644 arch/m68k/emu/nfeth.c
 create mode 100644 arch/m68k/include/asm/natfeat.h

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
