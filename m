Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0ETGwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 02:52:37 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53102 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab0ETGwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 02:52:35 -0400
Date: Thu, 20 May 2010 15:51:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] genesis updates for 2.6.35-rc1
Message-ID: <20100520065132.GA13004@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/genesis-2.6.git

Which contains:

Kuninori Morimoto (10):
      ARM: mach-shmobile: sh7372: Add I2C0, I2C1 support
      ARM: mach-shmobile: ap4evb: Add TouchScreen support
      ARM: mach-shmobile: ap4evb: Add SW43, SW3 tiny document
      ARM: mach-shmobile: ap4evb: Add R2025S RTC support
      ARM: mach-shmobile: intc-sh7377: Add INTCS support
      ARM: mach-shmobile: Add missing __initdata on intcs sh7367/sh7377
      ARM: mach-shmobile: Add SDHI support
      ARM: mach-shmobile: intc-sh7372: modify wrong address
      ARM: mach-shmobile: ap4evb: Add USB host support
      ARM: mach-shmobile: g3evm: Add IrDA support

Magnus Damm (13):
      dmaengine: shdma: Enable on SH-Mobile ARM
      i2c: i2c-sh_mobile register access code break out
      i2c: i2c-sh_mobile support for new ICIC bits
      i2c: i2c-sh_mobile kconfig update for SH-Mobile ARM
      ARM: mach-shmobile: add INTCS macros
      ARM: mach-shmobile: sh7367 INTCS support
      ARM: mach-shmobile: Use 0x2200 as INTCS_VECT_BASE
      ARM: mach-shmobile: sh7372 INTCS support
      ARM: mach-shmobile: Enable TMU driver build
      ARM: mach-shmobile: Use shared clock framework
      ARM: mach-shmobile: sh7372 clock framework support V2
      ARM: mach-shmobile: Set CONSISTENT_DMA_SIZE to 158 MB
      ARM: mach-shmobile: Update VMALLOC_END

Paul Mundt (2):
      MAINTAINERS: Add a patchwork entry for ARM/SH-Mobile.
      ARM: mach-shmobile: update defconfigs.

 MAINTAINERS                                   |    3 +-
 arch/arm/configs/ap4evb_defconfig             |   71 ++++-
 arch/arm/configs/g3evm_defconfig              |   73 ++++-
 arch/arm/configs/g4evm_defconfig              |   72 ++++-
 arch/arm/mach-shmobile/Kconfig                |   10 +
 arch/arm/mach-shmobile/Makefile               |    4 +-
 arch/arm/mach-shmobile/board-ap4evb.c         |  122 ++++++++-
 arch/arm/mach-shmobile/board-g3evm.c          |   33 ++
 arch/arm/mach-shmobile/board-g4evm.c          |  127 ++++++++
 arch/arm/mach-shmobile/clock-sh7367.c         |   36 +---
 arch/arm/mach-shmobile/clock-sh7372.c         |  387 +++++++++++++++++++++++++
 arch/arm/mach-shmobile/clock.c                |   44 +++
 arch/arm/mach-shmobile/include/mach/common.h  |    3 +
 arch/arm/mach-shmobile/include/mach/irqs.h    |    6 +
 arch/arm/mach-shmobile/include/mach/memory.h  |    3 +
 arch/arm/mach-shmobile/include/mach/vmalloc.h |    3 +-
 arch/arm/mach-shmobile/intc-sh7367.c          |  178 +++++++++++-
 arch/arm/mach-shmobile/intc-sh7372.c          |  232 ++++++++++++++-
 arch/arm/mach-shmobile/intc-sh7377.c          |  300 +++++++++++++++++++-
 arch/arm/mach-shmobile/setup-sh7372.c         |   55 +++-
 drivers/dma/Kconfig                           |    2 +-
 drivers/dma/shdma.c                           |    8 +-
 drivers/i2c/busses/Kconfig                    |    2 +-
 drivers/i2c/busses/i2c-sh_mobile.c            |  121 ++++++---
 drivers/sh/Makefile                           |    5 +-
 include/linux/serial_sci.h                    |    2 +-
 26 files changed, 1754 insertions(+), 148 deletions(-)
 create mode 100644 arch/arm/mach-shmobile/clock-sh7372.c
 create mode 100644 arch/arm/mach-shmobile/clock.c
