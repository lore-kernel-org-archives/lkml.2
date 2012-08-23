Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030604Ab2HWQBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:01:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64598 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130Ab2HWQBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:01:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for v3.6-rc3
Date: Thu, 23 Aug 2012 16:01:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208231601.18358.arnd@arndb.de>
X-Provags-ID: V02:K0:NHMw6FemuhHvpf7hfDh81lgtJNy7N6+COhq6Ig6GwXJ
 QhawysDNtLotKYx1VpRk5SVYrpuTMxV9fK96fGUs82oYJcBEwg
 OCZoA2sVb5gJDzriSKq+OFVwK0AXQeND6IRUp29j/1vCZcwfZZ
 EPnh33nnWkij1r5iNzDDZ4QwHK12oG3EfewPERaqkV060MlBfp
 HR/4uog8Z5MaCIomRf1//ZF1rXNqzzoPpjTj3Vvzx4utBL8PMp
 RkdjFtnDgO+512PfXzMs4Jp+DBW1wW0rvK2o97HdouwyIFRXos
 mQi6bNn12OaLNABNu8VKHAyrp4g9wSRHkqO1Rbljyvkw9RS4d9
 YIIIou9qw59DIZz5cA/A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I don't know what happened with the set of patches that I sent, so I'm
hoping you dropped accidentally. Here are the same patches and then
some more that came in since.

	Arnd

The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-3.6-rc3

for you to fetch changes up to 57f0b2014135235d5bf03834dee1284629ce50d2:

  Merge branch 'randconfig/mach' into fixes (2012-08-23 17:30:54 +0200)

----------------------------------------------------------------

arm-soc fixes for v3.6-rc3

Bug fixes for various ARM platforms. About half of these are
for OMAP and submitted before but did not make it into v3.6-rc2.

----------------------------------------------------------------
Afzal Mohammed (1):
      arm/dts: Fix am33xx wdt node

Arnaud Patard (3):
      ARM: Orion: Set eth packet size csum offload limit
      ARM: Kirkwood: Fix iconnect leds
      ARM: Kirkwood: fix Makefile.boot

Arnd Bergmann (14):
      ARM: mv78xx0: fix win_cfg_base prototype
      Merge tag 'omap-fixes-for-v3.6-rc1' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'fixes-for-v3.6' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge branch 'fixes' of git://github.com/hzhuang1/linux into fixes
      Merge branch 'imx/fixes-for-3.6' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge branch 'v3.6-samsung-fixes-1' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'ux500-fixes-v3.6-rc2' of git://git.kernel.org/.../linusw/linux-stericsson into fixes
      ARM: omap: allow building omap44xx without SMP
      ARM: imx: build pm-imx5 code only when PM is enabled
      ARM: imx: fix ksz9021rn_phy_fixup
      ARM: imx: select CPU_FREQ_TABLE when needed
      ARM: imx: build i.MX6 functions only when needed
      ARM: ux500: don't select LEDS_GPIO for snowball
      Merge branch 'randconfig/mach' into fixes

Domenico Andreoli (1):
      OMAP: remove unused parameter arch_id from uncompress.h

Heiko Stuebner (2):
      ARM: S3C24XX: Add missing DMACH_DT_PROP
      ARM: S3C24XX: Fix s3c2410_dma_enqueue parameters

Igor Grinberg (1):
      Revert "ARM: OMAP3530evm: set pendown_state and debounce time for ads7846"

Jan Luebbe (1):
      omap: Fix multi.h when only ARCH_OMAP3 and SOC_AM33XX are selected

Javier Martinez Canillas (1):
      ARM: OMAP3: igep0020: set GPIO mode for mux mcspi1_cs2 pin

Jon Hunter (1):
      ARM: OMAP2+: Fix dmtimer set source clock failure

Kevin Hilman (2):
      ARM: OMAP3: TWL4030: ensure sys_nirq1 is mux'd and wakeup enabled
      Revert "ARM: OMAP3: PM: call pre/post transition per powerdomain"

Lee Jones (2):
      ARM: ux500: Fix merge error, no matching driver name for 'snd_soc_u8500'
      ARM: ux500: Ensure probing of Audio devices when Device Tree is enabled

Michael Jones (1):
      omap2: mux: remove comment for nonexistent member

Philipp Zabel (1):
      ARM i.MX6q: Add virtual 1/3.5 dividers in the LDB clock path

Rajendra Nayak (3):
      arm/dts: Mark vcxio, v2v1 and v1v8 regulators as always on
      cpufreq: OMAP: Handle missing frequency table on SMP systems
      ARM: OMAP4: Register the OPP table only for 4430 device

Sachin Kamat (3):
      ARM: Samsung: Make uart_save static in pm.c file
      ARM: SAMSUNG: Set HDMI platform data for Exynos4x12 SoCs
      ARM: EXYNOS: Set HDMI platform data in SMDKV310

Santosh Shilimkar (2):
      OMAP2+: Fix random config build break with !ARM_CPU_SUSPEND
      ARM: OMAP4: sleep: Save the complete used register stack frame

Shawn Guo (2):
      ARM: imx6: spin the cpu until hardware takes it down
      ARM: dts: imx51-babbage: fix esdhc cd/wp properties

Timo Kokkonen (1):
      ARM: OMAP: dmtimers: Fix locking issue in omap_dm_timer_request*()

Tony Lindgren (2):
      Merge branch 'for_3.6/fixes/ads7846-2' of git://git.kernel.org/.../khilman/linux-omap-pm into fixes
      Merge branch 'for_3.6/fixes/pm' of git://git.kernel.org/.../khilman/linux-omap-pm into fixes

Tushar Behera (2):
      ARM: SAMSUNG: Add API to set platform data for s5p-tv driver
      ARM: EXYNOS: Set HDMI platform data in Origen board

Vaibhav Hiremath (1):
      ARM: OMAP2+: cpu: Add am33xx device under cpu_class_is_omap2

Yuanhan Liu (1):
      ARM: mmp: fix potential NULL dereference

 .../devicetree/bindings/mmc/fsl-imx-esdhc.txt      |    8 +++---
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/am33xx.dtsi                      |    5 ++++
 arch/arm/boot/dts/imx51-babbage.dts                |    4 +--
 arch/arm/boot/dts/kirkwood-iconnect.dts            |    6 +++-
 arch/arm/boot/dts/twl6030.dtsi                     |    3 ++
 arch/arm/configs/u8500_defconfig                   |    1 +
 arch/arm/mach-dove/common.c                        |    3 +-
 arch/arm/mach-exynos/mach-origen.c                 |    7 +++++
 arch/arm/mach-exynos/mach-smdkv310.c               |    7 +++++
 arch/arm/mach-imx/Makefile                         |   10 +++----
 arch/arm/mach-imx/clk-imx6q.c                      |    8 ++++--
 arch/arm/mach-imx/{head-v7.S => headsmp.S}         |    0
 arch/arm/mach-imx/hotplug.c                        |   23 ++--------------
 arch/arm/mach-imx/mach-imx6q.c                     |    4 +--
 arch/arm/mach-kirkwood/Makefile.boot               |    3 +-
 arch/arm/mach-kirkwood/common.c                    |    4 +--
 arch/arm/mach-mmp/sram.c                           |    2 +-
 arch/arm/mach-mv78xx0/addr-map.c                   |    2 +-
 arch/arm/mach-mv78xx0/common.c                     |    6 ++--
 arch/arm/mach-omap2/Kconfig                        |    3 +-
 arch/arm/mach-omap2/board-igep0020.c               |    2 ++
 arch/arm/mach-omap2/board-omap3evm.c               |    1 +
 arch/arm/mach-omap2/common-board-devices.c         |   11 --------
 arch/arm/mach-omap2/common-board-devices.h         |    1 -
 arch/arm/mach-omap2/cpuidle44xx.c                  |    3 +-
 arch/arm/mach-omap2/mux.h                          |    1 -
 arch/arm/mach-omap2/opp4xxx_data.c                 |    2 +-
 arch/arm/mach-omap2/pm34xx.c                       |   19 +++----------
 arch/arm/mach-omap2/sleep44xx.S                    |    8 ++++--
 arch/arm/mach-omap2/twl-common.c                   |    1 +
 arch/arm/mach-orion5x/common.c                     |    3 +-
 arch/arm/mach-s3c24xx/include/mach/dma.h           |    3 +-
 arch/arm/mach-ux500/Kconfig                        |    1 -
 arch/arm/mach-ux500/board-mop500-msp.c             |   10 +++----
 arch/arm/mach-ux500/board-mop500.c                 |    4 +++
 arch/arm/plat-omap/dmtimer.c                       |    6 ++--
 arch/arm/plat-omap/include/plat/cpu.h              |    3 +-
 arch/arm/plat-omap/include/plat/multi.h            |    9 ++++++
 arch/arm/plat-omap/include/plat/uncompress.h       |    4 +--
 arch/arm/plat-orion/common.c                       |    8 ++++--
 arch/arm/plat-orion/include/plat/common.h          |    6 ++--
 arch/arm/plat-s3c24xx/dma.c                        |    2 +-
 arch/arm/plat-samsung/devs.c                       |   29 +++++++++++++++++++-
 arch/arm/plat-samsung/include/plat/hdmi.h          |   16 +++++++++++
 arch/arm/plat-samsung/pm.c                         |    2 +-
 drivers/cpufreq/omap-cpufreq.c                     |    4 ++-
 include/linux/cpuidle.h                            |    4 +++
 include/linux/mv643xx_eth.h                        |    2 ++
 49 files changed, 174 insertions(+), 101 deletions(-)
 rename arch/arm/mach-imx/{head-v7.S => headsmp.S} (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat/hdmi.h
