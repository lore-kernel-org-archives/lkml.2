Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0JYBup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 21:50:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44010 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0JYBuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 21:50:44 -0400
Date: Mon, 25 Oct 2010 10:50:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.37-rc1
Message-ID: <20101025015021.GA12579@linux-sh.org>
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

Akinobu Mita (1):
      sh: fix uninitialized spinlock

Andrew Murray (1):
      sh: Use __GFP_ZERO for dma_generic_alloc_coherent().

Arnd Bergmann (1):
      sh: kill big kernel lock

Carmelo AMOROSO (1):
      sh: Add syscall entries for non multiplexed socket calls

Guennadi Liakhovetski (5):
      dmaengine: initialise DMA engine before MMC
      sh: move a debug printk() to a more meaningful location in the clock driver
      sh: remove bogus highest / lowest logic from clock rate rounding
      sh: fix a kfree address in clkdev code
      sh: fix clk_get() error handling

Hitoshi Mitake (1):
      sh: SH-2007 board support.

Kulikov Vasiliy (2):
      sh: dma: check return value of create_proc_read_entry()
      sh: boards/mach-x3proto: gpio: fix error handling code

Kuninori Morimoto (2):
      sh: ecovec24: modify tsc2007 platform settings
      sh: clkfwk: modify for_each_frequency end condition

Magnus Damm (6):
      clocksource: sh_cmt: One-off clockevent fix V2
      clocksource: sh_cmt: Rate calculation fix
      i2c: i2c-sh_mobile irq rollback fix
      sh: boot kernel with SR.BL set
      sh: free-without-alloc fix for sh_mobile_lcdcfb
      sh: remove name and id from struct clk

Markus Pietrek (1):
      sound/soc/sh/siu: Fixed undefined dma_length of scatter gather list

Matt Fleming (3):
      sh: Fix typos in PCI initialization message
      sh: Additional register definitions for SH7786 PCIe.
      sh: Set CONFIG_SYSFS_DEPRECATED_V2=n

Nobuhiro Iwamatsu (3):
      sh: Drop dependence for 29bit mode of trigger_address_error()
      sh: Fix address calculation of Initrd
      sh: i2c-sh7760: Replase from ctrl_* to __raw_*

Paul Mundt (73):
      sh: Add kprobe-based event tracer.
      sh: split out ptrace header for _32/_64 variants.
      sh: kprobes SMP support.
      sh: update the FDPIC relocations.
      sh: fix up an off-by-1 in the number of early ioremap fixmaps.
      sh: Fix up PUD trampling in ranged page table init for X2TLB.
      sh: Provide a global TLB flush for U/I-TLB clear.
      sh: wire up fanotify/prlimit64 syscalls.
      sh: fix up fallout from syscall arg constification.
      sh: stub __flush_tlb_global() definition for nommu.
      sh: Support type 1 accesses for SH7786 PCI.
      sh: Fix up SH7786 PCIe PHY initialization.
      sh: reinstate clock framework rate rounding.
      sh: Relax devfn constraints for SH7786 PCIe.
      sh: sh2007/sh7757lcr defconfig reduction.
      sh: Make SH7786 PCIe port reset logic more aggressive.
      sh: Establish a SuperHyway<->PCIe window mapping on SH7786 PCIe.
      sh: Ignore 32-bit windows in 29-bit mode for SH7786 PCIe.
      sh: Properly wire up channel 2's I/O window on SH7786 PCIe.
      sh: Hook up 3rd memory window for all SH7786 PCIe channels.
      sh: Provide a non-multiplexed sys_recvmmsg path.
      Revert "sh: ecovec24: modify tsc2007 platform settings"
      mfd: Fix up section mismatches in SH SDHI.
      usb: Fix up r8a66597-hcd section mismatches.
      sh: pci: Use generic pci_enable_resources() for pcibios_enable_device().
      sh: pci: Toggle configuration accesses on SH7786.
      sh: pci: Give SH7786 PHY some time to settle.
      sh: pci: Move Renesas PCI IDs to a better place.
      sh: pci: Support root complex config accesses on SH7786 PCIe.
      sh: pci: Discard initial PCICONF4/5 settings for SH7786 PCIe.
      sh: pci: Support ports with disabled links on SH7786 PCIe.
      sh: pci: Use I/O accessors consistently in SH7786 PCIe init code.
      sh: pci: clock framework support for SH7786 PCIe.
      sh: pci: Use a generic raw spinlock for PCI config access locking.
      sh: provide generic arch_debugfs_dir.
      sh: Update SH-X3 subtype for clkdev lookups.
      sh: Support userimask for all SH-X3 interrupt controllers.
      sh: Support IRQ balancing for SH-X3 proto cores, too.
      sh: pinmux support for SH-X3 proto CPUs.
      sh: Handle pinmux for SH-X3 proto IRQ/IRL modes.
      sh: Support early IRQ vector map reservation for delayed controllers.
      sh: Allow GPIO chips to register IRQ mappings.
      sh: mach-x3proto: Move the ilsel header to a better place.
      sh: mach-x3proto: Support for baseboard GPIOs.
      sh: mach-x3proto: gpio-keys support.
      sh: mach-x3proto: Improve ILSEL debugging.
      sh: pfc: support pinmux deregistration.
      sh: Drop __initdata for SH-X3 pinmux tables.
      sh: pfc: Fix up BUG() triggered by gpiolib debugfs lookups.
      sh: intc: Implement reverse mapping for IRQs to per-controller IDs.
      sh: intc: Support virtual mappings for IRQ subgroups.
      sh: intc: Handle early lookups of subgroup IRQs.
      sh: intc: Split up the INTC code.
      sh: Wire up INTC subgroup splitting for SH7786 SCIF1.
      sh: intc: Add missing files.
      sh: intc: Fix build with IRQ balancing disabled.
      sh: Fix up the SH-3 build.
      sh: wire up perf alignment and emulation faults.
      sh: perf: Support SH-X3 hardware counters.
      sh: perf: Set up perf_max_events.
      sh: use pr_fmt for clock framework, too.
      sh: mach-sdk7786: Add support for fpga gpios.
      sh: Fix up PMB locking.
      sh: pci: Support slot 4 routing on SDK7786.
      sh: pci: Support secondary FPGA-driven PCIe clocks on SDK7786.
      sh: Provide a generic SRAM pool for tiny memories.
      sh: mach-sdk7786: Add support for the FPGA SRAM.
      sh: pci: Convert to upper/lower_32_bits() helpers.
      sh: clkfwk: support clock remapping.
      sh: clkfwk: Abstract rate rounding helper.
      sh: clkfwk: Add a helper for rate rounding by divisor ranges.
      sh: clkfwk: Fix fault in frequency iterator.
      sh: clkfwk: Shuffle around to match the intc split up.

Phil Edworthy (1):
      sh: Add sh7724 BEU resources

Sam Ravnborg (1):
      sh: fix recursive dependency in Kconfig

Yoshihiro Shimoda (7):
      sh: modify NR_IRQS from 256 to 512
      sh: change PVR of SH7757 for 2nd cut
      sh: fix the id of scif in setup-sh7757
      sh: add some INTC_VECT for setup-sh7757
      sh: modify pinmux for SH7757 2nd cut
      sh: modify clock framework of SH7757
      sh: add sh7757lcr board support

matt mooney (1):
      sh: change to new flag variable

 arch/sh/Kconfig                                    |    6 +-
 arch/sh/boards/Kconfig                             |   18 +
 arch/sh/boards/Makefile                            |    2 +
 arch/sh/boards/board-sh2007.c                      |  133 ++
 arch/sh/boards/board-sh7757lcr.c                   |  374 +++++
 arch/sh/boards/mach-ecovec24/setup.c               |    6 +-
 arch/sh/boards/mach-sdk7786/Makefile               |    5 +-
 arch/sh/boards/mach-sdk7786/gpio.c                 |   49 +
 arch/sh/boards/mach-sdk7786/setup.c                |   54 +-
 arch/sh/boards/mach-sdk7786/sram.c                 |   72 +
 arch/sh/boards/mach-x3proto/Makefile               |    2 +
 arch/sh/boards/mach-x3proto/gpio.c                 |  135 ++
 arch/sh/boards/mach-x3proto/ilsel.c                |   18 +-
 arch/sh/boards/mach-x3proto/setup.c                |  132 ++-
 arch/sh/boot/compressed/head_32.S                  |    4 +-
 arch/sh/cchips/hd6446x/Makefile                    |    2 +-
 arch/sh/configs/ap325rxa_defconfig                 |    1 -
 arch/sh/configs/cayman_defconfig                   |    1 -
 arch/sh/configs/dreamcast_defconfig                |    1 -
 arch/sh/configs/ecovec24-romimage_defconfig        |    1 -
 arch/sh/configs/edosk7760_defconfig                |    1 -
 arch/sh/configs/espt_defconfig                     |    1 -
 arch/sh/configs/hp6xx_defconfig                    |    1 -
 arch/sh/configs/kfr2r09-romimage_defconfig         |    1 -
 arch/sh/configs/kfr2r09_defconfig                  |    1 -
 arch/sh/configs/landisk_defconfig                  |    1 -
 arch/sh/configs/lboxre2_defconfig                  |    1 -
 arch/sh/configs/magicpanelr2_defconfig             |    1 -
 arch/sh/configs/microdev_defconfig                 |    1 -
 arch/sh/configs/migor_defconfig                    |    1 -
 arch/sh/configs/polaris_defconfig                  |    1 -
 arch/sh/configs/r7780mp_defconfig                  |    1 -
 arch/sh/configs/r7785rp_defconfig                  |    1 -
 arch/sh/configs/rts7751r2d1_defconfig              |    1 -
 arch/sh/configs/rts7751r2dplus_defconfig           |    1 -
 arch/sh/configs/sdk7780_defconfig                  |    1 -
 arch/sh/configs/se7343_defconfig                   |    1 -
 arch/sh/configs/se7712_defconfig                   |    1 -
 arch/sh/configs/se7721_defconfig                   |    1 -
 arch/sh/configs/se7722_defconfig                   |    1 -
 arch/sh/configs/se7724_defconfig                   |    1 -
 arch/sh/configs/se7750_defconfig                   |    1 -
 arch/sh/configs/se7751_defconfig                   |    1 -
 arch/sh/configs/se7780_defconfig                   |    1 -
 arch/sh/configs/sh03_defconfig                     |    1 -
 arch/sh/configs/sh2007_defconfig                   |  212 +++
 arch/sh/configs/sh7710voipgw_defconfig             |    1 -
 arch/sh/configs/sh7757lcr_defconfig                |   85 ++
 arch/sh/configs/sh7763rdp_defconfig                |    1 -
 arch/sh/configs/sh7785lcr_defconfig                |    1 -
 arch/sh/configs/shx3_defconfig                     |    1 -
 arch/sh/configs/snapgear_defconfig                 |    1 -
 arch/sh/configs/systemh_defconfig                  |    1 -
 arch/sh/configs/titan_defconfig                    |    1 -
 arch/sh/configs/ul2_defconfig                      |    1 -
 arch/sh/drivers/dma/dma-api.c                      |    4 +-
 arch/sh/drivers/pci/Makefile                       |    1 +
 arch/sh/drivers/pci/fixups-sdk7786.c               |   67 +
 arch/sh/drivers/pci/ops-sh4.c                      |   11 +-
 arch/sh/drivers/pci/ops-sh7786.c                   |   69 +-
 arch/sh/drivers/pci/pci-sh7751.c                   |    2 +-
 arch/sh/drivers/pci/pci-sh7780.c                   |    2 +-
 arch/sh/drivers/pci/pci-sh7780.h                   |    6 -
 arch/sh/drivers/pci/pci.c                          |   43 +-
 arch/sh/drivers/pci/pcie-sh7786.c                  |  251 +++-
 arch/sh/drivers/pci/pcie-sh7786.h                  |   56 +-
 arch/sh/include/asm/Kbuild                         |    2 +
 arch/sh/include/asm/elf.h                          |   27 +-
 arch/sh/include/asm/fixmap.h                       |    4 +-
 arch/sh/include/asm/gpio.h                         |    6 +-
 arch/sh/include/asm/irq.h                          |    2 +-
 arch/sh/include/asm/kprobes.h                      |    1 -
 arch/sh/include/asm/pci.h                          |    2 +
 arch/sh/include/asm/processor_32.h                 |    3 -
 arch/sh/include/asm/processor_64.h                 |    3 -
 arch/sh/include/asm/ptrace.h                       |  169 +--
 arch/sh/include/asm/ptrace_32.h                    |   83 +
 arch/sh/include/asm/ptrace_64.h                    |   20 +
 arch/sh/include/asm/sizes.h                        |    1 +
 arch/sh/include/asm/sram.h                         |   38 +
 arch/sh/include/asm/syscalls_32.h                  |    7 +-
 arch/sh/include/asm/system.h                       |    2 -
 arch/sh/include/asm/system_32.h                    |   15 +-
 arch/sh/include/asm/tlbflush.h                     |    2 +
 arch/sh/include/asm/unistd_32.h                    |   27 +-
 arch/sh/include/asm/unistd_64.h                    |    5 +-
 arch/sh/include/cpu-sh3/cpu/mmu_context.h          |    1 +
 arch/sh/include/cpu-sh4/cpu/freq.h                 |    4 +-
 arch/sh/include/cpu-sh4/cpu/sh7757.h               |  301 ++--
 arch/sh/include/cpu-sh4/cpu/shx3.h                 |   64 +
 arch/sh/include/mach-common/mach/sh2007.h          |  117 ++
 arch/sh/include/mach-sdk7786/mach/fpga.h           |   26 +-
 arch/sh/include/mach-x3proto/mach/hardware.h       |   12 +
 arch/sh/include/{asm => mach-x3proto/mach}/ilsel.h |    0
 arch/sh/kernel/Makefile                            |    8 +-
 arch/sh/kernel/clkdev.c                            |    4 +-
 arch/sh/kernel/cpu/sh4/probe.c                     |    2 +-
 arch/sh/kernel/cpu/sh4a/Makefile                   |    5 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c             |  199 ++--
 arch/sh/kernel/cpu/sh4a/clock-shx3.c               |  225 ++-
 arch/sh/kernel/cpu/sh4a/intc-shx3.c                |   34 +
 arch/sh/kernel/cpu/sh4a/perf_event.c               |   20 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c            | 1582 ++++++++++++--------
 arch/sh/kernel/cpu/sh4a/pinmux-shx3.c              |  587 ++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c             |   66 +
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c             |  222 ++-
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c             |  126 +-
 arch/sh/kernel/cpu/sh4a/setup-shx3.c               |   42 +-
 arch/sh/kernel/head_32.S                           |    2 +-
 arch/sh/kernel/io_trapped.c                        |    2 +-
 arch/sh/kernel/irq.c                               |    2 +
 arch/sh/kernel/kdebugfs.c                          |   16 +
 arch/sh/kernel/kprobes.c                           |  100 +-
 arch/sh/kernel/perf_event.c                        |    1 +
 arch/sh/kernel/ptrace.c                            |   33 +
 arch/sh/kernel/ptrace_32.c                         |   27 +
 arch/sh/kernel/ptrace_64.c                         |   88 +-
 arch/sh/kernel/reboot.c                            |    4 +
 arch/sh/kernel/setup.c                             |   22 +-
 arch/sh/kernel/syscalls_32.S                       |   22 +
 arch/sh/kernel/syscalls_64.S                       |    3 +
 arch/sh/kernel/traps_32.c                          |   29 +-
 arch/sh/kernel/traps_64.c                          |   11 +-
 arch/sh/lib/Makefile                               |    2 +-
 arch/sh/math-emu/math.c                            |    3 +
 arch/sh/mm/Kconfig                                 |    4 +
 arch/sh/mm/Makefile                                |    3 +-
 arch/sh/mm/asids-debugfs.c                         |    2 +-
 arch/sh/mm/cache-debugfs.c                         |   10 +-
 arch/sh/mm/consistent.c                            |    3 +-
 arch/sh/mm/init.c                                  |   52 +-
 arch/sh/mm/nommu.c                                 |    4 +
 arch/sh/mm/pmb.c                                   |   35 +-
 arch/sh/mm/sram.c                                  |   34 +
 arch/sh/mm/tlb-debugfs.c                           |   11 +-
 arch/sh/mm/tlbflush_32.c                           |   16 +
 arch/sh/mm/tlbflush_64.c                           |    5 +
 arch/sh/tools/mach-types                           |    2 +
 drivers/Makefile                                   |    2 +-
 drivers/clocksource/sh_cmt.c                       |   12 +-
 drivers/i2c/busses/i2c-sh7760.c                    |    4 +-
 drivers/i2c/busses/i2c-sh_mobile.c                 |   23 +-
 drivers/mfd/sh_mobile_sdhi.c                       |    2 +-
 drivers/serial/sh-sci.h                            |   17 +-
 drivers/sh/Kconfig                                 |   25 +-
 drivers/sh/Makefile                                |    7 +-
 drivers/sh/clk/Makefile                            |    3 +
 drivers/sh/{clk.c => clk/core.c}                   |  203 +++-
 drivers/sh/{clk-cpg.c => clk/cpg.c}                |   11 +-
 drivers/sh/intc.c                                  | 1390 -----------------
 drivers/sh/intc/Kconfig                            |   35 +
 drivers/sh/intc/Makefile                           |    5 +
 drivers/sh/intc/access.c                           |  237 +++
 drivers/sh/intc/balancing.c                        |   97 ++
 drivers/sh/intc/chip.c                             |  215 +++
 drivers/sh/intc/core.c                             |  469 ++++++
 drivers/sh/intc/dynamic.c                          |  135 ++
 drivers/sh/intc/handle.c                           |  307 ++++
 drivers/sh/intc/internals.h                        |  186 +++
 drivers/sh/intc/userimask.c                        |   83 +
 drivers/sh/intc/virq-debugfs.c                     |   64 +
 drivers/sh/intc/virq.c                             |  255 ++++
 drivers/sh/pfc.c                                   |   17 +-
 drivers/usb/host/r8a66597-hcd.c                    |    4 +-
 drivers/video/sh_mobile_lcdcfb.c                   |    6 +-
 include/linux/pci_ids.h                            |    7 +
 include/linux/sh_clk.h                             |   17 +-
 include/linux/sh_intc.h                            |   16 +-
 include/linux/sh_pfc.h                             |    1 +
 sound/soc/sh/siu_pcm.c                             |    2 +
 170 files changed, 7270 insertions(+), 3059 deletions(-)
 create mode 100644 arch/sh/boards/board-sh2007.c
 create mode 100644 arch/sh/boards/board-sh7757lcr.c
 create mode 100644 arch/sh/boards/mach-sdk7786/gpio.c
 create mode 100644 arch/sh/boards/mach-sdk7786/sram.c
 create mode 100644 arch/sh/boards/mach-x3proto/gpio.c
 create mode 100644 arch/sh/configs/sh2007_defconfig
 create mode 100644 arch/sh/configs/sh7757lcr_defconfig
 create mode 100644 arch/sh/drivers/pci/fixups-sdk7786.c
 create mode 100644 arch/sh/include/asm/ptrace_32.h
 create mode 100644 arch/sh/include/asm/ptrace_64.h
 create mode 100644 arch/sh/include/asm/sram.h
 create mode 100644 arch/sh/include/cpu-sh4/cpu/shx3.h
 create mode 100644 arch/sh/include/mach-common/mach/sh2007.h
 create mode 100644 arch/sh/include/mach-x3proto/mach/hardware.h
 rename arch/sh/include/{asm => mach-x3proto/mach}/ilsel.h (100%)
 create mode 100644 arch/sh/kernel/cpu/sh4a/intc-shx3.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/pinmux-shx3.c
 create mode 100644 arch/sh/kernel/kdebugfs.c
 create mode 100644 arch/sh/kernel/ptrace.c
 create mode 100644 arch/sh/mm/sram.c
 create mode 100644 drivers/sh/clk/Makefile
 rename drivers/sh/{clk.c => clk/core.c} (74%)
 rename drivers/sh/{clk-cpg.c => clk/cpg.c} (96%)
 delete mode 100644 drivers/sh/intc.c
 create mode 100644 drivers/sh/intc/Kconfig
 create mode 100644 drivers/sh/intc/Makefile
 create mode 100644 drivers/sh/intc/access.c
 create mode 100644 drivers/sh/intc/balancing.c
 create mode 100644 drivers/sh/intc/chip.c
 create mode 100644 drivers/sh/intc/core.c
 create mode 100644 drivers/sh/intc/dynamic.c
 create mode 100644 drivers/sh/intc/handle.c
 create mode 100644 drivers/sh/intc/internals.h
 create mode 100644 drivers/sh/intc/userimask.c
 create mode 100644 drivers/sh/intc/virq-debugfs.c
 create mode 100644 drivers/sh/intc/virq.c
