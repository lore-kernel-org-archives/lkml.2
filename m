Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2EUTeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:34:16 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:41357 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2EUTeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:34:13 -0400
Date: Mon, 21 May 2012 21:34:07 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.5
Message-ID: <alpine.DEB.2.00.1205212128130.22772@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:
  Linus Torvalds (1):
        Linux 3.4

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (11):
      m68k: Remove unused MAX_NOINT_IPL definition
      m68k/amiga: Mark z_dev_present() __init
      m68k/amiga: Add error checks when registering platform devices
      m68k/amiga: Use arch_initcall() for registering platform devices
      m68k/atari: Change VME irq numbers from unsigned long to unsigned int
      net/ariadne: Improve debug prints
      scsi/atari: Revive "atascsi=" setup option
      scsi/atari: Make more functions static
      m68k: Make sure {read,write}s[bwl]() are always defined
      m68k/video: Create <asm/vga.h>
      m68k: Setup CROSS_COMPILE at the top

Kautuk Consul (1):
      m68k/mm: Port OOM changes to do_page_fault()

Mikael Pettersson (1):
      m68k: Correct the Atari ALLOWINT definition

The net/ariadne change has been acked by David S. Miller.
The drivers/usb/musb/musb_io.h change (for {read,write}s[bwl]()) has been
acked by Felipe Balbi.

Thanks for pulling!

 arch/m68k/Makefile                    |   13 ++--
 arch/m68k/amiga/platform.c            |  126 ++++++++++++++++++++++++---------
 arch/m68k/atari/ataints.c             |    4 +-
 arch/m68k/include/asm/atariints.h     |    4 +-
 arch/m68k/include/asm/entry.h         |    6 +-
 arch/m68k/include/asm/io_mm.h         |    7 ++
 arch/m68k/include/asm/vga.h           |   27 +++++++
 arch/m68k/mm/fault.c                  |   42 +++++++++--
 drivers/net/ethernet/amd/ariadne.c    |    8 +-
 drivers/net/ethernet/amd/atarilance.c |   11 +--
 drivers/scsi/atari_scsi.c             |   26 +++++--
 drivers/scsi/atari_scsi.h             |    5 --
 drivers/usb/musb/musb_io.h            |    2 +-
 include/video/vga.h                   |   22 ------
 14 files changed, 200 insertions(+), 103 deletions(-)
 create mode 100644 arch/m68k/include/asm/vga.h

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
