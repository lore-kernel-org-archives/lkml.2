Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab0D1HC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:02:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:56466 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab0D1HCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:02:25 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1272347770.24542.1.camel@pasglop>
References: <1272347770.24542.1.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 17:02:11 +1000
Message-ID: <1272438131.24542.90.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 15:56 +1000, Benjamin Herrenschmidt wrote:
> Hi Linus !
> 
> PowerPC has been a bit quiet this time around :-) That is until Kumar
> woke me up with a few fixes and defconfig updates for the freescale
> embedded platforms.

I added a few patches to that. Some ps3 defconfig & maintainers change
and a couple of nasty bug fixes.

Here's an updated request.

Cheers,
Ben.

The following changes since commit b91ce4d14a21fc04d165be30319541e0f9204f15:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Blanchard (1):
      powerpc/numa: Add form 1 NUMA affinity

Anton Vorontsov (1):
      powerpc/85xx/86xx: Fix build w/ CONFIG_PCI=n

Becky Bruce (1):
      powerpc/fsl_booke: Correct test for MMU_FTR_BIG_PHYS

Benjamin Herrenschmidt (1):
      powerpc/pseries: Flush lazy kernel mappings after unplug operations

Geoff Levand (2):
      powerpc/ps3: Update platform maintainer
      powerpc/ps3: Update ps3_defconfig

Kim Phillips (4):
      powerpc/83xx: add RTC drivers in 83xx defconfig
      powerpc/83xx: enable EPOLL syscall in defconfig
      powerpc/83xx: configure SIL SATA driver in 83xx-wide defconfig
      powerpc/mpc8xxx defconfigs - turn off SYSFS_DEPRECATED

Kumar Gala (2):
      powerpc: 2.6.34 update of defconfigs for embedded 6xx/7xxx, 8xx, 8xxx
      powerpc/fsl-booke: Fix CONFIG_RELOCATABLE support on FSL Book-E ppc32

Wolfgang Ocker (1):
      powerpc/fsl-cpm: Configure clock correctly for SCC

 MAINTAINERS                                       |    8 +-
 arch/powerpc/configs/83xx/asp8347_defconfig       |   44 +++---
 arch/powerpc/configs/83xx/kmeter1_defconfig       |   28 ++--
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   |   49 +++---
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   |   50 +++---
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   |   45 +++---
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |   49 +++---
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |   44 +++---
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |   43 +++---
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   |   46 +++---
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   |   45 +++---
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   |   44 +++--
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   |   46 +++---
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |   51 +++---
 arch/powerpc/configs/83xx/sbc834x_defconfig       |   44 +++---
 arch/powerpc/configs/85xx/ksi8560_defconfig       |   23 ++-
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |   25 ++-
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   |   34 +++--
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   |   31 +++--
 arch/powerpc/configs/85xx/sbc8548_defconfig       |   31 +++--
 arch/powerpc/configs/85xx/sbc8560_defconfig       |   25 ++-
 arch/powerpc/configs/85xx/socrates_defconfig      |   51 ++++---
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |   51 ++++---
 arch/powerpc/configs/85xx/tqm8540_defconfig       |   48 +++--
 arch/powerpc/configs/85xx/tqm8541_defconfig       |   54 ++++--
 arch/powerpc/configs/85xx/tqm8548_defconfig       |   47 +++--
 arch/powerpc/configs/85xx/tqm8555_defconfig       |   54 ++++--
 arch/powerpc/configs/85xx/tqm8560_defconfig       |   54 ++++--
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig   |   59 +++++--
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig     |  102 +++++++-----
 arch/powerpc/configs/86xx/gef_sbc310_defconfig    |   53 ++++---
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    |   96 +++++++----
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  |   34 ++--
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  |   48 ++++--
 arch/powerpc/configs/86xx/sbc8641d_defconfig      |   40 +++--
 arch/powerpc/configs/adder875_defconfig           |   18 +-
 arch/powerpc/configs/c2k_defconfig                |   55 +++----
 arch/powerpc/configs/ep8248e_defconfig            |   20 ++-
 arch/powerpc/configs/ep88xc_defconfig             |   17 +-
 arch/powerpc/configs/linkstation_defconfig        |   48 +++--
 arch/powerpc/configs/mgcoge_defconfig             |   31 +++-
 arch/powerpc/configs/mgsuvd_defconfig             |   19 ++-
 arch/powerpc/configs/mpc7448_hpc2_defconfig       |   26 ++-
 arch/powerpc/configs/mpc8272_ads_defconfig        |   23 ++-
 arch/powerpc/configs/mpc83xx_defconfig            |  124 +++++++++++---
 arch/powerpc/configs/mpc85xx_defconfig            |   62 +++++---
 arch/powerpc/configs/mpc85xx_smp_defconfig        |   64 +++++---
 arch/powerpc/configs/mpc866_ads_defconfig         |   20 +-
 arch/powerpc/configs/mpc86xx_defconfig            |   57 ++++---
 arch/powerpc/configs/mpc885_ads_defconfig         |   20 +-
 arch/powerpc/configs/pq2fads_defconfig            |   22 ++-
 arch/powerpc/configs/prpmc2800_defconfig          |   52 ++++--
 arch/powerpc/configs/ps3_defconfig                |  189 ++++++++++++++-------
 arch/powerpc/configs/storcenter_defconfig         |   33 ++--
 arch/powerpc/include/asm/page.h                   |   15 ++-
 arch/powerpc/kernel/prom_init.c                   |    3 +-
 arch/powerpc/mm/fsl_booke_mmu.c                   |    4 +-
 arch/powerpc/mm/numa.c                            |   17 ++-
 arch/powerpc/platforms/85xx/Kconfig               |    4 +-
 arch/powerpc/platforms/86xx/Kconfig               |    4 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c   |    7 +
 arch/powerpc/sysdev/cpm1.c                        |   14 ++-
 arch/powerpc/sysdev/cpm2.c                        |   11 +-
 drivers/pci/hotplug/rpadlpar_core.c               |    3 +
 drivers/pci/hotplug/rpaphp_core.c                 |    3 +
 65 files changed, 1609 insertions(+), 972 deletions(-)


