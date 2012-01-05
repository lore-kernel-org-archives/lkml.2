Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2AEPML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:12:11 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:57815 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab2AEPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:12:08 -0500
Date: Thu, 5 Jan 2012 16:12:03 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gerg@snapgear.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.3
Message-ID: <alpine.DEB.2.00.1201051608180.5699@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:
  Linus Torvalds (1):
        Linux 3.2

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

The drivers/net change has been acked by David S. Miller.

Thanks for pulling!

Andi Kleen (1):
      m68k: Initconst section fixes

Andreas Schwab (1):
      m68k: Don't comment out syscalls used by glibc

Finn Thain (11):
      m68k/mac: early console
      m68k/mac: cleanup mac_clear_irq
      m68k/mac: cleanup mac_irq_pending
      m68k/mac: cleanup forward declarations
      m68k/mac: enable via_alt_mapping on performa 580
      m68k/mac: fix nubus slot irq disable and shutdown
      m68k/mac: oss irq fixes
      m68k/mac: fix baboon irq disable and shutdown
      m68k/mac: fix powerbook 150 adb_type
      mac_scsi: fix mac_scsi on some powerbooks
      m68k/mac: cleanup macro case

Geert Uytterhoeven (6):
      m68k/hp300: Export hp300_ledstate
      m68k/serial: Remove references to obsolete CONFIG_SERIAL167
      m68k/atari: Move declaration of atari_SCC_reset_done to header file
      m68k/net: Remove obsolete IRQ_FLG_* users
      m68k/serial: Remove references to obsolete serial config options
      m68k/mac: Make CONFIG_HEARTBEAT unavailable on Mac

Kars de Jong (2):
      m68k/serial: SERIAL_PORT_DFNS only if CONFIG_ISA
      m68k/mvme16x: Add support for EARLY_PRINTK

 arch/m68k/Kconfig.debug                 |   11 ++
 arch/m68k/Kconfig.devices               |   46 +-----
 arch/m68k/atari/ataints.c               |    2 -
 arch/m68k/atari/debug.c                 |    1 -
 arch/m68k/configs/amiga_defconfig       |    1 -
 arch/m68k/configs/apollo_defconfig      |    2 -
 arch/m68k/configs/atari_defconfig       |    3 -
 arch/m68k/configs/multi_defconfig       |    5 -
 arch/m68k/configs/mvme16x_defconfig     |    2 -
 arch/m68k/emu/nfeth.c                   |    2 +-
 arch/m68k/hp300/config.c                |    3 +-
 arch/m68k/include/asm/atarihw.h         |    2 +
 arch/m68k/include/asm/blinken.h         |    8 +-
 arch/m68k/include/asm/mac_baboon.h      |    6 +
 arch/m68k/include/asm/mac_iop.h         |    2 +
 arch/m68k/include/asm/mac_oss.h         |   23 +---
 arch/m68k/include/asm/mac_psc.h         |    4 +
 arch/m68k/include/asm/mac_via.h         |    9 +
 arch/m68k/include/asm/macintosh.h       |   10 +-
 arch/m68k/include/asm/macints.h         |    6 +-
 arch/m68k/include/asm/serial.h          |    2 +
 arch/m68k/include/asm/unistd.h          |   10 +-
 arch/m68k/kernel/head.S                 |  117 +++++++-------
 arch/m68k/mac/baboon.c                  |   41 +----
 arch/m68k/mac/config.c                  |   93 ++++++++----
 arch/m68k/mac/iop.c                     |    8 +-
 arch/m68k/mac/macints.c                 |  197 ++++++------------------
 arch/m68k/mac/oss.c                     |  157 +++++++-------------
 arch/m68k/mac/psc.c                     |   17 --
 arch/m68k/mac/via.c                     |  255 +++++++++++++++----------------
 arch/m68k/mvme16x/config.c              |  160 +++++++++++++++++++
 drivers/block/swim.c                    |    1 -
 drivers/net/ethernet/natsemi/macsonic.c |    7 +-
 drivers/scsi/mac_esp.c                  |    3 +-
 34 files changed, 582 insertions(+), 634 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
