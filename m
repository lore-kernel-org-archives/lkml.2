Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2EVMNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:13:21 -0400
Received: from linux-sh.org ([111.68.239.195]:39928 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2EVMNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:13:19 -0400
Date: Tue, 22 May 2012 21:13:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 3.5-rc1
Message-ID: <20120522121313.GG22483@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 42ea7d7f2a7356962022cdd124d9043c488ca5e2:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2012-05-17 16:52:29 -0700)

are available in the git repository at:

  git://github.com/pmundt/linux-sh.git tags/sh-for-linus

for you to fetch changes up to 5f19f14fed7786652b9617c633db101d26a42251:

  sh: intc: Kill off special reservation interface. (2012-05-22 19:07:55 +0900)

----------------------------------------------------------------
SuperH updates for 3.5-rc1 merge window

- New CPUs: SH7734 (SH-4A), SH7264 and SH7269 (SH-2A)
- New boards: RSK2+SH7264, RSK2+SH7269
- Unbreaking kgdb for SMP
- Consolidation of _32/_64 page fault handling.
- watchdog and legacy DMA chainsawing, part 1
- Conversion to evt2irq() hwirq lookup, to support relocation
  of vectored IRQs for irqdomains.

----------------------------------------------------------------
Filippo Arcidiacono (1):
      sh: initial stack protector support.

Kautuk Consul (1):
      sh/mm/fault_32.c: Port OOM changes to do_page_fault

Nobuhiro Iwamatsu (7):
      sh: sh4a: Change the specification method of IRQ to SCIx_IRQ_MUXED
      sh: sh4: Change the specification method of IRQ to SCIx_IRQ_MUXED
      sh: sh3: Change the specification method of IRQ to SCIx_IRQ_MUXED
      sh: sh2: Change the specification method of IRQ to SCIx_IRQ_MUXED
      sh: Add initial support for SH7734 CPU subtype
      sh: Add support pinmux for SH7734
      sh: Fix mistake of the member variable of plat_sci_port for SH7343

Paul Mundt (85):
      sh: kgdb: Fix up basic SMP support.
      sh: kgdb: Individual register get/set support.
      sh: kgdb: Fill out sleeping_thread_to_gdb_regs() state.
      sh: kgdb: Fix up NULL pointer deref by kgdb_nmicallback.
      sh: kgdb: Unset CACHE_FLUSH_IS_SAFE for SMP.
      sh: clkfwk: Support variable size accesses for MSTP clocks.
      sh64: Port OOM changes to do_page_fault
      sh64: Kill off dead page fault debug cruft.
      MAINTAINERS: Update git URL for SH.
      sh: clkfwk: Support variable size accesses for div4/div6 clocks.
      Merge branch 'common/clkfwk' into sh-latest
      Merge branch 'sh/kgdb' into sh-latest
      Merge branches 'sh/st-integration' and 'sh/stackprotector' into sh-latest
      sh64: Kill off unused trap_no/error_code from thread_struct.
      Merge branch 'sh/rsk-updates' into sh-latest
      sh: Provide stubbed I/O routines for NO_IOPORT case.
      watchdog: shwdt: Migrate from reboot notifier to platform shutdown.
      watchdog: shwdt: Conversion to watchdog core.
      watchdog: shwdt: Migrate to per-device locking.
      watchdog: shwdt: Trim down private data structure.
      watchdog: shwdt: Basic clock framework support.
      watchdog: shwdt: Preliminary runtime PM support.
      watchdog: shwdt: Use finer grained clock control.
      Merge branches 'sh/wdt' and 'sh/rsk-updates' into sh-latest
      sh: Fix up comment noise in sh7269 pinmux code.
      sh: Tidy up and generalize page fault error paths.
      sh64: Provide EXPEVT helper.
      sh: Support thread fault code encoding.
      sh64: Utilize thread fault code encoding.
      sh: Ensure fixmap and store queue space can co-exist.
      sh64: Kill off unused fixed I/O mapping window.
      sh: Enable shared page fault handler for _32/_64.
      sh64: Migrate to __update_tlb() API.
      sh64: Invert page fault fast-path error path values.
      sh64: Fix up caller-save register settings for fast-path.
      sh64: Tidy up and consolidate the TLB miss fast path.
      sh64: Set additional fault code values.
      sh: sh7786 evt2irq migration.
      sh: sh7343 evt2irq migration.
      sh: sh7366 evt2irq migration.
      sh: sh7722 evt2irq migration.
      sh: sh7723 evt2irq migration.
      sh: sh7724 evt2irq migration.
      sh: sh7757 evt2irq migration.
      sh: sh7763 evt2irq migration.
      sh: sh7770 evt2irq migration.
      sh: sh7780 evt2irq migration.
      sh: sh7785 evt2irq migration.
      sh: sh-x3 evt2irq migration.
      sh: sh4-202 evt2irq migration.
      sh: sh7750 evt2irq migration.
      sh: sh7760 evt2irq migration.
      sh: sh7705 evt2irq migration.
      sh: sh7706/sh7707/sh7709/sh7709 evt2irq migration.
      sh: sh7710/sh7712 evt2irq migration.
      sh: sh7720 evt2irq migration.
      sh: edosk7705 evt2irq migration.
      sh: edosk7760 evt2irq migration.
      sh: espt evt2irq migration.
      sh: magicpanelr2 evt2irq migration.
      sh: sh7757lcr evt2irq migration.
      sh: mach-se evt2irq migration.
      sh: hp6xx evt2irq migration.
      sh: sh7785lcr evt2irq migration.
      sh: urquell evt2irq migration.
      sh: ap325rxa evt2irq migration.
      sh: ecovec24 evt2irq migration.
      sh: kfr2r09 evt2irq migration.
      sh: landisk evt2irq migration.
      sh: migor evt2irq migration.
      sh: sdk7780 evt2irq migration.
      sh: sh7763rdp evt2irq migration.
      sh: cpu dma evt2irq migration.
      sh: legacy PCI evt2irq migration.
      Merge branch 'sh/evt2irq-migration' into sh-latest
      serial: sh-sci: Fix for port types without BRI interrupts.
      Revert "sh: Ensure fixmap and store queue space can co-exist."
      sh64: Fix up vmalloc fault range check.
      sh: Move sh4a dma header from cpu-sh4 to cpu-sh4a.
      sh: Tidy up some of the cpu legacy dma header mess.
      sh: Kill off MAX_DMA_ADDRESS leftovers.
      sh: dma: More legacy cpu dma chainsawing.
      sh: Kill off machvec IRQ hinting.
      sh: Enable PIO API for hp6xx and se770x.
      sh: intc: Kill off special reservation interface.

Phil Edworthy (6):
      sh: Add sh7264 device
      sh: Add RSK2+SH7264 board
      sh: Add pinmux for sh7264
      sh: Add sh7269 device
      sh: Add RSK2+SH7269 board
      sh: Add pinmux for sh7269

Shimoda, Yoshihiro (2):
      serial: sh-sci: modify sci_break_ctl()
      serial: sh-sci: Update break_ctl handling for all SCSPTR-capable regtypes.

Stuart Menefy (2):
      sh: Improve oops error reporting
      sh: Move board specific options into the Board support menu

 MAINTAINERS                                        |    2 +-
 arch/sh/Kconfig                                    |   45 +-
 arch/sh/Makefile                                   |    4 +
 arch/sh/boards/Kconfig                             |    7 +-
 arch/sh/boards/board-edosk7705.c                   |    4 +-
 arch/sh/boards/board-edosk7760.c                   |   16 +-
 arch/sh/boards/board-espt.c                        |    3 +-
 arch/sh/boards/board-magicpanelr2.c                |   27 +-
 arch/sh/boards/board-polaris.c                     |    1 -
 arch/sh/boards/board-secureedge5410.c              |    1 -
 arch/sh/boards/board-sh7757lcr.c                   |   27 +-
 arch/sh/boards/board-sh7785lcr.c                   |   15 +-
 arch/sh/boards/board-urquell.c                     |    3 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |   15 +-
 arch/sh/boards/mach-cayman/setup.c                 |    1 -
 arch/sh/boards/mach-ecovec24/setup.c               |   44 +-
 arch/sh/boards/mach-hp6xx/setup.c                  |    5 +-
 arch/sh/boards/mach-kfr2r09/setup.c                |   15 +-
 arch/sh/boards/mach-lboxre2/setup.c                |    1 -
 arch/sh/boards/mach-microdev/setup.c               |    1 -
 arch/sh/boards/mach-migor/setup.c                  |   13 +-
 arch/sh/boards/mach-rsk/Kconfig                    |   10 +
 arch/sh/boards/mach-rsk/Makefile                   |    2 +
 arch/sh/boards/mach-rsk/devices-rsk7264.c          |   58 +
 arch/sh/boards/mach-rsk/devices-rsk7269.c          |   60 +
 arch/sh/boards/mach-sdk7780/setup.c                |    1 -
 arch/sh/boards/mach-se/7206/setup.c                |    1 -
 arch/sh/boards/mach-se/770x/setup.c                |   11 -
 arch/sh/boards/mach-se/7721/setup.c                |    1 -
 arch/sh/boards/mach-se/7722/setup.c                |    3 +-
 arch/sh/boards/mach-se/7724/setup.c                |   32 +-
 arch/sh/boards/mach-se/7751/setup.c                |    1 -
 arch/sh/boards/mach-se/7780/setup.c                |    1 -
 arch/sh/boards/mach-se/board-se7619.c              |    1 -
 arch/sh/boards/mach-sh03/setup.c                   |    1 -
 arch/sh/boards/mach-sh7763rdp/setup.c              |    6 +-
 arch/sh/configs/rsk7264_defconfig                  |   80 +
 arch/sh/configs/rsk7269_defconfig                  |   65 +
 arch/sh/drivers/dma/Kconfig                        |   17 -
 arch/sh/drivers/dma/dma-sh.c                       |  290 +-
 arch/sh/drivers/dma/dma-sysfs.c                    |    2 +-
 arch/sh/drivers/pci/fixups-landisk.c               |    3 +-
 arch/sh/drivers/pci/fixups-r7780rp.c               |    7 +-
 arch/sh/drivers/pci/fixups-sdk7780.c               |   18 +-
 arch/sh/drivers/pci/fixups-se7751.c                |    5 +-
 arch/sh/drivers/pci/fixups-sh03.c                  |   19 +-
 arch/sh/drivers/pci/fixups-snapgear.c              |   11 +-
 arch/sh/drivers/pci/pcie-sh7786.c                  |    3 +-
 arch/sh/include/asm/dma-sh.h                       |   87 -
 arch/sh/include/asm/dma.h                          |    9 -
 arch/sh/include/asm/fixmap.h                       |    2 +-
 arch/sh/include/asm/i2c-sh7760.h                   |    2 -
 arch/sh/include/asm/io.h                           |    5 +
 arch/sh/include/asm/io_noioport.h                  |   41 +
 arch/sh/include/asm/irq.h                          |   13 +-
 arch/sh/include/asm/kdebug.h                       |    2 +
 arch/sh/include/asm/kgdb.h                         |   30 +-
 arch/sh/include/asm/machvec.h                      |    1 -
 arch/sh/include/asm/pgtable_64.h                   |    3 -
 arch/sh/include/asm/processor.h                    |    5 +-
 arch/sh/include/asm/processor_64.h                 |    3 -
 arch/sh/include/asm/stackprotector.h               |   27 +
 arch/sh/include/asm/thread_info.h                  |   46 +-
 arch/sh/include/asm/traps_64.h                     |   14 +
 arch/sh/include/cpu-sh2/cpu/dma.h                  |   23 -
 arch/sh/include/cpu-sh2a/cpu/dma.h                 |    1 -
 arch/sh/include/cpu-sh2a/cpu/sh7264.h              |  176 ++
 arch/sh/include/cpu-sh2a/cpu/sh7269.h              |  201 ++
 arch/sh/include/cpu-sh3/cpu/dma.h                  |   13 +-
 arch/sh/include/cpu-sh4/cpu/dma-sh4a.h             |   83 -
 arch/sh/include/cpu-sh4/cpu/dma.h                  |   25 +-
 arch/sh/include/cpu-sh4/cpu/freq.h                 |    5 +
 arch/sh/include/cpu-sh4/cpu/sh7734.h               |  306 +++
 arch/sh/include/cpu-sh4a/cpu/dma.h                 |   72 +
 arch/sh/include/cpu-sh5/cpu/dma.h                  |    6 -
 arch/sh/include/mach-common/mach/hp6xx.h           |    7 +-
 arch/sh/include/mach-common/mach/lboxre2.h         |   13 +-
 arch/sh/include/mach-common/mach/sdk7780.h         |    5 +-
 arch/sh/include/mach-common/mach/titan.h           |   12 +-
 arch/sh/include/mach-dreamcast/mach/dma.h          |    2 -
 arch/sh/include/mach-landisk/mach/iodata_landisk.h |   19 +-
 arch/sh/include/mach-se/mach/se.h                  |   19 +-
 arch/sh/include/mach-se/mach/se7343.h              |    9 +-
 arch/sh/include/mach-se/mach/se7721.h              |    6 +-
 arch/sh/include/mach-se/mach/se7722.h              |    9 +-
 arch/sh/include/mach-se/mach/se7724.h              |    7 +-
 arch/sh/include/mach-se/mach/se7751.h              |    3 +-
 arch/sh/include/mach-se/mach/se7780.h              |    7 +-
 arch/sh/kernel/cpu/proc.c                          |    4 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c              |    6 +-
 arch/sh/kernel/cpu/sh2a/Makefile                   |    4 +
 arch/sh/kernel/cpu/sh2a/clock-sh7264.c             |  153 ++
 arch/sh/kernel/cpu/sh2a/clock-sh7269.c             |  184 ++
 arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c            | 2136 +++++++++++++++
 arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c            | 2800 ++++++++++++++++++++
 arch/sh/kernel/cpu/sh2a/probe.c                    |    6 +
 arch/sh/kernel/cpu/sh2a/setup-mxg.c                |    2 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c             |   16 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c             |    8 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c             |    8 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7264.c             |  606 +++++
 arch/sh/kernel/cpu/sh2a/setup-sh7269.c             |  615 +++++
 arch/sh/kernel/cpu/sh3/entry.S                     |   11 +-
 arch/sh/kernel/cpu/sh3/setup-sh7705.c              |   13 +-
 arch/sh/kernel/cpu/sh3/setup-sh770x.c              |   15 +-
 arch/sh/kernel/cpu/sh3/setup-sh7710.c              |   13 +-
 arch/sh/kernel/cpu/sh3/setup-sh7720.c              |   32 +-
 arch/sh/kernel/cpu/sh4/probe.c                     |    3 +
 arch/sh/kernel/cpu/sh4/setup-sh4-202.c             |   12 +-
 arch/sh/kernel/cpu/sh4/setup-sh7750.c              |   17 +-
 arch/sh/kernel/cpu/sh4/setup-sh7760.c              |   26 +-
 arch/sh/kernel/cpu/sh4a/Makefile                   |    3 +
 arch/sh/kernel/cpu/sh4a/clock-sh7734.c             |  266 ++
 arch/sh/kernel/cpu/sh4a/pinmux-sh7734.c            | 2497 +++++++++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c             |   31 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c             |   23 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c             |   47 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c             |   47 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c             |   77 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7734.c             |  800 ++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c             |   90 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c             |   30 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c             |   39 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c             |   37 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c             |   43 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c             |   47 +-
 arch/sh/kernel/cpu/sh4a/setup-shx3.c               |   31 +-
 arch/sh/kernel/cpu/sh5/entry.S                     |   22 +-
 arch/sh/kernel/cpu/sh5/fpu.c                       |    3 -
 arch/sh/kernel/irq.c                               |    6 +-
 arch/sh/kernel/kgdb.c                              |  105 +-
 arch/sh/kernel/machvec.c                           |    3 -
 arch/sh/kernel/process.c                           |    7 +
 arch/sh/kernel/process_32.c                        |    5 +
 arch/sh/kernel/traps_64.c                          |    2 -
 arch/sh/mm/Makefile                                |    8 +-
 arch/sh/mm/fault.c                                 |  514 ++++
 arch/sh/mm/fault_32.c                              |  374 ---
 arch/sh/mm/fault_64.c                              |  265 --
 arch/sh/mm/tlb-sh5.c                               |   40 +
 arch/sh/mm/tlbex_32.c                              |   78 +
 arch/sh/mm/tlbex_64.c                              |  166 ++
 arch/sh/mm/tlbflush_64.c                           |  294 +-
 arch/sh/tools/mach-types                           |    2 +
 drivers/sh/clk/cpg.c                               |   77 +-
 drivers/sh/intc/dynamic.c                          |    8 -
 drivers/tty/serial/sh-sci.c                        |   49 +-
 drivers/watchdog/Kconfig                           |    1 +
 drivers/watchdog/shwdt.c                           |  306 +--
 include/linux/serial_sci.h                         |    2 +
 include/linux/sh_clk.h                             |   34 +-
 include/linux/sh_intc.h                            |    1 -
 152 files changed, 13243 insertions(+), 2205 deletions(-)
 create mode 100644 arch/sh/boards/mach-rsk/devices-rsk7264.c
 create mode 100644 arch/sh/boards/mach-rsk/devices-rsk7269.c
 create mode 100644 arch/sh/configs/rsk7264_defconfig
 create mode 100644 arch/sh/configs/rsk7269_defconfig
 delete mode 100644 arch/sh/include/asm/dma-sh.h
 create mode 100644 arch/sh/include/asm/io_noioport.h
 create mode 100644 arch/sh/include/asm/stackprotector.h
 delete mode 100644 arch/sh/include/cpu-sh2/cpu/dma.h
 delete mode 100644 arch/sh/include/cpu-sh2a/cpu/dma.h
 create mode 100644 arch/sh/include/cpu-sh2a/cpu/sh7264.h
 create mode 100644 arch/sh/include/cpu-sh2a/cpu/sh7269.h
 delete mode 100644 arch/sh/include/cpu-sh4/cpu/dma-sh4a.h
 create mode 100644 arch/sh/include/cpu-sh4/cpu/sh7734.h
 create mode 100644 arch/sh/include/cpu-sh4a/cpu/dma.h
 delete mode 100644 arch/sh/include/cpu-sh5/cpu/dma.h
 create mode 100644 arch/sh/kernel/cpu/sh2a/clock-sh7264.c
 create mode 100644 arch/sh/kernel/cpu/sh2a/clock-sh7269.c
 create mode 100644 arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c
 create mode 100644 arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c
 create mode 100644 arch/sh/kernel/cpu/sh2a/setup-sh7264.c
 create mode 100644 arch/sh/kernel/cpu/sh2a/setup-sh7269.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/clock-sh7734.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/pinmux-sh7734.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/setup-sh7734.c
 create mode 100644 arch/sh/mm/fault.c
 delete mode 100644 arch/sh/mm/fault_32.c
 delete mode 100644 arch/sh/mm/fault_64.c
 create mode 100644 arch/sh/mm/tlbex_32.c
 create mode 100644 arch/sh/mm/tlbex_64.c
