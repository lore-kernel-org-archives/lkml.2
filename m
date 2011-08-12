Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1HLTUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:20:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab1HLTUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:20:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [GIT PULL] arm-soc fixes for 3.1-rc1
Date: Fri, 12 Aug 2011 21:20:22 +0200
Message-ID: <5354254.j6qvIU3YrO@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:o6+cMyER9Mw7gV2b0qLc/xYgWy8H5XrO3VXxTxK4QRx
 LZBFbGC+NDi3LYrRrDqF2/HgyC7sY0RUfOHgEbS+ifaKuvoRqS
 kifr/TyOMtGNH09Y881pDqe44+RrRGHDMJ9bidKRBXEqSKNxKW
 Siaof1HvrSDpzPWIjvNuNFMsFQp5jKpYrN5L17MXr4lnyA+ppi
 8rB0llfwUnDOkFhsMHxVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the latest bug fixes that have accumulated in the arm-soc tree
for the 3.1 release, almost all of them for the omap, pxa and i.MX
platforms.

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ fixes

Arnaud Patard (4):
      efikasb/mx: fix usbh1 initialisation
      efikasb: fix gpio keys.
      efika: Fix board id detection
      iMX: Fix build for iMX53

Arnd Bergmann (3):
      Merge branch 'imx-fixes-for-arnd' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge branch 'fix' of git://git.kernel.org/.../ycmiao/pxa-linux-2.6 into fixes
      Merge branch 'fixes' of git://git.kernel.org/.../tmlind/linux-omap-2.6 into fixes

Ben Dooks (1):
      ARM: mx5: board-cpuimx51.c fixup irq_to_gpio() usage

Colin Cross (1):
      OMAP2+: PM: SmartReflex: use put_sync_suspend for IRQ-safe disabling

Eric Miao (1):
      ARM: mx53: add pad configuration for I2C signals

Fabio Estevam (3):
      ARM: mach-imx/mx31ads: Fix section mismatches
      ARM: mach-imx/mx31lilly: Fix section mismatches
      ARM: board-mx51_babbage: Fix UART2 registration

Hemant Pedanekar (1):
      omap: timer: Set dmtimer used as clocksource in autoreload mode

Jason Liu (1):
      ARM: iMX5: Don't enable DPLL if it already enabled

Javier Martin (1):
      Add tlv320aic32x4 platform data to Visstrim_M10.

Johan Hovold (1):
      OMAP3: am3517crane: remove NULL board_mux from board file

Kevin Hilman (3):
      OMAP2+: Kconfig: don't select PM in OMAP2PLUS_TYPICAL
      OMAP1: enable GENERIC_IRQ_CHIP
      OMAP3: beagle: don't touch omap_device internals

Lennert Buytenhek (4):
      ARM: pxa: fix logic error in PJ4 iWMMXt handling
      ARM: mmp: Also start timer 1 on boot.
      ARM: mmp: Switch to using timer 1 as clocksource timer.
      ARM: mmp: Change the way we use timer 0 as clockevent timer.

Linus Walleij (1):
      mach-sa1100: fix PCI build problem

Maxin John (1):
      arch:arm:plat-omap:iovmm: remove unused variable 'va'

Mehnert, Torsten (1):
      i.MX25 GPT clock fix: ensure correct the clock source

Nishanth Menon (1):
      OMAP3+: SR: ensure pm-runtime callbacks can be invoked with IRQs disabled

Oleg Drokin (1):
      Update Nook Color machine 3284 to common Encore name

Paul Walmsley (1):
      OMAP: hwmod: fix build break on non-OMAP4 multi-OMAP2 builds

Peter Ujfalusi (1):
      OMAP: Fix linking error in twl-common.c for OMAP2/3/4 only builds

Raphaël Assénat (1):
      am3505/3517: Various platform defines for UART4

Sascha Hauer (1):
      Merge commit 'v3.1-rc1' into imx-fixes

Tanmay Upadhyay (2):
      ARM: pxa168/gplugd: get rid of mfp-gplugd.h
      ARM: pxa168/gplugd: free correct GPIO

Thomas Meyer (1):
      arm: mach-omap2: mux: use kstrdup()

Tony Lindgren (1):
      Merge branch 'for_3.1/pm-fixes' of git://git.kernel.org/.../khilman/linux-omap-pm into fixes

 arch/arm/kernel/iwmmxt.S                     |    6 +-
 arch/arm/mach-imx/clock-imx25.c              |    3 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c  |   13 ++++
 arch/arm/mach-imx/mach-mx31ads.c             |    4 +-
 arch/arm/mach-imx/mach-mx31lilly.c           |    2 +-
 arch/arm/mach-mmp/gplugd.c                   |   22 +++++--
 arch/arm/mach-mmp/include/mach/mfp-gplugd.h  |   52 -----------------
 arch/arm/mach-mmp/include/mach/mfp-pxa168.h  |   37 +++++++++++--
 arch/arm/mach-mmp/time.c                     |   62 ++++++++++++++------
 arch/arm/mach-mx5/board-cpuimx51.c           |    2 +-
 arch/arm/mach-mx5/board-mx51_babbage.c       |    2 +-
 arch/arm/mach-mx5/board-mx51_efikamx.c       |    6 +-
 arch/arm/mach-mx5/board-mx51_efikasb.c       |   15 +++--
 arch/arm/mach-mx5/clock-mx51-mx53.c          |    6 ++-
 arch/arm/mach-mx5/mx51_efika.c               |    2 +-
 arch/arm/mach-omap2/Kconfig                  |    1 -
 arch/arm/mach-omap2/board-am3517crane.c      |    2 -
 arch/arm/mach-omap2/board-omap3beagle.c      |   23 +++----
 arch/arm/mach-omap2/cminst44xx.h             |   25 ++++++++-
 arch/arm/mach-omap2/mux.c                    |   14 +---
 arch/arm/mach-omap2/smartreflex.c            |    3 +-
 arch/arm/mach-omap2/timer.c                  |    3 +-
 arch/arm/mach-omap2/twl-common.c             |   78 +++++++++++++------------
 arch/arm/mach-sa1100/pci-nanoengine.c        |    1 +
 arch/arm/plat-mxc/include/mach/debug-macro.S |    8 +++
 arch/arm/plat-mxc/include/mach/iomux-mx53.h  |   31 ++++++-----
 arch/arm/plat-omap/Kconfig                   |    1 +
 arch/arm/plat-omap/include/plat/dma.h        |    5 ++
 arch/arm/plat-omap/include/plat/irqs.h       |    1 +
 arch/arm/plat-omap/include/plat/serial.h     |    3 +
 arch/arm/plat-omap/iovmm.c                   |    3 -
 arch/arm/tools/mach-types                    |    2 +-
 32 files changed, 252 insertions(+), 186 deletions(-)
 delete mode 100644 arch/arm/mach-mmp/include/mach/mfp-gplugd.h

