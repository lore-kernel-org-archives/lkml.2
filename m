Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2LQXbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 18:31:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:53590 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2LQXbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 18:31:48 -0500
Message-ID: <1355787094.5397.30.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Tue, 18 Dec 2012 10:31:34 +1100
In-Reply-To: <1355517897.19932.136.camel@pasglop>
References: <1355517897.19932.136.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-15 at 07:44 +1100, Benjamin Herrenschmidt wrote:
> Hi Linus !
> 
> Finally managed to get my head away from some other distractions
> to put this pull request together, sorry for the lateness :-)
> 
> The main highlight is probably some base POWER8 support. There's
> more to come such as transactional memory support but that will
> wait for the next one. (next merge window)
> 
> Overall it's pretty quiet, or rather I've been pretty poor at
> picking things up from patchwork and reviewing them this time
> around and Kumar no better on the FSL side it seems...

So it looks like I'm an idiot and totally failed to put your email
address on the CC list of that pull request :-)

This is an updated version with Anatolij 52xx which I hadn't merged back
then but have now (it's all be in -next for a while).

Cheers,
Ben.

The following changes since commit b69f0859dc8e633c5d8c06845811588fe17e68b3:

  Linux 3.7-rc8 (2012-12-03 11:22:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 376bddd34433065aeb9b9a140870537feecf90ef:

  Merge remote-tracking branch 'agust/next' into next (2012-12-18 10:22:27 +1100)

----------------------------------------------------------------

Akinobu Mita (3):
      powerpc/iommu: Use bitmap library
      powerpc: Remove BITOP_MASK and BITOP_WORD from asm/bitops.h
      powerpc: Use asm-generic/bitops/le.h

Andreas Schwab (1):
      powerpc/powermac/cpufreq_32: Set non-infinite transition time for 7447A driver

Anton Blanchard (3):
      powerpc: Move most of setup.h out of uapi
      powerpc: Remove stale function prototypes from setup.h
      powerpc: Fix CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n build

Aravinda Prasad (1):
      powerpc/ptrace: Enable hardware breakpoint upon re-registering

Benjamin Herrenschmidt (6):
      powerpc/powernv: Fix OPAL debug entry
      Merge branch 'dt' into next
      Merge branch 'merge' into next
      Merge remote-tracking branch 'kumar/next' into next
      powerpc+of: Rename and fix OF reconfig notifier error inject module
      Merge remote-tracking branch 'agust/next' into next

Dan Horák (1):
      fbdev: Add GXT4000P and GXT6500P support to the gxt4500 driver

Gavin Shan (1):
      powerpc/pnv: Avoid bogus output

Ian Munsie (5):
      powerpc: Add set_mode hcall
      powerpc: Add wrappers to enable/disable relocation on exceptions
      powerpc: Move get_longbusy_msecs into hvcall.h and remove duplicate function
      powerpc: Enable relocation on during exceptions at boot
      powerpc: Disable relocation on exceptions when kexecing

Jia Hongtao (1):
      powerpc/fsl-pci: Add PCI controller ATMU PM support

JoonSoo Kim (1):
      powerpc: Change free_bootmem() to kfree()

Julia Lawall (1):
      powerpc/rtas_flash: Eliminate possible double free

K.Prasad (1):
      powerpc/hw-breakpoint: Use generic hw-breakpoint interfaces for new PPC ptrace flags

Li Zhong (1):
      powerpc: Fix MAX_STACK_TRACE_ENTRIES too low warning !

Matthew McClintock (1):
      powerpc: dtc is required to build dtb files

Michael Ellerman (12):
      powerpc/udbg: Remove unused udbg_read()
      powerpc/xmon: Remove unused xmon_expect() & xmon_read_poll()
      powerpc/xmon: Remove empty xmon_map_scc()
      powerpc/xmon: Make xmon_getchar() static
      powerpc/xmon: Merge start.c into nonstdio.c
      powerpc/xmon: Remove renaming #defines of scanhex() and skipbl()
      powerpc/xmon: Remove unused #defines
      powerpc/xmon: Use STACK_FRAME_OVERHEAD in xmon_show_stack()
      powerpc/xmon: Fiddle xmon_depth_to_print logic in xmon_show_stack()
      powerpc/xmon: Fallback to printk() in xmon_printf() if udbg is not setup
      powerpc: Remove no longer used ppc_md.idle_loop()
      powerpc/perf: Add missing L2 constraint handling in Power7 PMU

Michael Neuling (16):
      powerpc/ptrace: Fix spelling mistake
      powerpc/ptrace: Remove unused addr parameter in ppc_del_hwdebug()
      powerpc: make POWER7 setup code name generic
      powerpc: Add POWER8 setup code
      powerpc: POWER8 cputable entry
      powerpc: Fix denorm symbol name
      powerpc/pseries: Update ibm,architecture.vec for PAPR 2.7/POWER8
      powerpc: Add POWER8 architected mode to cputable
      powerpc: Whitespace changes in exception64s.S
      powerpc: Remove unessessary 0x3000 location enforcement
      powerpc: Make load_hander handle upto 64k offset
      powerpc: Turn syscall handler into macros
      powerpc: Add new macros needed for relocation on exceptions
      powerpc: Add relocation on exception vector handlers
      powerpc: Move initial mfspr LPCR out of __init_LPCR
      powerpc: Setup relocation on exceptions for bare metal systems

Nathan Fontenot (6):
      powerpc+of: Add /proc device tree updating to of node add/remove
      powerpc+of: Move of_drconf_cell struct definition to asm/prom.h
      powerpc+of: Add of node/property notification chain for adds and removes
      powerpc+of: Rename the drivers/of prom_* functions to of_*
      powerpc+of: Remove the pSeries_reconfig.h file
      powerpc+of: Export of_reconfig_notifier_[register,unregister]

Nishanth Aravamudan (1):
      powerpc/pseries: Double NR_CPUS in defconfig

Srinivas Kandagatla (2):
      powerpc/sysdev: Use module_platform_driver macro
      powerpc/mpc52xx: use module_platform_driver macro

Stefan Roese (1):
      powerpc: mpc5200: Add a3m071 board support

Sukadev Bhattiprolu (1):
      powerpc/perf: Use uapi/unistd.h to fix build error

Timur Tabi (3):
      drivers/virt: the Freescale hypervisor driver doesn't need to check MSR[GS]
      powerpc/86xx: fsl_pcibios_fixup_bus requires CONFIG_PCI
      powerpc/512x: don't compile any platform DIU code if the DIU is not enabled

Tony Breeds (2):
      powerpc/47x: Use the new ppc-opcode infrastructure
      powerpc: Add asm/debug.h to get powerpc_debugfs_root

Tushar Behera (1):
      powerpc/85xx: p1022ds: Use NULL instead of 0 for pointers

Varun Sethi (1):
      powerpc/iommu/fsl: Add PAMU bypass enable register to ccsr_guts struct

Wei Yongjun (1):
      powerpc/windfarm: Use module_i2c_driver to simplify the code

Xuelin Shi (1):
      powerpc/dma/raidengine: add raidengine device

Yang Li (1):
      powerpc: Fix typos in Freescale copyright claims

York Sun (1):
      powerpc/mpc85xx: Change spin table to cached memory

 .../devicetree/bindings/powerpc/fsl/raideng.txt    |   81 +++++
 Documentation/powerpc/ptrace.txt                   |   16 +
 arch/arm/mach-mxs/mach-mxs.c                       |    2 +-
 arch/powerpc/Makefile                              |    2 +-
 arch/powerpc/boot/dts/a3m071.dts                   |  144 +++++++++
 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi        |    1 +
 arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi         |    6 +
 arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi     |   85 ++++++
 arch/powerpc/configs/pseries_defconfig             |    2 +-
 arch/powerpc/include/asm/bitops.h                  |   75 +----
 arch/powerpc/include/asm/cputable.h                |   12 +-
 arch/powerpc/include/asm/dbell.h                   |    2 +-
 arch/powerpc/include/asm/exception-64s.h           |   97 +++++-
 arch/powerpc/include/asm/firmware.h                |    4 +-
 arch/powerpc/include/asm/fsl_gtm.h                 |    2 +-
 arch/powerpc/include/asm/fsl_guts.h                |    4 +-
 arch/powerpc/include/asm/hvcall.h                  |   23 +-
 arch/powerpc/include/asm/immap_qe.h                |    2 +-
 arch/powerpc/include/asm/machdep.h                 |    3 -
 arch/powerpc/include/asm/mmu.h                     |    1 +
 arch/powerpc/include/asm/pSeries_reconfig.h        |   47 ---
 arch/powerpc/include/asm/ppc-opcode.h              |    6 +-
 arch/powerpc/include/asm/prom.h                    |   16 +
 arch/powerpc/include/asm/qe.h                      |    2 +-
 arch/powerpc/include/asm/qe_ic.h                   |    2 +-
 arch/powerpc/include/asm/reg.h                     |    3 +
 arch/powerpc/include/asm/rtas.h                    |    5 +
 arch/powerpc/include/asm/setup.h                   |   29 ++
 arch/powerpc/include/asm/ucc.h                     |    2 +-
 arch/powerpc/include/asm/ucc_fast.h                |    2 +-
 arch/powerpc/include/asm/ucc_slow.h                |    2 +-
 arch/powerpc/include/asm/udbg.h                    |    1 -
 arch/powerpc/include/uapi/asm/setup.h              |   31 --
 arch/powerpc/kernel/Makefile                       |    2 +-
 .../{cpu_setup_power7.S => cpu_setup_power.S}      |   32 +-
 arch/powerpc/kernel/cputable.c                     |   38 +++
 arch/powerpc/kernel/entry_64.S                     |    2 +
 arch/powerpc/kernel/exceptions-64s.S               |  308 ++++++++++++++++----
 arch/powerpc/kernel/head_64.S                      |    6 +-
 arch/powerpc/kernel/idle.c                         |    3 -
 arch/powerpc/kernel/iommu.c                        |   16 +-
 arch/powerpc/kernel/machine_kexec.c                |   14 +-
 arch/powerpc/kernel/machine_kexec_64.c             |    8 +-
 arch/powerpc/kernel/pci_32.c                       |    2 +-
 arch/powerpc/kernel/prom.c                         |    7 +-
 arch/powerpc/kernel/prom_init.c                    |   11 +-
 arch/powerpc/kernel/ptrace.c                       |   90 +++++-
 arch/powerpc/kernel/rtas.c                         |    1 -
 arch/powerpc/kernel/rtas_flash.c                   |    4 +-
 arch/powerpc/kernel/setup_64.c                     |    5 +
 arch/powerpc/kernel/udbg.c                         |   23 --
 arch/powerpc/mm/numa.c                             |   12 -
 arch/powerpc/mm/tlb_nohash_low.S                   |   15 +-
 arch/powerpc/perf/power7-pmu.c                     |   17 +-
 arch/powerpc/platforms/512x/Kconfig                |    1 -
 arch/powerpc/platforms/512x/mpc5121_ads.c          |    3 +
 arch/powerpc/platforms/512x/mpc512x.h              |   11 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c       |   25 +-
 arch/powerpc/platforms/52xx/lite5200.c             |    2 +-
 arch/powerpc/platforms/52xx/mpc5200_simple.c       |    1 +
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |   16 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c       |    8 +-
 arch/powerpc/platforms/83xx/mpc832x_mds.c          |    2 +-
 arch/powerpc/platforms/83xx/mpc836x_mds.c          |    2 +-
 arch/powerpc/platforms/83xx/mpc836x_rdk.c          |    2 +-
 arch/powerpc/platforms/83xx/mpc837x_rdb.c          |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    2 +-
 arch/powerpc/platforms/85xx/p1022_ds.c             |    8 +-
 arch/powerpc/platforms/85xx/smp.c                  |   49 +++-
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |    2 +
 arch/powerpc/platforms/powermac/cpufreq_32.c       |    5 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   25 +-
 arch/powerpc/platforms/ps3/os-area.c               |    6 +-
 arch/powerpc/platforms/pseries/dlpar.c             |   34 +--
 arch/powerpc/platforms/pseries/firmware.c          |    1 +
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |    8 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   60 ++--
 arch/powerpc/platforms/pseries/iommu.c             |   10 +-
 arch/powerpc/platforms/pseries/mobility.c          |    4 +-
 arch/powerpc/platforms/pseries/plpar_wrappers.h    |   31 ++
 arch/powerpc/platforms/pseries/reconfig.c          |  119 +-------
 arch/powerpc/platforms/pseries/setup.c             |   77 ++++-
 arch/powerpc/platforms/pseries/smp.c               |    1 -
 arch/powerpc/sysdev/fsl_gtm.c                      |    2 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   37 ++-
 arch/powerpc/sysdev/pmi.c                          |   13 +-
 arch/powerpc/sysdev/qe_lib/qe.c                    |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.h                 |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_io.c                 |    2 +-
 arch/powerpc/sysdev/qe_lib/ucc.c                   |    2 +-
 arch/powerpc/sysdev/qe_lib/ucc_fast.c              |    2 +-
 arch/powerpc/sysdev/qe_lib/ucc_slow.c              |    2 +-
 arch/powerpc/sysdev/qe_lib/usb.c                   |    2 +-
 arch/powerpc/xmon/Makefile                         |    2 +-
 arch/powerpc/xmon/nonstdio.c                       |   53 ++--
 arch/powerpc/xmon/nonstdio.h                       |    6 -
 arch/powerpc/xmon/start.c                          |   34 ---
 arch/powerpc/xmon/xmon.c                           |   26 +-
 drivers/crypto/nx/nx-842.c                         |   20 +-
 drivers/crypto/nx/nx.c                             |    1 -
 drivers/infiniband/hw/ehca/hcp_if.c                |   20 --
 drivers/macintosh/smu.c                            |    2 +-
 drivers/macintosh/windfarm_fcu_controls.c          |   14 +-
 drivers/macintosh/windfarm_lm75_sensor.c           |   14 +-
 drivers/macintosh/windfarm_max6690_sensor.c        |   13 +-
 drivers/macintosh/windfarm_smu_sat.c               |   13 +-
 drivers/net/ethernet/ibm/ehea/ehea_phyp.h          |   20 --
 drivers/of/base.c                                  |  142 ++++++++-
 drivers/video/Kconfig                              |    8 +-
 drivers/video/gxt4500.c                            |   15 +-
 drivers/virt/fsl_hypervisor.c                      |    3 -
 include/linux/of.h                                 |   29 +-
 lib/Kconfig.debug                                  |   10 +-
 lib/Makefile                                       |    4 +-
 ...nject.c => of-reconfig-notifier-error-inject.c} |   22 +-
 tools/perf/perf.h                                  |    1 +
 117 files changed, 1546 insertions(+), 839 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/raideng.txt
 create mode 100644 arch/powerpc/boot/dts/a3m071.dts
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi
 delete mode 100644 arch/powerpc/include/asm/pSeries_reconfig.h
 create mode 100644 arch/powerpc/include/asm/setup.h
 rename arch/powerpc/kernel/{cpu_setup_power7.S => cpu_setup_power.S} (80%)
 delete mode 100644 arch/powerpc/xmon/start.c
 rename lib/{pSeries-reconfig-notifier-error-inject.c => of-reconfig-notifier-error-inject.c} (51%)


