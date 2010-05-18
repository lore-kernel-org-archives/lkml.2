Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0ERJ0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 05:26:32 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40039 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab0ERJ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 05:26:29 -0400
Date: Tue, 18 May 2010 18:25:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.35-rc1
Message-ID: <20100518092532.GA3050@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Guennadi Liakhovetski (5):
      SH: extend SCI DMA support to work on SCIFA ports
      SH: constify multiple DMA related objects and references to them
      SH: fix TS field shift calculation for DMA drivers
      SH: fix error paths in DMA driver
      sh: simplify WARN usage in SH clock driver

Hiroshi DOYU (1):
      sh: clkfwk: Use debugfs_remove_recursive() for rewinding

Kuninori Morimoto (2):
      sh: Check return value of clk_get on ecovec24
      sh: Check return value of clk_get on ms7724

Magnus Damm (52):
      sh: add INTC out of memory error handling
      sh: INTC ioremap support
      dmaengine: shdma: Remove sh_dmae_slave_chan_id enum
      dmaengine: shdma: Common SH_DMA_SLAVE_NUMBER
      serial: sh-sci: Use sg_dma_len() and sg_dma_address()
      dmaengine: shdma: Introduce include/linux/sh_dma.h
      sh: Fix maximum number of SCIF ports in R2D defconfigs
      sh: sh7751 pci controller io port fix
      sh: add CONFIG_VIRTUALIZATION for virtio support
      sh: hwblk index rework
      sh: scif and tmu clkdev changes
      sh: tie in hwblk clocks using clkdev
      sh: allow registering clocks without name
      sh: get rid of hwblk clock names
      sh: tie in div6 clocks using clkdev
      sh: get rid of div6 clock names
      sh: sh7343 mstp32 index rework
      sh: sh7343 mstp32 clkdev lookup
      sh: sh7366 mstp32 index rework
      sh: sh7366 mstp32 clkdev lookup
      sh: sh7785 mstp32 index rework
      sh: sh7785 mstp32 clkdev lookup
      sh: sh7786 mstp32 index rework
      sh: sh7786 mstp32 clkdev lookup
      sh: get rid of mstp32 clock name and id
      sh: div4 reparent workaround
      sh: sh7722 div4 clkdev lookup
      sh: sh7723 div4 clkdev lookup
      sh: sh7724 div4 clkdev lookup
      sh: sh7343 div4 clkdev lookup
      sh: sh7366 div4 clkdev lookup
      sh: sh7785 div4 clkdev lookup
      sh: sh7786 div4 clkdev lookup
      sh: get rid of div4 clock name
      sh: switch legacy clocks to clkdev
      sh: switch sh7724 to clkdev
      sh: switch sh7723 to clkdev
      sh: switch sh7722 to clkdev
      sh: switch sh7343 to clkdev
      sh: switch sh7366 to clkdev
      sh: switch sh7785 to clkdev
      sh: switch sh7786 to clkdev
      sh: switch sh7780 to clkdev
      sh: switch sh7763 to clkdev
      sh: switch sh7757 to clkdev
      sh: switch shx3 to clkdev
      sh: switch sh4-202 to clkdev
      sh: switch boards to clkdev
      sh: remove unused clock lookup
      sh: move sh asm/clock.h contents to linux/sh_clk.h V2
      sh: move sh clock.c contents to drivers/sh/clk.
      sh: move sh clock-cpg.c contents to drivers/sh/clk-cpg.c

Matt Fleming (7):
      sh: tlb debugfs support.
      sh: Assembly friendly __pa and __va definitions
      sh: Fix address to decompress at when CONFIG_32BIT=y
      sh: Fix zImage load address when CONFIG_32BIT=y
      sh: Do not try merging two 128MB PMB mappings
      sh: Use correct mask when comparing PMB DATA array values
      sh: native_cpu_disable() build error when CONFIG_HOTPLUG_CPU=n

Nick Piggin (1):
      sh: invoke oom-killer from page fault

Paul Mundt (63):
      sh: Merge clkdev API updates.
      sh: Support early clkdev allocations.
      driver core: Early dev_name() support.
      clocksource: Use dev_name() universally across the SH drivers.
      sh: Kill off all timer name clobbering.
      serial: sh-sci: clkdev updates for MSTP gating.
      driver core: Convert to kasprintf() for early dev_name().
      clocksource: Deprecate clock string across the SH drivers.
      sh: sh7786 clkdev lookups.
      sh: sh7785 clkdev lookups.
      sh: provide some clock lookup aliases for legacy CPG parts.
      sh: Kill off timer clock strings for legacy CPG parts.
      sh: sh7343 clock string death.
      sh: sh7366 clock string death.
      sh: sh7722 clock string death.
      sh: sh7723 clkdev lookups.
      sh: sh7724 clkdev lookups.
      sh: Disable MMUCR_AT for SH-4 nommu.
      sh: dmaengine support for SH7786 DMAC0.
      sh: intc: Provide sysdev name for intc controllers.
      sh: intc: Tidy up loglevel mismatches.
      sh: intc: userimask support.
      sh: Disable IRQ balancing for timer and IPI IRQs.
      sh: intc: IRQ auto-distribution support.
      sh: mach-sdk7786: pm_power_off support.
      sh: Enable SH-X3 hardware synonym avoidance handling.
      sh: dwarf unwinder needs linux/module.h.
      sh: Zero out aliases counter when using SH-X3 hardware assistance.
      sh: hw-breakpoints: Kill off stub unthrottle callback.
      sh: Tidy CPU probing and fixup section annotations.
      sh: __cpuinit annotate the CPU init path.
      sh: Move platform smp ops in to their own structure.
      sh: Kill off dangling goto labels from oom-killer rework.
      sh: mach-sdk7786: update defconfig for compressed kernel image.
      sh: Flag present CPUs hotpluggable in topology registration.
      sh: arch/sh/kernel/setup.c needs asm/smp.h.
      sh: convert online CPU map twiddling to cpumask.
      sh: Make sure all SH-X3 cores are populated in the present CPU map.
      sh: provide percpu CPU states for hotplug notifiers.
      sh: flag smp_store_cpu_info() __cpuinit.
      sh: cache secondary CPUs idle loop.
      sh: CPU hotplug support.
      sh: CPU hotplug support for SH-X3 SMP.
      sh: make latencytop available on SMP, too.
      sh: Make initrd detection more robust.
      sh: convert kexec crash kernel management to LMB.
      sh: convert initrd reservation to LMB.
      sh: bump up extra LMB reservations in bootmem init.
      sh: flag kdump as broken on SMP for now.
      sh: Ensure that X2 TLB settings are reflected in vmcore.
      sh: shuffle the elfcorehdr handling over to the crash dump code.
      sh: enable LMB region setup via machvec.
      sh: rework memory limits to work with LMB.
      sh: bootmem refactoring.
      sh: Reject small mappings for PMB bolting.
      sh: Ensure active regions have a backing PMB entry.
      sh: All SH-X3 cores support NUMA and SMP, update Kconfig.
      driver core: Early dev_name() depends on slab_is_available().
      sh: fixup the docbook paths for clock framework shuffling.
      sh: fix up CONFIG_KEXEC=n build.
      sh64: provide a stub per_cpu_trap_init() definition.
      sh: Fix up the NUMA build for recent LMB changes.
      sh: update defconfigs.

 Documentation/DocBook/sh.tmpl               |   10 +-
 arch/sh/Kconfig                             |   36 ++-
 arch/sh/Makefile                            |    1 -
 arch/sh/boards/board-urquell.c              |    3 +
 arch/sh/boards/mach-ecovec24/setup.c        |   26 +-
 arch/sh/boards/mach-highlander/setup.c      |   12 +-
 arch/sh/boards/mach-sdk7786/setup.c         |   17 +
 arch/sh/boards/mach-se/7724/setup.c         |   20 +-
 arch/sh/boards/mach-x3proto/setup.c         |    7 +
 arch/sh/boot/compressed/Makefile            |    6 +
 arch/sh/boot/compressed/head_32.S           |    4 +
 arch/sh/configs/ap325rxa_defconfig          |   56 ++--
 arch/sh/configs/cayman_defconfig            |   46 ++-
 arch/sh/configs/dreamcast_defconfig         |   29 +-
 arch/sh/configs/ecovec24-romimage_defconfig |   54 ++-
 arch/sh/configs/ecovec24_defconfig          |    7 +-
 arch/sh/configs/edosk7705_defconfig         |   21 +-
 arch/sh/configs/edosk7760_defconfig         |   38 +-
 arch/sh/configs/espt_defconfig              |   42 +-
 arch/sh/configs/hp6xx_defconfig             |   24 +-
 arch/sh/configs/kfr2r09-romimage_defconfig  |   50 ++-
 arch/sh/configs/kfr2r09_defconfig           |   57 ++--
 arch/sh/configs/landisk_defconfig           |   45 ++-
 arch/sh/configs/lboxre2_defconfig           |   35 +-
 arch/sh/configs/magicpanelr2_defconfig      |   28 +-
 arch/sh/configs/microdev_defconfig          |   23 +-
 arch/sh/configs/migor_defconfig             |   60 ++--
 arch/sh/configs/polaris_defconfig           |   31 +-
 arch/sh/configs/r7780mp_defconfig           |   72 ++--
 arch/sh/configs/r7785rp_defconfig           |   76 ++--
 arch/sh/configs/rsk7201_defconfig           |   31 +-
 arch/sh/configs/rsk7203_defconfig           |   49 ++-
 arch/sh/configs/rts7751r2d1_defconfig       |   56 ++-
 arch/sh/configs/rts7751r2dplus_defconfig    |   56 ++-
 arch/sh/configs/sdk7780_defconfig           |   53 ++-
 arch/sh/configs/sdk7786_defconfig           |  644 +++++++++++++++++++--------
 arch/sh/configs/se7206_defconfig            |   38 +-
 arch/sh/configs/se7343_defconfig            |   53 ++-
 arch/sh/configs/se7619_defconfig            |   22 +-
 arch/sh/configs/se7705_defconfig            |   25 +-
 arch/sh/configs/se7712_defconfig            |   28 +-
 arch/sh/configs/se7721_defconfig            |   40 +-
 arch/sh/configs/se7722_defconfig            |   29 +-
 arch/sh/configs/se7724_defconfig            |   78 ++--
 arch/sh/configs/se7750_defconfig            |   24 +-
 arch/sh/configs/se7751_defconfig            |   25 +-
 arch/sh/configs/se7780_defconfig            |   39 ++-
 arch/sh/configs/sh03_defconfig              |   43 +-
 arch/sh/configs/sh7710voipgw_defconfig      |   29 +-
 arch/sh/configs/sh7724_generic_defconfig    |   58 +--
 arch/sh/configs/sh7763rdp_defconfig         |   45 +--
 arch/sh/configs/sh7770_generic_defconfig    |   54 +--
 arch/sh/configs/sh7785lcr_32bit_defconfig   |   75 ++--
 arch/sh/configs/sh7785lcr_defconfig         |   62 ++-
 arch/sh/configs/shmin_defconfig             |   23 +-
 arch/sh/configs/shx3_defconfig              |   67 ++--
 arch/sh/configs/snapgear_defconfig          |   31 +-
 arch/sh/configs/systemh_defconfig           |   23 +-
 arch/sh/configs/titan_defconfig             |   49 ++-
 arch/sh/configs/ul2_defconfig               |   38 +-
 arch/sh/configs/urquell_defconfig           |   82 +++--
 arch/sh/drivers/pci/pci-sh7751.c            |    5 +-
 arch/sh/include/asm/cache.h                 |    4 -
 arch/sh/include/asm/clkdev.h                |   35 ++
 arch/sh/include/asm/clock.h                 |  161 +-------
 arch/sh/include/asm/dmaengine.h             |   63 +---
 arch/sh/include/asm/hw_breakpoint.h         |    1 -
 arch/sh/include/asm/hwblk.h                 |   12 +-
 arch/sh/include/asm/io_generic.h            |    1 +
 arch/sh/include/asm/irq.h                   |   19 +
 arch/sh/include/asm/kexec.h                 |    8 +
 arch/sh/include/asm/machvec.h               |    2 +
 arch/sh/include/asm/mmzone.h                |    3 +-
 arch/sh/include/asm/page.h                  |   15 +-
 arch/sh/include/asm/processor.h             |    7 +
 arch/sh/include/asm/processor_32.h          |    2 -
 arch/sh/include/asm/setup.h                 |    1 +
 arch/sh/include/asm/siu.h                   |    8 +-
 arch/sh/include/asm/smp-ops.h               |   51 +++
 arch/sh/include/asm/smp.h                   |   40 ++-
 arch/sh/include/cpu-sh4/cpu/dma-register.h  |    5 +-
 arch/sh/include/cpu-sh4/cpu/mmu_context.h   |   18 +-
 arch/sh/include/mach-sdk7786/mach/fpga.h    |    9 +
 arch/sh/kernel/Makefile                     |    2 +-
 arch/sh/kernel/clkdev.c                     |  169 +++++++
 arch/sh/kernel/cpu/Makefile                 |    2 +-
 arch/sh/kernel/cpu/clock-cpg.c              |  312 +------------
 arch/sh/kernel/cpu/clock.c                  |  630 +--------------------------
 arch/sh/kernel/cpu/hwblk.c                  |    5 +
 arch/sh/kernel/cpu/init.c                   |   24 +-
 arch/sh/kernel/cpu/sh2/probe.c              |    5 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c       |    6 -
 arch/sh/kernel/cpu/sh2a/probe.c             |    4 +-
 arch/sh/kernel/cpu/sh2a/setup-mxg.c         |    9 -
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c      |    9 -
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c      |   12 -
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c      |   15 -
 arch/sh/kernel/cpu/sh3/probe.c              |    4 +-
 arch/sh/kernel/cpu/sh3/setup-sh7705.c       |    9 -
 arch/sh/kernel/cpu/sh3/setup-sh770x.c       |    9 -
 arch/sh/kernel/cpu/sh3/setup-sh7710.c       |    9 -
 arch/sh/kernel/cpu/sh3/setup-sh7720.c       |   24 -
 arch/sh/kernel/cpu/sh4/clock-sh4-202.c      |   17 +-
 arch/sh/kernel/cpu/sh4/probe.c              |    4 +-
 arch/sh/kernel/cpu/sh4/setup-sh4-202.c      |    9 -
 arch/sh/kernel/cpu/sh4/setup-sh7750.c       |   15 -
 arch/sh/kernel/cpu/sh4/setup-sh7760.c       |    9 -
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c      |  231 +++++++---
 arch/sh/kernel/cpu/sh4a/clock-sh7366.c      |  210 ++++++---
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c      |  177 +++++---
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c      |  279 +++++++++----
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c      |  295 +++++++++----
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c      |   11 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7763.c      |   12 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7780.c      |   12 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c      |  176 ++++++--
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c      |  223 ++++++++--
 arch/sh/kernel/cpu/sh4a/clock-shx3.c        |   13 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c      |   16 -
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c      |   13 -
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c      |   21 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c      |   27 --
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c      |   81 +---
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c      |    6 -
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c      |   18 -
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c      |   27 --
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c      |   24 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c      |   30 +--
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c      |  157 +++++--
 arch/sh/kernel/cpu/sh4a/setup-shx3.c        |   18 -
 arch/sh/kernel/cpu/sh4a/smp-shx3.c          |   74 +++-
 arch/sh/kernel/cpu/sh5/probe.c              |    4 +-
 arch/sh/kernel/cpu/sh5/setup-sh5.c          |    9 -
 arch/sh/kernel/crash_dump.c                 |   20 +-
 arch/sh/kernel/dwarf.c                      |    1 +
 arch/sh/kernel/head_32.S                    |    7 +-
 arch/sh/kernel/hw_breakpoint.c              |    5 -
 arch/sh/kernel/idle.c                       |    8 +-
 arch/sh/kernel/irq.c                        |   91 +++-
 arch/sh/kernel/localtimer.c                 |    6 +-
 arch/sh/kernel/machine_kexec.c              |   62 +++-
 arch/sh/kernel/machvec.c                    |    1 +
 arch/sh/kernel/process.c                    |    2 +-
 arch/sh/kernel/setup.c                      |  300 +++----------
 arch/sh/kernel/smp.c                        |  160 ++++++-
 arch/sh/kernel/topology.c                   |    6 +-
 arch/sh/kernel/traps_64.c                   |    5 +
 arch/sh/mm/Makefile                         |    9 +-
 arch/sh/mm/cache-shx3.c                     |   44 ++
 arch/sh/mm/cache.c                          |    7 +
 arch/sh/mm/fault_32.c                       |   14 +-
 arch/sh/mm/init.c                           |  173 +++++++-
 arch/sh/mm/numa.c                           |   38 --
 arch/sh/mm/pmb.c                            |    4 +-
 arch/sh/mm/tlb-debugfs.c                    |  179 ++++++++
 arch/sh/mm/tlbflush_64.c                    |   20 +-
 drivers/base/platform.c                     |   20 +
 drivers/clocksource/sh_cmt.c                |   45 +-
 drivers/clocksource/sh_mtu2.c               |   37 +-
 drivers/clocksource/sh_tmu.c                |   41 +-
 drivers/dma/shdma.c                         |   52 ++-
 drivers/dma/shdma.h                         |    4 +-
 drivers/serial/sh-sci.c                     |  189 ++++++---
 drivers/sh/Kconfig                          |   24 +
 drivers/sh/Makefile                         |    2 +
 drivers/sh/clk-cpg.c                        |  298 +++++++++++++
 drivers/sh/clk.c                            |  545 ++++++++++++++++++++++
 drivers/sh/intc.c                           |  333 +++++++++++++--
 include/linux/device.h                      |    4 +
 include/linux/serial_sci.h                  |    4 +-
 include/linux/sh_clk.h                      |  150 +++++++
 include/linux/sh_dma.h                      |  102 +++++
 include/linux/sh_intc.h                     |   26 +-
 173 files changed, 6135 insertions(+), 3755 deletions(-)
 create mode 100644 arch/sh/include/asm/clkdev.h
 create mode 100644 arch/sh/include/asm/smp-ops.h
 create mode 100644 arch/sh/kernel/clkdev.c
 create mode 100644 arch/sh/mm/cache-shx3.c
 create mode 100644 arch/sh/mm/tlb-debugfs.c
 create mode 100644 drivers/sh/Kconfig
 create mode 100644 drivers/sh/clk-cpg.c
 create mode 100644 drivers/sh/clk.c
 create mode 100644 include/linux/sh_clk.h
 create mode 100644 include/linux/sh_dma.h
