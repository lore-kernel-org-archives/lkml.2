Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab1GZWbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:31:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab1GZWbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:31:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [GIT PULL] arm-soc bug fixes (part 2) for 3.1
Date: Wed, 27 Jul 2011 00:31:19 +0200
Message-ID: <1687325.AEKSI6RCv5@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
In-Reply-To: <3057645.NjCAYUXHGt@wuerfel>
References: <3057645.NjCAYUXHGt@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Sj9khbOU/zAUXywQiKPRtZ2gnHPXFM3zDLK4ANkjT+s
 DBisYdK0F7234jEMey0peM9Bsl3dZiYvUrC/IzSCTflzthSyOd
 aUtA1ub8pMpu8J3ZedsX4hfahV+WCS9drgfz6IkIQZnfHlcOhA
 lJiQ7I4UbZPleFNH4xe+mnEj8oRLzpqvgbye9C4MSu8q/y61be
 kb++TPIH41xXuM8wxvvQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This branch contains more bug fixes, all for the omap platform. They were not
part of the first pull request because they depend on branches that you
have pulled in the meantime.

	Arnd

The following changes since commit ba5b56cb3e3d2cab73d4fee9a022bb69462a8cd9:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2011-07-26 13:38:50 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ next/fixes2

Ambresh K (1):
      OMAP4: DMTIMER: enable autoidle mode

Andy Green (6):
      I2C: OMAP2+: Set hwmod flags to only allow 16-bit accesses to i2c
      I2C: OMAP2+: increase omap_i2c_dev_attr flags from u8 to u32
      I2C: OMAP2+:  Introduce I2C IP versioning constants
      I2C: OMAP1/OMAP2+: create omap I2C functionality flags for each cpu_... test
      I2C: OMAP2+: Tag all OMAP2+ hwmod defintions with I2C IP revision
      I2C: OMAP2+: add correct functionality flags to all omap2plus i2c dev_attr

Arnd Bergmann (1):
      Merge branch 'fixes-part-2' of git://git.kernel.org/.../tmlind/linux-omap-2.6 into omap/fixes

Avinash.H.M (1):
      OMAP: hwmod: fix the i2c-reset timeout during bootup

Benoit Cousson (1):
      OMAP4: powerdomain data: Fix core mem states and missing cefuse flag

Charulatha V (1):
      omap: ZOOM: QUART: Request reset GPIO

Daniel Mack (1):
      omap: Overo: remove duplicate call to overo_ads7846_init()

Igor Grinberg (2):
      arm: omap3: cm-t35: minor comments fixes
      arm: omap3: cm-t35: fix slow path warning

Julia Lawall (1):
      arch/arm/mach-omap2/clock.c: add missing clk_put

Ohad Ben-Cohen (2):
      omap: iovmm: s/sg_dma_len(sg)/sg->length/
      OMAP4: iommu: fix clock name

Paul Walmsley (2):
      Merge branches 'powerdomain_fixes_3.1', 'hardware_workarounds_3.1', 'hwmod_dss_fix_3.1' and 'i2c_fixes_3.1' into prcm-fixes-3.1
      ASoC: omap: McBSP: fix build breakage on OMAP1

Rajendra Nayak (1):
      OMAP2+: PM: Initialise sleep_switch to a non-valid value

Santosh Shilimkar (2):
      OMAP4: clock data: Keep GPMC clocks always enabled and hardware managed
      OMAP4: powerdomain data: Remove unsupported MPU powerdomain state

Silesh C V (1):
      omap: HSMMC: Fix GPIO muxing

Suman Anna (1):
      omap: iommu: fix pte programming

Tomi Valkeinen (2):
      OMAP4: hwmod data: Modify DSS opt clocks
      OMAP4: hwmod data: Change DSS main_clk scheme

Tony Lindgren (2):
      Merge branch 'iommu-for-tony' of git://github.com/ohadbc/omap-iommu into devel-fixes
      Merge branch 'prcm-fixes-3.1' of git://git.pwsan.com/linux-2.6 into fixes-part-2

 arch/arm/mach-omap2/board-cm-t35.c           |   18 ++----
 arch/arm/mach-omap2/board-overo.c            |    1 -
 arch/arm/mach-omap2/board-zoom-debugboard.c  |    9 +++
 arch/arm/mach-omap2/clock.c                  |    1 +
 arch/arm/mach-omap2/clock44xx_data.c         |    9 ++-
 arch/arm/mach-omap2/hsmmc.c                  |    7 +-
 arch/arm/mach-omap2/i2c.c                    |   68 +++++++++++++++++++++
 arch/arm/mach-omap2/iommu2.c                 |    4 +-
 arch/arm/mach-omap2/omap-iommu.c             |    2 +-
 arch/arm/mach-omap2/omap_hwmod.c             |   27 +++++++++
 arch/arm/mach-omap2/omap_hwmod_2420_data.c   |    9 +++-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c   |    7 ++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |   18 +++++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c   |   81 ++++++++++++++++++++------
 arch/arm/mach-omap2/pm.c                     |    2 +-
 arch/arm/mach-omap2/powerdomains44xx_data.c  |    9 ++-
 arch/arm/plat-omap/dmtimer.c                 |    4 +-
 arch/arm/plat-omap/include/plat/i2c.h        |    6 ++-
 arch/arm/plat-omap/include/plat/omap_hwmod.h |    1 +
 arch/arm/plat-omap/iovmm.c                   |    6 +-
 arch/arm/plat-omap/mcbsp.c                   |   27 +++++++++
 include/linux/i2c-omap.h                     |   27 +++++++++
 22 files changed, 288 insertions(+), 55 deletions(-)
