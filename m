Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1AUN3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:29:21 -0500
Received: from www.tglx.de ([62.245.132.106]:42883 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab1AUN3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:29:20 -0500
Date: Fri, 21 Jan 2011 14:28:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] genirq cleanups for 2.6.38
Message-ID: <alpine.LFD.2.00.1101211427280.2971@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-cleanup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-cleanup-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (37):
      h8300: Convert to new irq_chip functions
      h8300: Convert interrupt handling to flow handler
      h8300: Use generic irq Kconfig
      cris: Use irq handling wrapper
      cris: Convert V10 interrupt handling
      cris: Convert V32 interrupt handling
      cris: Use generic irq Kconfig
      m32r: Cleanup direct irq_desc access
      m32r: Convert m32104ut irq handling
      m32r: Convert m32104ut irq chip
      m32r: Convert m32700ut pld irq chip
      m32r: Convert m32700ut lanpld irq chip
      m32r: Convert m32700ut lcdpld irq chip
      m32r: Convert mappi irq chips
      m32r: Convert mappi2 irq chip
      m32r: Convert mappi3 irq chip
      m32r: Convert oaks32r irq chips
      m32r: Convert opsput irq chip
      m32r: Convert opsput pld irq chip
      m32r: Convert opsput lanpld irq chip
      m32r: Convert opsput_lcdpld irq chip
      m32r: Convert usrv platform irq handling
      m32r: Convert to generic irq Kconfig
      genirq: Remove __do_IRQ
      alpha: Use generic irq Kconfig
      blackfin: Use generic irq Kconfig
      frv: Use generic irq Kconfig
      ia64: Use generic irq Kconfig
      m68knommu: Use generic irq Kconfig
      microblaze: Use generic irq Kconfig
      mn10300: Use generic irq Kconfig
      parisc: Use generic irq Kconfig
      powerpc: Use generic irq Kconfig
      score: Use generic irq Kconfig
      sparc: Use generic irq Kconfig
      tile: Use generic irq Kconfig
      um: Use generic irq Kconfig


 Documentation/feature-removal-schedule.txt |    8 -
 arch/alpha/Kconfig                         |   19 +--
 arch/blackfin/Kconfig                      |   17 +--
 arch/cris/Kconfig                          |    6 +-
 arch/cris/arch-v10/kernel/irq.c            |   41 ++----
 arch/cris/arch-v32/kernel/irq.c            |   50 ++-----
 arch/cris/kernel/irq.c                     |    6 +-
 arch/frv/Kconfig                           |    9 +-
 arch/h8300/Kconfig                         |    6 +-
 arch/h8300/kernel/irq.c                    |   50 +++----
 arch/ia64/Kconfig                          |   26 +---
 arch/m32r/Kconfig                          |   11 +-
 arch/m32r/kernel/irq.c                     |   10 +-
 arch/m32r/platforms/m32104ut/setup.c       |   58 +++-----
 arch/m32r/platforms/m32700ut/setup.c       |  214 +++++++++------------------
 arch/m32r/platforms/mappi/setup.c          |   78 ++++-------
 arch/m32r/platforms/mappi2/setup.c         |   89 ++++--------
 arch/m32r/platforms/mappi3/setup.c         |   92 ++++--------
 arch/m32r/platforms/oaks32r/setup.c        |   65 +++------
 arch/m32r/platforms/opsput/setup.c         |  220 ++++++++++------------------
 arch/m32r/platforms/usrv/setup.c           |  115 +++++----------
 arch/m68knommu/Kconfig                     |    9 +-
 arch/microblaze/Kconfig                    |   11 +-
 arch/mips/Kconfig                          |    3 -
 arch/mn10300/Kconfig                       |    8 +-
 arch/parisc/Kconfig                        |   18 +--
 arch/powerpc/Kconfig                       |   28 +---
 arch/score/Kconfig                         |   10 +-
 arch/sparc/Kconfig                         |    9 +-
 arch/tile/Kconfig                          |   53 +++----
 arch/um/Kconfig.common                     |    6 +-
 arch/um/Kconfig.um                         |    3 -
 include/linux/irqdesc.h                    |   14 --
 kernel/irq/Kconfig                         |    3 -
 kernel/irq/handle.c                        |  111 --------------
 35 files changed, 428 insertions(+), 1048 deletions(-)

