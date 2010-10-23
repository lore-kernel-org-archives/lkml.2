Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab0JWDu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 23:50:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55589 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0JWDu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 23:50:56 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Fri, 22 Oct 2010 23:50:37 -0400
Message-Id: <1287805837-18174-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1287787141-9021-1-git-send-email-vapier@gentoo.org>
References: <1287787141-9021-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d4429f608abde89e8bc1e24b43cd503feb95c496:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-10-21 21:19:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Ashish Gupta (1):
      Blackfin: tll6527m: new board port

Barry Song (8):
      Blackfin: bf537-stamp: update GPIO CS devices
      Blackfin: boards: update AD183x resources
      Blackfin: bf537-stamp: add example ad1937 i2c resources
      Blackfin: bf537-stamp: use correct spi mode with ad2s90 parts
      Blackfin: ptrace: enable access to L1 stacks
      Blackfin: bf561-ezkit: add AD1836 codec resources
      Blackfin: access_ok: permit L1 stack
      Blackfin: initial preempt support while returning from interrupt

Bob Liu (2):
      Blackfin: bf51x/bf52x: fix 16/32bit SPORT MMR helpers
      Blackfin: bf518-ezkit: add ssm2603 codec resources

Cliff Cai (1):
      Blackfin: bf537-stamp: add example adau1373 i2c resources

Michael Hennerich (6):
      Blackfin: cm-bf548: add support for Socket CAN
      Blackfin: boards: use proper irq flags with isp1362-hcd
      Blackfin: bf537-stamp: add example IIO resources
      Blackfin: SIC: BF537: change default data/error relative priorities
      Blackfin: ad7160eval: new board port
      Blackfin: SIC: fix off-by-one error in loop

Mike Frysinger (19):
      Blackfin: punt short SPI MMR bit names
      Blackfin: bf537-stamp: fix NAND resources
      Blackfin: boards: fix num_chipselect values for on-chip SPI buses
      Blackfin: i2c-gpio boards: use GPIO_PF# defines
      Blackfin: bf51x: enable support for 0.2 silicon
      Blackfin: bf548-ezkit: increase u-boot partition size
      Blackfin: dma: bf54x: add missing break for SPORT1 TX IRQ
      Blackfin: bf526-ezbrd/bf527-ezkit: add NAND partition for u-boot
      Blackfin: coreb: add gpl module license
      Blackfin: coreb: update ioctl numbers
      Blackfin: update sparse flags for latest upstream changes
      Blackfin: glue XIP/ROM kernel kconfigs
      Blackfin: H8606: move 8250 irqflags to platform resources
      Blackfin: bf54x: add missing SIC_RVECT definition
      Blackfin: bf561: rewrite SICA_xxx to just SIC_xxx
      Blackfin: bf538: add missing SIC_RVECT define
      Blackfin: bfin_can.h: add missing VERSION/VERSION2 MMRs
      Blackfin: bfin_ppi.h: start a common PPI/EPPI header
      Blackfin: bfin_spi.h: add MMR peripheral layout

Robin Getz (1):
      Blackfin: workaround anomaly 05000481 (corruption with ITEST MMRs)

Sonic Zhang (5):
      Blackfin: bf537-stamp: re-use the fixed regulator voltage driver
      Blackfin: bf537-stamp: re-use regulator framework with ad5398 parts
      Blackfin: bf537-stamp: tweak i2c address for ad5280 add-on tftlcd board
      Blackfin: add new cacheflush syscall
      Blackfin: merge kernel init memory back into main memory region

Valentin Yakovenkov (1):
      Blackfin: bf561-acvilon: fix NAND resources

Yi Li (1):
      Blackfin: bf537-stamp: add example adav801/3 resources

steven miao (2):
      Blackfin: boards: add example i2c resources for ad525x devices
      Blackfin: gpio: add peripheral group check

 arch/blackfin/Kconfig                              |   12 +-
 arch/blackfin/Makefile                             |    3 +-
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig  |  105 +++
 arch/blackfin/configs/BF527-TLL6527M_defconfig     |  180 ++++
 arch/blackfin/include/asm/Kbuild                   |    1 +
 arch/blackfin/include/asm/bfin5xx_spi.h            |   19 +
 arch/blackfin/include/asm/bfin_can.h               |    9 +-
 arch/blackfin/include/asm/bfin_ppi.h               |   51 +
 arch/blackfin/include/asm/cachectl.h               |   20 +
 arch/blackfin/include/asm/cdef_LPBlackfin.h        |    9 +-
 arch/blackfin/include/asm/ptrace.h                 |    3 +
 arch/blackfin/include/asm/serial.h                 |    1 -
 arch/blackfin/include/asm/unistd.h                 |    3 +-
 arch/blackfin/kernel/bfin_gpio.c                   |  185 +++--
 arch/blackfin/kernel/process.c                     |    5 +
 arch/blackfin/kernel/ptrace.c                      |   12 +-
 arch/blackfin/kernel/sys_bfin.c                    |   15 +
 arch/blackfin/mach-bf518/boards/ezbrd.c            |   21 +-
 arch/blackfin/mach-bf518/boards/tcm-bf518.c        |    2 +-
 .../mach-bf518/include/mach/cdefBF51x_base.h       |   32 +-
 .../mach-bf518/include/mach/defBF51x_base.h        |   45 -
 arch/blackfin/mach-bf527/boards/Kconfig            |   10 +
 arch/blackfin/mach-bf527/boards/Makefile           |    2 +
 arch/blackfin/mach-bf527/boards/ad7160eval.c       |  870 +++++++++++++++++
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |   12 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c            |    6 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |   23 +-
 arch/blackfin/mach-bf527/boards/tll6527m.c         |  986 ++++++++++++++++++++
 .../mach-bf527/include/mach/cdefBF52x_base.h       |   32 +-
 .../mach-bf527/include/mach/defBF52x_base.h        |   45 -
 arch/blackfin/mach-bf533/boards/H8606.c            |   10 +-
 arch/blackfin/mach-bf533/boards/blackstamp.c       |    4 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |   10 +-
 arch/blackfin/mach-bf533/boards/ezkit.c            |   12 +-
 arch/blackfin/mach-bf533/boards/ip0x.c             |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c            |   19 +-
 arch/blackfin/mach-bf533/include/mach/defBF532.h   |   70 --
 arch/blackfin/mach-bf537/Kconfig                   |    4 +-
 arch/blackfin/mach-bf537/boards/cm_bf537e.c        |   10 +-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c        |   10 +-
 arch/blackfin/mach-bf537/boards/pnav10.c           |   12 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |  597 ++++++++++--
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |   10 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |   44 -
 arch/blackfin/mach-bf538/boards/ezkit.c            |    4 +-
 arch/blackfin/mach-bf538/include/mach/defBF539.h   |   73 +--
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |   47 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |   31 +-
 arch/blackfin/mach-bf548/dma.c                     |    1 +
 .../mach-bf548/include/mach/cdefBF54x_base.h       |    2 +
 .../mach-bf548/include/mach/defBF54x_base.h        |   51 +-
 arch/blackfin/mach-bf561/boards/acvilon.c          |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |   10 +-
 arch/blackfin/mach-bf561/boards/ezkit.c            |   68 ++-
 arch/blackfin/mach-bf561/coreb.c                   |   11 +-
 arch/blackfin/mach-bf561/include/mach/blackfin.h   |   33 +-
 arch/blackfin/mach-bf561/include/mach/cdefBF561.h  |   76 +-
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |   94 +--
 arch/blackfin/mach-bf561/ints-priority.c           |   16 +-
 arch/blackfin/mach-bf561/smp.c                     |   24 +-
 arch/blackfin/mach-common/dpmc_modes.S             |   50 +-
 arch/blackfin/mach-common/entry.S                  |  113 +++-
 arch/blackfin/mach-common/interrupt.S              |   17 +
 arch/blackfin/mach-common/ints-priority.c          |   11 +-
 arch/blackfin/mm/init.c                            |    3 +
 65 files changed, 3431 insertions(+), 839 deletions(-)
 create mode 100644 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
 create mode 100644 arch/blackfin/configs/BF527-TLL6527M_defconfig
 create mode 100644 arch/blackfin/include/asm/bfin_ppi.h
 create mode 100644 arch/blackfin/include/asm/cachectl.h
 create mode 100644 arch/blackfin/mach-bf527/boards/ad7160eval.c
 create mode 100644 arch/blackfin/mach-bf527/boards/tll6527m.c
