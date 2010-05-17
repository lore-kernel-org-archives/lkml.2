Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0EQToP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:44:15 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:56610 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab0EQToO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:44:14 -0400
Date: Mon, 17 May 2010 21:44:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 2.6.35
Message-ID: <alpine.DEB.2.00.1005172139470.30344@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

Please pull to receive the first batch of m68k updates for 2.6.35.
The platform patch has been acked by GregKH.

I have a second batch ready, but it has to wait a bit since it depends on
a big pile of SCSI patches.

Thanks for pulling!

The following changes since commit e40152ee1e1c7a63f4777791863215e3faa37a86:
  Linus Torvalds (1):
        Linus 2.6.34

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Andrea Gelmini (1):
      m68k: hp300 - Checkpatch cleanup

Frans Pop (1):
      m68k: Remove trailing spaces in messages

Geert Uytterhoeven (8):
      m68k: Implement generic_find_next_{zero_,}le_bit()
      serial167: Kill unused variables
      platform: Make platform resource input parameters const
      m68k: amiga - Zorro bus modalias support
      m68k: amiga - Zorro host bridge platform device conversion
      m68k: amiga - Frame buffer platform device conversion
      m68k: amiga - Sound platform device conversion
      m68k: amiga - Floppy platform device conversion

Nick Piggin (1):
      m68k: invoke oom-killer from page fault

Robert P. J. Day (1):
      m68k: Simplify param.h by using <asm-generic/param.h>

Thomas Gleixner (1):
      m68k: Remove BKL from rtc implementations

 arch/m68k/amiga/Makefile            |    2 +-
 arch/m68k/amiga/platform.c          |   83 ++++++++++++
 arch/m68k/bvme6000/rtc.c            |   29 ++---
 arch/m68k/hp300/time.h              |    4 +-
 arch/m68k/include/asm/bitops_mm.h   |   14 +-
 arch/m68k/include/asm/param.h       |   16 +--
 arch/m68k/kernel/traps.c            |    2 +-
 arch/m68k/mac/config.c              |   10 +-
 arch/m68k/mm/fault.c                |   14 +--
 arch/m68k/mvme16x/rtc.c             |   19 +--
 arch/m68k/q40/config.c              |    2 +-
 drivers/base/platform.c             |    4 +-
 drivers/block/amiflop.c             |   47 +++----
 drivers/char/serial167.c            |    2 -
 drivers/net/a2065.c                 |    1 +
 drivers/net/ariadne.c               |    1 +
 drivers/net/hydra.c                 |    1 +
 drivers/net/zorro8390.c             |    1 +
 drivers/scsi/zorro7xx.c             |    1 +
 drivers/video/amifb.c               |   49 +++++---
 drivers/video/cirrusfb.c            |    1 +
 drivers/video/fm2fb.c               |    1 +
 drivers/zorro/proc.c                |    6 +-
 drivers/zorro/zorro-driver.c        |   24 ++++
 drivers/zorro/zorro-sysfs.c         |   11 ++
 drivers/zorro/zorro.c               |  243 ++++++++++++++++++-----------------
 include/linux/mod_devicetable.h     |    9 ++
 include/linux/platform_device.h     |    6 +-
 include/linux/zorro.h               |   22 +---
 scripts/mod/file2alias.c            |   14 ++
 sound/oss/dmasound/dmasound_paula.c |   51 +++++---
 31 files changed, 405 insertions(+), 285 deletions(-)
 create mode 100644 arch/m68k/amiga/platform.c

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
