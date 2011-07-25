Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1GYU1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:27:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1GYU1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:27:01 -0400
Date: Mon, 25 Jul 2011 22:26:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1107252219350.7300@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive trivial tree patches queued for this merge window.

It's usual trivial stuff all over the tree with nothing really standing 
out.

You'll receive two conflicts easy to fix:

1) the one updating Ryan Malons' e-mail address in 
   drivers/gpio/gpio-ep93xx.c. Just context changes.
   You can as well drop this on the floor completely, as this
   file is going to be removed anyway in this merge window
   (see https://lkml.org/lkml/2011/6/16/913)
2) the one in drivers/net/r8169.c. Context changes as well -- correct 
   resolution is to use the version from your HEAD and remove the
   trailing semicolon from RTL_FIRMWARE_UNKNOWN there.

If you want me to update the tree first and resolve the conflicts, let me 
know.

Thanks.


Andrew Lunn (1):
      ARM: remove duplicate include from arch/arm/mach-dove/common.c

Andrew Murray (1):
      bootgraph.pl: relax timing information requirements

Deepak Saxena (1):
      Update feature-removal-update.txt with 3.x versioning

Jan Engelhardt (1):
      lib/vsprintf: replace link to Draft by final RFC number

Jean Delvare (1):
      fs: Merge split strings

Jesper Juhl (10):
      docproc: cleanup brace placement
      ARM: static should be at beginning of declaration
      MIPS: static should be at beginning of declaration
      SH: static should be at beginning of declaration
      XTENSA: static should be at beginning of declaration
      drivers/i2c: static should be at beginning of declaration
      drivers/media: static should be at beginning of declaration
      drivers/net: static should be at beginning of declaration
      net, netfilter: Remove redundant goto in ebt_ulog_packet
      uwb: Fix misspelling of neighbourhood in comment

Jiri Kosina (4):
      trivial: don't touch fsi_ssl.c with ioremap fixes
      s390: do not touch sie64a.S with duplicate include removal
      gma500: push through device driver tree
      trivial: don't touch files that are removed in the staging tree

Joe Perches (3):
      treewide: Convert uses of struct resource to resource_size(ptr)
      treewide: Fix recieve/receive typos
      treewide: transciever/transceiver spelling fixes

Jonathan Neuschäfer (2):
      scripts/gcc-goto.sh: fix a typo ("suport")
      stop_machine.h: "disables preeempt" -> "disables preemption"

Justin P. Mattock (4):
      doc: i2o: fix typo 'Settting'
      Input: libps2.c: fix comment typo arrrives.
      ata: sata_dwc_460ex.c: fix comment typo corrresponding
      scsi: qla_isr.c: fix comment typo 'hammmer'

Michael Buesch (1):
      Update my e-mail address

Michael Witten (5):
      mm Kconfig typo: cleancacne -> cleancache
      PCIe ASPM: forcedly -> forcibly
      doc: Konfig: Documentation/power/{pm => apm-acpi}.txt
      doc: Kconfig: Typo: square -> squared
      doc: Kconfig: `to be' -> `be'

Michal Hocko (1):
      rcu: treewide: Do not use rcu_read_lock_held when calling rcu_dereference_check

Mike Frysinger (1):
      doc: powerpc: drop +x perms on text file

Nikanth Karthikesan (1):
      viafbdev: fix compilation warning for unused variable

Phil Carmody (1):
      treewide: fix potentially dangerous trailing ';' in #defined values/expressions

Ryan Mallon (1):
      Change Ryan Mallon's email address across the kernel

Sasha Levin (1):
      hwrng: fix spelling mistake in header comment

Vitaliy Ivanov (2):
      treewide: remove duplicate includes
      treewide: fix kernel-doc warnings

Wanlong Gao (1):
      doc: fix wrong arch/i386 references

 .mailmap                                           |    3 +-
 Documentation/DocBook/v4l/io.xml                   |    2 +-
 Documentation/RCU/NMI-RCU.txt                      |    4 +-
 Documentation/blockdev/README.DAC960               |    2 +-
 Documentation/blockdev/ramdisk.txt                 |    8 ++--
 Documentation/cpu-freq/cpu-drivers.txt             |    2 +-
 Documentation/feature-removal-schedule.txt         |   20 +++++-----
 Documentation/filesystems/nfs/nfsroot.txt          |    2 +-
 Documentation/i2o/ioctl                            |    2 +-
 Documentation/isdn/README.HiSax                    |    2 +-
 Documentation/kbuild/makefiles.txt                 |   38 ++++++++++----------
 Documentation/magic-number.txt                     |    2 +-
 Documentation/mca.txt                              |    4 +-
 Documentation/scheduler/sched-arch.txt             |    2 +-
 Documentation/scsi/BusLogic.txt                    |    2 +-
 Documentation/serial/computone.txt                 |    2 +-
 Documentation/zh_CN/magic-number.txt               |    2 +-
 MAINTAINERS                                        |    6 ++--
 arch/alpha/include/asm/floppy.h                    |    2 +-
 arch/arm/common/scoop.c                            |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |    2 +-
 arch/arm/mach-at91/board-snapper9260.c             |    2 +-
 arch/arm/mach-dove/common.c                        |    2 -
 arch/arm/mach-ep93xx/dma-m2p.c                     |    2 +-
 arch/arm/mach-ep93xx/gpio.c                        |    2 +-
 arch/arm/mach-ep93xx/simone.c                      |    4 +-
 arch/arm/mach-ep93xx/snappercl15.c                 |    4 +-
 arch/arm/mach-mv78xx0/pcie.c                       |    8 ++--
 arch/arm/mach-pxa/include/mach/corgi.h             |    2 +-
 arch/arm/mach-pxa/include/mach/pxa27x-udc.h        |    4 +-
 arch/arm/mach-s3c2410/h1940-bluetooth.c            |    1 -
 arch/arm/mach-shmobile/board-ap4evb.c              |    2 +-
 arch/arm/mach-u300/core.c                          |    2 +-
 arch/arm/mach-ux500/board-mop500-regulators.c      |    2 +-
 arch/arm/plat-mxc/pwm.c                            |    8 ++--
 arch/arm/plat-s5p/sysmmu.c                         |    6 ++--
 arch/arm/plat-samsung/pm-check.c                   |    2 +-
 arch/avr32/kernel/setup.c                          |   10 +++---
 arch/avr32/mach-at32ap/extint.c                    |    2 +-
 arch/avr32/mach-at32ap/hsmc.c                      |    2 +-
 arch/avr32/mach-at32ap/intc.c                      |    2 +-
 arch/avr32/mach-at32ap/pio.c                       |    2 +-
 arch/h8300/kernel/setup.c                          |    2 +-
 arch/ia64/include/asm/sn/tioce.h                   |    2 +-
 arch/microblaze/pci/pci-common.c                   |    2 +-
 arch/mips/bcm47xx/setup.c                          |    2 +-
 arch/mips/include/asm/floppy.h                     |    2 +-
 arch/mips/include/asm/mach-jz4740/gpio.h           |    5 +--
 arch/mips/lantiq/devices.c                         |    2 -
 arch/mips/lantiq/xway/devices.c                    |    2 -
 arch/mips/pci/pci-rc32434.c                        |    2 +-
 arch/mips/pci/pci-vr41xx.c                         |    2 +-
 arch/mips/powertv/asic/asic_devices.c              |   10 ++---
 arch/parisc/include/asm/dma-mapping.h              |    2 +-
 arch/parisc/math-emu/decode_exc.c                  |    2 +-
 arch/powerpc/include/asm/elf.h                     |    4 +-
 arch/powerpc/include/asm/macio.h                   |    2 +-
 arch/powerpc/include/asm/smu.h                     |    2 +-
 arch/powerpc/kernel/machine_kexec.c                |    4 +-
 arch/powerpc/kernel/pci-common.c                   |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c          |    8 ++--
 arch/powerpc/platforms/83xx/km83xx.c               |    2 +-
 arch/powerpc/platforms/83xx/mpc832x_mds.c          |    2 +-
 arch/powerpc/platforms/83xx/mpc834x_mds.c          |    2 +-
 arch/powerpc/platforms/83xx/mpc836x_mds.c          |    2 +-
 arch/powerpc/platforms/83xx/usb.c                  |    2 +-
 arch/powerpc/platforms/85xx/sbc8560.c              |    2 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c          |    2 +-
 arch/powerpc/platforms/cell/celleb_scc_epci.c      |    8 ++--
 arch/powerpc/platforms/cell/celleb_scc_pciex.c     |    2 +-
 arch/powerpc/platforms/cell/spu_manage.c           |    2 +-
 arch/powerpc/platforms/chrp/pci.c                  |    2 +-
 arch/powerpc/platforms/pasemi/dma_lib.c            |    2 +-
 arch/powerpc/platforms/powermac/nvram.c            |    4 +-
 arch/powerpc/platforms/powermac/pci.c              |    6 +--
 arch/powerpc/platforms/powermac/time.c             |    2 +-
 arch/powerpc/platforms/pseries/smp.c               |    1 -
 arch/powerpc/sysdev/axonram.c                      |    2 +-
 arch/powerpc/sysdev/cpm1.c                         |    2 +-
 arch/powerpc/sysdev/cpm_common.c                   |    2 +-
 arch/powerpc/sysdev/dart_iommu.c                   |    2 +-
 arch/powerpc/sysdev/fsl_msi.c                      |    2 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   12 +++---
 arch/powerpc/sysdev/fsl_rio.c                      |    2 +-
 arch/powerpc/sysdev/ipic.c                         |    2 +-
 arch/powerpc/sysdev/mmio_nvram.c                   |    2 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                   |    2 +-
 arch/powerpc/sysdev/mv64x60_udbg.c                 |    4 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                   |   16 ++++----
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_io.c                 |    2 +-
 arch/powerpc/sysdev/xics/icp-native.c              |    2 +-
 arch/s390/oprofile/init.c                          |    2 -
 arch/sh/boards/mach-ap325rxa/setup.c               |    2 +-
 arch/sh/boards/mach-ecovec24/setup.c               |    4 +-
 arch/sh/boards/mach-kfr2r09/setup.c                |    2 +-
 arch/sh/boards/mach-migor/setup.c                  |    2 +-
 arch/sh/boards/mach-se/7724/setup.c                |    4 +-
 arch/sh/kernel/io_trapped.c                        |    8 ++--
 arch/sh/kernel/machine_kexec.c                     |    2 +-
 arch/sparc/include/asm/elf_64.h                    |    2 +-
 arch/sparc/kernel/ioport.c                         |   12 +++---
 arch/sparc/kernel/pci.c                            |    6 +--
 arch/tile/kernel/setup.c                           |    3 +-
 arch/um/sys-i386/signal.c                          |    2 +-
 arch/x86/Kconfig                                   |    4 +-
 arch/x86/kernel/i387.c                             |    2 +-
 arch/x86/kernel/pci-calgary_64.c                   |    2 +-
 arch/x86/kernel/probe_roms.c                       |    2 +-
 arch/x86/kvm/mmu.c                                 |    1 -
 arch/xtensa/include/asm/uaccess.h                  |    3 +-
 arch/xtensa/variants/s6000/include/variant/dmac.h  |    2 +-
 crypto/Kconfig                                     |    2 +-
 drivers/acpi/ac.c                                  |    2 +-
 drivers/acpi/battery.c                             |    2 +-
 drivers/acpi/sbs.c                                 |    2 +-
 drivers/bcma/driver_chipcommon.c                   |    2 +-
 drivers/bcma/driver_chipcommon_pmu.c               |    2 +-
 drivers/bcma/driver_pci.c                          |    2 +-
 drivers/char/bsr.c                                 |    2 +-
 drivers/char/hw_random/core.c                      |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |    2 +-
 drivers/dma/mv_xor.c                               |    5 +--
 drivers/edac/cell_edac.c                           |    2 +-
 drivers/edac/mpc85xx_edac.c                        |   12 +++---
 drivers/gpio/ab8500-gpio.c                         |    1 -
 drivers/gpio/bt8xxgpio.c                           |    2 +-
 drivers/gpio/gpio-u300.c                           |    8 ++--
 drivers/gpu/drm/nouveau/nv50_graph.c               |    1 -
 drivers/gpu/drm/sis/sis_drv.h                      |    4 +-
 drivers/hwmon/gl520sm.c                            |    2 +-
 drivers/i2c/Kconfig                                |    2 +-
 drivers/i2c/busses/i2c-highlander.c                |    2 +-
 drivers/i2c/busses/i2c-omap.c                      |    4 +-
 drivers/ide/palm_bk3710.c                          |    2 +-
 drivers/ide/tx4939ide.c                            |    4 +-
 drivers/input/serio/libps2.c                       |    2 +-
 drivers/input/serio/sa1111ps2.c                    |    6 +--
 drivers/isdn/i4l/isdn_bsdcomp.c                    |    2 +-
 drivers/media/rc/ite-cir.c                         |    1 -
 drivers/media/video/davinci/vpif.c                 |    2 +-
 drivers/media/video/m5mols/m5mols_capture.c        |    1 -
 drivers/media/video/omap/omap_vout.c               |    2 +-
 drivers/media/video/omap24xxcam.c                  |    5 +--
 drivers/media/video/videobuf2-memops.c             |    1 -
 drivers/message/i2o/iop.c                          |    8 ++--
 drivers/mfd/tc6387xb.c                             |    2 +-
 drivers/misc/atmel-ssc.c                           |    2 +-
 drivers/misc/atmel_pwm.c                           |    2 +-
 drivers/mmc/host/dw_mmc.c                          |    2 +-
 drivers/mmc/host/vub300.c                          |    4 +-
 drivers/mtd/devices/sst25l.c                       |    4 +-
 drivers/mtd/maps/bfin-async-flash.c                |    2 +-
 drivers/mtd/maps/ixp2000.c                         |   11 +++---
 drivers/mtd/maps/pxa2xx-flash.c                    |    2 +-
 drivers/mtd/nand/atmel_nand.c                      |    4 +-
 drivers/mtd/nand/bcm_umi_nand.c                    |    2 +-
 drivers/mtd/nand/mpc5121_nfc.c                     |    2 +-
 drivers/net/b44.c                                  |    2 +-
 drivers/net/bcm63xx_enet.c                         |    8 ++--
 drivers/net/bsd_comp.c                             |    2 +-
 drivers/net/can/c_can/c_can.c                      |    1 -
 drivers/net/can/c_can/c_can_platform.c             |    1 -
 drivers/net/can/softing/softing_main.c             |    2 +-
 drivers/net/davinci_emac.c                         |    6 ++--
 drivers/net/eexpress.c                             |    2 +-
 drivers/net/ethoc.c                                |    2 +-
 drivers/net/fec_mpc52xx.c                          |    7 ++--
 drivers/net/fs_enet/mii-bitbang.c                  |    4 +-
 drivers/net/fs_enet/mii-fec.c                      |    2 +-
 drivers/net/gianfar_ptp.c                          |    2 +-
 drivers/net/ibm_newemac/core.c                     |    2 +-
 drivers/net/irda/toim3232-sir.c                    |    2 +-
 drivers/net/macb.c                                 |    2 +-
 drivers/net/mv643xx_eth.c                          |    2 +-
 drivers/net/natsemi.c                              |    4 +-
 drivers/net/pxa168_eth.c                           |    2 +-
 drivers/net/r8169.c                                |    2 +-
 drivers/net/s2io.h                                 |    4 +-
 drivers/net/sb1250-mac.c                           |    2 +-
 drivers/net/sungem.c                               |    3 +-
 drivers/net/usb/kalmia.c                           |   12 +++---
 drivers/net/wan/lmc/lmc_var.h                      |    2 +-
 drivers/net/wireless/ath/ath5k/ahb.c               |    1 -
 drivers/net/wireless/b43/debugfs.c                 |    2 +-
 drivers/net/wireless/b43/dma.c                     |    2 +-
 drivers/net/wireless/b43/leds.c                    |    2 +-
 drivers/net/wireless/b43/lo.c                      |    2 +-
 drivers/net/wireless/b43/main.c                    |    2 +-
 drivers/net/wireless/b43/main.h                    |    2 +-
 drivers/net/wireless/b43/pcmcia.c                  |    2 +-
 drivers/net/wireless/b43/phy_a.c                   |    2 +-
 drivers/net/wireless/b43/phy_common.c              |    2 +-
 drivers/net/wireless/b43/phy_g.c                   |    2 +-
 drivers/net/wireless/b43/phy_lp.c                  |    2 +-
 drivers/net/wireless/b43/phy_n.c                   |    2 +-
 drivers/net/wireless/b43/pio.c                     |    2 +-
 drivers/net/wireless/b43/radio_2055.c              |    2 +-
 drivers/net/wireless/b43/rfkill.c                  |    2 +-
 drivers/net/wireless/b43/sdio.c                    |    2 +-
 drivers/net/wireless/b43/sysfs.c                   |    2 +-
 drivers/net/wireless/b43/tables.c                  |    2 +-
 drivers/net/wireless/b43/tables_lpphy.c            |    2 +-
 drivers/net/wireless/b43/tables_nphy.c             |    2 +-
 drivers/net/wireless/b43/wa.c                      |    2 +-
 drivers/net/wireless/b43/xmit.c                    |    2 +-
 drivers/net/wireless/b43legacy/debugfs.c           |    2 +-
 drivers/net/wireless/b43legacy/dma.c               |    2 +-
 drivers/net/wireless/b43legacy/ilt.c               |    2 +-
 drivers/net/wireless/b43legacy/leds.c              |    2 +-
 drivers/net/wireless/b43legacy/main.c              |    2 +-
 drivers/net/wireless/b43legacy/main.h              |    2 +-
 drivers/net/wireless/b43legacy/phy.c               |    2 +-
 drivers/net/wireless/b43legacy/phy.h               |    2 +-
 drivers/net/wireless/b43legacy/pio.c               |    2 +-
 drivers/net/wireless/b43legacy/radio.c             |    2 +-
 drivers/net/wireless/b43legacy/radio.h             |    2 +-
 drivers/net/wireless/b43legacy/rfkill.c            |    2 +-
 drivers/net/wireless/b43legacy/sysfs.c             |    2 +-
 drivers/net/wireless/b43legacy/xmit.c              |    2 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       |    4 +-
 drivers/parport/parport_ax88796.c                  |    2 +-
 drivers/pci/hotplug/shpchp_sysfs.c                 |   21 +++++------
 drivers/pci/pcie/aspm.c                            |    2 +-
 drivers/pcmcia/at91_cf.c                           |    7 ++--
 drivers/pcmcia/electra_cf.c                        |    4 +-
 drivers/pcmcia/rsrc_iodyn.c                        |    6 ++--
 drivers/pcmcia/rsrc_nonstatic.c                    |    6 ++--
 drivers/pnp/pnpacpi/rsparser.c                     |   10 +++---
 drivers/pnp/pnpbios/rsparser.c                     |   12 +++---
 drivers/power/ds2782_battery.c                     |    4 +-
 drivers/rtc/rtc-at32ap700x.c                       |    2 +-
 drivers/rtc/rtc-cmos.c                             |    6 ++--
 drivers/rtc/rtc-ds1286.c                           |    2 +-
 drivers/rtc/rtc-ds1511.c                           |    2 +-
 drivers/rtc/rtc-ds1742.c                           |    2 +-
 drivers/rtc/rtc-m48t35.c                           |    2 +-
 drivers/rtc/rtc-m48t59.c                           |    2 +-
 drivers/rtc/rtc-mrst.c                             |    5 +--
 drivers/rtc/rtc-puv3.c                             |    5 +--
 drivers/rtc/rtc-s3c.c                              |    5 +--
 drivers/scsi/device_handler/scsi_dh_rdac.c         |    2 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |    8 ++--
 drivers/scsi/qla2xxx/qla_isr.c                     |    4 +-
 drivers/ssb/b43_pci_bridge.c                       |    2 +-
 drivers/ssb/driver_chipcommon.c                    |    2 +-
 drivers/ssb/driver_chipcommon_pmu.c                |    2 +-
 drivers/ssb/driver_extif.c                         |    2 +-
 drivers/ssb/driver_gige.c                          |    2 +-
 drivers/ssb/driver_mipscore.c                      |    2 +-
 drivers/ssb/driver_pcicore.c                       |    2 +-
 drivers/ssb/embedded.c                             |    2 +-
 drivers/ssb/main.c                                 |    2 +-
 drivers/ssb/pci.c                                  |    2 +-
 drivers/ssb/pcihost_wrapper.c                      |    2 +-
 drivers/ssb/pcmcia.c                               |    2 +-
 drivers/ssb/scan.c                                 |    2 +-
 drivers/ssb/sdio.c                                 |    2 +-
 drivers/ssb/sprom.c                                |    2 +-
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    1 -
 drivers/staging/bcm/headers.h                      |    7 +---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    9 +----
 drivers/staging/hv/hv_mouse.c                      |    1 -
 drivers/staging/hv/tools/hv_kvp_daemon.c           |    1 -
 drivers/staging/nvec/nvec.c                        |    1 -
 drivers/staging/rtl8712/drv_types.h                |    1 -
 drivers/staging/rtl8712/osdep_service.h            |    1 -
 drivers/staging/sep/sep_driver.c                   |    1 -
 drivers/staging/usbip/userspace/src/utils.h        |    1 -
 drivers/target/loopback/tcm_loop.c                 |    1 -
 drivers/target/tcm_fc/tfc_cmd.c                    |    1 -
 drivers/target/tcm_fc/tfc_conf.c                   |    1 -
 drivers/target/tcm_fc/tfc_io.c                     |    1 -
 drivers/target/tcm_fc/tfc_sess.c                   |    2 -
 drivers/tty/serial/8250_pci.c                      |    2 +-
 drivers/tty/serial/bfin_5xx.c                      |    5 +--
 drivers/tty/serial/imx.c                           |    5 +--
 drivers/tty/serial/m32r_sio.c                      |    2 +-
 drivers/tty/serial/omap-serial.c                   |    6 ++--
 drivers/tty/serial/pxa.c                           |    2 +-
 drivers/tty/serial/sunsu.c                         |    2 +-
 drivers/tty/serial/vt8500_serial.c                 |    3 +-
 drivers/uio/uio_pdrv.c                             |    2 +-
 drivers/uio/uio_pdrv_genirq.c                      |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
 drivers/usb/gadget/fsl_udc_core.c                  |    6 ++--
 drivers/usb/gadget/pxa27x_udc.h                    |    4 +-
 drivers/usb/host/ehci-ath79.c                      |    2 +-
 drivers/usb/host/ehci-cns3xxx.c                    |    2 +-
 drivers/usb/host/ehci-fsl.c                        |    2 +-
 drivers/usb/host/ehci-grlib.c                      |    2 +-
 drivers/usb/host/ehci-ixp4xx.c                     |    2 +-
 drivers/usb/host/ehci-octeon.c                     |    2 +-
 drivers/usb/host/ehci-pmcmsp.c                     |   10 +++---
 drivers/usb/host/ehci-ppc-of.c                     |    2 +-
 drivers/usb/host/ehci-w90x900.c                    |    2 +-
 drivers/usb/host/ehci-xilinx-of.c                  |    2 +-
 drivers/usb/host/fhci-hcd.c                        |    2 +-
 drivers/usb/host/ohci-ath79.c                      |    4 +-
 drivers/usb/host/ohci-cns3xxx.c                    |    2 +-
 drivers/usb/host/ohci-da8xx.c                      |    2 +-
 drivers/usb/host/ohci-octeon.c                     |    2 +-
 drivers/usb/host/ohci-ppc-of.c                     |    2 +-
 drivers/usb/host/ohci-ppc-soc.c                    |    2 +-
 drivers/usb/host/ohci-sa1111.c                     |    2 +-
 drivers/usb/host/ohci-sm501.c                      |   11 +++---
 drivers/usb/host/ohci-ssb.c                        |    2 +-
 drivers/usb/host/ohci-tmio.c                       |    6 ++--
 drivers/usb/host/oxu210hp-hcd.c                    |    2 +-
 drivers/usb/host/uhci-grlib.c                      |    2 +-
 drivers/usb/host/whci/init.c                       |    2 +-
 drivers/usb/misc/ftdi-elan.c                       |   28 +++++++-------
 drivers/usb/musb/musb_core.c                       |    2 +-
 drivers/usb/otg/isp1301_omap.c                     |    4 +-
 drivers/usb/otg/otg_fsm.c                          |    1 -
 drivers/usb/otg/twl4030-usb.c                      |    2 +-
 drivers/uwb/uwbd.c                                 |    2 +-
 drivers/uwb/whc-rc.c                               |    2 +-
 drivers/video/atmel_lcdfb.c                        |    4 +-
 drivers/video/aty/atyfb_base.c                     |    7 ++--
 drivers/video/au1100fb.c                           |    2 +-
 drivers/video/cobalt_lcdfb.c                       |    2 +-
 drivers/video/controlfb.c                          |    4 +-
 drivers/video/ep93xx-fb.c                          |    4 +-
 drivers/video/i810/i810.h                          |    2 +-
 drivers/video/mb862xx/mb862xxfbdrv.c               |    4 +-
 drivers/video/msm/mdp.c                            |    3 +-
 drivers/video/msm/msm_fb.c                         |    7 ++--
 drivers/video/nuc900fb.c                           |    2 +-
 drivers/video/platinumfb.c                         |    5 +--
 drivers/video/pxa168fb.c                           |    2 +-
 drivers/video/udlfb.c                              |    1 -
 drivers/video/via/viafbdev.c                       |    4 +-
 fs/ecryptfs/keystore.c                             |    2 +-
 fs/jffs2/readinode.c                               |    2 +-
 fs/nfs/idmap.c                                     |    7 +---
 fs/ocfs2/move_extents.c                            |    1 -
 fs/xfs/xfs_dir2_node.c                             |    2 +-
 include/linux/ceph/libceph.h                       |    2 +-
 include/linux/cgroup.h                             |    1 -
 include/linux/cred.h                               |    1 -
 include/linux/dio.h                                |    2 +-
 include/linux/fdtable.h                            |    1 -
 include/linux/fs.h                                 |    1 -
 include/linux/hw_random.h                          |    2 +-
 include/linux/mfd/tps65910.h                       |    2 +-
 include/linux/nl80211.h                            |    2 +-
 include/linux/pnp.h                                |    2 +-
 include/linux/rtnetlink.h                          |    3 +-
 include/linux/ssb/ssb_driver_chipcommon.h          |    2 +-
 include/linux/stop_machine.h                       |    2 +-
 include/linux/zorro.h                              |    2 +-
 include/net/sock.h                                 |    3 +-
 include/scsi/osd_initiator.h                       |    2 +-
 include/scsi/scsi.h                                |    2 +-
 include/sound/soundfont.h                          |    2 +-
 kernel/cgroup.c                                    |    8 +---
 kernel/exit.c                                      |    1 -
 kernel/kexec.c                                     |    2 +-
 kernel/pid.c                                       |    1 -
 kernel/power/Kconfig                               |    4 +-
 kernel/rcutorture.c                                |    2 -
 kernel/sched.c                                     |    1 -
 lib/vsprintf.c                                     |    3 +-
 mm/Kconfig                                         |    2 +-
 mm/slub.c                                          |    2 +-
 net/bridge/netfilter/ebt_ulog.c                    |    1 -
 net/mac80211/mesh_hwmp.c                           |   20 +++++-----
 net/mac80211/sta_info.c                            |    4 --
 net/netlabel/netlabel_domainhash.c                 |    3 +-
 net/netlabel/netlabel_unlabeled.c                  |    3 +-
 scripts/bootgraph.pl                               |    2 +-
 scripts/docproc.c                                  |   17 +++------
 scripts/gcc-goto.sh                                |    2 +-
 security/keys/keyring.c                            |    1 -
 sound/aoa/soundbus/i2sbus/core.c                   |    9 ++---
 sound/atmel/abdac.c                                |    2 +-
 sound/atmel/ac97c.c                                |    2 +-
 sound/pci/ice1712/ice1712.c                        |    2 +-
 sound/ppc/pmac.c                                   |    9 ++---
 sound/soc/ep93xx/ep93xx-i2s.c                      |    4 +-
 sound/soc/ep93xx/ep93xx-pcm.c                      |    4 +-
 sound/soc/ep93xx/snappercl15.c                     |    4 +-
 sound/soc/fsl/mpc5200_dma.c                        |    2 +-
 sound/soc/omap/ams-delta.c                         |    2 +-
 389 files changed, 580 insertions(+), 690 deletions(-)
 mode change 100755 => 100644 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
