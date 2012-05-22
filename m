Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2EVFiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:38:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57599 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2EVFho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:37:44 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=207/8=5D=20arm-soc=3A=20power=20management=20changes?=
Date: Mon, 21 May 2012 22:35:07 -0700
Message-Id: <1337664908-17478-8-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1337664908-17478-1-git-send-email-olof@lixom.net>
References: <1337664908-17478-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power management changes here are mostly for the omap platform, but also
include cpuidle changes for ux500 and suspend/resume code for mmp.

----------------------------------------------------------------

The following changes since commit 99d764e237ce06a95dfa718db3baa3dc6b350310:

  Merge tag 'pinctrl' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/pm

for you to fetch changes up to ada2e35defe6c6f0a986ec8147e47726fbd0e7b1:

  Merge branch 'next/cpuidle' into next/pm

----------------------------------------------------------------

Arnd Bergmann (4):
      Merge branch 'ux500-cpuidle-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/cpuidle
      Merge branch 'mmp/dt' into next/pm
      Merge branch 'power' of git://github.com/hzhuang1/linux into next/pm
      Merge branch 'next/cpuidle' into next/pm

Benoît Cousson (6):
      ARM: OMAP4: hwmod data: add GPMC
      ARM: OMAP4: hwmod data: add the Slimbus IP blocks
      ARM: OMAP4: hwmod data: add McASP
      ARM: OMAP4: hwmod data: add remaining USB-related IP blocks
      ARM: OMAP4: hwmod data: add the OCP-WP IP block
      ARM: OMAP4: hwmod data: add DEBUGSS skeleton

Chao Xie (6):
      ARM: mmp: move XX_REG definition to addr-map.h
      ARM: mmp: add PM support for mmp2
      ARM: mm: proc-mohawk: add suspend resume for mohawk
      ARM: cache: tauros2: add disable and resume callback
      ARM: mmp: ttc_dkb: add PMIC support
      ARM: mmp: add pm support for pxa910

Daniel Lezcano (1):
      ARM: ux500: add the cpuidle driver for WFI and ARM retention

Kevin Hilman (7):
      ARM: OMAP2+: voltage: ensure voltage used is exact voltage from OPP table
      Merge tag 'topic/twl' into for_3.4/pm/smps-regulator
      Merge branch 'pm-wip/smps-regulator' into for_3.4/pm/smps-regulator
      ARM: OMAP3: clock data: replace 3503/3517 flag with AM35x flag for UART4
      ARM: OMAP3: clock data: treat all AM35x devices the same
      ARM: OMAP: clock: convert AM3517/3505 detection/flags to AM35xx
      ARM: OMAP2+: WDTIMER integration: fix !PM boot crash, disarm timer after hwmod reset

Mark A. Greer (1):
      arm: omap3: clockdomain data: Remove superfluous commas from gfx_sgx_3xxx_wkdeps[]

Ming Lei (1):
      ARM: OMAP4: hwmod data: introduce fdif(face detect module) hwmod

Olof Johansson (4):
      Merge tag 'omap-pm-regulator-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/pm
      Merge tag 'omap-devel-hwmod-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/pm
      Merge tag 'omap-devel-prcm-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/pm
      Merge tag 'omap-devel-hwmod-data-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/pm

Paul Walmsley (14):
      ARM: OMAP2+: clockdomains: make {prm,cm}_clkdm common
      ARM: OMAP4: hwmod data: add HDQ/1-wire
      ARM: OMAP4: hwmod data: add EMIF1 and 2
      ARM: OMAP4: hwmod data: add GPU
      ARM: OMAP4: hwmod data: add some interconnect-related IP blocks
      ARM: OMAP4: hwmod data: add OCM RAM IP block
      ARM: OMAP4: hwmod data: add System Control Module
      ARM: OMAP4: hwmod data: add PRCM and related IP blocks
      ARM: OMAP3: clock data: add clockdomain for HDQ functional clock
      Merge branches 'clock_am35xx_cleanup_3.5', 'prm_cm_devel_a_3.5', 'clock_devel_a_3.5' and 'pwrdm_clkdm_cleanup_3.5' into prcm_devel_a_3.5
      ARM: OMAP2+: HDQ1W: add custom reset function
      ARM: OMAP2+: hwmod data: add HDQ/1-wire hwmod shared data
      ARM: OMAP3: hwmod data: add HDQ/1-wire hwmod
      ARM: OMAP2xxx: hwmod data: add HDQ/1-wire hwmod

Peter Ujfalusi (2):
      ARM: OMAP3: hwmod_data: Rename the common irq for McBSP ports
      ARM: OMAP4: hwmod_data: Name the common irq for McBSP ports

R Sricharan (1):
      ARM: OMAP4+: Add prm and cm base init function.

Rajendra Nayak (1):
      ARM: OMAP3: Fix CM register bit masks

Santosh Shilimkar (1):
      ARM: OMAP2+: powerdomain: Get rid off duplicate pwrdm_clkdm_state_switch() API

Shubhrajyoti D (1):
      ARM: OMAP4: hwmod data: I2C: add flag for context restore

Tarun Kanti DebBarma (1):
      ARM: OMAP2+: dmtimer: cleanup iclk usage

Tero Kristo (4):
      arm: omap3: voltage: fix channel configuration
      arm: omap3: add common twl configurations for vdd1 and vdd2
      arm: omap3: twl: add external controllers for core voltage regulators
      arm: omap4: add common twl configurations for vdd1, vdd2 and vdd3

Tony Lindgren (5):
      Merge tag 'omap-devel-a-for-3.5' of git://git.kernel.org/.../pjw/omap-pending into devel-hwmod
      Merge branch 'for_3.4/pm/smps-regulator' of git://git.kernel.org/.../khilman/linux-omap-pm into pm-regulator
      Merge tag 'omap-devel-b-for-3.5' of git://git.kernel.org/.../pjw/omap-pending into devel-prcm
      ARM: OMAP2420: hwmod data: Add MMC hwmod data for 2420
      Merge tag 'omap-devel-c-for-3.5' of git://git.kernel.org/.../pjw/omap-pending into devel-hwmod-data

Vaibhav Bedia (1):
      ARM: OMAP3+: dpll: Configure autoidle mode only if it's supported

Vaibhav Hiremath (2):
      ARM: OMAP2/3: Add idle_st bits for ST_32KSYNC timer to prcm-common header
      ARM: OMAP2/3: hwmod data: Add 32k-sync timer data to hwmod database


 arch/arm/Kconfig                                |    2 +-
 arch/arm/mach-mmp/Makefile                      |    5 +
 arch/arm/mach-mmp/include/mach/addr-map.h       |   12 +
 arch/arm/mach-mmp/include/mach/pm-mmp2.h        |   61 +
 arch/arm/mach-mmp/include/mach/pm-pxa910.h      |   77 +
 arch/arm/mach-mmp/include/mach/regs-apbc.h      |    3 -
 arch/arm/mach-mmp/include/mach/regs-apmu.h      |    3 -
 arch/arm/mach-mmp/irq.c                         |   13 +
 arch/arm/mach-mmp/pm-mmp2.c                     |  264 +++
 arch/arm/mach-mmp/pm-pxa910.c                   |  285 ++++
 arch/arm/mach-mmp/ttc_dkb.c                     |   11 +
 arch/arm/mach-omap2/Makefile                    |   13 +-
 arch/arm/mach-omap2/clock.c                     |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c            |   25 +-
 arch/arm/mach-omap2/clock44xx_data.c            |   11 -
 arch/arm/mach-omap2/clockdomain.c               |    7 +-
 arch/arm/mach-omap2/clockdomain44xx.c           |    6 +
 .../arm/mach-omap2/clockdomains2xxx_3xxx_data.c |   10 -
 arch/arm/mach-omap2/clockdomains3xxx_data.c     |    6 +-
 arch/arm/mach-omap2/clockdomains44xx_data.c     |    2 +
 arch/arm/mach-omap2/clockdomains_common_data.c  |   24 +
 arch/arm/mach-omap2/cm-regbits-34xx.h           |    4 +-
 arch/arm/mach-omap2/cminst44xx.c                |   28 +-
 arch/arm/mach-omap2/common.c                    |    1 +
 arch/arm/mach-omap2/common.h                    |    1 +
 arch/arm/mach-omap2/dpll3xxx.c                  |   23 +-
 arch/arm/mach-omap2/hdq1w.c                     |   72 +
 arch/arm/mach-omap2/io.c                        |   18 -
 arch/arm/mach-omap2/msdi.c                      |   88 +
 arch/arm/mach-omap2/omap_hwmod_2420_data.c      |  112 ++
 arch/arm/mach-omap2/omap_hwmod_2430_data.c      |   47 +
 .../omap_hwmod_2xxx_3xxx_interconnect_data.c    |    9 +
 .../omap_hwmod_2xxx_3xxx_ipblock_data.c         |   22 +
 .../mach-omap2/omap_hwmod_2xxx_ipblock_data.c   |   23 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      |   94 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c      | 1516 +++++++++++++++++-
 arch/arm/mach-omap2/omap_hwmod_common_data.h    |    5 +
 arch/arm/mach-omap2/powerdomain.c               |   10 -
 arch/arm/mach-omap2/powerdomain.h               |    1 -
 arch/arm/mach-omap2/prcm-common.h               |   17 +
 arch/arm/mach-omap2/prcm.c                      |    8 +
 arch/arm/mach-omap2/prminst44xx.c               |   27 +-
 arch/arm/mach-omap2/timer.c                     |    7 -
 arch/arm/mach-omap2/twl-common.c                |  147 ++
 arch/arm/mach-omap2/vc3xxx_data.c               |    1 +
 arch/arm/mach-omap2/voltage.c                   |   21 +-
 arch/arm/mach-omap2/wd_timer.c                  |   45 +
 arch/arm/mach-omap2/wd_timer.h                  |    1 +
 arch/arm/mach-ux500/Makefile                    |    1 +
 arch/arm/mach-ux500/cpuidle.c                   |  171 ++
 arch/arm/mm/cache-tauros2.c                     |   24 +
 arch/arm/mm/proc-mohawk.S                       |   35 +
 arch/arm/plat-omap/include/plat/clkdev_omap.h   |    4 +-
 arch/arm/plat-omap/include/plat/dmtimer.h       |    2 +-
 arch/arm/plat-omap/include/plat/hdq1w.h         |   36 +
 arch/arm/plat-omap/include/plat/mmc.h           |    4 +
 arch/arm/plat-omap/include/plat/omap_hwmod.h    |    1 +
 57 files changed, 3248 insertions(+), 220 deletions(-)
 create mode 100644 arch/arm/mach-mmp/include/mach/pm-mmp2.h
 create mode 100644 arch/arm/mach-mmp/include/mach/pm-pxa910.h
 create mode 100644 arch/arm/mach-mmp/pm-mmp2.c
 create mode 100644 arch/arm/mach-mmp/pm-pxa910.c
 create mode 100644 arch/arm/mach-omap2/clockdomains_common_data.c
 create mode 100644 arch/arm/mach-omap2/hdq1w.c
 create mode 100644 arch/arm/mach-omap2/msdi.c
 create mode 100644 arch/arm/mach-ux500/cpuidle.c
 create mode 100644 arch/arm/plat-omap/include/plat/hdq1w.h
