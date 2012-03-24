Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2CXWEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:04:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab2CXWDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:03:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 04/09] ARM: timer cleanup work
Date: Sat, 24 Mar 2012 22:02:43 +0000
Message-Id: <1332626568-17812-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332626568-17812-1-git-send-email-arnd@arndb.de>
References: <1332626568-17812-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:tOFIKjwAqhweW4itEPJyhjG0Bzzz29x1BPZ/Wa6sqz8
 KWg2AEeaxl4u9WBA1rpnQTufYIPyScK5LcFQIo4p2APgUGDimo
 X//Gk3Bw50lQU/6icIddemB0wqMmFTz/J0c+A+u+fk4ROTOqTU
 PLDuQrLj7Zf/gUg/pWOtF3p12C9o2hJXZEZiB1xRWr/N11Us/1
 2z32rtvWOz3drJrtpvtzdpcx2JuP6NkbUEwZHqmkXG3lrYlBGo
 DRmS0wPzW1aZxPUH/1aVQtsVp7pY/OYEaWF+s6/RtAXagHIz6x
 EtQTemY4vgdAdi8kWa0HZ61OVhola8HgQGtLWVmf7MynUkCz2Z
 Qch7zuNU0a7xXckh2b4jymjYfmikd99Ivg9ngdPt8OPWglCz86
 676MyiYRXiCdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are split out from the generic soc and driver updates because
there was a lot of conflicting work by multiple people. Marc Zyngier
worked on simplifying the "localtimer" interfaces, and some of the
platforms are touching the same code as they move to device tree
based booting.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

The following changes since commit "0f98c77 Merge branch 'next/timer' into
for-next", leading up to commit " 2cbe23e Merge branch 'tegra/cleanups'
into next/timer", are available in

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/timer

Arnd Bergmann (12):
      Merge tag 'tegra-cleanups' of git://git.kernel.org/.../olof/tegra into tegra/cleanups
      Merge branch 'ux500/timers' into next/timer
      Merge branch 'vexpress/timer' into next/timer
      Merge branch 'local_timers-for-arm-soc' of git://git.kernel.org/.../maz/arm-platforms into next/timer
      ARM: shmobile: remove additional __io() macro use
      Merge branch 'local_timers-for-arm-soc' of git://git.kernel.org/.../maz/arm-platforms into next/timer
      Merge branch 'renesas/fixes' into renesas/soc
      ARM: tegra: select USB_ULPI if USB is selected
      Merge branch 'for-3.4/cleanup-and-fixes' of git://git.kernel.org/.../olof/tegra into tegra/cleanups
      Merge branch 'renesas/timer' into next/timer
      Merge branch 'tegra/cleanups' into next/timer
      Merge branch 'next/timer' into for-next

Dmitry Artamonow (3):
      arm/tegra: fix harmony pinmux for PCIe
      arm/tegra: add timeout to PCIe PLL lock detection loop
      arm/tegra: pcie: fix return value of function

Linus Walleij (3):
      ARM: plat-nomadik: get rid of global mtu base pointer
      ARM: plat-nomadik: handle clocking properly
      ARM: plat-nomadik: modernize MTU timer

Magnus Damm (35):
      sh: introduce sh_clk_ops in parallel with clk_ops
      sh: convert cpg code to sh_clk_ops
      ARM: mach-shmobile: sh7367 sh_clk_ops rename
      ARM: mach-shmobile: sh7377 sh_clk_ops rename
      ARM: mach-shmobile: sh7372 sh_clk_ops rename
      ARM: mach-shmobile: sh73a0 sh_clk_ops rename
      ARM: mach-shmobile: r8a7740 sh_clk_ops rename
      ARM: mach-shmobile: r8a7779 sh_clk_ops rename
      sh: sh header sh_clk_ops rename
      sh: sh2 sh_clk_ops rename
      sh: sh2a sh_clk_ops rename
      sh: sh3 sh_clk_ops rename
      sh: sh4 sh_clk_ops rename
      sh: sh4a sh_clk_ops rename
      sh: sh5 sh_clk_ops rename
      sh: board sh_clk_ops rename
      sh: remove clk_ops
      ARM: mach-shmobile: sh7367 map_io and init_early update
      ARM: mach-shmobile: sh7377 map_io and init_early update
      ARM: mach-shmobile: sh7372 map_io and init_early update
      ARM: mach-shmobile: sh73a0 map_io and init_early update
      ARM: mach-shmobile: r8a7740 map_io and init_early update
      ARM: mach-shmobile: r8a7779 map_io and init_early update
      ARM: mach-shmobile: r8a7779 L2 cache support
      ARM: mach-shmobile: rename clk_init() to shmobile_clk_init()
      ARM: mach-shmobile: Move sh7372 Mackerel external clk setup
      ARM: mach-shmobile: Move sh7372 AP4EVB external clk setup
      ARM: mach-shmobile: add shmobile_earlytimer_init()
      ARM: mach-shmobile: sh7367 and G3EVM timer rework
      ARM: mach-shmobile: sh7377 and G4EVM timer rework
      ARM: mach-shmobile: sh7372, AP4EVB and Mackerel timer rework
      ARM: mach-shmobile: sh73a0, AG5EVM and Kota2 timer rework
      ARM: mach-shmobile: r8a7740 and Bonito timer rework
      ARM: mach-shmobile: r8a7779 and Marzen timer rework
      ARM: mach-shmobile: default to no earlytimer

Marc Zyngier (16):
      ARM: smp_twd: make local_timer_stop a symbol instead of a #define
      ARM: local timers: introduce a new registration interface
      ARM: smp_twd: add runtime registration support
      ARM: smp_twd: add device tree support
      ARM: OMAP4: convert to twd_local_timer_register() interface
      ARM: plat-versatile: convert to twd_local_timer_register() interface
      ARM: tegra: convert to twd_local_timer_register() interface
      ARM: shmobile: convert to twd_local_timer_register() interface
      ARM: ux500: convert to twd_local_timer_register() interface
      ARM: highbank: convert to twd_local_timer_register() interface
      ARM: imx6q: convert to twd_local_timer_register() interface
      ARM: smp_twd: remove old local timer interface
      ARM: local timers: convert exynos to runtime registration interface
      ARM: local timers: convert MSM to runtime registration interface
      ARM: local timers: make the runtime registration interface mandatory
      ARM: ux500: fix compilation after local timer rework

Olof Johansson (1):
      Merge branch 'ux500-timers' of git://git.kernel.org/.../linusw/linux-stericsson into ux500/timers

Pawel Moll (2):
      ARM: vexpress: Get rid of MMIO_P2V
      ARM: versatile: Map local timers using Device Tree when possible


 Documentation/devicetree/bindings/arm/twd.txt     |   48 ++++++++
 arch/arm/boot/dts/highbank.dts                    |    8 +-
 arch/arm/boot/dts/imx6q.dtsi                      |    6 +-
 arch/arm/include/asm/hardware/arm_timer.h         |    5 +
 arch/arm/include/asm/localtimer.h                 |   37 +-----
 arch/arm/include/asm/smp_twd.h                    |   25 ++++-
 arch/arm/kernel/smp.c                             |   22 +++-
 arch/arm/kernel/smp_twd.c                         |  123 +++++++++++++++++----
 arch/arm/mach-exynos/mct.c                        |   18 ++--
 arch/arm/mach-highbank/Makefile                   |    1 -
 arch/arm/mach-highbank/highbank.c                 |    3 +
 arch/arm/mach-highbank/localtimer.c               |   40 -------
 arch/arm/mach-imx/Makefile                        |    1 -
 arch/arm/mach-imx/localtimer.c                    |   35 ------
 arch/arm/mach-imx/mach-imx6q.c                    |    2 +
 arch/arm/mach-msm/timer.c                         |   79 ++++++++------
 arch/arm/mach-nomadik/board-nhk8815.c             |    7 +-
 arch/arm/mach-nomadik/include/mach/setup.h        |   19 ---
 arch/arm/mach-omap2/Makefile                      |    1 -
 arch/arm/mach-omap2/timer-mpu.c                   |   39 -------
 arch/arm/mach-omap2/timer.c                       |   22 +++-
 arch/arm/mach-realview/realview_eb.c              |   27 ++++-
 arch/arm/mach-realview/realview_pb11mp.c          |   21 +++-
 arch/arm/mach-realview/realview_pbx.c             |   20 +++-
 arch/arm/mach-shmobile/Makefile                   |    1 -
 arch/arm/mach-shmobile/board-ag5evm.c             |   39 +------
 arch/arm/mach-shmobile/board-ap4evb.c             |   44 +-------
 arch/arm/mach-shmobile/board-bonito.c             |   44 ++------
 arch/arm/mach-shmobile/board-g3evm.c              |   38 +------
 arch/arm/mach-shmobile/board-g4evm.c              |   38 +------
 arch/arm/mach-shmobile/board-kota2.c              |   38 +------
 arch/arm/mach-shmobile/board-mackerel.c           |   39 +------
 arch/arm/mach-shmobile/board-marzen.c             |   62 +----------
 arch/arm/mach-shmobile/clock-r8a7740.c            |    8 +-
 arch/arm/mach-shmobile/clock-r8a7779.c            |    4 +-
 arch/arm/mach-shmobile/clock-sh7367.c             |    8 +-
 arch/arm/mach-shmobile/clock-sh7372.c             |   10 +-
 arch/arm/mach-shmobile/clock-sh7377.c             |    8 +-
 arch/arm/mach-shmobile/clock-sh73a0.c             |   14 +-
 arch/arm/mach-shmobile/clock.c                    |    2 +-
 arch/arm/mach-shmobile/include/mach/common.h      |   11 ++-
 arch/arm/mach-shmobile/localtimer.c               |   26 -----
 arch/arm/mach-shmobile/platsmp.c                  |    1 -
 arch/arm/mach-shmobile/setup-r8a7740.c            |   45 ++++++++
 arch/arm/mach-shmobile/setup-r8a7779.c            |   54 +++++++++
 arch/arm/mach-shmobile/setup-sh7367.c             |   32 ++++++
 arch/arm/mach-shmobile/setup-sh7372.c             |   32 ++++++
 arch/arm/mach-shmobile/setup-sh7377.c             |   32 ++++++
 arch/arm/mach-shmobile/setup-sh73a0.c             |   32 ++++++
 arch/arm/mach-shmobile/smp-r8a7779.c              |    8 +-
 arch/arm/mach-shmobile/smp-sh73a0.c               |    8 +-
 arch/arm/mach-shmobile/timer.c                    |   16 +++-
 arch/arm/mach-tegra/Kconfig                       |    4 +-
 arch/arm/mach-tegra/Makefile                      |    1 -
 arch/arm/mach-tegra/board-harmony-pinmux.c        |    6 +-
 arch/arm/mach-tegra/localtimer.c                  |   26 -----
 arch/arm/mach-tegra/pcie.c                        |   16 ++-
 arch/arm/mach-tegra/timer.c                       |   22 +++-
 arch/arm/mach-ux500/Makefile                      |    1 -
 arch/arm/mach-ux500/cpu.c                         |    1 -
 arch/arm/mach-ux500/include/mach/setup.h          |    3 -
 arch/arm/mach-ux500/localtimer.c                  |   29 -----
 arch/arm/mach-ux500/timer.c                       |   39 +++++--
 arch/arm/mach-vexpress/core.h                     |    7 +-
 arch/arm/mach-vexpress/ct-ca9x4.c                 |   67 +++++-------
 arch/arm/mach-vexpress/include/mach/ct-ca9x4.h    |    3 -
 arch/arm/mach-vexpress/include/mach/motherboard.h |   52 ++++-----
 arch/arm/mach-vexpress/platsmp.c                  |    5 +-
 arch/arm/mach-vexpress/v2m.c                      |   68 ++++++++----
 arch/arm/plat-nomadik/include/plat/mtu.h          |    4 +-
 arch/arm/plat-nomadik/timer.c                     |   33 ++----
 arch/arm/plat-versatile/Makefile                  |    1 -
 arch/arm/plat-versatile/localtimer.c              |   27 -----
 arch/sh/boards/mach-highlander/setup.c            |    2 +-
 arch/sh/boards/mach-sdk7786/setup.c               |    2 +-
 arch/sh/include/asm/clock.h                       |    2 +-
 arch/sh/kernel/cpu/sh2/clock-sh7619.c             |   12 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7201.c            |   12 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7203.c            |   12 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7206.c            |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh3.c                |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh7705.c             |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh7706.c             |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh7709.c             |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh7710.c             |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh7712.c             |   10 +-
 arch/sh/kernel/cpu/sh4/clock-sh4-202.c            |    6 +-
 arch/sh/kernel/cpu/sh4/clock-sh4.c                |   12 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c            |    4 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7366.c            |    4 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c            |    4 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c            |    4 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c            |    6 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c            |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7763.c            |   14 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7770.c            |   12 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7780.c            |   14 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c            |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c            |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-shx3.c              |    2 +-
 arch/sh/kernel/cpu/sh5/clock-sh5.c                |   12 +-
 drivers/sh/clk/cpg.c                              |   16 ++--
 include/linux/sh_clk.h                            |    5 +-
 103 files changed, 964 insertions(+), 999 deletions(-)
