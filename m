Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1CRFox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 01:44:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:34090 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab1CRFos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 01:44:48 -0400
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Mar 2011 16:44:32 +1100
Message-ID: <1300427072.22236.1277.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are the changes for this merge window for powerpc. One highlight
is irq data conversion so we can get rid of the legacy stuff. The new
Dynamic DMA windows for pSeries should also improve performances for
some devices nicely on more recent machines/firmwares. Plus a little
pack of embedded things.

Cheers,
Ben.

The following changes since commit 08351fc6a75731226e1112fc7254542bd3a2912e:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2011-03-17 19:34:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Anatolij Gustschin (1):
      powerpc/mpc8xxx_gpio: simplify searching for 'fsl, qoriq-gpio' compatiable

Anton Blanchard (1):
      powerpc: Add pgprot_writecombine

Benjamin Herrenschmidt (2):
      powerpc/pseries: Reduce HVCS driver insanity
      Merge remote branch 'jwb/next' into next

Dave Kleikamp (2):
      powerpc/476: define specific cpu table entry DD2 core
      powerpc/476: Workaround for PLB6 hang

Grant Likely (1):
      powerpc/macintosh: Fix __devexit annotation in rack-meter.c

Holger Brunck (3):
      powerpc/83xx: rename and update kmeter1
      powerpc/82xx: rename and update mgcoge board support
      powerpc/8xx: remove obsolete mgsuvd board

Jim Keniston (2):
      powerpc/nvram: Generalize code for OS partitions in NVRAM
      powerpc/pseries/nvram: Capture oops/panic reports in ibm, oops-log partition

Julia Lawall (1):
      drivers/serial/ucc_uart.c: Add of_node_put to avoid memory leak

Justin Mattock (1):
      powerpc/eeh: Remove one to many l's in the word.

Kumar Gala (1):
      powerpc/85xx: Fix writing to spin table 'cpu-release-addr' on ppc64e

Lennert Buytenhek (28):
      powerpc: mpic irq_data conversion.
      powerpc: platforms/512x irq_data conversion.
      powerpc: platforms/52xx irq_data conversion.
      powerpc: platforms/82xx irq_data conversion.
      powerpc: platforms/85xx irq_data conversion.
      powerpc: platforms/86xx irq_data conversion.
      powerpc: platforms/8xx irq_data conversion.
      powerpc: platforms/cell irq_data conversion.
      powerpc: platforms/chrp irq_data conversion.
      powerpc: platforms/embedded6xx irq_data conversion.
      powerpc: platforms/iseries irq_data conversion.
      powerpc: platforms/powermac irq_data conversion.
      powerpc: platforms/ps3 irq_data conversion.
      powerpc: platforms/pseries irq_data conversion.
      powerpc: sysdev/cpm1 irq_data conversion.
      powerpc: sysdev/cpm2_pic irq_data conversion.
      powerpc: sysdev/fsl_msi irq_data conversion.
      powerpc: sysdev/i8259 irq_data conversion.
      powerpc: sysdev/ipic irq_data conversion.
      powerpc: sysdev/mpc8xx_pic irq_data conversion.
      powerpc: sysdev/mpc8xxx_gpio irq_data conversion.
      powerpc: sysdev/mv64x60_pic irq_data conversion.
      powerpc: sysdev/qe_lib/qe_ic irq_data conversion.
      powerpc: sysdev/tsi108_pci irq_data conversion.
      powerpc: sysdev/uic irq_data conversion.
      powerpc: sysdev/xilinx_intc irq_data conversion.
      powerpc: core irq_data conversion.
      powerpc: Enable GENERIC_HARDIRQS_NO_DEPRECATED.

Liu Yu (1):
      powerpc/85xx: Workaroudn e500 CPU erratum A005

Nicolas Kaiser (1):
      powerpc/mv64x60: Suspected typo in assignment

Nishanth Aravamudan (2):
      powerpc/pseries: Add support for dynamic dma windows
      powerpc/pseries: Disable MSI using new interface if possible

Paul E. McKenney (1):
      powerpc: Mask smp_processor_id() false positive

Prabhakar Kushwaha (1):
      powerpc/fsl_pci: Add support for FSL PCIe controllers v2.x

Prarit Bhargava (1):
      powerpc/pseries: Cleanup use of notifier_from_errno()

Rupjyoti Sarmah (1):
      powerpc/44x: PHY fixup for USB on canyonlands board

Scott Wood (2):
      powerpc: Fix memory limits when starting at a non-zero address
      powerpc/fsl_msi: Handle msi-available-ranges better

Shan Hai (1):
      powerpc/85xx: Fix SPE float to integer conversion failure

Stuart Yoder (1):
      powerpc/fsl: define binding for fsl mpic interrupt controllers

Thomas Gleixner (2):
      powerpc: Use ARCH_IRQ_INIT_FLAGS
      powerpc: Use new irq allocator

Tirumala Marri (1):
      powerpc/44x: Add USB DWC DTS entry to Canyonlands board

Tseng-Hui (Frank) Lin (1):
      powerpc: Cleanup definition of the PID register

Vasiliy Kulikov (1):
      powerpc/85xx: Fix signedness bug in cache-sram

Vivek Mahajan (1):
      powerpc/fsl: 85xx: document cache sram bindings

Xulei (2):
      ATA: Add FSL sata v2 controller support
      powerpc/85xx: Update sata controller compatible for p1022ds board

 .../devicetree/bindings/powerpc/fsl/cache_sram.txt |   20 +
 .../devicetree/bindings/powerpc/fsl/mpic.txt       |  253 +++++++--
 .../devicetree/bindings/powerpc/fsl/msi-pic.txt    |    9 +-
 Documentation/kernel-parameters.txt                |    4 +
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/boot/dts/canyonlands.dts              |   24 +
 arch/powerpc/boot/dts/kmeter1.dts                  |   69 ++--
 arch/powerpc/boot/dts/mgcoge.dts                   |   47 +-
 arch/powerpc/boot/dts/mgsuvd.dts                   |  163 ------
 arch/powerpc/boot/dts/p1022ds.dts                  |    4 +-
 arch/powerpc/configs/83xx/kmeter1_defconfig        |    7 +-
 arch/powerpc/configs/mgcoge_defconfig              |    9 +-
 arch/powerpc/configs/mgsuvd_defconfig              |   81 ---
 arch/powerpc/include/asm/cputable.h                |    3 +-
 arch/powerpc/include/asm/hw_irq.h                  |    2 +
 arch/powerpc/include/asm/mpic.h                    |    6 +-
 arch/powerpc/include/asm/nvram.h                   |    3 +-
 arch/powerpc/include/asm/pgtable.h                 |    1 +
 arch/powerpc/include/asm/qe_ic.h                   |   19 +-
 arch/powerpc/include/asm/reg.h                     |   12 +
 arch/powerpc/include/asm/reg_booke.h               |    3 -
 arch/powerpc/kernel/cputable.c                     |   22 +-
 arch/powerpc/kernel/irq.c                          |   55 +-
 arch/powerpc/kernel/machine_kexec.c                |   21 +-
 arch/powerpc/kernel/nvram_64.c                     |   31 +-
 arch/powerpc/kernel/prom.c                         |    2 +-
 arch/powerpc/kernel/rtasd.c                        |    3 +-
 arch/powerpc/math-emu/math_efp.c                   |   65 ++-
 arch/powerpc/mm/init_32.c                          |    2 +-
 arch/powerpc/mm/tlb_nohash_low.S                   |   35 ++
 arch/powerpc/platforms/44x/44x.h                   |    4 +
 arch/powerpc/platforms/44x/Kconfig                 |    1 -
 arch/powerpc/platforms/44x/Makefile                |    1 +
 arch/powerpc/platforms/44x/canyonlands.c           |  134 +++++
 arch/powerpc/platforms/44x/ppc44x_simple.c         |    1 -
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c     |   14 +-
 arch/powerpc/platforms/52xx/media5200.c            |   21 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c          |   26 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c          |   80 ++--
 arch/powerpc/platforms/82xx/Makefile               |    2 +-
 arch/powerpc/platforms/82xx/{mgcoge.c => km82xx.c} |   62 ++-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c       |   27 +-
 arch/powerpc/platforms/83xx/Makefile               |    2 +-
 .../powerpc/platforms/83xx/{kmeter1.c => km83xx.c} |   46 +-
 arch/powerpc/platforms/85xx/ksi8560.c              |    3 +-
 arch/powerpc/platforms/85xx/mpc85xx_ads.c          |    3 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |    3 +-
 arch/powerpc/platforms/85xx/sbc8560.c              |    3 +-
 arch/powerpc/platforms/85xx/smp.c                  |    6 +-
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c    |   40 +-
 arch/powerpc/platforms/85xx/stx_gp3.c              |    3 +-
 arch/powerpc/platforms/85xx/tqm85xx.c              |    3 +-
 arch/powerpc/platforms/86xx/gef_pic.c              |   22 +-
 arch/powerpc/platforms/86xx/pic.c                  |    5 +-
 arch/powerpc/platforms/8xx/Kconfig                 |    6 -
 arch/powerpc/platforms/8xx/Makefile                |    1 -
 arch/powerpc/platforms/8xx/m8xx_setup.c            |    9 +-
 arch/powerpc/platforms/8xx/mgsuvd.c                |   92 ---
 arch/powerpc/platforms/cell/axon_msi.c             |    3 +-
 arch/powerpc/platforms/cell/beat_interrupt.c       |   36 +-
 arch/powerpc/platforms/cell/interrupt.c            |   30 +-
 arch/powerpc/platforms/cell/setup.c                |    6 +-
 arch/powerpc/platforms/cell/spider-pic.c           |   43 +-
 arch/powerpc/platforms/chrp/setup.c                |    5 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c   |   32 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c      |   41 +-
 arch/powerpc/platforms/iseries/irq.c               |   43 +-
 arch/powerpc/platforms/pasemi/setup.c              |    4 +-
 arch/powerpc/platforms/powermac/pic.c              |   48 +-
 arch/powerpc/platforms/ps3/interrupt.c             |   40 +-
 arch/powerpc/platforms/pseries/cmm.c               |   14 +-
 arch/powerpc/platforms/pseries/eeh.c               |    2 +-
 arch/powerpc/platforms/pseries/iommu.c             |  587 ++++++++++++++++++++
 arch/powerpc/platforms/pseries/msi.c               |   14 +-
 arch/powerpc/platforms/pseries/nvram.c             |  255 +++++++--
 arch/powerpc/platforms/pseries/setup.c             |    5 +-
 arch/powerpc/platforms/pseries/xics.c              |   89 ++--
 arch/powerpc/sysdev/cpm1.c                         |   18 +-
 arch/powerpc/sysdev/cpm2_pic.c                     |   32 +-
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c              |    4 +-
 arch/powerpc/sysdev/fsl_msi.c                      |  111 +++--
 arch/powerpc/sysdev/fsl_pci.c                      |   15 +-
 arch/powerpc/sysdev/fsl_pci.h                      |   17 +-
 arch/powerpc/sysdev/i8259.c                        |   42 +-
 arch/powerpc/sysdev/ipic.c                         |   54 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                   |   32 +-
 arch/powerpc/sysdev/mpc8xxx_gpio.c                 |   46 +-
 arch/powerpc/sysdev/mpic.c                         |  137 +++---
 arch/powerpc/sysdev/mpic.h                         |    5 +-
 arch/powerpc/sysdev/mpic_pasemi_msi.c              |   18 +-
 arch/powerpc/sysdev/mpic_u3msi.c                   |   18 +-
 arch/powerpc/sysdev/mv64x60_dev.c                  |    2 +-
 arch/powerpc/sysdev/mv64x60_pic.c                  |   46 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |   25 +-
 arch/powerpc/sysdev/tsi108_pci.c                   |   41 +-
 arch/powerpc/sysdev/uic.c                          |   59 +-
 arch/powerpc/sysdev/xilinx_intc.c                  |   48 +-
 drivers/ata/sata_fsl.c                             |   25 +-
 drivers/macintosh/rack-meter.c                     |    2 +-
 drivers/tty/hvc/hvcs.c                             |   74 ++-
 drivers/tty/serial/ucc_uart.c                      |   67 ++--
 101 files changed, 2437 insertions(+), 1394 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cache_sram.txt
 delete mode 100644 arch/powerpc/boot/dts/mgsuvd.dts
 delete mode 100644 arch/powerpc/configs/mgsuvd_defconfig
 create mode 100644 arch/powerpc/platforms/44x/canyonlands.c
 rename arch/powerpc/platforms/82xx/{mgcoge.c => km82xx.c} (69%)
 rename arch/powerpc/platforms/83xx/{kmeter1.c => km83xx.c} (80%)
 delete mode 100644 arch/powerpc/platforms/8xx/mgsuvd.c


