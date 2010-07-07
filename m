Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0GGMrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:47:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33738 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0GGMrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:47:31 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] trivial: fix typos concerning "address"
Date: Wed,  7 Jul 2010 14:47:24 +0200
Message-Id: <1278506844-1174-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 Documentation/IPMI.txt                             |    4 +-
 Documentation/misc-devices/isl29003                |    2 +-
 Documentation/networking/arcnet-hardware.txt       |    2 +-
 Documentation/powerpc/booting-without-of.txt       |    2 +-
 Documentation/scsi/ChangeLog.megaraid              |    2 +-
 arch/alpha/kernel/core_marvel.c                    |    2 +-
 arch/alpha/kernel/core_mcpcia.c                    |    2 +-
 arch/alpha/kernel/core_titan.c                     |    2 +-
 arch/alpha/kernel/core_tsunami.c                   |    2 +-
 arch/alpha/kernel/core_wildfire.c                  |    2 +-
 arch/arm/common/it8152.c                           |    2 +-
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h    |    2 +-
 .../arm/mach-bcmring/include/mach/csp/dmacHw_reg.h |    2 +-
 arch/arm/mach-pxa/include/mach/sharpsl.h           |    2 +-
 arch/arm/mach-u300/include/mach/coh901318.h        |    2 +-
 arch/blackfin/kernel/ftrace.c                      |    2 +-
 arch/blackfin/lib/memcmp.S                         |    2 +-
 arch/blackfin/lib/memmove.S                        |    2 +-
 .../mach-bf518/include/mach/defBF51x_base.h        |    2 +-
 .../mach-bf527/include/mach/defBF52x_base.h        |    2 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |    2 +-
 arch/blackfin/mach-bf538/include/mach/defBF539.h   |    2 +-
 arch/cris/arch-v32/lib/nand_init.S                 |    2 +-
 arch/ia64/include/asm/sn/leds.h                    |    2 +-
 arch/ia64/include/asm/sn/sn_cpuid.h                |    2 +-
 arch/ia64/kvm/kvm-ia64.c                           |    2 +-
 arch/ia64/kvm/kvm_fw.c                             |    2 +-
 arch/ia64/sn/kernel/bte.c                          |    2 +-
 arch/ia64/sn/kernel/bte_error.c                    |    2 +-
 arch/ia64/sn/kernel/huberror.c                     |    2 +-
 arch/ia64/sn/kernel/io_acpi_init.c                 |    2 +-
 arch/ia64/sn/kernel/io_common.c                    |    2 +-
 arch/ia64/sn/kernel/io_init.c                      |    2 +-
 arch/ia64/sn/kernel/irq.c                          |    2 +-
 arch/ia64/sn/kernel/msi_sn.c                       |    2 +-
 arch/ia64/sn/kernel/setup.c                        |    2 +-
 arch/ia64/sn/kernel/sn2/prominfo_proc.c            |    2 +-
 arch/ia64/sn/kernel/sn2/sn2_smp.c                  |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c                |    2 +-
 arch/ia64/sn/kernel/tiocx.c                        |    2 +-
 arch/ia64/sn/pci/pcibr/pcibr_dma.c                 |    2 +-
 arch/ia64/sn/pci/pcibr/pcibr_provider.c            |    2 +-
 arch/ia64/sn/pci/tioca_provider.c                  |    2 +-
 arch/ia64/sn/pci/tioce_provider.c                  |    2 +-
 arch/m68k/ifpsp060/src/isp.S                       |    2 +-
 arch/microblaze/kernel/ftrace.c                    |    2 +-
 arch/microblaze/mm/fault.c                         |    2 +-
 arch/microblaze/mm/pgtable.c                       |    2 +-
 .../mips/include/asm/mach-ip27/kernel-entry-init.h |    2 +-
 arch/mips/include/asm/mach-ip27/mmzone.h           |    2 +-
 .../mips/include/asm/pmc-sierra/msp71xx/msp_regs.h |    2 +-
 arch/mips/include/asm/sgi/mc.h                     |    2 +-
 arch/mips/include/asm/sn/addrs.h                   |    4 +-
 arch/mips/include/asm/sn/agent.h                   |    2 +-
 arch/mips/include/asm/sn/gda.h                     |    2 +-
 arch/mips/include/asm/sn/klconfig.h                |    4 +-
 arch/mips/include/asm/sn/launch.h                  |    2 +-
 arch/mips/include/asm/sn/nmi.h                     |    2 +-
 arch/mips/include/asm/sn/sn0/addrs.h               |    2 +-
 arch/mips/include/asm/sn/sn0/hub.h                 |    2 +-
 arch/mips/include/asm/sn/sn0/ip27.h                |    2 +-
 arch/mips/kernel/ftrace.c                          |    2 +-
 arch/mips/kernel/genex.S                           |    2 +-
 arch/mips/pci/pcie-octeon.c                        |    2 +-
 arch/mips/sgi-ip27/ip27-berr.c                     |    2 +-
 arch/mips/sgi-ip27/ip27-console.c                  |    2 +-
 arch/mips/sgi-ip27/ip27-hubio.c                    |    2 +-
 arch/mips/sgi-ip27/ip27-init.c                     |    2 +-
 arch/mips/sgi-ip27/ip27-irq.c                      |    2 +-
 arch/mips/sgi-ip27/ip27-nmi.c                      |    2 +-
 arch/mips/sgi-ip27/ip27-reset.c                    |    2 +-
 arch/mips/sgi-ip27/ip27-timer.c                    |    4 +-
 arch/mips/sibyte/common/cfe.c                      |    2 +-
 arch/mips/txx9/generic/pci.c                       |    2 +-
 arch/parisc/kernel/ftrace.c                        |    2 +-
 arch/powerpc/kernel/ftrace.c                       |    2 +-
 arch/powerpc/kernel/pci_of_scan.c                  |   18 ++--
 arch/powerpc/kernel/rtas_flash.c                   |    4 +-
 arch/powerpc/kvm/44x_tlb.c                         |    2 +-
 arch/powerpc/mm/pgtable_32.c                       |    2 +-
 arch/powerpc/platforms/cell/spu_base.c             |    8 +-
 arch/powerpc/platforms/pseries/eeh.c               |    4 +-
 arch/powerpc/platforms/pseries/eeh_cache.c         |    2 +-
 arch/powerpc/xmon/xmon.c                           |   92 ++++++++--------
 arch/sh/kernel/ftrace.c                            |    2 +-
 arch/sh/mm/cache-sh5.c                             |    2 +-
 arch/sparc/kernel/ftrace.c                         |    2 +-
 arch/sparc/kernel/pci.c                            |   14 +-
 arch/sparc/kernel/traps_64.c                       |    2 +-
 arch/x86/include/asm/pgalloc.h                     |    2 +-
 arch/x86/kernel/ftrace.c                           |    2 +-
 arch/x86/lguest/i386_head.S                        |    2 +-
 drivers/atm/iphase.c                               |    2 +-
 drivers/char/agp/sgi-agp.c                         |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |   12 +-
 drivers/char/mbcs.c                                |    2 +-
 drivers/char/mmtimer.c                             |    2 +-
 drivers/char/mspec.c                               |    2 +-
 drivers/char/pc8736x_gpio.c                        |    2 +-
 drivers/dma/ppc4xx/adma.c                          |   14 +-
 drivers/edac/cell_edac.c                           |    4 +-
 drivers/gpu/drm/radeon/atombios.h                  |    2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c             |    2 +-
 drivers/infiniband/hw/ipath/ipath_init_chip.c      |    8 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   16 ++--
 drivers/infiniband/hw/nes/nes_verbs.c              |    2 +-
 drivers/infiniband/hw/qib/qib_init.c               |   10 +-
 drivers/md/raid1.c                                 |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |    4 +-
 drivers/media/video/bt8xx/bttv-cards.c             |   16 ++--
 drivers/media/video/cx23885/cx23885.h              |    2 +-
 drivers/media/video/davinci/vpif.h                 |    2 +-
 drivers/media/video/davinci/vpif_display.c         |    2 +-
 drivers/media/video/w9968cf.c                      |    4 +-
 drivers/misc/hpilo.c                               |    4 +-
 drivers/misc/hpilo.h                               |    4 +-
 drivers/mtd/chips/jedec_probe.c                    |    4 +-
 drivers/net/3c501.h                                |    2 +-
 drivers/net/3c503.c                                |    4 +-
 drivers/net/3c505.c                                |    2 +-
 drivers/net/7990.c                                 |    8 +-
 drivers/net/a2065.c                                |    8 +-
 drivers/net/arm/ether3.c                           |   18 ++--
 drivers/net/bfin_mac.c                             |    8 +-
 drivers/net/bmac.c                                 |   10 +-
 drivers/net/bnx2x_reg.h                            |    2 +-
 drivers/net/bonding/bond_3ad.c                     |    4 +-
 drivers/net/bsd_comp.c                             |    6 +-
 drivers/net/chelsio/subr.c                         |    2 +-
 drivers/net/cxgb3/t3_hw.c                          |    2 +-
 drivers/net/davinci_emac.c                         |    4 +-
 drivers/net/declance.c                             |    8 +-
 drivers/net/defxx.c                                |   10 +-
 drivers/net/depca.c                                |    8 +-
 drivers/net/e100.c                                 |    2 +-
 drivers/net/e1000/e1000_main.c                     |    2 +-
 drivers/net/e1000e/phy.c                           |    2 +-
 drivers/net/eepro.c                                |    2 +-
 drivers/net/enic/enic_main.c                       |    4 +-
 drivers/net/ewrk3.c                                |    8 +-
 drivers/net/hamachi.c                              |    2 +-
 drivers/net/hp100.c                                |   10 +-
 drivers/net/hp100.h                                |    2 +-
 drivers/net/ixgb/ixgb_hw.h                         |    2 +-
 drivers/net/ixgbe/ixgbe_common.c                   |    4 +-
 drivers/net/korina.c                               |    6 +-
 drivers/net/ll_temac_main.c                        |    2 +-
 drivers/net/mace.c                                 |    2 +-
 drivers/net/niu.h                                  |    4 +-
 drivers/net/pcnet32.c                              |    8 +-
 drivers/net/r6040.c                                |    6 +-
 drivers/net/s2io.h                                 |    2 +-
 drivers/net/sis900.c                               |    2 +-
 drivers/net/skfp/h/supern_2.h                      |    2 +-
 drivers/net/stmmac/dwmac1000_core.c                |    2 +-
 drivers/net/sunbmac.c                              |    8 +-
 drivers/net/sungem.c                               |    6 +-
 drivers/net/sunhme.c                               |   16 ++--
 drivers/net/sunlance.c                             |    8 +-
 drivers/net/sunqe.c                                |    8 +-
 drivers/net/tehuti.c                               |    2 +-
 drivers/net/tulip/de4x5.c                          |   12 +-
 drivers/net/tulip/de4x5.h                          |    2 +-
 drivers/net/tun.c                                  |    6 +-
 drivers/net/vxge/vxge-config.h                     |    4 +-
 drivers/net/vxge/vxge-traffic.h                    |    2 +-
 drivers/net/wan/pc300.h                            |    4 +-
 drivers/net/wan/pc300too.c                         |    4 +-
 drivers/net/wan/pci200syn.c                        |    4 +-
 drivers/net/wimax/i2400m/driver.c                  |    2 +-
 drivers/net/wireless/ath/ath5k/reg.h               |    6 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |    2 +-
 drivers/net/wireless/mwl8k.c                       |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |    2 +-
 drivers/net/wireless/wl3501_cs.c                   |    2 +-
 drivers/parisc/dino.c                              |    2 +-
 drivers/pci/hotplug/sgi_hotplug.c                  |    2 +-
 drivers/pci/iova.c                                 |    2 +-
 drivers/scsi/a100u2w.c                             |    2 +-
 drivers/scsi/aic94xx/aic94xx_hwi.h                 |    2 +-
 drivers/scsi/aic94xx/aic94xx_reg_def.h             |    4 +-
 drivers/scsi/bnx2i/bnx2i.h                         |    2 +-
 drivers/scsi/mac53c94.c                            |    2 +-
 drivers/scsi/mesh.c                                |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h                |    2 +-
 drivers/scsi/sun3_scsi_vme.c                       |    6 +-
 drivers/spi/atmel_spi.c                            |    4 +-
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    8 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    2 +-
 drivers/staging/comedi/drivers/s626.c              |    4 +-
 drivers/staging/comedi/drivers/usbdux.c            |    2 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |    2 +-
 drivers/staging/cx25821/cx25821.h                  |    2 +-
 drivers/staging/dt3155/dt3155_io.c                 |    2 +-
 drivers/staging/octeon/cvmx-fau.h                  |    2 +-
 drivers/staging/otus/80211core/ctxrx.c             |    2 +-
 drivers/staging/pohmelfs/inode.c                   |    2 +-
 drivers/staging/sep/sep_driver_api.h               |    2 +-
 drivers/staging/slicoss/slichw.h                   |    2 +-
 drivers/staging/winbond/wbusb.c                    |    2 +-
 drivers/staging/wlags49_h2/mdd.h                   |   28 +++---
 drivers/staging/wlags49_h2/wl_netdev.c             |    4 +-
 drivers/staging/wlags49_h2/wl_netdev.h             |    2 +-
 drivers/usb/host/u132-hcd.c                        |    6 +-
 drivers/usb/wusbcore/wa-rpipe.c                    |    2 +-
 drivers/video/aty/radeon_base.c                    |    2 +-
 drivers/video/backlight/corgi_lcd.c                |    4 +-
 drivers/video/backlight/tosa_lcd.c                 |    4 +-
 drivers/video/controlfb.h                          |    2 +-
 fs/ext4/ext4.h                                     |    2 +-
 fs/freevxfs/vxfs_inode.h                           |    4 +-
 include/acpi/actbl1.h                              |    2 +-
 include/linux/i2c-dev.h                            |    2 +-
 include/linux/i2c.h                                |    4 +-
 include/linux/if_ppp.h                             |    2 +-
 include/linux/inet_diag.h                          |    2 +-
 include/linux/netfilter_ipv6/ip6t_rt.h             |    2 +-
 include/linux/spi/eeprom.h                         |    6 +-
 include/linux/sunrpc/clnt.h                        |    4 +-
 include/linux/tboot.h                              |    2 +-
 include/media/tvaudio.h                            |    4 +-
 include/net/ipv6.h                                 |    2 +-
 include/net/phonet/pn_dev.h                        |    2 +-
 include/net/sctp/structs.h                         |    2 +-
 include/net/sctp/user.h                            |   12 +-
 include/xen/interface/grant_table.h                |    2 +-
 kernel/kexec.c                                     |    2 +-
 kernel/sysctl_binary.c                             |    2 +-
 kernel/trace/trace_entries.h                       |    2 +-
 mm/migrate.c                                       |    2 +-
 net/decnet/dn_dev.c                                |    2 +-
 net/ipv4/ipconfig.c                                |   20 ++--
 net/ipv6/addrconf.c                                |    2 +-
 net/ipv6/ah6.c                                     |   12 +-
 net/ipv6/ip6_fib.c                                 |    2 +-
 net/ipv6/netfilter/ip6t_rt.c                       |    4 +-
 net/phonet/pn_dev.c                                |   18 ++--
 net/phonet/pn_netlink.c                            |    2 +-
 net/rds/iw_rdma.c                                  |    2 +-
 net/rds/recv.c                                     |    2 +-
 net/sctp/bind_addr.c                               |    6 +-
 net/sctp/ipv6.c                                    |    2 +-
 net/sctp/sm_make_chunk.c                           |   24 ++--
 net/sctp/socket.c                                  |  122 ++++++++++----------
 sound/pci/ca0106/ca0106.h                          |    2 +-
 sound/pci/cs5535audio/cs5535audio.h                |    2 +-
 sound/pci/echoaudio/echoaudio_dsp.h                |    2 +-
 sound/pci/emu10k1/emu10k1x.c                       |    2 +-
 sound/pci/emu10k1/p16v.h                           |    2 +-
 sound/pci/es1968.c                                 |    2 +-
 sound/pci/rme9652/hdspm.c                          |    2 +-
 252 files changed, 575 insertions(+), 575 deletions(-)

diff --git a/Documentation/IPMI.txt b/Documentation/IPMI.txt
index 69dd29e..40ffcef 100644
--- a/Documentation/IPMI.txt
+++ b/Documentation/IPMI.txt
@@ -359,7 +359,7 @@ interface at the spec-specified I/O port 0xca2 without interrupts.
 You can change this at module load time (for a module) with:
 
   modprobe ipmi_si.o type=<type1>,<type2>....
-       ports=<port1>,<port2>... addrs=<addr1>,<addr2>...
+       ports=<port1>,<port2>... address=<addr1>,<addr2>...
        irqs=<irq1>,<irq2>... trydefaults=[0|1]
        regspacings=<sp1>,<sp2>,... regsizes=<size1>,<size2>,...
        regshifts=<shift1>,<shift2>,...
@@ -427,7 +427,7 @@ When compiled into the kernel, the parameters can be specified on the
 kernel command line as:
 
   ipmi_si.type=<type1>,<type2>...
-       ipmi_si.ports=<port1>,<port2>... ipmi_si.addrs=<addr1>,<addr2>...
+       ipmi_si.ports=<port1>,<port2>... ipmi_si.address=<addr1>,<addr2>...
        ipmi_si.irqs=<irq1>,<irq2>... ipmi_si.trydefaults=[0|1]
        ipmi_si.regspacings=<sp1>,<sp2>,...
        ipmi_si.regsizes=<size1>,<size2>,...
diff --git a/Documentation/misc-devices/isl29003 b/Documentation/misc-devices/isl29003
index c4ff5f3..80b952f 100644
--- a/Documentation/misc-devices/isl29003
+++ b/Documentation/misc-devices/isl29003
@@ -29,7 +29,7 @@ Detection
 
 The ISL29003 does not have an ID register which could be used to identify
 it, so the detection routine will just try to read from the configured I2C
-addess and consider the device to be present as soon as it ACKs the
+address and consider the device to be present as soon as it ACKs the
 transfer.
 
 
diff --git a/Documentation/networking/arcnet-hardware.txt b/Documentation/networking/arcnet-hardware.txt
index 731de41..0e67e9c 100644
--- a/Documentation/networking/arcnet-hardware.txt
+++ b/Documentation/networking/arcnet-hardware.txt
@@ -2884,7 +2884,7 @@ Jumpers 3-5 of jumper block SW1 select the Memory Base address.
   
 *) To enable the Boot ROM set the jumper 8 of jumper block SW3 to position ON.
 
-The jumpers 1 and 2 probably add 0x0800, 0x1000 and 0x1800 to RAM adders.
+The jumpers 1 and 2 probably add 0x0800, 0x1000 and 0x1800 to RAM address.
 
 Setting the Interrupt Line
 --------------------------
diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index 46d2210..2dac110 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -1125,7 +1125,7 @@ supported currently at the toplevel.
                                  * an arbitrary array of bytes
                                  */
 
-  childnode@addresss {	/* define a child node named "childnode"
+  childnode@address {	/* define a child node named "childnode"
                                  * whose unit name is "childnode at
 				 * address"
                                  */
diff --git a/Documentation/scsi/ChangeLog.megaraid b/Documentation/scsi/ChangeLog.megaraid
index 38e9e7c..773ebe7 100644
--- a/Documentation/scsi/ChangeLog.megaraid
+++ b/Documentation/scsi/ChangeLog.megaraid
@@ -84,7 +84,7 @@ Older Version	: 2.20.4.8 (scsi module), 2.20.2.6 (cmm module)
 
 3.	One of member in the data structure of the driver leads unaligne
 	issue on 64-bit platform.
-	Customer reporeted "kernel unaligned access addrss" issue when
+	Customer reporeted "kernel unaligned access address" issue when
 	application communicates with MegaRAID HBA driver.
 	Root Cause: in uioc_t structure, one of member had misaligned and it
 	led system to display the error message.
diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index 53dd2f1..e74f82e 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -443,7 +443,7 @@ marvel_init_arch(void)
 {
 	struct io7 *io7;
 
-	/* With multiple PCI busses, we play with I/O as physical addrs.  */
+	/* With multiple PCI busses, we play with I/O as physical address.  */
 	ioport_resource.end = ~0UL;
 
 	/* PCI DMA Direct Mapping is 1GB at 2GB.  */
diff --git a/arch/alpha/kernel/core_mcpcia.c b/arch/alpha/kernel/core_mcpcia.c
index 381fec0..6b42d26 100644
--- a/arch/alpha/kernel/core_mcpcia.c
+++ b/arch/alpha/kernel/core_mcpcia.c
@@ -400,7 +400,7 @@ mcpcia_startup_hose(struct pci_controller *hose)
 void __init
 mcpcia_init_arch(void)
 {
-	/* With multiple PCI busses, we play with I/O as physical addrs.  */
+	/* With multiple PCI busses, we play with I/O as physical address.  */
 	ioport_resource.end = ~0UL;
 
 	/* Allocate hose 0.  That's the one that all the ISA junk hangs
diff --git a/arch/alpha/kernel/core_titan.c b/arch/alpha/kernel/core_titan.c
index 219bf27..33eb13d 100644
--- a/arch/alpha/kernel/core_titan.c
+++ b/arch/alpha/kernel/core_titan.c
@@ -384,7 +384,7 @@ titan_init_arch(void)
 
 	boot_cpuid = __hard_smp_processor_id();
 
-	/* With multiple PCI busses, we play with I/O as physical addrs.  */
+	/* With multiple PCI busses, we play with I/O as physical address.  */
 	ioport_resource.end = ~0UL;
 	iomem_resource.end = ~0UL;
 
diff --git a/arch/alpha/kernel/core_tsunami.c b/arch/alpha/kernel/core_tsunami.c
index 5e7c28f..94419dd 100644
--- a/arch/alpha/kernel/core_tsunami.c
+++ b/arch/alpha/kernel/core_tsunami.c
@@ -403,7 +403,7 @@ tsunami_init_arch(void)
 	printk("%s: CSR_STR 0x%lx\n", __func__, TSUNAMI_dchip->str.csr);
 	printk("%s: CSR_DREV 0x%lx\n", __func__, TSUNAMI_dchip->drev.csr);
 #endif
-	/* With multiple PCI busses, we play with I/O as physical addrs.  */
+	/* With multiple PCI busses, we play with I/O as physical address.  */
 	ioport_resource.end = ~0UL;
 
 	/* Find how many hoses we have, and initialize them.  TSUNAMI
diff --git a/arch/alpha/kernel/core_wildfire.c b/arch/alpha/kernel/core_wildfire.c
index 7e07244..9e7ebc7 100644
--- a/arch/alpha/kernel/core_wildfire.c
+++ b/arch/alpha/kernel/core_wildfire.c
@@ -304,7 +304,7 @@ wildfire_init_arch(void)
 {
 	int qbbno;
 
-	/* With multiple PCI buses, we play with I/O as physical addrs.  */
+	/* With multiple PCI buses, we play with I/O as physical address.  */
 	ioport_resource.end = ~0UL;
 
 
diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
index 7974baa..2ee1e1c 100644
--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -236,7 +236,7 @@ static struct resource it8152_mem = {
 
 /*
  * The following functions are needed for DMA bouncing.
- * ITE8152 chip can addrees up to 64MByte, so all the devices
+ * ITE8152 chip can address up to 64MByte, so all the devices
  * connected to ITE8152 (PCI and USB) should have limited DMA window
  */
 
diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
index cbf334d..d67e2f8 100644
--- a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
@@ -28,7 +28,7 @@
 
 /* Data type for DMA Link List Item */
 typedef struct {
-	uint32_t sar;		/* Source Adress Register.
+	uint32_t sar;		/* Source Address Register.
 				   Address must be aligned to CTLx.SRC_TR_WIDTH.             */
 	uint32_t dar;		/* Destination Address Register.
 				   Address must be aligned to CTLx.DST_TR_WIDTH.             */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
index 891cea8..f1ecf96 100644
--- a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
@@ -35,7 +35,7 @@ typedef struct {
 
 /* Data type representing DMA channel registers */
 typedef struct {
-	dmacHw_REG64_t ChannelSar;	/*  Source Adress Register. 64 bits (upper 32 bits are reserved)
+	dmacHw_REG64_t ChannelSar;	/*  Source Address Register. 64 bits (upper 32 bits are reserved)
 					   Address must be aligned to CTLx.SRC_TR_WIDTH.
 					 */
 	dmacHw_REG64_t ChannelDar;	/*  Destination Address Register.64 bits (upper 32 bits are reserved)
diff --git a/arch/arm/mach-pxa/include/mach/sharpsl.h b/arch/arm/mach-pxa/include/mach/sharpsl.h
index 8242e14..8e05586 100644
--- a/arch/arm/mach-pxa/include/mach/sharpsl.h
+++ b/arch/arm/mach-pxa/include/mach/sharpsl.h
@@ -7,7 +7,7 @@ unsigned long corgi_ssp_ads7846_get(void);
 void corgi_ssp_ads7846_put(unsigned long data);
 void corgi_ssp_ads7846_lock(void);
 void corgi_ssp_ads7846_unlock(void);
-void corgi_ssp_lcdtg_send (unsigned char adrs, unsigned char data);
+void corgi_ssp_lcdtg_send (unsigned char address, unsigned char data);
 void corgi_ssp_blduty_set(int duty);
 int corgi_ssp_max1111_get(unsigned long data);
 
diff --git a/arch/arm/mach-u300/include/mach/coh901318.h b/arch/arm/mach-u300/include/mach/coh901318.h
index 193da2d..2013d2b 100644
--- a/arch/arm/mach-u300/include/mach/coh901318.h
+++ b/arch/arm/mach-u300/include/mach/coh901318.h
@@ -24,7 +24,7 @@
  * @src_addr: transfer source address
  * @dst_addr: transfer destination address
  * @link_addr:  physical address to next lli
- * @virt_link_addr: virtual addres of next lli (only used by pool_free)
+ * @virt_link_addr: virtual address of next lli (only used by pool_free)
  * @phy_this: physical address of current lli (only used by pool_free)
  */
 struct coh901318_lli {
diff --git a/arch/blackfin/kernel/ftrace.c b/arch/blackfin/kernel/ftrace.c
index a61d948..7b0de42 100644
--- a/arch/blackfin/kernel/ftrace.c
+++ b/arch/blackfin/kernel/ftrace.c
@@ -13,7 +13,7 @@
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 /*
- * Hook the return address and push it in the stack of return addrs
+ * Hook the return address and push it in the stack of return address
  * in current thread info.
  */
 void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
diff --git a/arch/blackfin/lib/memcmp.S b/arch/blackfin/lib/memcmp.S
index ce5b9f1..bbcb69c 100644
--- a/arch/blackfin/lib/memcmp.S
+++ b/arch/blackfin/lib/memcmp.S
@@ -29,7 +29,7 @@ ENTRY(_memcmp)
 	R1 = R1 | R0;		/* OR addresses together */
 	R1 <<= 30;		/* check bottom two bits */
 	CC =  AZ;			/* AZ set if zero. */
-	IF !CC JUMP .Lbytes ;	/* Jump if addrs not aligned. */
+	IF !CC JUMP .Lbytes ;	/* Jump if address not aligned. */
 
 	P1 = P2 >> 2;		/* count = n/4 */
 	R3 =  3;
diff --git a/arch/blackfin/lib/memmove.S b/arch/blackfin/lib/memmove.S
index 80c240a..e8a9538 100644
--- a/arch/blackfin/lib/memmove.S
+++ b/arch/blackfin/lib/memmove.S
@@ -36,7 +36,7 @@ ENTRY(_memmove)
 	R3 = R1 | R0;             /* OR addresses together */
 	R3 <<= 30;                /* check bottom two bits */
 	CC =  AZ;                 /* AZ set if zero.*/
-	IF !CC JUMP .Lbytes;      /* Jump if addrs not aligned.*/
+	IF !CC JUMP .Lbytes;      /* Jump if address not aligned.*/
 
 	I0 = P3;
 	P1 = P2 >> 2;             /* count = n/4 */
diff --git a/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h b/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
index 9241205..f889fa5 100644
--- a/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
+++ b/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
@@ -1324,7 +1324,7 @@
 #define	SADD_LEN	0x0002		/* Slave Address Length							*/
 #define	STDVAL		0x0004		/* Slave Transmit Data Valid					*/
 #define	NAK			0x0008		/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010		/* General Call Adrress Matching Enabled		*/
+#define	GEN			0x0010		/* General Call Address Matching Enabled		*/
 
 /* TWI_SLAVE_STAT Masks															*/
 #define	SDIR		0x0001		/* Slave Transfer Direction (Transmit/Receive*)	*/
diff --git a/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h b/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
index 8b18b53..25b4914 100644
--- a/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
+++ b/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
@@ -1333,7 +1333,7 @@
 #define	SADD_LEN	0x0002		/* Slave Address Length							*/
 #define	STDVAL		0x0004		/* Slave Transmit Data Valid					*/
 #define	NAK			0x0008		/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010		/* General Call Adrress Matching Enabled		*/
+#define	GEN			0x0010		/* General Call Address Matching Enabled		*/
 
 /* TWI_SLAVE_STAT Masks															*/
 #define	SDIR		0x0001		/* Slave Transfer Direction (Transmit/Receive*)	*/
diff --git a/arch/blackfin/mach-bf537/include/mach/defBF534.h b/arch/blackfin/mach-bf537/include/mach/defBF534.h
index cf396ea..b20edfc 100644
--- a/arch/blackfin/mach-bf537/include/mach/defBF534.h
+++ b/arch/blackfin/mach-bf537/include/mach/defBF534.h
@@ -1647,7 +1647,7 @@
 #define	SADD_LEN	0x0002	/* Slave Address Length                                                 */
 #define	STDVAL		0x0004	/* Slave Transmit Data Valid                                    */
 #define	NAK			0x0008	/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010	/* General Call Adrress Matching Enabled                */
+#define	GEN			0x0010	/* General Call Address Matching Enabled                */
 
 /* TWI_SLAVE_STAT Masks															*/
 #define	SDIR		0x0001	/* Slave Transfer Direction (Transmit/Receive*) */
diff --git a/arch/blackfin/mach-bf538/include/mach/defBF539.h b/arch/blackfin/mach-bf538/include/mach/defBF539.h
index d7061d9..182c840 100644
--- a/arch/blackfin/mach-bf538/include/mach/defBF539.h
+++ b/arch/blackfin/mach-bf538/include/mach/defBF539.h
@@ -2363,7 +2363,7 @@
 #define	SADD_LEN	0x0002		/* Slave Address Length */
 #define	STDVAL		0x0004		/* Slave Transmit Data Valid */
 #define	NAK			0x0008		/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010		/* General Call	Adrress	Matching Enabled */
+#define	GEN			0x0010		/* General Call	Address	Matching Enabled */
 
 /* TWIx_SLAVE_STAT Masks								 */
 #define	SDIR		0x0001		/* Slave Transfer Direction (Transmit/Receive*) */
diff --git a/arch/cris/arch-v32/lib/nand_init.S b/arch/cris/arch-v32/lib/nand_init.S
index e705f5c..d671fed 100644
--- a/arch/cris/arch-v32/lib/nand_init.S
+++ b/arch/cris/arch-v32/lib/nand_init.S
@@ -139,7 +139,7 @@ copy_nand_to_ram:
 	lsrq	8, $r4
 	move.b	$r4, [$r1]	; Row address
 	lsrq	8, $r4
-	move.b	$r4, [$r1]	; Row adddress
+	move.b	$r4, [$r1]	; Row address
 	moveq	20, $r4
 2:	bne	2b
 	subq	1, $r4
diff --git a/arch/ia64/include/asm/sn/leds.h b/arch/ia64/include/asm/sn/leds.h
index 66cf8c4..c01cabb 100644
--- a/arch/ia64/include/asm/sn/leds.h
+++ b/arch/ia64/include/asm/sn/leds.h
@@ -7,7 +7,7 @@
 #ifndef _ASM_IA64_SN_LEDS_H
 #define _ASM_IA64_SN_LEDS_H
 
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/pda.h>
 #include <asm/sn/shub_mmr.h>
 
diff --git a/arch/ia64/include/asm/sn/sn_cpuid.h b/arch/ia64/include/asm/sn/sn_cpuid.h
index a676dd9..e11414c 100644
--- a/arch/ia64/include/asm/sn/sn_cpuid.h
+++ b/arch/ia64/include/asm/sn/sn_cpuid.h
@@ -12,7 +12,7 @@
 #define _ASM_IA64_SN_SN_CPUID_H
 
 #include <linux/smp.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/pda.h>
 #include <asm/intrinsics.h>
 
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 9b109f2..ab4dd09 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -41,7 +41,7 @@
 #include <asm/div64.h>
 #include <asm/tlb.h>
 #include <asm/elf.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/clksupport.h>
 #include <asm/sn/shub_mmr.h>
 
diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
index cb548ee..e3105b5 100644
--- a/arch/ia64/kvm/kvm_fw.c
+++ b/arch/ia64/kvm/kvm_fw.c
@@ -21,7 +21,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/smp.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/clksupport.h>
 #include <asm/sn/shub_mmr.h>
 
diff --git a/arch/ia64/sn/kernel/bte.c b/arch/ia64/sn/kernel/bte.c
index cad775a..d90b145 100644
--- a/arch/ia64/sn/kernel/bte.c
+++ b/arch/ia64/sn/kernel/bte.c
@@ -8,7 +8,7 @@
 
 #include <linux/module.h>
 #include <asm/sn/nodepda.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/sn_cpuid.h>
 #include <asm/sn/pda.h>
diff --git a/arch/ia64/sn/kernel/bte_error.c b/arch/ia64/sn/kernel/bte_error.c
index 4cb09f3..c834e80 100644
--- a/arch/ia64/sn/kernel/bte_error.c
+++ b/arch/ia64/sn/kernel/bte_error.c
@@ -9,7 +9,7 @@
 #include <linux/types.h>
 #include <asm/sn/sn_sal.h>
 #include "ioerror.h"
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/shubio.h>
 #include <asm/sn/geo.h>
 #include "xtalk/xwidgetdev.h"
diff --git a/arch/ia64/sn/kernel/huberror.c b/arch/ia64/sn/kernel/huberror.c
index 08b0d9b..0e7c6e3 100644
--- a/arch/ia64/sn/kernel/huberror.c
+++ b/arch/ia64/sn/kernel/huberror.c
@@ -11,7 +11,7 @@
 #include <asm/delay.h>
 #include <asm/sn/sn_sal.h>
 #include "ioerror.h"
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/shubio.h>
 #include <asm/sn/geo.h>
 #include "xtalk/xwidgetdev.h"
diff --git a/arch/ia64/sn/kernel/io_acpi_init.c b/arch/ia64/sn/kernel/io_acpi_init.c
index 8cdcb17..1ecfad6 100644
--- a/arch/ia64/sn/kernel/io_acpi_init.c
+++ b/arch/ia64/sn/kernel/io_acpi_init.c
@@ -7,7 +7,7 @@
  */
 
 #include <asm/sn/types.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/pcidev.h>
 #include <asm/sn/pcibus_provider_defs.h>
 #include <asm/sn/sn_sal.h>
diff --git a/arch/ia64/sn/kernel/io_common.c b/arch/ia64/sn/kernel/io_common.c
index 4433dd0..a749046 100644
--- a/arch/ia64/sn/kernel/io_common.c
+++ b/arch/ia64/sn/kernel/io_common.c
@@ -9,7 +9,7 @@
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <asm/sn/types.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/sn_feature_sets.h>
 #include <asm/sn/geo.h>
 #include <asm/sn/io.h>
diff --git a/arch/ia64/sn/kernel/io_init.c b/arch/ia64/sn/kernel/io_init.c
index 98079f2..e23b2d4 100644
--- a/arch/ia64/sn/kernel/io_init.c
+++ b/arch/ia64/sn/kernel/io_init.c
@@ -8,7 +8,7 @@
 
 #include <linux/slab.h>
 #include <asm/sn/types.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/io.h>
 #include <asm/sn/module.h>
 #include <asm/sn/intr.h>
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 13c15d9..002870c 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/rculist.h>
 #include <linux/slab.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/pcibr_provider.h>
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index ebfdd6a..f20ece7 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -13,7 +13,7 @@
 #include <linux/msi.h>
 #include <linux/slab.h>
 
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/pcibus_provider_defs.h>
 #include <asm/sn/pcidev.h>
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index dbc4cbe..334e143 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -37,7 +37,7 @@
 #include <asm/processor.h>
 #include <asm/vga.h>
 #include <asm/sn/arch.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/pda.h>
 #include <asm/sn/nodepda.h>
 #include <asm/sn/sn_cpuid.h>
diff --git a/arch/ia64/sn/kernel/sn2/prominfo_proc.c b/arch/ia64/sn/kernel/sn2/prominfo_proc.c
index e633288..9415588 100644
--- a/arch/ia64/sn/kernel/sn2/prominfo_proc.c
+++ b/arch/ia64/sn/kernel/sn2/prominfo_proc.c
@@ -16,7 +16,7 @@
 #include <asm/io.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/sn/sn_cpuid.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 
 MODULE_DESCRIPTION("PROM version reporting for /proc");
 MODULE_AUTHOR("Chad Talbott");
diff --git a/arch/ia64/sn/kernel/sn2/sn2_smp.c b/arch/ia64/sn/kernel/sn2/sn2_smp.c
index e884ba4..1d69010 100644
--- a/arch/ia64/sn/kernel/sn2/sn2_smp.c
+++ b/arch/ia64/sn/kernel/sn2/sn2_smp.c
@@ -36,7 +36,7 @@
 #include <asm/current.h>
 #include <asm/sn/sn_cpuid.h>
 #include <asm/sn/sn_sal.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/shub_mmr.h>
 #include <asm/sn/nodepda.h>
 #include <asm/sn/rw_mmr.h>
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index fa1ecee..a82e8d8 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -43,7 +43,7 @@
 #include <asm/sn/module.h>
 #include <asm/sn/geo.h>
 #include <asm/sn/sn2/sn_hwperf.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 
 static void *sn_hwperf_salheap = NULL;
 static int sn_hwperf_obj_cnt = 0;
diff --git a/arch/ia64/sn/kernel/tiocx.c b/arch/ia64/sn/kernel/tiocx.c
index c1bd1cf..c9216ab 100644
--- a/arch/ia64/sn/kernel/tiocx.c
+++ b/arch/ia64/sn/kernel/tiocx.c
@@ -17,7 +17,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/sn/sn_sal.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/io.h>
 #include <asm/sn/types.h>
 #include <asm/sn/shubio.h>
diff --git a/arch/ia64/sn/pci/pcibr/pcibr_dma.c b/arch/ia64/sn/pci/pcibr/pcibr_dma.c
index c659ad5..d166a64 100644
--- a/arch/ia64/sn/pci/pcibr/pcibr_dma.c
+++ b/arch/ia64/sn/pci/pcibr/pcibr_dma.c
@@ -8,7 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/geo.h>
 #include <asm/sn/pcibr_provider.h>
 #include <asm/sn/pcibus_provider_defs.h>
diff --git a/arch/ia64/sn/pci/pcibr/pcibr_provider.c b/arch/ia64/sn/pci/pcibr/pcibr_provider.c
index 3cb5cf3..0f904a9 100644
--- a/arch/ia64/sn/pci/pcibr/pcibr_provider.c
+++ b/arch/ia64/sn/pci/pcibr/pcibr_provider.c
@@ -10,7 +10,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/geo.h>
 #include <asm/sn/pcibr_provider.h>
 #include <asm/sn/pcibus_provider_defs.h>
diff --git a/arch/ia64/sn/pci/tioca_provider.c b/arch/ia64/sn/pci/tioca_provider.c
index 4d4536e..662cef6 100644
--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -12,7 +12,7 @@
 #include <linux/bitmap.h>
 #include <linux/slab.h>
 #include <asm/sn/sn_sal.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/io.h>
 #include <asm/sn/pcidev.h>
 #include <asm/sn/pcibus_provider_defs.h>
diff --git a/arch/ia64/sn/pci/tioce_provider.c b/arch/ia64/sn/pci/tioce_provider.c
index 27faba0..6041b85 100644
--- a/arch/ia64/sn/pci/tioce_provider.c
+++ b/arch/ia64/sn/pci/tioce_provider.c
@@ -11,7 +11,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <asm/sn/sn_sal.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/io.h>
 #include <asm/sn/pcidev.h>
 #include <asm/sn/pcibus_provider_defs.h>
diff --git a/arch/m68k/ifpsp060/src/isp.S b/arch/m68k/ifpsp060/src/isp.S
index 6dccda7..cbd2f46 100644
--- a/arch/m68k/ifpsp060/src/isp.S
+++ b/arch/m68k/ifpsp060/src/isp.S
@@ -2923,7 +2923,7 @@ cr_cas2:
 #			    (external to package)			#
 #	_isp_cas_terminate(): create access error stack frame on fault	#
 #			      (external and internal to package)	#
-#	_isp_cas_inrange(): checks whether instr addess is within range	#
+#	_isp_cas_inrange(): checks whether instr address is within range	#
 #			    of core cas/cas2emulation code		#
 #			    (external to package)			#
 #									#
diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
index 515feb4..7d1f0cc 100644
--- a/arch/microblaze/kernel/ftrace.c
+++ b/arch/microblaze/kernel/ftrace.c
@@ -16,7 +16,7 @@
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 /*
- * Hook the return address and push it in the stack of return addrs
+ * Hook the return address and push it in the stack of return address
  * in current thread info.
  */
 void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
diff --git a/arch/microblaze/mm/fault.c b/arch/microblaze/mm/fault.c
index bab9229..2879790 100644
--- a/arch/microblaze/mm/fault.c
+++ b/arch/microblaze/mm/fault.c
@@ -241,7 +241,7 @@ survive:
 		current->min_flt++;
 	up_read(&mm->mmap_sem);
 	/*
-	 * keep track of tlb+htab misses that are good addrs but
+	 * keep track of tlb+htab misses that are good address but
 	 * just need pte's created via handle_mm_fault()
 	 * -- Cort
 	 */
diff --git a/arch/microblaze/mm/pgtable.c b/arch/microblaze/mm/pgtable.c
index 59bf233..5ba119a 100644
--- a/arch/microblaze/mm/pgtable.c
+++ b/arch/microblaze/mm/pgtable.c
@@ -90,7 +90,7 @@ static void __iomem *__ioremap(phys_addr_t addr, unsigned long size,
 
 	/*
 	 * Is it already mapped? If the whole area is mapped then we're
-	 * done, otherwise remap it since we want to keep the virt addrs for
+	 * done, otherwise remap it since we want to keep the virt address for
 	 * each request contiguous.
 	 *
 	 * We make the assumption here that if the bottom and top
diff --git a/arch/mips/include/asm/mach-ip27/kernel-entry-init.h b/arch/mips/include/asm/mach-ip27/kernel-entry-init.h
index 624d66c..23931ba 100644
--- a/arch/mips/include/asm/mach-ip27/kernel-entry-init.h
+++ b/arch/mips/include/asm/mach-ip27/kernel-entry-init.h
@@ -9,7 +9,7 @@
 #ifndef __ASM_MACH_IP27_KERNEL_ENTRY_H
 #define __ASM_MACH_IP27_KERNEL_ENTRY_H
 
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/sn0/hubni.h>
 #include <asm/sn/klkernvars.h>
 
diff --git a/arch/mips/include/asm/mach-ip27/mmzone.h b/arch/mips/include/asm/mach-ip27/mmzone.h
index 986a3b9..5f544de 100644
--- a/arch/mips/include/asm/mach-ip27/mmzone.h
+++ b/arch/mips/include/asm/mach-ip27/mmzone.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_MACH_MMZONE_H
 #define _ASM_MACH_MMZONE_H
 
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/hub.h>
 
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
index 603eb73..e4cbe8c 100644
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
+++ b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
@@ -1,7 +1,7 @@
 /*
  * Defines for the address space, registers and register configuration
  * (bit masks, access macros etc) for the PMC-Sierra line of MSP products.
- * This file contains addess maps for all the devices in the line of
+ * This file contains address maps for all the devices in the line of
  * products but only has register definitions and configuration masks for
  * registers which aren't definitely associated with any device.  Things
  * like clock settings, reset access, the ELB etc.  Individual device
diff --git a/arch/mips/include/asm/sgi/mc.h b/arch/mips/include/asm/sgi/mc.h
index 1576c23..5dc473f 100644
--- a/arch/mips/include/asm/sgi/mc.h
+++ b/arch/mips/include/asm/sgi/mc.h
@@ -151,7 +151,7 @@ struct sgimc_regs {
 
 	/* GIO dma control registers. */
 	u32 _unused22[15];
-	volatile u32 gio_dma_trans;	/* DMA mask to translation GIO addrs */
+	volatile u32 gio_dma_trans;	/* DMA mask to translation GIO address */
 	u32 _unused23;
 	volatile u32 gio_dma_sbits;	/* DMA GIO addr substitution bits */
 	u32 _unused24;
diff --git a/arch/mips/include/asm/sn/addrs.h b/arch/mips/include/asm/sn/addrs.h
index 2367b56..7eacb21 100644
--- a/arch/mips/include/asm/sn/addrs.h
+++ b/arch/mips/include/asm/sn/addrs.h
@@ -19,9 +19,9 @@
 #include <asm/sn/kldir.h>
 
 #if defined(CONFIG_SGI_IP27)
-#include <asm/sn/sn0/addrs.h>
+#include <asm/sn/sn0/address.h>
 #elif defined(CONFIG_SGI_IP35)
-#include <asm/sn/sn1/addrs.h>
+#include <asm/sn/sn1/address.h>
 #endif
 
 
diff --git a/arch/mips/include/asm/sn/agent.h b/arch/mips/include/asm/sn/agent.h
index ac4ea85..93c7705 100644
--- a/arch/mips/include/asm/sn/agent.h
+++ b/arch/mips/include/asm/sn/agent.h
@@ -12,7 +12,7 @@
 #define _ASM_SGI_SN_AGENT_H
 
 #include <linux/topology.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/arch.h>
 
 #if defined(CONFIG_SGI_IP27)
diff --git a/arch/mips/include/asm/sn/gda.h b/arch/mips/include/asm/sn/gda.h
index 9cb6ff7..be88d66 100644
--- a/arch/mips/include/asm/sn/gda.h
+++ b/arch/mips/include/asm/sn/gda.h
@@ -14,7 +14,7 @@
 #ifndef _ASM_SN_GDA_H
 #define _ASM_SN_GDA_H
 
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 
 #define GDA_MAGIC	0x58464552
 
diff --git a/arch/mips/include/asm/sn/klconfig.h b/arch/mips/include/asm/sn/klconfig.h
index 09e590d..48af280 100644
--- a/arch/mips/include/asm/sn/klconfig.h
+++ b/arch/mips/include/asm/sn/klconfig.h
@@ -32,7 +32,7 @@
 
 #if defined(CONFIG_SGI_IP27)
 
-#include <asm/sn/sn0/addrs.h>
+#include <asm/sn/sn0/address.h>
 //#include <sys/SN/router.h>
 // XXX Stolen from <sys/SN/router.h>:
 #define MAX_ROUTER_PORTS (6)    /* Max. number of ports on a router */
@@ -42,7 +42,7 @@
 
 #elif defined(CONFIG_SGI_IP35)
 
-#include <asm/sn/sn1/addrs.h>
+#include <asm/sn/sn1/address.h>
 #include <sys/sn/router.h>
 #include <sys/graph.h>
 #include <asm/xtalk/xbow.h>
diff --git a/arch/mips/include/asm/sn/launch.h b/arch/mips/include/asm/sn/launch.h
index b7c2226..4f5ff75 100644
--- a/arch/mips/include/asm/sn/launch.h
+++ b/arch/mips/include/asm/sn/launch.h
@@ -10,7 +10,7 @@
 #define _ASM_SN_LAUNCH_H
 
 #include <asm/sn/types.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 
 /*
  * The launch data structure resides at a fixed place in each node's memory
diff --git a/arch/mips/include/asm/sn/nmi.h b/arch/mips/include/asm/sn/nmi.h
index 1af4989..f68a1db 100644
--- a/arch/mips/include/asm/sn/nmi.h
+++ b/arch/mips/include/asm/sn/nmi.h
@@ -10,7 +10,7 @@
 #ifndef __ASM_SN_NMI_H
 #define __ASM_SN_NMI_H
 
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 
 /*
  * The launch data structure resides at a fixed place in each node's memory
diff --git a/arch/mips/include/asm/sn/sn0/addrs.h b/arch/mips/include/asm/sn/sn0/addrs.h
index b061900..90a596e 100644
--- a/arch/mips/include/asm/sn/sn0/addrs.h
+++ b/arch/mips/include/asm/sn/sn0/addrs.h
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Derived from IRIX <sys/SN/SN0/addrs.h>, revision 1.126.
+ * Derived from IRIX <sys/SN/SN0/address.h>, revision 1.126.
  *
  * Copyright (C) 1992 - 1997, 1999 Silicon Graphics, Inc.
  * Copyright (C) 1999 by Ralf Baechle
diff --git a/arch/mips/include/asm/sn/sn0/hub.h b/arch/mips/include/asm/sn/sn0/hub.h
index 3e228f8..c6cf51a 100644
--- a/arch/mips/include/asm/sn/sn0/hub.h
+++ b/arch/mips/include/asm/sn/sn0/hub.h
@@ -24,7 +24,7 @@
 
 #define MAX_HUB_PATH		80
 
-#include <asm/sn/sn0/addrs.h>
+#include <asm/sn/sn0/address.h>
 #include <asm/sn/sn0/hubpi.h>
 #include <asm/sn/sn0/hubmd.h>
 #include <asm/sn/sn0/hubio.h>
diff --git a/arch/mips/include/asm/sn/sn0/ip27.h b/arch/mips/include/asm/sn/sn0/ip27.h
index 3c97e08..2ec849f 100644
--- a/arch/mips/include/asm/sn/sn0/ip27.h
+++ b/arch/mips/include/asm/sn/sn0/ip27.h
@@ -74,7 +74,7 @@
 #define SCACHE_LINESIZE	128
 #define SCACHE_LINEMASK	(SCACHE_LINESIZE - 1)
 
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 
 #define LED_CYCLE_MASK  0x0f
 #define LED_CYCLE_SHFT  4
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index e9e64e0..0226fb4 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -205,7 +205,7 @@ unsigned long ftrace_get_parent_addr(unsigned long self_addr,
 #endif
 
 /*
- * Hook the return address and push it in the stack of return addrs
+ * Hook the return address and push it in the stack of return address
  * in current thread info.
  */
 void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index 8882e57..71d5f71 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -447,7 +447,7 @@ NESTED(nmi_handler, PT_SIZE, sp)
 	.endm
 
 	BUILD_HANDLER adel ade ade silent		/* #4  */
-	BUILD_HANDLER ades ade ade silent		/* #5  */
+	BUILD_HANDLER address ade ade silent		/* #5  */
 	BUILD_HANDLER ibe be cli silent			/* #6  */
 	BUILD_HANDLER dbe be cli silent			/* #7  */
 	BUILD_HANDLER bp bp sti silent			/* #9  */
diff --git a/arch/mips/pci/pcie-octeon.c b/arch/mips/pci/pcie-octeon.c
index 6aa5c54..77a356e 100644
--- a/arch/mips/pci/pcie-octeon.c
+++ b/arch/mips/pci/pcie-octeon.c
@@ -891,7 +891,7 @@ static int cvmx_pcie_rc_initialize(int pcie_port)
 	mem_access_subid.s.ror = 0;
 	/* Disable Relaxed Ordering for Writes. */
 	mem_access_subid.s.row = 0;
-	/* PCIe Adddress Bits <63:34>. */
+	/* PCIe Address Bits <63:34>. */
 	mem_access_subid.s.ba = 0;
 
 	/*
diff --git a/arch/mips/sgi-ip27/ip27-berr.c b/arch/mips/sgi-ip27/ip27-berr.c
index 04cebad..bbc39bf 100644
--- a/arch/mips/sgi-ip27/ip27-berr.c
+++ b/arch/mips/sgi-ip27/ip27-berr.c
@@ -14,7 +14,7 @@
 #include <linux/sched.h>	/* schow_regs(), force_sig() */
 
 #include <asm/module.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/sn0/hub.h>
 #include <asm/tlbdebug.h>
diff --git a/arch/mips/sgi-ip27/ip27-console.c b/arch/mips/sgi-ip27/ip27-console.c
index 984e561..a820cbd 100644
--- a/arch/mips/sgi-ip27/ip27-console.c
+++ b/arch/mips/sgi-ip27/ip27-console.c
@@ -8,7 +8,7 @@
 #include <linux/init.h>
 
 #include <asm/page.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/sn0/hub.h>
 #include <asm/sn/klconfig.h>
 #include <asm/sn/ioc3.h>
diff --git a/arch/mips/sgi-ip27/ip27-hubio.c b/arch/mips/sgi-ip27/ip27-hubio.c
index a1fa4ab..fc63d26 100644
--- a/arch/mips/sgi-ip27/ip27-hubio.c
+++ b/arch/mips/sgi-ip27/ip27-hubio.c
@@ -9,7 +9,7 @@
 #include <linux/bitops.h>
 #include <linux/string.h>
 #include <linux/mmzone.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/hub.h>
 
diff --git a/arch/mips/sgi-ip27/ip27-init.c b/arch/mips/sgi-ip27/ip27-init.c
index 51d3a4f..5784e2e 100644
--- a/arch/mips/sgi-ip27/ip27-init.c
+++ b/arch/mips/sgi-ip27/ip27-init.c
@@ -18,7 +18,7 @@
 #include <asm/pgtable.h>
 #include <asm/time.h>
 #include <asm/sn/types.h>
-#include <asm/sn/sn0/addrs.h>
+#include <asm/sn/sn0/address.h>
 #include <asm/sn/sn0/hubni.h>
 #include <asm/sn/sn0/hubio.h>
 #include <asm/sn/klconfig.h>
diff --git a/arch/mips/sgi-ip27/ip27-irq.c b/arch/mips/sgi-ip27/ip27-irq.c
index 6a123ea..704a894 100644
--- a/arch/mips/sgi-ip27/ip27-irq.c
+++ b/arch/mips/sgi-ip27/ip27-irq.c
@@ -31,7 +31,7 @@
 
 #include <asm/processor.h>
 #include <asm/pci/bridge.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/agent.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/hub.h>
diff --git a/arch/mips/sgi-ip27/ip27-nmi.c b/arch/mips/sgi-ip27/ip27-nmi.c
index bc4fa8d..182cb05 100644
--- a/arch/mips/sgi-ip27/ip27-nmi.c
+++ b/arch/mips/sgi-ip27/ip27-nmi.c
@@ -5,7 +5,7 @@
 #include <linux/smp.h>
 #include <asm/atomic.h>
 #include <asm/sn/types.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/nmi.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/sn0/hub.h>
diff --git a/arch/mips/sgi-ip27/ip27-reset.c b/arch/mips/sgi-ip27/ip27-reset.c
index c170761..e15152e 100644
--- a/arch/mips/sgi-ip27/ip27-reset.c
+++ b/arch/mips/sgi-ip27/ip27-reset.c
@@ -21,7 +21,7 @@
 #include <asm/reboot.h>
 #include <asm/system.h>
 #include <asm/sgialib.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/gda.h>
 #include <asm/sn/sn0/hub.h>
diff --git a/arch/mips/sgi-ip27/ip27-timer.c b/arch/mips/sgi-ip27/ip27-timer.c
index d6802d6..e7d8aa3 100644
--- a/arch/mips/sgi-ip27/ip27-timer.c
+++ b/arch/mips/sgi-ip27/ip27-timer.c
@@ -22,7 +22,7 @@
 #include <asm/sn/ioc3.h>
 #include <asm/sn/klconfig.h>
 #include <asm/sn/arch.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/sn_private.h>
 #include <asm/sn/sn0/ip27.h>
 #include <asm/sn/sn0/hub.h>
@@ -31,7 +31,7 @@
 
 /* Includes for ioc3_init().  */
 #include <asm/sn/types.h>
-#include <asm/sn/sn0/addrs.h>
+#include <asm/sn/sn0/address.h>
 #include <asm/sn/sn0/hubni.h>
 #include <asm/sn/sn0/hubio.h>
 #include <asm/pci/bridge.h>
diff --git a/arch/mips/sibyte/common/cfe.c b/arch/mips/sibyte/common/cfe.c
index 6343011..b42d8ce 100644
--- a/arch/mips/sibyte/common/cfe.c
+++ b/arch/mips/sibyte/common/cfe.c
@@ -148,7 +148,7 @@ static __init void prom_meminit(void)
 				/*
 				 * memcpy/__copy_user prefetch, which
 				 * will cause a bus error for
-				 * KSEG/KUSEG addrs not backed by RAM.
+				 * KSEG/KUSEG address not backed by RAM.
 				 * Hence, reserve some padding for the
 				 * prefetch distance.
 				 */
diff --git a/arch/mips/txx9/generic/pci.c b/arch/mips/txx9/generic/pci.c
index 9a0be81..96e69a0 100644
--- a/arch/mips/txx9/generic/pci.c
+++ b/arch/mips/txx9/generic/pci.c
@@ -107,7 +107,7 @@ int txx9_pci_mem_high __initdata;
 
 /*
  * allocate pci_controller and resources.
- * mem_base, io_base: physical addresss.  0 for auto assignment.
+ * mem_base, io_base: physical address.  0 for auto assignment.
  * mem_size and io_size means max size on auto assignment.
  * pcic must be &txx9_primary_pcic or NULL.
  */
diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index 9877372..fa17453 100644
--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -103,7 +103,7 @@ unsigned long ftrace_return_to_handler(unsigned long retval0,
 }
 
 /*
- * Hook the return address and push it in the stack of return addrs
+ * Hook the return address and push it in the stack of return address
  * in current thread info.
  */
 void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index ce1f3e4..66112d8 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -532,7 +532,7 @@ extern void mod_return_to_handler(void);
 #endif
 
 /*
- * Hook the return address and push it in the stack of return addrs
+ * Hook the return address and push it in the stack of return address
  * in current thread info.
  */
 void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 6ddb795..391cad7 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -75,23 +75,23 @@ static void of_pci_parse_addrs(struct device_node *node, struct pci_dev *dev)
 	u64 base, size;
 	unsigned int flags;
 	struct resource *res;
-	const u32 *addrs;
+	const u32 *address;
 	u32 i;
 	int proplen;
 
-	addrs = of_get_property(node, "assigned-addresses", &proplen);
-	if (!addrs)
+	address = of_get_property(node, "assigned-addresses", &proplen);
+	if (!address)
 		return;
-	pr_debug("    parse addresses (%d bytes) @ %p\n", proplen, addrs);
-	for (; proplen >= 20; proplen -= 20, addrs += 5) {
-		flags = pci_parse_of_flags(addrs[0], 0);
+	pr_debug("    parse addresses (%d bytes) @ %p\n", proplen, address);
+	for (; proplen >= 20; proplen -= 20, address += 5) {
+		flags = pci_parse_of_flags(address[0], 0);
 		if (!flags)
 			continue;
-		base = of_read_number(&addrs[1], 2);
-		size = of_read_number(&addrs[3], 2);
+		base = of_read_number(&address[1], 2);
+		size = of_read_number(&address[3], 2);
 		if (!size)
 			continue;
-		i = addrs[0] & 0xff;
+		i = address[0] & 0xff;
 		pr_debug("  base: %llx, size: %llx, i: %x\n",
 			 (unsigned long long)base,
 			 (unsigned long long)size, i);
diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index bfc2aba..bc7e547 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -111,7 +111,7 @@ static struct kmem_cache *flash_block_cache = NULL;
  * list as we go.  This list will be put in the
  * rtas_firmware_flash_list var once it is fully read.
  *
- * For convenience as we build the list we use virtual addrs,
+ * For convenience as we build the list we use virtual address,
  * we do not fill in the version number, and the length field
  * is treated as the number of entries currently in the block
  * (i.e. not a byte count).  This is all fixed on release.
@@ -626,7 +626,7 @@ static void rtas_flash_firmware(int reboot_type)
 	/* Update the block_list in place. */
 	image_size = 0;
 	for (f = flist; f; f = next) {
-		/* Translate data addrs to absolute */
+		/* Translate data address to absolute */
 		for (i = 0; i < f->num_blocks; i++) {
 			f->blocks[i].data = (char *)virt_to_abs(f->blocks[i].data);
 			image_size += f->blocks[i].length;
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 8123125..443d4c2 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -478,7 +478,7 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 		eaddr = get_tlb_eaddr(tlbe);
 		gpaddr = get_tlb_raddr(tlbe);
 
-		/* Use the advertised page size to mask effective and real addrs. */
+		/* Use the advertised page size to mask effective and real address. */
 		bytes = get_tlb_bytes(tlbe);
 		eaddr &= ~(bytes - 1);
 		gpaddr &= ~(bytes - 1);
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 9fc02dc..3de267b 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -215,7 +215,7 @@ __ioremap_caller(phys_addr_t addr, unsigned long size, unsigned long flags,
 	/*
 	 * Is it already mapped?  Perhaps overlapped by a previous
 	 * BAT mapping.  If the whole area is mapped then we're done,
-	 * otherwise remap it since we want to keep the virt addrs for
+	 * otherwise remap it since we want to keep the virt address for
 	 * each request contiguous.
 	 *
 	 * We make the assumption here that if the bottom and top
diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index 8547e86..456bf7f 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -298,18 +298,18 @@ void spu_setup_kernel_slbs(struct spu *spu, struct spu_lscsa *lscsa,
 	struct spu_slb slbs[4];
 	int i, nr_slbs = 0;
 	/* start and end addresses of both mappings */
-	void *addrs[] = {
+	void *address[] = {
 		lscsa, (void *)lscsa + sizeof(*lscsa) - 1,
 		code, code + code_size - 1
 	};
 
 	/* check the set of addresses, and create a new entry in the slbs array
 	 * if there isn't already a SLB for that address */
-	for (i = 0; i < ARRAY_SIZE(addrs); i++) {
-		if (__slb_present(slbs, nr_slbs, addrs[i]))
+	for (i = 0; i < ARRAY_SIZE(address); i++) {
+		if (__slb_present(slbs, nr_slbs, address[i]))
 			continue;
 
-		__spu_kernel_slb(addrs[i], &slbs[nr_slbs]);
+		__spu_kernel_slb(address[i], &slbs[nr_slbs]);
 		nr_slbs++;
 	}
 
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index 34b7dc1..49992f6 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -406,7 +406,7 @@ void eeh_mark_slot (struct device_node *dn, int mode_flag)
 	struct pci_dev *dev;
 	dn = find_device_pe (dn);
 
-	/* Back up one, since config addrs might be shared */
+	/* Back up one, since config address might be shared */
 	if (!pcibios_find_pci_bus(dn) && PCI_DN(dn->parent))
 		dn = dn->parent;
 
@@ -440,7 +440,7 @@ void eeh_clear_slot (struct device_node *dn, int mode_flag)
 	
 	dn = find_device_pe (dn);
 	
-	/* Back up one, since config addrs might be shared */
+	/* Back up one, since config address might be shared */
 	if (!pcibios_find_pci_bus(dn) && PCI_DN(dn->parent))
 		dn = dn->parent;
 
diff --git a/arch/powerpc/platforms/pseries/eeh_cache.c b/arch/powerpc/platforms/pseries/eeh_cache.c
index 30b987b..9e2ae6b 100644
--- a/arch/powerpc/platforms/pseries/eeh_cache.c
+++ b/arch/powerpc/platforms/pseries/eeh_cache.c
@@ -302,7 +302,7 @@ void __init pci_addr_cache_build(void)
 	}
 
 #ifdef DEBUG
-	/* Verify tree built up above, echo back the list of addrs. */
+	/* Verify tree built up above, echo back the list of address. */
 	pci_addr_cache_print(&pci_io_addr_cache_root);
 #endif
 }
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 8bad7d5..a8ac2cf 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -63,7 +63,7 @@ static int xmon_gate;
 
 static unsigned long in_xmon __read_mostly = 0;
 
-static unsigned long adrs;
+static unsigned long address;
 static int size = 1;
 #define MAX_DUMP (128 * 1024)
 static unsigned long ndump = 64;
@@ -1054,14 +1054,14 @@ csum(void)
 	unsigned short fcs;
 	unsigned char v;
 
-	if (!scanhex(&adrs))
+	if (!scanhex(&address))
 		return;
 	if (!scanhex(&ncsum))
 		return;
 	fcs = 0xffff;
 	for (i = 0; i < ncsum; ++i) {
-		if (mread(adrs+i, &v, 1) == 0) {
-			printf("csum stopped at %x\n", adrs+i);
+		if (mread(address+i, &v, 1) == 0) {
+			printf("csum stopped at %x\n", address+i);
 			break;
 		}
 		fcs = FCS(fcs, v);
@@ -1507,7 +1507,7 @@ static void cacheflush(void)
 	cmd = inchar();
 	if (cmd != 'i')
 		termch = cmd;
-	scanhex((void *)&adrs);
+	scanhex((void *)&address);
 	if (termch != '\n')
 		termch = 0;
 	nflush = 1;
@@ -1518,11 +1518,11 @@ static void cacheflush(void)
 		sync();
 
 		if (cmd != 'i') {
-			for (; nflush > 0; --nflush, adrs += L1_CACHE_BYTES)
-				cflush((void *) adrs);
+			for (; nflush > 0; --nflush, address += L1_CACHE_BYTES)
+				cflush((void *) address);
 		} else {
-			for (; nflush > 0; --nflush, adrs += L1_CACHE_BYTES)
-				cinval((void *) adrs);
+			for (; nflush > 0; --nflush, address += L1_CACHE_BYTES)
+				cinval((void *) address);
 		}
 		sync();
 		/* wait a little while to see if we get a machine check */
@@ -1667,7 +1667,7 @@ static void super_regs(void)
  * Stuff for reading and writing memory safely
  */
 static int
-mread(unsigned long adrs, void *buf, int size)
+mread(unsigned long address, void *buf, int size)
 {
 	volatile int n;
 	char *p, *q;
@@ -1676,7 +1676,7 @@ mread(unsigned long adrs, void *buf, int size)
 	if (setjmp(bus_error_jmp) == 0) {
 		catch_memory_errors = 1;
 		sync();
-		p = (char *)adrs;
+		p = (char *)address;
 		q = (char *)buf;
 		switch (size) {
 		case 2:
@@ -1704,7 +1704,7 @@ mread(unsigned long adrs, void *buf, int size)
 }
 
 static int
-mwrite(unsigned long adrs, void *buf, int size)
+mwrite(unsigned long address, void *buf, int size)
 {
 	volatile int n;
 	char *p, *q;
@@ -1713,7 +1713,7 @@ mwrite(unsigned long adrs, void *buf, int size)
 	if (setjmp(bus_error_jmp) == 0) {
 		catch_memory_errors = 1;
 		sync();
-		p = (char *) adrs;
+		p = (char *) address;
 		q = (char *) buf;
 		switch (size) {
 		case 2:
@@ -1736,7 +1736,7 @@ mwrite(unsigned long adrs, void *buf, int size)
 		__delay(200);
 		n = size;
 	} else {
-		printf("*** Error writing address %x\n", adrs + n);
+		printf("*** Error writing address %x\n", address + n);
 	}
 	catch_memory_errors = 0;
 	return n;
@@ -1837,7 +1837,7 @@ memex(void)
 	unsigned long n;
 	unsigned char val[16];
 
-	scanhex((void *)&adrs);
+	scanhex((void *)&address);
 	cmd = skipbl();
 	if (cmd == '?') {
 		printf(memex_help_string);
@@ -1863,8 +1863,8 @@ memex(void)
 		size = 8;
 	for(;;){
 		if (!mnoread)
-			n = mread(adrs, val, size);
-		printf(REG"%c", adrs, brev? 'r': ' ');
+			n = mread(address, val, size);
+		printf(REG"%c", address, brev? 'r': ' ');
 		if (!mnoread) {
 			if (brev)
 				byterev(val, size);
@@ -1883,7 +1883,7 @@ memex(void)
 					val[i] = n >> (i * 8);
 				if (!brev)
 					byterev(val, size);
-				mwrite(adrs, val, size);
+				mwrite(address, val, size);
 				inc = size;
 			}
 			cmd = skipbl();
@@ -1902,14 +1902,14 @@ memex(void)
 						val[i] = n >> (i * 8);
 					if (!brev)
 						byterev(val, size);
-					mwrite(adrs, val, size);
-					adrs += size;
+					mwrite(address, val, size);
+					address += size;
 				}
-				adrs -= size;
+				address -= size;
 				inc = size;
 				break;
 			case ',':
-				adrs += size;
+				address += size;
 				break;
 			case '.':
 				mnoread = 0;
@@ -1934,27 +1934,27 @@ memex(void)
 				size = 8;
 				break;
 			case '^':
-				adrs -= size;
+				address -= size;
 				break;
 				break;
 			case '/':
 				if (nslash > 0)
-					adrs -= 1 << nslash;
+					address -= 1 << nslash;
 				else
 					nslash = 0;
 				nslash += 4;
-				adrs += 1 << nslash;
+				address += 1 << nslash;
 				break;
 			case '\\':
 				if (nslash < 0)
-					adrs += 1 << -nslash;
+					address += 1 << -nslash;
 				else
 					nslash = 0;
 				nslash -= 4;
-				adrs -= 1 << -nslash;
+				address -= 1 << -nslash;
 				break;
 			case 'm':
-				scanhex((void *)&adrs);
+				scanhex((void *)&address);
 				break;
 			case 'n':
 				mnoread = 1;
@@ -1965,19 +1965,19 @@ memex(void)
 			case '<':
 				n = size;
 				scanhex(&n);
-				adrs -= n;
+				address -= n;
 				break;
 			case '>':
 				n = size;
 				scanhex(&n);
-				adrs += n;
+				address += n;
 				break;
 			case '?':
 				printf(memex_subcmd_help_string);
 				break;
 			}
 		}
-		adrs += inc;
+		address += inc;
 	}
 }
 
@@ -1996,15 +1996,15 @@ bsesc(void)
 	return c;
 }
 
-static void xmon_rawdump (unsigned long adrs, long ndump)
+static void xmon_rawdump (unsigned long address, long ndump)
 {
 	long n, m, r, nr;
 	unsigned char temp[16];
 
 	for (n = ndump; n > 0;) {
 		r = n < 16? n: 16;
-		nr = mread(adrs, temp, r);
-		adrs += nr;
+		nr = mread(address, temp, r);
+		address += nr;
 		for (m = 0; m < r; ++m) {
 			if (m < nr)
 				printf("%.2x", temp[m]);
@@ -2029,7 +2029,7 @@ dump(void)
 	c = inchar();
 	if ((isxdigit(c) && c != 'f' && c != 'd') || c == '\n')
 		termch = c;
-	scanhex((void *)&adrs);
+	scanhex((void *)&address);
 	if (termch != '\n')
 		termch = 0;
 	if (c == 'i') {
@@ -2038,7 +2038,7 @@ dump(void)
 			nidump = 16;
 		else if (nidump > MAX_DUMP)
 			nidump = MAX_DUMP;
-		adrs += ppc_inst_dump(adrs, nidump, 1);
+		address += ppc_inst_dump(address, nidump, 1);
 		last_cmd = "di\n";
 	} else if (c == 'l') {
 		dump_log_buf();
@@ -2046,8 +2046,8 @@ dump(void)
 		scanhex(&ndump);
 		if (ndump == 0)
 			ndump = 64;
-		xmon_rawdump(adrs, ndump);
-		adrs += ndump;
+		xmon_rawdump(address, ndump);
+		address += ndump;
 		last_cmd = "dr\n";
 	} else {
 		scanhex(&ndump);
@@ -2055,24 +2055,24 @@ dump(void)
 			ndump = 64;
 		else if (ndump > MAX_DUMP)
 			ndump = MAX_DUMP;
-		prdump(adrs, ndump);
-		adrs += ndump;
+		prdump(address, ndump);
+		address += ndump;
 		last_cmd = "d\n";
 	}
 }
 
 static void
-prdump(unsigned long adrs, long ndump)
+prdump(unsigned long address, long ndump)
 {
 	long n, m, c, r, nr;
 	unsigned char temp[16];
 
 	for (n = ndump; n > 0;) {
-		printf(REG, adrs);
+		printf(REG, address);
 		putchar(' ');
 		r = n < 16? n: 16;
-		nr = mread(adrs, temp, r);
-		adrs += nr;
+		nr = mread(address, temp, r);
+		address += nr;
 		for (m = 0; m < r; ++m) {
 		        if ((m & (sizeof(long) - 1)) == 0 && m > 0)
 				putchar(' ');
@@ -2322,7 +2322,7 @@ static void proccall(void)
 			unsigned long, unsigned long, unsigned long);
 	callfunc_t func;
 
-	if (!scanhex(&adrs))
+	if (!scanhex(&address))
 		return;
 	if (termch != '\n')
 		termch = 0;
@@ -2333,7 +2333,7 @@ static void proccall(void)
 			break;
 		termch = 0;
 	}
-	func = (callfunc_t) adrs;
+	func = (callfunc_t) address;
 	ret = 0;
 	if (setjmp(bus_error_jmp) == 0) {
 		catch_memory_errors = 1;
diff --git a/arch/sh/kernel/ftrace.c b/arch/sh/kernel/ftrace.c
index 30e1319..b09ee15 100644
--- a/arch/sh/kernel/ftrace.c
+++ b/arch/sh/kernel/ftrace.c
@@ -324,7 +324,7 @@ int ftrace_disable_ftrace_graph_caller(void)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /*
- * Hook the return address and push it in the stack of return addrs
+ * Hook the return address and push it in the stack of return address
  * in the current thread info.
  *
  * This is the main routine for the function graph tracer. The function
diff --git a/arch/sh/mm/cache-sh5.c b/arch/sh/mm/cache-sh5.c
index eb4cc4e..d1bffbc 100644
--- a/arch/sh/mm/cache-sh5.c
+++ b/arch/sh/mm/cache-sh5.c
@@ -568,7 +568,7 @@ static void sh5_flush_dcache_page(void *page)
 }
 
 /*
- * Flush the range [start,end] of kernel virtual adddress space from
+ * Flush the range [start,end] of kernel virtual address space from
  * the I-cache.  The corresponding range must be purged from the
  * D-cache also because the SH-5 doesn't have cache snooping between
  * the caches.  The addresses will be visible through the superpage
diff --git a/arch/sparc/kernel/ftrace.c b/arch/sparc/kernel/ftrace.c
index 03ab022..82fb149 100644
--- a/arch/sparc/kernel/ftrace.c
+++ b/arch/sparc/kernel/ftrace.c
@@ -121,7 +121,7 @@ int ftrace_disable_ftrace_graph_caller(void)
 #endif /* !CONFIG_DYNAMIC_FTRACE */
 
 /*
- * Hook the return address and push it in the stack of return addrs
+ * Hook the return address and push it in the stack of return address
  * in current thread info.
  */
 unsigned long prepare_ftrace_return(unsigned long parent,
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 8a8363a..2b3ec11 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -203,25 +203,25 @@ static void pci_parse_of_addrs(struct of_device *op,
 			       struct pci_dev *dev)
 {
 	struct resource *op_res;
-	const u32 *addrs;
+	const u32 *address;
 	int proplen;
 
-	addrs = of_get_property(node, "assigned-addresses", &proplen);
-	if (!addrs)
+	address = of_get_property(node, "assigned-addresses", &proplen);
+	if (!address)
 		return;
 	if (ofpci_verbose)
 		printk("    parse addresses (%d bytes) @ %p\n",
-		       proplen, addrs);
+		       proplen, address);
 	op_res = &op->resource[0];
-	for (; proplen >= 20; proplen -= 20, addrs += 5, op_res++) {
+	for (; proplen >= 20; proplen -= 20, address += 5, op_res++) {
 		struct resource *res;
 		unsigned long flags;
 		int i;
 
-		flags = pci_parse_of_flags(addrs[0]);
+		flags = pci_parse_of_flags(address[0]);
 		if (!flags)
 			continue;
-		i = addrs[0] & 0xff;
+		i = address[0] & 0xff;
 		if (ofpci_verbose)
 			printk("  start: %llx, end: %llx, i: %x\n",
 			       op_res->start, op_res->end, i);
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 42ad2ba..1e97709 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -622,7 +622,7 @@ static const char CHAFSR_PERR_msg[] =
 static const char CHAFSR_IERR_msg[] =
 	"Internal processor error";
 static const char CHAFSR_ISAP_msg[] =
-	"System request parity error on incoming addresss";
+	"System request parity error on incoming address";
 static const char CHAFSR_UCU_msg[] =
 	"Uncorrectable E-cache ECC error for ifetch/data";
 static const char CHAFSR_UCC_msg[] =
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index 271de94..b4389a4 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -92,7 +92,7 @@ static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 extern void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
-				  unsigned long adddress)
+				  unsigned long address)
 {
 	___pmd_free_tlb(tlb, pmd);
 }
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index cd37469..ea919d5 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -450,7 +450,7 @@ int ftrace_disable_ftrace_graph_caller(void)
 #endif /* !CONFIG_DYNAMIC_FTRACE */
 
 /*
- * Hook the return address and push it in the stack of return addrs
+ * Hook the return address and push it in the stack of return address
  * in current thread info.
  */
 void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
diff --git a/arch/x86/lguest/i386_head.S b/arch/x86/lguest/i386_head.S
index 4f420c2..ade4375 100644
--- a/arch/x86/lguest/i386_head.S
+++ b/arch/x86/lguest/i386_head.S
@@ -17,7 +17,7 @@
  * if it's set to '1' (lguest's assigned number), then it calls us here.
  *
  * WARNING: be very careful here!  We're running at addresses equal to physical
- * addesses (around 0), not above PAGE_OFFSET as most code expectes
+ * addresses (around 0), not above PAGE_OFFSET as most code expectes
  * (eg. 0xC0000000).  Jumps are relative, so they're OK, but we can't touch any
  * data without remembering to subtract __PAGE_OFFSET!
  *
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index ee9ddeb..96c1154 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -2366,7 +2366,7 @@ static int __devinit ia_init(struct atm_dev *dev)
 	iadev->reass_ram = base + ACTUAL_REASS_RAM_BASE;  
   
 	/* lets print out the above */  
-	IF_INIT(printk("Base addrs: %p %p %p \n %p %p %p %p\n", 
+	IF_INIT(printk("Base address: %p %p %p \n %p %p %p %p\n", 
           iadev->reg,iadev->seg_reg,iadev->reass_reg, 
           iadev->phy, iadev->ram, iadev->seg_ram, 
           iadev->reass_ram);) 
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index ffa888c..55b45bf 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/agp_backend.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/io.h>
 #include <asm/sn/pcidev.h>
 #include <asm/sn/pcibus_provider_defs.h>
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 35603dd..afcd1ab 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1211,7 +1211,7 @@ static int           si_trydefaults = 1;
 static char          *si_type[SI_MAX_PARMS];
 #define MAX_SI_TYPE_STR 30
 static char          si_type_str[MAX_SI_TYPE_STR];
-static unsigned long addrs[SI_MAX_PARMS];
+static unsigned long address[SI_MAX_PARMS];
 static unsigned int num_addrs;
 static unsigned int  ports[SI_MAX_PARMS];
 static unsigned int num_ports;
@@ -1246,8 +1246,8 @@ MODULE_PARM_DESC(type, "Defines the type of each interface, each"
 		 " interface separated by commas.  The types are 'kcs',"
 		 " 'smic', and 'bt'.  For example si_type=kcs,bt will set"
 		 " the first interface to kcs and the second to bt");
-module_param_array(addrs, ulong, &num_addrs, 0);
-MODULE_PARM_DESC(addrs, "Sets the memory address of each interface, the"
+module_param_array(address, ulong, &num_addrs, 0);
+MODULE_PARM_DESC(address, "Sets the memory address of each interface, the"
 		 " addresses separated by commas.  Only use if an interface"
 		 " is in memory.  Otherwise, set it to zero or leave"
 		 " it blank.");
@@ -1829,7 +1829,7 @@ static __devinit void hardcode_find_bmc(void)
 	struct smi_info *info;
 
 	for (i = 0; i < SI_MAX_PARMS; i++) {
-		if (!ports[i] && !addrs[i])
+		if (!ports[i] && !address[i])
 			continue;
 
 		info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -1858,10 +1858,10 @@ static __devinit void hardcode_find_bmc(void)
 			info->io_setup = port_setup;
 			info->io.addr_data = ports[i];
 			info->io.addr_type = IPMI_IO_ADDR_SPACE;
-		} else if (addrs[i]) {
+		} else if (address[i]) {
 			/* A memory port */
 			info->io_setup = mem_setup;
-			info->io.addr_data = addrs[i];
+			info->io.addr_data = address[i];
 			info->io.addr_type = IPMI_MEM_ADDR_SPACE;
 		} else {
 			printk(KERN_WARNING PFX "Interface type specified "
diff --git a/drivers/char/mbcs.c b/drivers/char/mbcs.c
index 83bef4e..12698d0 100644
--- a/drivers/char/mbcs.c
+++ b/drivers/char/mbcs.c
@@ -31,7 +31,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/tiocx.h>
 #include "mbcs.h"
diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index ea7c99f..1f8e1a7 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -36,7 +36,7 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/shub_mmr.h>
 #include <asm/sn/nodepda.h>
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index ecb89d7..d49ee64 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -49,7 +49,7 @@
 #include <asm/atomic.h>
 #include <asm/tlbflush.h>
 #include <asm/uncached.h>
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/mspec.h>
 #include <asm/sn/sn_cpuid.h>
diff --git a/drivers/char/pc8736x_gpio.c b/drivers/char/pc8736x_gpio.c
index 8ecbcc1..bd1a770 100644
--- a/drivers/char/pc8736x_gpio.c
+++ b/drivers/char/pc8736x_gpio.c
@@ -54,7 +54,7 @@ static u8 pc8736x_gpio_shadow[4];
 #define SIO_VLM_UNIT	0x0D
 #define SIO_TMS_UNIT	0x0E
 
-/* config-space addrs to read/write each unit's runtime addr */
+/* config-space address to read/write each unit's runtime addr */
 #define SIO_BASE_HADDR		0x60
 #define SIO_BASE_LADDR		0x61
 
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index 5a22ca6..83720f1 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -3197,7 +3197,7 @@ static void ppc440spe_adma_pq_zero_op(struct ppc440spe_adma_desc_slot *iter,
  * for the PQXOR operation
  */
 static void ppc440spe_adma_pq_set_dest(struct ppc440spe_adma_desc_slot *sw_desc,
-		dma_addr_t *addrs, unsigned long flags)
+		dma_addr_t *address, unsigned long flags)
 {
 	struct ppc440spe_adma_desc_slot *iter;
 	struct ppc440spe_adma_chan *chan;
@@ -3210,12 +3210,12 @@ static void ppc440spe_adma_pq_set_dest(struct ppc440spe_adma_desc_slot *sw_desc,
 	if (flags & DMA_PREP_PQ_DISABLE_P)
 		paddr = 0;
 	else
-		paddr = addrs[0];
+		paddr = address[0];
 
 	if (flags & DMA_PREP_PQ_DISABLE_Q)
 		qaddr = 0;
 	else
-		qaddr = addrs[1];
+		qaddr = address[1];
 
 	if (!paddr || !qaddr)
 		addr = paddr ? paddr : qaddr;
@@ -4087,7 +4087,7 @@ static int ppc440spe_test_raid6(struct ppc440spe_adma_chan *chan)
 	struct ppc440spe_adma_desc_slot *sw_desc, *iter;
 	struct page *pg;
 	char *a;
-	dma_addr_t dma_addr, addrs[2];
+	dma_addr_t dma_addr, address[2];
 	unsigned long op = 0;
 	int rval = 0;
 
@@ -4121,9 +4121,9 @@ static int ppc440spe_test_raid6(struct ppc440spe_adma_chan *chan)
 	/* Setup addresses */
 	ppc440spe_adma_pq_set_src(sw_desc, dma_addr, 0);
 	ppc440spe_adma_pq_set_src_mult(sw_desc, 1, 0, 0);
-	addrs[0] = dma_addr;
-	addrs[1] = 0;
-	ppc440spe_adma_pq_set_dest(sw_desc, addrs, DMA_PREP_PQ_DISABLE_Q);
+	address[0] = dma_addr;
+	address[1] = 0;
+	ppc440spe_adma_pq_set_dest(sw_desc, address, DMA_PREP_PQ_DISABLE_Q);
 
 	async_tx_ack(&sw_desc->async_tx);
 	sw_desc->async_tx.callback = ppc440spe_test_callback;
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index c973004..db1df59 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -47,7 +47,7 @@ static void cell_edac_count_ce(struct mem_ctl_info *mci, int chan, u64 ar)
 	offset = address & ~PAGE_MASK;
 	syndrome = (ar & 0x000000001fe00000ul) >> 21;
 
-	/* TODO: Decoding of the error addresss */
+	/* TODO: Decoding of the error address */
 	edac_mc_handle_ce(mci, csrow->first_page + pfn, offset,
 			  syndrome, 0, chan, "");
 }
@@ -68,7 +68,7 @@ static void cell_edac_count_ue(struct mem_ctl_info *mci, int chan, u64 ar)
 	pfn = address >> PAGE_SHIFT;
 	offset = address & ~PAGE_MASK;
 
-	/* TODO: Decoding of the error addresss */
+	/* TODO: Decoding of the error address */
 	edac_mc_handle_ue(mci, csrow->first_page + pfn, offset, 0, "");
 }
 
diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index 1bc72c3..21a54d0 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -1314,7 +1314,7 @@ typedef struct _GET_ENGINE_CLOCK_PARAMETERS
 typedef struct _READ_EDID_FROM_HW_I2C_DATA_PARAMETERS
 {
   USHORT    usPrescale;         //Ratio between Engine clock and I2C clock
-  USHORT    usVRAMAddress;      //Adress in Frame Buffer where to pace raw EDID
+  USHORT    usVRAMAddress;      //Address in Frame Buffer where to pace raw EDID
   USHORT    usStatus;           //When use output: lower byte EDID checksum, high byte hardware status
                                 //WHen use input:  lower byte as 'byte to read':currently limited to 128byte or 1byte
   UCHAR     ucSlaveAddr;        //Read from which slave
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 31a68b9..88b19b0 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -2155,7 +2155,7 @@ static int ehca_set_pagebuf_fmr(struct ehca_mr_pginfo *pginfo,
 				pginfo->u.fmr.fmr_pgsize;
 			unsigned int j;
 			u64 prev = *kpage;
-			/* check if adrs are contiguous */
+			/* check if address are contiguous */
 			for (j = 1; j < cnt_per_hwpage; j++) {
 				u64 p = phys_to_abs(fmrlist[j] &
 						    ~(pginfo->hwpage_size - 1));
diff --git a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers/infiniband/hw/ipath/ipath_init_chip.c
index 7769382..32bb2d3 100644
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c
+++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c
@@ -440,7 +440,7 @@ done:
 static void init_shadow_tids(struct ipath_devdata *dd)
 {
 	struct page **pages;
-	dma_addr_t *addrs;
+	dma_addr_t *address;
 
 	pages = vmalloc(dd->ipath_cfgports * dd->ipath_rcvtidcnt *
 			sizeof(struct page *));
@@ -451,9 +451,9 @@ static void init_shadow_tids(struct ipath_devdata *dd)
 		return;
 	}
 
-	addrs = vmalloc(dd->ipath_cfgports * dd->ipath_rcvtidcnt *
+	address = vmalloc(dd->ipath_cfgports * dd->ipath_rcvtidcnt *
 			sizeof(dma_addr_t));
-	if (!addrs) {
+	if (!address) {
 		ipath_dev_err(dd, "failed to allocate shadow dma handle "
 			      "array, no expected sends!\n");
 		vfree(pages);
@@ -465,7 +465,7 @@ static void init_shadow_tids(struct ipath_devdata *dd)
 	       sizeof(struct page *));
 
 	dd->ipath_pageshadow = pages;
-	dd->ipath_physshadow = addrs;
+	dd->ipath_physshadow = address;
 }
 
 static void enable_chip(struct ipath_devdata *dd, int reinit)
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 5cc0a9a..c168f3a 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -823,7 +823,7 @@ static void set_allmulti(struct nes_device *nesdev, u32 nic_active_bit)
 	nes_write_indexed(nesdev, NES_IDX_NIC_UNICAST_ALL, nic_active);
 }
 
-#define get_addr(addrs, index) ((addrs) + (index) * ETH_ALEN)
+#define get_addr(address, index) ((address) + (index) * ETH_ALEN)
 
 /**
  * nes_netdev_set_multicast_list
@@ -875,18 +875,18 @@ static void nes_netdev_set_multicast_list(struct net_device *netdev)
 		  mc_count, !!(netdev->flags & IFF_PROMISC),
 		  !!(netdev->flags & IFF_ALLMULTI));
 	if (!mc_all_on) {
-		char *addrs;
+		char *address;
 		int i;
 		struct netdev_hw_addr *ha;
 
-		addrs = kmalloc(ETH_ALEN * mc_count, GFP_ATOMIC);
-		if (!addrs) {
+		address = kmalloc(ETH_ALEN * mc_count, GFP_ATOMIC);
+		if (!address) {
 			set_allmulti(nesdev, nic_active_bit);
 			goto unlock;
 		}
 		i = 0;
 		netdev_for_each_mc_addr(ha, netdev)
-			memcpy(get_addr(addrs, i++), ha->addr, ETH_ALEN);
+			memcpy(get_addr(address, i++), ha->addr, ETH_ALEN);
 
 		perfect_filter_register_address = NES_IDX_PERFECT_FILTER_LOW +
 						pft_entries_preallocated * 0x8;
@@ -894,7 +894,7 @@ static void nes_netdev_set_multicast_list(struct net_device *netdev)
 		     mc_index++) {
 			while (i < mc_count && nesvnic->mcrq_mcast_filter &&
 			((mc_nic_index = nesvnic->mcrq_mcast_filter(nesvnic,
-					get_addr(addrs, i++))) == 0));
+					get_addr(address, i++))) == 0));
 			if (mc_nic_index < 0)
 				mc_nic_index = nesvnic->nic_index;
 			while (nesadapter->pft_mcast_map[mc_index] < 16 &&
@@ -911,7 +911,7 @@ static void nes_netdev_set_multicast_list(struct net_device *netdev)
 			if (mc_index >= max_pft_entries_avaiable)
 				break;
 			if (i < mc_count) {
-				char *addr = get_addr(addrs, i++);
+				char *addr = get_addr(address, i++);
 
 				nes_debug(NES_DBG_NIC_RX, "Assigning MC Address %pM to register 0x%04X nic_idx=%d\n",
 					  addr,
@@ -941,7 +941,7 @@ static void nes_netdev_set_multicast_list(struct net_device *netdev)
 				nesadapter->pft_mcast_map[mc_index] = 255;
 			}
 		}
-		kfree(addrs);
+		kfree(address);
 		/* PFT is not large enough */
 		if (i < mc_count)
 			set_allmulti(nesdev, nic_active_bit);
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 9bc2d74..bafe69b 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -929,7 +929,7 @@ static int nes_setup_virt_qp(struct nes_qp *nesqp, struct nes_pbl *nespbl,
 			(void *)nespbl->pbl_vbase,
 			(unsigned long) nespbl->pbl_pbase);
 	pbl = (__le64 *) nespbl->pbl_vbase; /* points to first pbl entry */
-	/* now lets set the sq_vbase as well as rq_vbase addrs we will assign */
+	/* now lets set the sq_vbase as well as rq_vbase address we will assign */
 	/* the first pbl to be fro the rq_vbase... */
 	rq_pbl_entries = (rq_size * sizeof(struct nes_hw_qp_wqe)) >> 12;
 	sq_pbl_entries = (sq_size * sizeof(struct nes_hw_qp_wqe)) >> 12;
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 9b40f34..1fbc263 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -266,7 +266,7 @@ done:
 static void init_shadow_tids(struct qib_devdata *dd)
 {
 	struct page **pages;
-	dma_addr_t *addrs;
+	dma_addr_t *address;
 
 	pages = vmalloc(dd->cfgctxts * dd->rcvtidcnt * sizeof(struct page *));
 	if (!pages) {
@@ -275,18 +275,18 @@ static void init_shadow_tids(struct qib_devdata *dd)
 		goto bail;
 	}
 
-	addrs = vmalloc(dd->cfgctxts * dd->rcvtidcnt * sizeof(dma_addr_t));
-	if (!addrs) {
+	address = vmalloc(dd->cfgctxts * dd->rcvtidcnt * sizeof(dma_addr_t));
+	if (!address) {
 		qib_dev_err(dd, "failed to allocate shadow dma handle "
 			    "array, no expected sends!\n");
 		goto bail_free;
 	}
 
 	memset(pages, 0, dd->cfgctxts * dd->rcvtidcnt * sizeof(struct page *));
-	memset(addrs, 0, dd->cfgctxts * dd->rcvtidcnt * sizeof(dma_addr_t));
+	memset(address, 0, dd->cfgctxts * dd->rcvtidcnt * sizeof(dma_addr_t));
 
 	dd->pageshadow = pages;
-	dd->physshadow = addrs;
+	dd->physshadow = address;
 	return;
 
 bail_free:
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a948da8..d1ec693 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1774,7 +1774,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		/* If we aborted, we need to abort the
 		 * sync on the 'current' bitmap chunk (there will
 		 * only be one in raid1 resync.
-		 * We can find the current addess in mddev->curr_resync
+		 * We can find the current address in mddev->curr_resync
 		 */
 		if (mddev->curr_resync < max_sector) /* aborted */
 			bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 800800a..ebd42bc 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -102,10 +102,10 @@ static int bristol_frontend_attach(struct dvb_usb_adapter *adap)
 		(10 + adap->id) << 1, &bristol_dib3000mc_config[adap->id])) == NULL ? -ENODEV : 0;
 }
 
-static int eeprom_read(struct i2c_adapter *adap,u8 adrs,u8 *pval)
+static int eeprom_read(struct i2c_adapter *adap,u8 address,u8 *pval)
 {
 	struct i2c_msg msg[2] = {
-		{ .addr = 0x50, .flags = 0,        .buf = &adrs, .len = 1 },
+		{ .addr = 0x50, .flags = 0,        .buf = &address, .len = 1 },
 		{ .addr = 0x50, .flags = I2C_M_RD, .buf = pval,  .len = 1 },
 	};
 	if (i2c_transfer(adap, msg, 2) != 2) return -EREMOTEIO;
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 7af56cd..fb99062 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -3521,7 +3521,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 
 	if (btv->has_saa6588 || saa6588[btv->c.nr]) {
 		/* Probe for RDS receiver chip */
-		static const unsigned short addrs[] = {
+		static const unsigned short address[] = {
 			0x20 >> 1,
 			0x22 >> 1,
 			I2C_CLIENT_END
@@ -3529,7 +3529,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		struct v4l2_subdev *sd;
 
 		sd = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, "saa6588", "saa6588", 0, addrs);
+			&btv->c.i2c_adap, "saa6588", "saa6588", 0, address);
 		btv->has_saa6588 = (sd != NULL);
 	}
 
@@ -3547,14 +3547,14 @@ void __devinit bttv_init_card2(struct bttv *btv)
 
 	case 1: {
 		/* The user specified that we should probe for msp3400 */
-		static const unsigned short addrs[] = {
+		static const unsigned short address[] = {
 			I2C_ADDR_MSP3400 >> 1,
 			I2C_ADDR_MSP3400_ALT >> 1,
 			I2C_CLIENT_END
 		};
 
 		btv->sd_msp34xx = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, "msp3400", "msp3400", 0, addrs);
+			&btv->c.i2c_adap, "msp3400", "msp3400", 0, address);
 		if (btv->sd_msp34xx)
 			return;
 		goto no_audio;
@@ -3562,13 +3562,13 @@ void __devinit bttv_init_card2(struct bttv *btv)
 
 	case 2: {
 		/* The user specified that we should probe for tda7432 */
-		static const unsigned short addrs[] = {
+		static const unsigned short address[] = {
 			I2C_ADDR_TDA7432 >> 1,
 			I2C_CLIENT_END
 		};
 
 		if (v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, "tda7432", "tda7432", 0, addrs))
+				&btv->c.i2c_adap, "tda7432", "tda7432", 0, address))
 			return;
 		goto no_audio;
 	}
@@ -3610,13 +3610,13 @@ void __devinit bttv_init_card2(struct bttv *btv)
 
 	/* it might also be a tda7432. */
 	if (!bttv_tvcards[btv->c.type].no_tda7432) {
-		static const unsigned short addrs[] = {
+		static const unsigned short address[] = {
 			I2C_ADDR_TDA7432 >> 1,
 			I2C_CLIENT_END
 		};
 
 		if (v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, "tda7432", "tda7432", 0, addrs))
+				&btv->c.i2c_adap, "tda7432", "tda7432", 0, address))
 			return;
 	}
 
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 8d6a55e..ec2e371 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -238,7 +238,7 @@ struct cx23885_i2c {
 	struct i2c_client          i2c_client;
 	u32                        i2c_rc;
 
-	/* 885 registers used for raw addess */
+	/* 885 registers used for raw address */
 	u32                        i2c_period;
 	u32                        reg_ctrl;
 	u32                        reg_stat;
diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
index 188841b..ebd5c43 100644
--- a/drivers/media/video/davinci/vpif.h
+++ b/drivers/media/video/davinci/vpif.h
@@ -33,7 +33,7 @@ extern spinlock_t vpif_lock;
 #define regr(reg)               readl((reg) + vpif_base)
 #define regw(value, reg)        writel(value, (reg + vpif_base))
 
-/* Register Addresss Offsets */
+/* Register Address Offsets */
 #define VPIF_PID			(0x0000)
 #define VPIF_CH0_CTRL			(0x0004)
 #define VPIF_CH1_CTRL			(0x0008)
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index da07607..9129a1e 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -264,7 +264,7 @@ static void process_progressive_mode(struct common_obj *common)
 	/* Mark status of the buffer as active */
 	common->next_frm->state = VIDEOBUF_ACTIVE;
 
-	/* Set top and bottom field addrs in VPIF registers */
+	/* Set top and bottom field address in VPIF registers */
 	addr = videobuf_to_dma_contig(common->next_frm);
 	common->set_addr(addr + common->ytop_off,
 				 addr + common->ybtm_off,
diff --git a/drivers/media/video/w9968cf.c b/drivers/media/video/w9968cf.c
index d807eea..2605f8d 100644
--- a/drivers/media/video/w9968cf.c
+++ b/drivers/media/video/w9968cf.c
@@ -3414,7 +3414,7 @@ w9968cf_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
 	struct list_head* ptr;
 	u8 sc = 0; /* number of simultaneous cameras */
 	static unsigned short dev_nr; /* 0 - we are handling device number n */
-	static unsigned short addrs[] = {
+	static unsigned short address[] = {
 		OV7xx0_SID,
 		OV6xx0_SID,
 		I2C_CLIENT_END
@@ -3519,7 +3519,7 @@ w9968cf_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
 	w9968cf_i2c_init(cam);
 	cam->sensor_sd = v4l2_i2c_new_subdev(&cam->v4l2_dev,
 			&cam->i2c_adapter,
-			"ovcamchip", "ovcamchip", 0, addrs);
+			"ovcamchip", "ovcamchip", 0, address);
 
 	usb_set_intfdata(intf, cam);
 	mutex_unlock(&cam->dev_mutex);
diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 98ad012..bdc8487 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -280,7 +280,7 @@ static int ilo_ccb_setup(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 	dma_pa = (char *)roundup((unsigned long)dma_pa, ILO_START_ALIGN);
 
 	/*
-	 * Create two ccb's, one with virt addrs, one with phys addrs.
+	 * Create two ccb's, one with virt address, one with phys address.
 	 * Copy the phys addr ccb to device shared mem.
 	 */
 	ctrl_setup(driver_ccb, NR_QENTRY, L2_QENTRY_SZ);
@@ -323,7 +323,7 @@ static void ilo_ccb_open(struct ilo_hwinfo *hw, struct ccb_data *data, int slot)
 	int pkt_id, pkt_sz;
 	struct ccb *driver_ccb = &data->driver_ccb;
 
-	/* copy the ccb with physical addrs to device memory */
+	/* copy the ccb with physical address to device memory */
 	data->mapped_ccb = (struct ccb __iomem *)
 				(hw->ram_vaddr + (slot * ILOHW_CCB_SZ));
 	memcpy_toio(data->mapped_ccb, &data->ilo_ccb, sizeof(struct ccb));
diff --git a/drivers/misc/hpilo.h b/drivers/misc/hpilo.h
index 247eb38..42ca116 100644
--- a/drivers/misc/hpilo.h
+++ b/drivers/misc/hpilo.h
@@ -128,10 +128,10 @@ struct ccb {
  * Per fd structure used to track the ccb allocated to that dev file.
  */
 struct ccb_data {
-	/* software version of ccb, using virtual addrs */
+	/* software version of ccb, using virtual address */
 	struct ccb  driver_ccb;
 
-	/* hardware version of ccb, using physical addrs */
+	/* hardware version of ccb, using physical address */
 	struct ccb  ilo_ccb;
 
 	/* hardware ccb is written to this shared mapped device memory */
diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index d72a5fb..024d275 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -271,7 +271,7 @@ struct amd_flash_info {
 	const uint16_t cmd_set;
 	const uint32_t regions[6];
 	const uint8_t devtypes;		/* Bitmask for x8, x16 etc. */
-	const uint8_t uaddr;		/* unlock addrs for 8, 16, 32, 64 */
+	const uint8_t uaddr;		/* unlock address for 8, 16, 32, 64 */
 };
 
 #define ERASEINFO(size,blocks) (size<<8)|(blocks-1)
@@ -2060,7 +2060,7 @@ static inline int jedec_match( uint32_t base,
 
 	uaddr = finfo->uaddr;
 
-	DEBUG( MTD_DEBUG_LEVEL3, "MTD %s(): check unlock addrs 0x%.4x 0x%.4x\n",
+	DEBUG( MTD_DEBUG_LEVEL3, "MTD %s(): check unlock address 0x%.4x 0x%.4x\n",
 	       __func__, cfi->addr_unlock1, cfi->addr_unlock2 );
 	if ( MTD_UADDR_UNNECESSARY != uaddr && MTD_UADDR_DONT_CARE != uaddr
 	     && ( unlock_addrs[uaddr].addr1 / cfi->device_type != cfi->addr_unlock1 ||
diff --git a/drivers/net/3c501.h b/drivers/net/3c501.h
index 183fd55..b201eeb 100644
--- a/drivers/net/3c501.h
+++ b/drivers/net/3c501.h
@@ -72,7 +72,7 @@ struct net_local
  *	to avoid bogus rx lockups.
  */
 
-#define RX_NORM 0xA8		/* 0x68 == all addrs, 0xA8 only to me. */
+#define RX_NORM 0xA8		/* 0x68 == all address, 0xA8 only to me. */
 #define RX_PROM 0x68		/* Senior Prom, uhmm promiscuous mode. */
 #define RX_MULT 0xE8		/* Accept multicast packets. */
 #define TX_NORM 0x0A		/* Interrupt on everything that might hang the chip */
diff --git a/drivers/net/3c503.c b/drivers/net/3c503.c
index baac246..0e9fce4 100644
--- a/drivers/net/3c503.c
+++ b/drivers/net/3c503.c
@@ -91,7 +91,7 @@ static const struct ethtool_ops netdev_ethtool_ops;
    */
 static int __init do_el2_probe(struct net_device *dev)
 {
-    int *addr, addrs[] = { 0xddffe, 0xd9ffe, 0xcdffe, 0xc9ffe, 0};
+    int *addr, address[] = { 0xddffe, 0xd9ffe, 0xcdffe, 0xc9ffe, 0};
     int base_addr = dev->base_addr;
     int irq = dev->irq;
 
@@ -100,7 +100,7 @@ static int __init do_el2_probe(struct net_device *dev)
     else if (base_addr != 0)		/* Don't probe at all. */
 	return -ENXIO;
 
-    for (addr = addrs; *addr; addr++) {
+    for (addr = address; *addr; addr++) {
 	void __iomem *p = ioremap(*addr, 1);
 	unsigned base_bits;
 	int i;
diff --git a/drivers/net/3c505.c b/drivers/net/3c505.c
index 88d766e..fe6d001 100644
--- a/drivers/net/3c505.c
+++ b/drivers/net/3c505.c
@@ -1221,7 +1221,7 @@ static void elp_set_mc_list(struct net_device *dev)
 	spin_lock_irqsave(&adapter->lock, flags);
 
 	if (!(dev->flags & (IFF_PROMISC | IFF_ALLMULTI))) {
-		/* send a "load multicast list" command to the board, max 10 addrs/cmd */
+		/* send a "load multicast list" command to the board, max 10 address/cmd */
 		/* if num_addrs==0 the list will be cleared */
 		adapter->tx_pcb.command = CMD_LOAD_MULTICAST_LIST;
 		adapter->tx_pcb.length = 6 * netdev_mc_count(dev);
diff --git a/drivers/net/7990.c b/drivers/net/7990.c
index 903bcb3..b35407c 100644
--- a/drivers/net/7990.c
+++ b/drivers/net/7990.c
@@ -594,7 +594,7 @@ static void lance_load_multicast (struct net_device *dev)
         volatile struct lance_init_block *ib = lp->init_block;
         volatile u16 *mcast_table = (u16 *)&ib->filter;
 	struct netdev_hw_addr *ha;
-        char *addrs;
+        char *address;
         u32 crc;
 
         /* set all multicast bits */
@@ -609,13 +609,13 @@ static void lance_load_multicast (struct net_device *dev)
 
         /* Add addresses */
 	netdev_for_each_mc_addr(ha, dev) {
-		addrs = ha->addr;
+		address = ha->addr;
 
                 /* multicast address? */
-                if (!(*addrs & 1))
+                if (!(*address & 1))
                         continue;
 
-		crc = ether_crc_le(6, addrs);
+		crc = ether_crc_le(6, address);
                 crc = crc >> 26;
                 mcast_table [crc >> 4] |= 1 << (crc & 0xf);
         }
diff --git a/drivers/net/a2065.c b/drivers/net/a2065.c
index f142cc2..557e879 100644
--- a/drivers/net/a2065.c
+++ b/drivers/net/a2065.c
@@ -602,7 +602,7 @@ static void lance_load_multicast (struct net_device *dev)
 	volatile struct lance_init_block *ib = lp->init_block;
 	volatile u16 *mcast_table = (u16 *)&ib->filter;
 	struct netdev_hw_addr *ha;
-	char *addrs;
+	char *address;
 	u32 crc;
 
 	/* set all multicast bits */
@@ -617,13 +617,13 @@ static void lance_load_multicast (struct net_device *dev)
 
 	/* Add addresses */
 	netdev_for_each_mc_addr(ha, dev) {
-		addrs = ha->addr;
+		address = ha->addr;
 
 		/* multicast address? */
-		if (!(*addrs & 1))
+		if (!(*address & 1))
 			continue;
 
-		crc = ether_crc_le(6, addrs);
+		crc = ether_crc_le(6, address);
 		crc = crc >> 26;
 		mcast_table [crc >> 4] |= 1 << (crc & 0xf);
 	}
diff --git a/drivers/net/arm/ether3.c b/drivers/net/arm/ether3.c
index 1361b73..b51e078 100644
--- a/drivers/net/arm/ether3.c
+++ b/drivers/net/arm/ether3.c
@@ -607,7 +607,7 @@ static int ether3_rx(struct net_device *dev, unsigned int maxcnt)
 
 	do {
 		unsigned int this_ptr, status;
-		unsigned char addrs[16];
+		unsigned char address[16];
 
 		/*
 		 * read the first 16 bytes from the buffer.
@@ -628,14 +628,14 @@ static int ether3_rx(struct net_device *dev, unsigned int maxcnt)
 			next_ptr = ntohs(temp_ptr);
 		}
 		ether3_setbuffer(dev, buffer_read, this_ptr);
-		ether3_readbuffer(dev, addrs+2, 12);
+		ether3_readbuffer(dev, address+2, 12);
 
 if (next_ptr < RX_START || next_ptr >= RX_END) {
  int i;
  printk("%s: bad next pointer @%04X: ", dev->name, priv(dev)->rx_head);
  printk("%02X %02X %02X %02X ", next_ptr >> 8, next_ptr & 255, status & 255, status >> 8);
  for (i = 2; i < 14; i++)
-   printk("%02X ", addrs[i]);
+   printk("%02X ", address[i]);
  printk("\n");
  next_ptr = priv(dev)->rx_head;
  break;
@@ -643,8 +643,8 @@ if (next_ptr < RX_START || next_ptr >= RX_END) {
 		/*
  		 * ignore our own packets...
 	 	 */
-		if (!(*(unsigned long *)&dev->dev_addr[0] ^ *(unsigned long *)&addrs[2+6]) &&
-		    !(*(unsigned short *)&dev->dev_addr[4] ^ *(unsigned short *)&addrs[2+10])) {
+		if (!(*(unsigned long *)&dev->dev_addr[0] ^ *(unsigned long *)&address[2+6]) &&
+		    !(*(unsigned short *)&dev->dev_addr[4] ^ *(unsigned short *)&address[2+10])) {
 			maxcnt ++; /* compensate for loopedback packet */
 			ether3_outw(next_ptr >> 8, REG_RECVEND);
 		} else
@@ -663,10 +663,10 @@ if (next_ptr < RX_START || next_ptr >= RX_END) {
 				buf = skb_put(skb, length);
 				ether3_readbuffer(dev, buf + 12, length - 12);
 				ether3_outw(next_ptr >> 8, REG_RECVEND);
-				*(unsigned short *)(buf + 0)	= *(unsigned short *)(addrs + 2);
-				*(unsigned long *)(buf + 2)	= *(unsigned long *)(addrs + 4);
-				*(unsigned long *)(buf + 6)	= *(unsigned long *)(addrs + 8);
-				*(unsigned short *)(buf + 10)	= *(unsigned short *)(addrs + 12);
+				*(unsigned short *)(buf + 0)	= *(unsigned short *)(address + 2);
+				*(unsigned long *)(buf + 2)	= *(unsigned long *)(address + 4);
+				*(unsigned long *)(buf + 6)	= *(unsigned long *)(address + 8);
+				*(unsigned short *)(buf + 10)	= *(unsigned short *)(address + 12);
 				skb->protocol = eth_type_trans(skb, dev);
 				netif_rx(skb);
 				received ++;
diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 368f333..e95d308 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -1250,19 +1250,19 @@ static void bfin_mac_multicast_hash(struct net_device *dev)
 {
 	u32 emac_hashhi, emac_hashlo;
 	struct netdev_hw_addr *ha;
-	char *addrs;
+	char *address;
 	u32 crc;
 
 	emac_hashhi = emac_hashlo = 0;
 
 	netdev_for_each_mc_addr(ha, dev) {
-		addrs = ha->addr;
+		address = ha->addr;
 
 		/* skip non-multicast addresses */
-		if (!(*addrs & 1))
+		if (!(*address & 1))
 			continue;
 
-		crc = ether_crc(ETH_ALEN, addrs);
+		crc = ether_crc(ETH_ALEN, address);
 		crc >>= 26;
 
 		if (crc & 0x20)
diff --git a/drivers/net/bmac.c b/drivers/net/bmac.c
index 959add2..6b15dac 100644
--- a/drivers/net/bmac.c
+++ b/drivers/net/bmac.c
@@ -1014,7 +1014,7 @@ static void bmac_set_multicast(struct net_device *dev)
 static void bmac_set_multicast(struct net_device *dev)
 {
 	struct netdev_hw_addr *ha;
-	char *addrs;
+	char *address;
 	int i;
 	unsigned short rx_cfg;
 	u32 crc;
@@ -1038,12 +1038,12 @@ static void bmac_set_multicast(struct net_device *dev)
 		for(i = 0; i < 4; i++) hash_table[i] = 0;
 
 		netdev_for_each_mc_addr(ha, dev) {
-			addrs = ha->addr;
+			address = ha->addr;
 
-			if(!(*addrs & 1))
+			if(!(*address & 1))
 				continue;
 
-			crc = ether_crc_le(6, addrs);
+			crc = ether_crc_le(6, address);
 			crc >>= 26;
 			hash_table[crc >> 4] |= 1 << (crc & 0xf);
 		}
@@ -1265,7 +1265,7 @@ static int __devinit bmac_probe(struct macio_dev *mdev, const struct of_device_i
 	int is_bmac_plus = ((int)match->data) != 0;
 
 	if (macio_resource_count(mdev) != 3 || macio_irq_count(mdev) != 3) {
-		printk(KERN_ERR "BMAC: can't use, need 3 addrs and 3 intrs\n");
+		printk(KERN_ERR "BMAC: can't use, need 3 address and 3 intrs\n");
 		return -ENODEV;
 	}
 	prop_addr = of_get_property(macio_get_of_node(mdev),
diff --git a/drivers/net/bnx2x_reg.h b/drivers/net/bnx2x_reg.h
index a1f3bf0..d0db947 100644
--- a/drivers/net/bnx2x_reg.h
+++ b/drivers/net/bnx2x_reg.h
@@ -1442,7 +1442,7 @@
    (~misc_registers_sw_timer_cfg_4.sw_timer_cfg_4[1] ) is set */
 #define MISC_REG_SW_TIMER_RELOAD_VAL_4				 0xa2fc
 /* [RW 32] the value of the counter for sw timers1-8. there are 8 addresses
-   in this register. addres 0 - timer 1; address 1 - timer 2, ...  address 7 -
+   in this register. address 0 - timer 1; address 1 - timer 2, ...  address 7 -
    timer 8 */
 #define MISC_REG_SW_TIMER_VAL					 0xa5c0
 /* [RW 1] Set by the MCP to remember if one or more of the drivers is/are
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 822f586..03145a7 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -848,7 +848,7 @@ static int ad_lacpdu_send(struct port *port)
 	lacpdu_header = (struct lacpdu_header *)skb_put(skb, length);
 
 	memcpy(lacpdu_header->hdr.h_dest, lacpdu_mcast_addr, ETH_ALEN);
-	/* Note: source addres is set to be the member's PERMANENT address,
+	/* Note: source address is set to be the member's PERMANENT address,
 	   because we use it to identify loopback lacpdus in receive. */
 	memcpy(lacpdu_header->hdr.h_source, slave->perm_hwaddr, ETH_ALEN);
 	lacpdu_header->hdr.h_proto = PKT_TYPE_LACPDU;
@@ -890,7 +890,7 @@ static int ad_marker_send(struct port *port, struct bond_marker *marker)
 	marker_header = (struct bond_marker_header *)skb_put(skb, length);
 
 	memcpy(marker_header->hdr.h_dest, lacpdu_mcast_addr, ETH_ALEN);
-	/* Note: source addres is set to be the member's PERMANENT address,
+	/* Note: source address is set to be the member's PERMANENT address,
 	   because we use it to identify loopback MARKERs in receive. */
 	memcpy(marker_header->hdr.h_source, slave->perm_hwaddr, ETH_ALEN);
 	marker_header->hdr.h_proto = PKT_TYPE_LACPDU;
diff --git a/drivers/net/bsd_comp.c b/drivers/net/bsd_comp.c
index 88edb98..27703d6 100644
--- a/drivers/net/bsd_comp.c
+++ b/drivers/net/bsd_comp.c
@@ -841,7 +841,7 @@ static int bsd_decompress (void *state, unsigned char *ibuf, int isize,
     unsigned int finchar;
     unsigned char *p;
     unsigned char *wptr;
-    int adrs;
+    int address;
     int ctrl;
     int ilen;
     int codelen;
@@ -859,7 +859,7 @@ static int bsd_decompress (void *state, unsigned char *ibuf, int isize,
      * and then get the sequence number.
      */
 
-    adrs  = PPP_ADDRESS (ibuf);
+    address  = PPP_ADDRESS (ibuf);
     ctrl  = PPP_CONTROL (ibuf);
 
     seq   = (ibuf[4] << 8) + ibuf[5];
@@ -891,7 +891,7 @@ static int bsd_decompress (void *state, unsigned char *ibuf, int isize,
      */
 
     wptr    = obuf;
-    *wptr++ = adrs;
+    *wptr++ = address;
     *wptr++ = ctrl;
     *wptr++ = 0;
 
diff --git a/drivers/net/chelsio/subr.c b/drivers/net/chelsio/subr.c
index 53bde15..ed06fea 100644
--- a/drivers/net/chelsio/subr.c
+++ b/drivers/net/chelsio/subr.c
@@ -561,7 +561,7 @@ struct chelsio_vpd_t {
 #define EEPROM_MAX_POLL   4
 
 /*
- * Read SEEPROM. A zero is written to the flag register when the addres is
+ * Read SEEPROM. A zero is written to the flag register when the address is
  * written to the Control register. The hardware device will set the flag to a
  * one when 4B have been transferred to the Data register.
  */
diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 95a8ba0..a591fed 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -605,7 +605,7 @@ struct t3_vpd {
  *
  *	Read a 32-bit word from a location in VPD EEPROM using the card's PCI
  *	VPD ROM capability.  A zero is written to the flag bit when the
- *	addres is written to the control register.  The hardware device will
+ *	address is written to the control register.  The hardware device will
  *	set the flag to 1 when 4 bytes have been read into the data register.
  */
 int t3_seeprom_read(struct adapter *adapter, u32 addr, __le32 *data)
diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
index 08e82b1..4b67483 100644
--- a/drivers/net/davinci_emac.c
+++ b/drivers/net/davinci_emac.c
@@ -1861,9 +1861,9 @@ static int emac_dev_setmac_addr(struct net_device *ndev, void *addr)
  * @buffer: buffer pointer for descriptor
  * @buf_token: buffer token (stores skb information)
  *
- * Prepares the recycled buffer descriptor and addes it to hardware
+ * Prepares the recycled buffer descriptor and address it to hardware
  * receive queue - if queue empty this descriptor becomes the head
- * else addes the descriptor to end of queue
+ * else address the descriptor to end of queue
  *
  */
 static void emac_addbd_to_rx_queue(struct emac_priv *priv, u32 ch,
diff --git a/drivers/net/declance.c b/drivers/net/declance.c
index 1d973db..ff24344 100644
--- a/drivers/net/declance.c
+++ b/drivers/net/declance.c
@@ -940,7 +940,7 @@ static void lance_load_multicast(struct net_device *dev)
 	struct lance_private *lp = netdev_priv(dev);
 	volatile u16 *ib = (volatile u16 *)dev->mem_start;
 	struct netdev_hw_addr *ha;
-	char *addrs;
+	char *address;
 	u32 crc;
 
 	/* set all multicast bits */
@@ -959,13 +959,13 @@ static void lance_load_multicast(struct net_device *dev)
 
 	/* Add addresses */
 	netdev_for_each_mc_addr(ha, dev) {
-		addrs = ha->addr;
+		address = ha->addr;
 
 		/* multicast address? */
-		if (!(*addrs & 1))
+		if (!(*address & 1))
 			continue;
 
-		crc = ether_crc_le(ETH_ALEN, addrs);
+		crc = ether_crc_le(ETH_ALEN, address);
 		crc = crc >> 26;
 		*lib_ptr(ib, filter[crc >> 4], lp->type) |= 1 << (crc & 0xf);
 	}
diff --git a/drivers/net/defxx.c b/drivers/net/defxx.c
index e5667c5..dde7173 100644
--- a/drivers/net/defxx.c
+++ b/drivers/net/defxx.c
@@ -973,8 +973,8 @@ static int __devinit dfx_driver_init(struct net_device *dev,
 	int dfx_bus_tc = DFX_BUS_TC(bdev);
 	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 	int alloc_size;			/* total buffer size needed */
-	char *top_v, *curr_v;		/* virtual addrs into memory block */
-	dma_addr_t top_p, curr_p;	/* physical addrs into memory block */
+	char *top_v, *curr_v;		/* virtual address into memory block */
+	dma_addr_t top_p, curr_p;	/* physical address into memory block */
 	u32 data;			/* host data register value */
 	__le32 le32;
 	char *board_name = NULL;
@@ -2230,12 +2230,12 @@ static void dfx_ctl_set_multicast_list(struct net_device *dev)
 		if (netdev_mc_count(dev) > (PI_CMD_ADDR_FILTER_K_SIZE - bp->uc_count))
 			{
 			bp->group_prom	= PI_FSTATE_K_PASS;		/* Enable LLC group prom mode */
-			bp->mc_count	= 0;					/* Don't add mc addrs to CAM */
+			bp->mc_count	= 0;					/* Don't add mc address to CAM */
 			}
 		else
 			{
 			bp->group_prom	= PI_FSTATE_K_BLOCK;	/* Disable LLC group prom mode */
-			bp->mc_count	= netdev_mc_count(dev);		/* Add mc addrs to CAM */
+			bp->mc_count	= netdev_mc_count(dev);		/* Add mc address to CAM */
 			}
 
 		/* Copy addresses to multicast address table, then update adapter CAM */
@@ -2330,7 +2330,7 @@ static int dfx_ctl_set_mac_address(struct net_device *dev, void *addr)
 	if ((bp->uc_count + bp->mc_count) > PI_CMD_ADDR_FILTER_K_SIZE)
 		{
 		bp->group_prom	= PI_FSTATE_K_PASS;		/* Enable LLC group prom mode */
-		bp->mc_count	= 0;					/* Don't add mc addrs to CAM */
+		bp->mc_count	= 0;					/* Don't add mc address to CAM */
 
 		/* Update adapter filters */
 
diff --git a/drivers/net/depca.c b/drivers/net/depca.c
index bf66e9b..4a52218 100644
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -1270,7 +1270,7 @@ static void SetMulticastFilter(struct net_device *dev)
 {
 	struct depca_private *lp = netdev_priv(dev);
 	struct netdev_hw_addr *ha;
-	char *addrs;
+	char *address;
 	int i, j, bit, byte;
 	u16 hashcode;
 	u32 crc;
@@ -1285,9 +1285,9 @@ static void SetMulticastFilter(struct net_device *dev)
 		}
 		/* Add multicast addresses */
 		netdev_for_each_mc_addr(ha, dev) {
-			addrs = ha->addr;
-			if ((*addrs & 0x01) == 1) {	/* multicast address? */
-				crc = ether_crc(ETH_ALEN, addrs);
+			address = ha->addr;
+			if ((*address & 0x01) == 1) {	/* multicast address? */
+				crc = ether_crc(ETH_ALEN, address);
 				hashcode = (crc & 1);	/* hashcode is 6 LSb of CRC ... */
 				for (j = 0; j < 5; j++) {	/* ... in reverse order. */
 					hashcode = (hashcode << 1) | ((crc >>= 1) & 1);
diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index b194bad..9500e39 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1423,7 +1423,7 @@ static int e100_phy_init(struct nic *nic)
 	u32 addr;
 	u16 bmcr, stat, id_lo, id_hi, cong;
 
-	/* Discover phy addr by searching addrs in order {1,0,2,..., 31} */
+	/* Discover phy addr by searching address in order {1,0,2,..., 31} */
 	for (addr = 0; addr < 32; addr++) {
 		nic->mii.phy_id = (addr == 0) ? 1 : (addr == 1) ? 0 : addr;
 		bmcr = mdio_read(netdev, nic->mii.phy_id, MII_BMCR);
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index ebdea08..fd8eaab 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -2150,7 +2150,7 @@ static void e1000_set_rx_mode(struct net_device *netdev)
 	 * addresses take precedence to avoid disabling unicast filtering
 	 * when possible.
 	 *
-	 * RAR 0 is used for the station MAC adddress
+	 * RAR 0 is used for the station MAC address
 	 * if there are not 14 addresses, go ahead and clear the filters
 	 */
 	i = 1;
diff --git a/drivers/net/e1000e/phy.c b/drivers/net/e1000e/phy.c
index b4ac82d..7bcb356 100644
--- a/drivers/net/e1000e/phy.c
+++ b/drivers/net/e1000e/phy.c
@@ -2973,7 +2973,7 @@ s32 e1000_write_phy_reg_hv_locked(struct e1000_hw *hw, u32 offset, u16 data)
 }
 
 /**
- *  e1000_get_phy_addr_for_hv_page - Get PHY adrress based on page
+ *  e1000_get_phy_addr_for_hv_page - Get PHY address based on page
  *  @page: page to be accessed
  **/
 static u32 e1000_get_phy_addr_for_hv_page(u32 page)
diff --git a/drivers/net/eepro.c b/drivers/net/eepro.c
index 8d97f16..9be9df6 100644
--- a/drivers/net/eepro.c
+++ b/drivers/net/eepro.c
@@ -1760,7 +1760,7 @@ module_param_array(io, int, NULL, 0);
 module_param_array(irq, int, NULL, 0);
 module_param_array(mem, int, NULL, 0);
 module_param(autodetect, int, 0);
-MODULE_PARM_DESC(io, "EtherExpress Pro/10 I/O base addres(es)");
+MODULE_PARM_DESC(io, "EtherExpress Pro/10 I/O base address(es)");
 MODULE_PARM_DESC(irq, "EtherExpress Pro/10 IRQ number(s)");
 MODULE_PARM_DESC(mem, "EtherExpress Pro/10 Rx buffer size(es) in kB (3-29)");
 MODULE_PARM_DESC(autodetect, "EtherExpress Pro/10 force board(s) detection (0-1)");
diff --git a/drivers/net/enic/enic_main.c b/drivers/net/enic/enic_main.c
index bc7d6b9..fdcc520 100644
--- a/drivers/net/enic/enic_main.c
+++ b/drivers/net/enic/enic_main.c
@@ -919,8 +919,8 @@ static void enic_set_multicast_list(struct net_device *netdev)
 	}
 
 	/* Is there an easier way?  Trying to minimize to
-	 * calls to add/del multicast addrs.  We keep the
-	 * addrs from the last call in enic->mc_addr and
+	 * calls to add/del multicast address.  We keep the
+	 * address from the last call in enic->mc_addr and
 	 * look for changes to add/del.
 	 */
 
diff --git a/drivers/net/ewrk3.c b/drivers/net/ewrk3.c
index 380d061..3e54314 100644
--- a/drivers/net/ewrk3.c
+++ b/drivers/net/ewrk3.c
@@ -1171,7 +1171,7 @@ static void SetMulticastFilter(struct net_device *dev)
 	struct netdev_hw_addr *ha;
 	u_long iobase = dev->base_addr;
 	int i;
-	char *addrs, bit, byte;
+	char *address, bit, byte;
 	short __iomem *p = lp->mctbl;
 	u16 hashcode;
 	u32 crc;
@@ -1213,9 +1213,9 @@ static void SetMulticastFilter(struct net_device *dev)
 
 		/* Update table */
 		netdev_for_each_mc_addr(ha, dev) {
-			addrs = ha->addr;
-			if ((*addrs & 0x01) == 1) {	/* multicast address? */
-				crc = ether_crc_le(ETH_ALEN, addrs);
+			address = ha->addr;
+			if ((*address & 0x01) == 1) {	/* multicast address? */
+				crc = ether_crc_le(ETH_ALEN, address);
 				hashcode = crc & ((1 << 9) - 1);	/* hashcode is 9 LSb of CRC */
 
 				byte = hashcode >> 3;	/* bit[3-8] -> byte in filter */
diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
index 61f2b1c..737ea12 100644
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -610,7 +610,7 @@ static int __devinit hamachi_init_one (struct pci_dev *pdev,
 	}
 
 	base = pci_resource_start(pdev, 0);
-#ifdef __alpha__				/* Really "64 bit addrs" */
+#ifdef __alpha__				/* Really "64 bit address" */
 	base |= (pci_resource_start(pdev, 1) << 32);
 #endif
 
diff --git a/drivers/net/hp100.c b/drivers/net/hp100.c
index dfc787f..8650234 100644
--- a/drivers/net/hp100.c
+++ b/drivers/net/hp100.c
@@ -2094,7 +2094,7 @@ static void hp100_set_multicast_list(struct net_device *dev)
 			memset(&lp->hash_bytes, 0xff, 8);
 		} else {
 			int i, idx;
-			u_char *addrs;
+			u_char *address;
 			struct netdev_hw_addr *ha;
 
 			memset(&lp->hash_bytes, 0x00, 8);
@@ -2103,14 +2103,14 @@ static void hp100_set_multicast_list(struct net_device *dev)
 			       dev->name, netdev_mc_count(dev));
 #endif
 			netdev_for_each_mc_addr(ha, dev) {
-				addrs = ha->addr;
-				if ((*addrs & 0x01) == 0x01) {	/* multicast address? */
+				address = ha->addr;
+				if ((*address & 0x01) == 0x01) {	/* multicast address? */
 #ifdef HP100_DEBUG
 					printk("hp100: %s: multicast = %pM, ",
-						     dev->name, addrs);
+						     dev->name, address);
 #endif
 					for (i = idx = 0; i < 6; i++) {
-						idx ^= *addrs++ & 0x3f;
+						idx ^= *address++ & 0x3f;
 						printk(":%02x:", idx);
 					}
 #ifdef HP100_DEBUG
diff --git a/drivers/net/hp100.h b/drivers/net/hp100.h
index e6ca128..7eb4243 100644
--- a/drivers/net/hp100.h
+++ b/drivers/net/hp100.h
@@ -436,7 +436,7 @@
 #define HP100_KEEP_CRC		0x02	/* 0:No, 1:Yes keep CRC on Rx packets. */
 					/*   The length will reflect this. */
 #define HP100_ACCFA             0x01	/* 1: For 802.5: Accept only functional
-					 * addrs that match FA mask (page1) */
+					 * address that match FA mask (page1) */
 #define HP100_MAC2MODEMASK	0x02
 #define HP100_MAC2MODE1		0x00
 #define HP100_MAC2MODE2		0x00
diff --git a/drivers/net/ixgb/ixgb_hw.h b/drivers/net/ixgb/ixgb_hw.h
index 873d32b..e2c04cb 100644
--- a/drivers/net/ixgb/ixgb_hw.h
+++ b/drivers/net/ixgb/ixgb_hw.h
@@ -673,7 +673,7 @@ struct ixgb_hw {
 	ixgb_phy_type phy_type;	/* Transceiver/phy identifier       */
 	u32 max_frame_size;	/* Maximum frame size supported     */
 	u32 mc_filter_type;	/* Multicast filter hash type       */
-	u32 num_mc_addrs;	/* Number of current Multicast addrs */
+	u32 num_mc_addrs;	/* Number of current Multicast address */
 	u8 curr_mac_addr[IXGB_ETH_LENGTH_OF_ADDRESS];	/* Individual address currently programmed in MAC */
 	u32 num_tx_desc;	/* Number of Transmit descriptors   */
 	u32 num_rx_desc;	/* Number of Receive descriptors    */
diff --git a/drivers/net/ixgbe/ixgbe_common.c b/drivers/net/ixgbe/ixgbe_common.c
index 9595b1b..55e2d67 100644
--- a/drivers/net/ixgbe/ixgbe_common.c
+++ b/drivers/net/ixgbe/ixgbe_common.c
@@ -1355,7 +1355,7 @@ static void ixgbe_add_uc_addr(struct ixgbe_hw *hw, u8 *addr, u32 vmdq)
  *  @hw: pointer to hardware structure
  *  @netdev: pointer to net device structure
  *
- *  The given list replaces any existing list.  Clears the secondary addrs from
+ *  The given list replaces any existing list.  Clears the secondary address from
  *  receive address registers.  Uses unused receive address registers for the
  *  first secondary addresses, and falls back to promiscuous mode as needed.
  *
@@ -1496,7 +1496,7 @@ static void ixgbe_set_mta(struct ixgbe_hw *hw, u8 *mc_addr)
  *  @hw: pointer to hardware structure
  *  @netdev: pointer to net device structure
  *
- *  The given list replaces any existing list. Clears the MC addrs from receive
+ *  The given list replaces any existing list. Clears the MC address from receive
  *  address registers and the multicast table. Uses unused receive address
  *  registers for the first multicast addresses, and hashes the rest into the
  *  multicast table.
diff --git a/drivers/net/korina.c b/drivers/net/korina.c
index c7a9bef..6902de1 100644
--- a/drivers/net/korina.c
+++ b/drivers/net/korina.c
@@ -504,12 +504,12 @@ static void korina_multicast_list(struct net_device *dev)
 			hash_table[i] = 0;
 
 		netdev_for_each_mc_addr(ha, dev) {
-			char *addrs = ha->addr;
+			char *address = ha->addr;
 
-			if (!(*addrs & 1))
+			if (!(*address & 1))
 				continue;
 
-			crc = ether_crc_le(6, addrs);
+			crc = ether_crc_le(6, address);
 			crc >>= 26;
 			hash_table[crc >> 4] |= 1 << (15 - (crc & 0xf));
 		}
diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index 315eb4c..04160c9 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -203,7 +203,7 @@ static int temac_dma_bd_init(struct net_device *ndev)
 
 	lp->rx_skb = kzalloc(sizeof(*lp->rx_skb) * RX_BD_NUM, GFP_KERNEL);
 	/* allocate the tx and rx ring buffer descriptors. */
-	/* returns a virtual addres and a physical address. */
+	/* returns a virtual address and a physical address. */
 	lp->tx_bd_v = dma_alloc_coherent(ndev->dev.parent,
 					 sizeof(*lp->tx_bd_v) * TX_BD_NUM,
 					 &lp->tx_bd_p, GFP_KERNEL);
diff --git a/drivers/net/mace.c b/drivers/net/mace.c
index 1c5221f..75fa308 100644
--- a/drivers/net/mace.c
+++ b/drivers/net/mace.c
@@ -114,7 +114,7 @@ static int __devinit mace_probe(struct macio_dev *mdev, const struct of_device_i
 	int j, rev, rc = -EBUSY;
 
 	if (macio_resource_count(mdev) != 3 || macio_irq_count(mdev) != 3) {
-		printk(KERN_ERR "can't use MACE %s: need 3 addrs and 3 irqs\n",
+		printk(KERN_ERR "can't use MACE %s: need 3 address and 3 irqs\n",
 		       mace->full_name);
 		return -ENODEV;
 	}
diff --git a/drivers/net/niu.h b/drivers/net/niu.h
index d671546..84ddcac 100644
--- a/drivers/net/niu.h
+++ b/drivers/net/niu.h
@@ -1497,7 +1497,7 @@ struct fcram_hash_opt {
 /* EXT=1, FMT=0 */
 struct fcram_hash_ipv4 {
 	u64	header;
-	u64	addrs;
+	u64	address;
 	u64	ports;
 	u64	action;
 };
@@ -1505,7 +1505,7 @@ struct fcram_hash_ipv4 {
 /* EXT=1, FMT=1 */
 struct fcram_hash_ipv6 {
 	u64	header;
-	u64	addrs[4];
+	u64	address[4];
 	u64	ports;
 	u64	action;
 };
diff --git a/drivers/net/pcnet32.c b/drivers/net/pcnet32.c
index c200c28..5f48280 100644
--- a/drivers/net/pcnet32.c
+++ b/drivers/net/pcnet32.c
@@ -2588,7 +2588,7 @@ static void pcnet32_load_multicast(struct net_device *dev)
 	volatile __le16 *mcast_table = (__le16 *)ib->filter;
 	struct netdev_hw_addr *ha;
 	unsigned long ioaddr = dev->base_addr;
-	char *addrs;
+	char *address;
 	int i;
 	u32 crc;
 
@@ -2608,13 +2608,13 @@ static void pcnet32_load_multicast(struct net_device *dev)
 
 	/* Add addresses */
 	netdev_for_each_mc_addr(ha, dev) {
-		addrs = ha->addr;
+		address = ha->addr;
 
 		/* multicast address? */
-		if (!(*addrs & 1))
+		if (!(*address & 1))
 			continue;
 
-		crc = ether_crc_le(6, addrs);
+		crc = ether_crc_le(6, address);
 		crc = crc >> 26;
 		mcast_table[crc >> 4] |= cpu_to_le16(1 << (crc & 0xf));
 	}
diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
index 9a251ac..3084a58 100644
--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -970,12 +970,12 @@ static void r6040_multicast_list(struct net_device *dev)
 			hash_table[i] = 0;
 
 		netdev_for_each_mc_addr(ha, dev) {
-			char *addrs = ha->addr;
+			char *address = ha->addr;
 
-			if (!(*addrs & 1))
+			if (!(*address & 1))
 				continue;
 
-			crc = ether_crc_le(6, addrs);
+			crc = ether_crc_le(6, address);
 			crc >>= 26;
 			hash_table[crc >> 4] |= 1 << (15 - (crc & 0xf));
 		}
diff --git a/drivers/net/s2io.h b/drivers/net/s2io.h
index 47c36e0..5f6071d 100644
--- a/drivers/net/s2io.h
+++ b/drivers/net/s2io.h
@@ -468,7 +468,7 @@ struct config_param {
 	u8 multiq;
 };
 
-/* Structure representing MAC Addrs */
+/* Structure representing MAC Address */
 struct mac_addr {
 	u8 mac_addr[ETH_ALEN];
 };
diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index bbbded7..770364f 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -1078,7 +1078,7 @@ sis900_init_rxfilter (struct net_device * net_dev)
 		outl(w, ioaddr + rfdr);
 
 		if (netif_msg_hw(sis_priv)) {
-			printk(KERN_DEBUG "%s: Receive Filter Addrss[%d]=%x\n",
+			printk(KERN_DEBUG "%s: Receive Filter Address[%d]=%x\n",
 			       net_dev->name, i, inl(ioaddr + rfdr));
 		}
 	}
diff --git a/drivers/net/skfp/h/supern_2.h b/drivers/net/skfp/h/supern_2.h
index 5ba0b83..5607fb3 100644
--- a/drivers/net/skfp/h/supern_2.h
+++ b/drivers/net/skfp/h/supern_2.h
@@ -345,7 +345,7 @@ struct tx_queue {
 #define	FM_LTDPA1	0x79		/* r/w Last Trans desc ptr for A1 qu. */
 /* 0x80-0x9a	PLCS registers of built-in PLCS  (Supernet 3 only) */
 
-/* Supernet 3: Adderss Filter Registers */
+/* Supernet 3: Address Filter Registers */
 #define	FM_AFCMD	0xb0		/* r/w Address Filter Command Reg */
 #define	FM_AFSTAT	0xb2		/* r/w Address Filter Status Reg */
 #define	FM_AFBIST	0xb4		/* r/w Address Filter BIST signature */
diff --git a/drivers/net/stmmac/dwmac1000_core.c b/drivers/net/stmmac/dwmac1000_core.c
index 917b4e1..5dc5dad 100644
--- a/drivers/net/stmmac/dwmac1000_core.c
+++ b/drivers/net/stmmac/dwmac1000_core.c
@@ -115,7 +115,7 @@ static void dwmac1000_set_filter(struct net_device *dev)
 
 	/* Handle multiple unicast addresses (perfect filtering)*/
 	if (netdev_uc_count(dev) > GMAC_MAX_UNICAST_ADDRESSES)
-		/* Switch to promiscuous mode is more than 16 addrs
+		/* Switch to promiscuous mode is more than 16 address
 		   are required */
 		value |= GMAC_FRAME_FILTER_PR;
 	else {
diff --git a/drivers/net/sunbmac.c b/drivers/net/sunbmac.c
index 367e96f..db90a28 100644
--- a/drivers/net/sunbmac.c
+++ b/drivers/net/sunbmac.c
@@ -998,7 +998,7 @@ static void bigmac_set_multicast(struct net_device *dev)
 	struct bigmac *bp = netdev_priv(dev);
 	void __iomem *bregs = bp->bregs;
 	struct netdev_hw_addr *ha;
-	char *addrs;
+	char *address;
 	int i;
 	u32 tmp, crc;
 
@@ -1027,12 +1027,12 @@ static void bigmac_set_multicast(struct net_device *dev)
 			hash_table[i] = 0;
 
 		netdev_for_each_mc_addr(ha, dev) {
-			addrs = ha->addr;
+			address = ha->addr;
 
-			if (!(*addrs & 1))
+			if (!(*address & 1))
 				continue;
 
-			crc = ether_crc_le(6, addrs);
+			crc = ether_crc_le(6, address);
 			crc >>= 26;
 			hash_table[crc >> 4] |= 1 << (crc & 0xf);
 		}
diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
index 434f9d7..d70733e 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -1851,12 +1851,12 @@ static u32 gem_setup_multicast(struct gem *gp)
 
 		memset(hash_table, 0, sizeof(hash_table));
 		netdev_for_each_mc_addr(ha, gp->dev) {
-			char *addrs = ha->addr;
+			char *address = ha->addr;
 
-			if (!(*addrs & 1))
+			if (!(*address & 1))
 				continue;
 
- 			crc = ether_crc_le(6, addrs);
+ 			crc = ether_crc_le(6, address);
 			crc >>= 24;
 			hash_table[crc >> 4] |= 1 << (15 - (crc & 0xf));
 		}
diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index 3d9650b..50abe12 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -1524,17 +1524,17 @@ static int happy_meal_init(struct happy_meal *hp)
 	} else if ((hp->dev->flags & IFF_PROMISC) == 0) {
 		u16 hash_table[4];
 		struct netdev_hw_addr *ha;
-		char *addrs;
+		char *address;
 		u32 crc;
 
 		memset(hash_table, 0, sizeof(hash_table));
 		netdev_for_each_mc_addr(ha, hp->dev) {
-			addrs = ha->addr;
+			address = ha->addr;
 
-			if (!(*addrs & 1))
+			if (!(*address & 1))
 				continue;
 
-			crc = ether_crc_le(6, addrs);
+			crc = ether_crc_le(6, address);
 			crc >>= 26;
 			hash_table[crc >> 4] |= 1 << (crc & 0xf);
 		}
@@ -2361,7 +2361,7 @@ static void happy_meal_set_multicast(struct net_device *dev)
 	struct happy_meal *hp = netdev_priv(dev);
 	void __iomem *bregs = hp->bigmacregs;
 	struct netdev_hw_addr *ha;
-	char *addrs;
+	char *address;
 	u32 crc;
 
 	spin_lock_irq(&hp->happy_lock);
@@ -2379,12 +2379,12 @@ static void happy_meal_set_multicast(struct net_device *dev)
 
 		memset(hash_table, 0, sizeof(hash_table));
 		netdev_for_each_mc_addr(ha, dev) {
-			addrs = ha->addr;
+			address = ha->addr;
 
-			if (!(*addrs & 1))
+			if (!(*address & 1))
 				continue;
 
-			crc = ether_crc_le(6, addrs);
+			crc = ether_crc_le(6, address);
 			crc >>= 26;
 			hash_table[crc >> 4] |= 1 << (crc & 0xf);
 		}
diff --git a/drivers/net/sunlance.c b/drivers/net/sunlance.c
index 7d9c33d..3d85623 100644
--- a/drivers/net/sunlance.c
+++ b/drivers/net/sunlance.c
@@ -1170,7 +1170,7 @@ static void lance_load_multicast(struct net_device *dev)
 {
 	struct lance_private *lp = netdev_priv(dev);
 	struct netdev_hw_addr *ha;
-	char *addrs;
+	char *address;
 	u32 crc;
 	u32 val;
 
@@ -1195,12 +1195,12 @@ static void lance_load_multicast(struct net_device *dev)
 
 	/* Add addresses */
 	netdev_for_each_mc_addr(ha, dev) {
-		addrs = ha->addr;
+		address = ha->addr;
 
 		/* multicast address? */
-		if (!(*addrs & 1))
+		if (!(*address & 1))
 			continue;
-		crc = ether_crc_le(6, addrs);
+		crc = ether_crc_le(6, address);
 		crc = crc >> 26;
 		if (lp->pio_buffer) {
 			struct lance_init_block __iomem *ib = lp->init_block_iomem;
diff --git a/drivers/net/sunqe.c b/drivers/net/sunqe.c
index 72b579c..81c0ba9 100644
--- a/drivers/net/sunqe.c
+++ b/drivers/net/sunqe.c
@@ -628,7 +628,7 @@ static void qe_set_multicast(struct net_device *dev)
 	struct sunqe *qep = netdev_priv(dev);
 	struct netdev_hw_addr *ha;
 	u8 new_mconfig = qep->mconfig;
-	char *addrs;
+	char *address;
 	int i;
 	u32 crc;
 
@@ -651,11 +651,11 @@ static void qe_set_multicast(struct net_device *dev)
 
 		memset(hash_table, 0, sizeof(hash_table));
 		netdev_for_each_mc_addr(ha, dev) {
-			addrs = ha->addr;
+			address = ha->addr;
 
-			if (!(*addrs & 1))
+			if (!(*address & 1))
 				continue;
-			crc = ether_crc_le(6, addrs);
+			crc = ether_crc_le(6, address);
 			crc >>= 26;
 			hash_table[crc >> 4] |= 1 << (crc & 0xf);
 		}
diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 737df60..90e5048 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -821,7 +821,7 @@ static void bdx_setmulti(struct net_device *ndev)
 		}
 
 		/* use PMF to accept first MAC_MCST_NUM (15) addresses */
-		/* TBD: sort addreses and write them in ascending order
+		/* TBD: sort addresses and write them in ascending order
 		 * into RX_MAC_MCST regs. we skip this phase now and accept ALL
 		 * multicast frames throu IMF */
 		/* accept the rest of addresses throu IMF */
diff --git a/drivers/net/tulip/de4x5.c b/drivers/net/tulip/de4x5.c
index 75a64c8..ae8106e 100644
--- a/drivers/net/tulip/de4x5.c
+++ b/drivers/net/tulip/de4x5.c
@@ -1954,7 +1954,7 @@ SetMulticastFilter(struct net_device *dev)
     u16 hashcode;
     u32 omr, crc;
     char *pa;
-    unsigned char *addrs;
+    unsigned char *address;
 
     omr = inl(DE4X5_OMR);
     omr &= ~(OMR_PR | OMR_PM);
@@ -1964,9 +1964,9 @@ SetMulticastFilter(struct net_device *dev)
 	omr |= OMR_PM;                       /* Pass all multicasts */
     } else if (lp->setup_f == HASH_PERF) {   /* Hash Filtering */
 	netdev_for_each_mc_addr(ha, dev) {
-	    addrs = ha->addr;
-	    if ((*addrs & 0x01) == 1) {      /* multicast address? */
-		crc = ether_crc_le(ETH_ALEN, addrs);
+	    address = ha->addr;
+	    if ((*address & 0x01) == 1) {      /* multicast address? */
+		crc = ether_crc_le(ETH_ALEN, address);
 		hashcode = crc & HASH_BITS;  /* hashcode is 9 LSb of CRC */
 
 		byte = hashcode >> 3;        /* bit[3-8] -> byte in filter */
@@ -1981,9 +1981,9 @@ SetMulticastFilter(struct net_device *dev)
 	}
     } else {                                 /* Perfect filtering */
 	netdev_for_each_mc_addr(ha, dev) {
-	    addrs = ha->addr;
+	    address = ha->addr;
 	    for (i=0; i<ETH_ALEN; i++) {
-		*(pa + (i&1)) = *addrs++;
+		*(pa + (i&1)) = *address++;
 		if (i & 0x01) pa += 4;
 	    }
 	}
diff --git a/drivers/net/tulip/de4x5.h b/drivers/net/tulip/de4x5.h
index 9f28774..a11a576 100644
--- a/drivers/net/tulip/de4x5.h
+++ b/drivers/net/tulip/de4x5.h
@@ -887,7 +887,7 @@
 #define PERFECT              0     /* 16 perfect physical addresses */
 #define HASH_PERF            1     /* 1 perfect, 512 multicast addresses */
 #define PERFECT_REJ          2     /* Reject 16 perfect physical addresses */
-#define ALL_HASH             3     /* Hashes all physical & multicast addrs */
+#define ALL_HASH             3     /* Hashes all physical & multicast address */
 
 #define ALL                  0     /* Clear out all the setup frame */
 #define PHYS_ADDR_ONLY       1     /* Update the physical address only */
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 6ad6fe7..658f456 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -85,8 +85,8 @@ static int debug;
 
 #define FLT_EXACT_COUNT 8
 struct tap_filter {
-	unsigned int    count;    /* Number of addrs. Zero means disabled */
-	u32             mask[2];  /* Mask of the hashed addrs */
+	unsigned int    count;    /* Number of address. Zero means disabled */
+	u32             mask[2];  /* Mask of the hashed address */
 	unsigned char	addr[FLT_EXACT_COUNT][ETH_ALEN];
 };
 
@@ -1297,7 +1297,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	case SIOCGIFHWADDR:
-		/* Get hw addres */
+		/* Get hw address */
 		memcpy(ifr.ifr_hwaddr.sa_data, tun->dev->dev_addr, ETH_ALEN);
 		ifr.ifr_hwaddr.sa_family = tun->dev->type;
 		if (copy_to_user(argp, &ifr, ifreq_len))
diff --git a/drivers/net/vxge/vxge-config.h b/drivers/net/vxge/vxge-config.h
index 4ae2625..b525424 100644
--- a/drivers/net/vxge/vxge-config.h
+++ b/drivers/net/vxge/vxge-config.h
@@ -28,8 +28,8 @@
 }
 
 #ifndef VXGE_ALIGN
-#define VXGE_ALIGN(adrs, size) \
-	(((size) - (((u64)adrs) & ((size)-1))) & ((size)-1))
+#define VXGE_ALIGN(address, size) \
+	(((size) - (((u64)address) & ((size)-1))) & ((size)-1))
 #endif
 
 #define VXGE_HW_MIN_MTU				68
diff --git a/drivers/net/vxge/vxge-traffic.h b/drivers/net/vxge/vxge-traffic.h
index c252f3d..f115a4d 100644
--- a/drivers/net/vxge/vxge-traffic.h
+++ b/drivers/net/vxge/vxge-traffic.h
@@ -1695,7 +1695,7 @@ struct vxge_hw_device_stats_sw_err {
  * struct vxge_hw_device_stats - Contains HW per-device statistics,
  * including hw.
  * @devh: HW device handle.
- * @dma_addr: DMA addres of the %hw_info. Given to device to fill-in the stats.
+ * @dma_addr: DMA address of the %hw_info. Given to device to fill-in the stats.
  * @hw_info_dmah: DMA handle used to map hw statistics onto the device memory
  *                space.
  * @hw_info_dma_acch: One more DMA handle used subsequently to free the
diff --git a/drivers/net/wan/pc300.h b/drivers/net/wan/pc300.h
index 2e4f84f..c8cad47 100644
--- a/drivers/net/wan/pc300.h
+++ b/drivers/net/wan/pc300.h
@@ -161,11 +161,11 @@
 struct RUNTIME_9050 {
 	u32 loc_addr_range[4];	/* 00-0Ch : Local Address Ranges */
 	u32 loc_rom_range;	/* 10h : Local ROM Range */
-	u32 loc_addr_base[4];	/* 14-20h : Local Address Base Addrs */
+	u32 loc_addr_base[4];	/* 14-20h : Local Address Base Address */
 	u32 loc_rom_base;	/* 24h : Local ROM Base */
 	u32 loc_bus_descr[4];	/* 28-34h : Local Bus Descriptors */
 	u32 rom_bus_descr;	/* 38h : ROM Bus Descriptor */
-	u32 cs_base[4];		/* 3C-48h : Chip Select Base Addrs */
+	u32 cs_base[4];		/* 3C-48h : Chip Select Base Address */
 	u32 intr_ctrl_stat;	/* 4Ch : Interrupt Control/Status */
 	u32 init_ctrl;		/* 50h : EEPROM ctrl, Init Ctrl, etc */
 };
diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index c7ab3be..cc2c7e4 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -63,11 +63,11 @@ enum { PC300_RSV = 1, PC300_X21, PC300_TE }; /* card types */
 typedef struct {
 	u32 loc_addr_range[4];	/* 00-0Ch : Local Address Ranges */
 	u32 loc_rom_range;	/* 10h : Local ROM Range */
-	u32 loc_addr_base[4];	/* 14-20h : Local Address Base Addrs */
+	u32 loc_addr_base[4];	/* 14-20h : Local Address Base Address */
 	u32 loc_rom_base;	/* 24h : Local ROM Base */
 	u32 loc_bus_descr[4];	/* 28-34h : Local Bus Descriptors */
 	u32 rom_bus_descr;	/* 38h : ROM Bus Descriptor */
-	u32 cs_base[4];		/* 3C-48h : Chip Select Base Addrs */
+	u32 cs_base[4];		/* 3C-48h : Chip Select Base Address */
 	u32 intr_ctrl_stat;	/* 4Ch : Interrupt Control/Status */
 	u32 init_ctrl;		/* 50h : EEPROM ctrl, Init Ctrl, etc */
 }plx9050;
diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index e2cff64..022a266 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -51,11 +51,11 @@ static int pci_clock_freq = 33000000;
 typedef struct {
 	u32 loc_addr_range[4];	/* 00-0Ch : Local Address Ranges */
 	u32 loc_rom_range;	/* 10h : Local ROM Range */
-	u32 loc_addr_base[4];	/* 14-20h : Local Address Base Addrs */
+	u32 loc_addr_base[4];	/* 14-20h : Local Address Base Address */
 	u32 loc_rom_base;	/* 24h : Local ROM Base */
 	u32 loc_bus_descr[4];	/* 28-34h : Local Bus Descriptors */
 	u32 rom_bus_descr;	/* 38h : ROM Bus Descriptor */
-	u32 cs_base[4];		/* 3C-48h : Chip Select Base Addrs */
+	u32 cs_base[4];		/* 3C-48h : Chip Select Base Address */
 	u32 intr_ctrl_stat;	/* 4Ch : Interrupt Control/Status */
 	u32 init_ctrl;		/* 50h : EEPROM ctrl, Init Ctrl, etc */
 }plx9052;
diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
index 9c8b78d..27c3200 100644
--- a/drivers/net/wimax/i2400m/driver.c
+++ b/drivers/net/wimax/i2400m/driver.c
@@ -280,7 +280,7 @@ int i2400m_check_mac_addr(struct i2400m *i2400m)
 			result);
 		goto error;
 	}
-	/* Extract MAC addresss */
+	/* Extract MAC address */
 	ddi = (void *) skb->data;
 	BUILD_BUG_ON(ETH_ALEN != sizeof(ddi->mac_address));
 	d_printf(2, dev, "GET DEVICE INFO: mac addr %pM\n",
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 55b4ac6..5246e56 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -1064,7 +1064,7 @@
 /*
  * EEPROM command register
  */
-#define AR5K_EEPROM_CMD		0x6008			/* Register Addres */
+#define AR5K_EEPROM_CMD		0x6008			/* Register Address */
 #define AR5K_EEPROM_CMD_READ	0x00000001	/* EEPROM read */
 #define AR5K_EEPROM_CMD_WRITE	0x00000002	/* EEPROM write */
 #define AR5K_EEPROM_CMD_RESET	0x00000004	/* EEPROM reset */
@@ -1084,7 +1084,7 @@
 /*
  * EEPROM config register
  */
-#define AR5K_EEPROM_CFG			0x6010			/* Register Addres */
+#define AR5K_EEPROM_CFG			0x6010			/* Register Address */
 #define AR5K_EEPROM_CFG_SIZE		0x00000003		/* Size determination override */
 #define AR5K_EEPROM_CFG_SIZE_AUTO	0
 #define AR5K_EEPROM_CFG_SIZE_4KBIT	1
@@ -1126,7 +1126,7 @@
  * Second station id register (Upper 16 bits of MAC address + PCU settings)
  */
 #define AR5K_STA_ID1			0x8004			/* Register Address */
-#define	AR5K_STA_ID1_ADDR_U16		0x0000ffff	/* Upper 16 bits of MAC addres */
+#define	AR5K_STA_ID1_ADDR_U16		0x0000ffff	/* Upper 16 bits of MAC address */
 #define AR5K_STA_ID1_AP			0x00010000	/* Set AP mode */
 #define AR5K_STA_ID1_ADHOC		0x00020000	/* Set Ad-Hoc mode */
 #define AR5K_STA_ID1_PWR_SV		0x00040000	/* Power save reporting */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 83a2636..3774230 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -104,7 +104,7 @@ static void iwl_process_add_sta_resp(struct iwl_priv *priv,
 	/*
 	 * XXX: The MAC address in the command buffer is often changed from
 	 * the original sent to the device. That is, the MAC address
-	 * written to the command buffer often is not the same MAC adress
+	 * written to the command buffer often is not the same MAC address
 	 * read from the command buffer when the command returns. This
 	 * issue has not yet been resolved and this debugging is left to
 	 * observe the problem.
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 808adb9..022f42e 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4049,7 +4049,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	 */
 	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 
-	/* Get config data, mac addrs etc */
+	/* Get config data, mac address etc */
 	if (priv->ap_fw) {
 		rc = mwl8k_cmd_get_hw_spec_ap(hw);
 		if (!rc)
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index abbd857..c848fc0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -278,7 +278,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	memcpy(&intf->mac, vif->addr, ETH_ALEN);
 
 	/*
-	 * The MAC adddress must be configured after the device
+	 * The MAC address must be configured after the device
 	 * has been initialized. Otherwise the device can reset
 	 * the MAC registers.
 	 */
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 376c6b9..a3e909d 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -209,7 +209,7 @@ static inline void wl3501_switch_page(struct wl3501_card *this, u8 page)
 }
 
 /*
- * Get Ethernet MAC addresss.
+ * Get Ethernet MAC address.
  *
  * WARNING: We switch to FPAGE0 and switc back again.
  *          Making sure there is no other WL function beening called by ISR.
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index c542c7b..262f060 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -1000,7 +1000,7 @@ static int __init dino_probe(struct parisc_device *dev)
 
 	dino_dev->hba.dev = dev;
 	dino_dev->hba.base_addr = ioremap_nocache(hpa, 4096);
-	dino_dev->hba.lmmio_space_offset = 0;	/* CPU addrs == bus addrs */
+	dino_dev->hba.lmmio_space_offset = 0;	/* CPU address == bus address */
 	spin_lock_init(&dino_dev->dinosaur_pen);
 	dino_dev->hba.iommu = ccio_get_iommu(dev);
 
diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index 72d507b..a13cd84 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -19,7 +19,7 @@
 #include <linux/types.h>
 #include <linux/mutex.h>
 
-#include <asm/sn/addrs.h>
+#include <asm/sn/address.h>
 #include <asm/sn/geo.h>
 #include <asm/sn/l1.h>
 #include <asm/sn/module.h>
diff --git a/drivers/pci/iova.c b/drivers/pci/iova.c
index 7914951..693ea16 100644
--- a/drivers/pci/iova.c
+++ b/drivers/pci/iova.c
@@ -364,7 +364,7 @@ __adjust_overlap_range(struct iova *iova,
  * reserve_iova - reserves an iova in the given range
  * @iovad: - iova domain pointer
  * @pfn_lo: - lower page frame address
- * @pfn_hi:- higher pfn adderss
+ * @pfn_hi:- higher pfn address
  * This function allocates reserves the address range from pfn_lo to pfn_hi so
  * that this address is not dished out as part of alloc_iova.
  */
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index dbbc601..61a6182 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -416,7 +416,7 @@ static u8 orc_load_firmware(struct orc_host * host)
 	/* Go back and check they match */
 
 	outb(PRGMRST | DOWNLOAD, host->base + ORC_RISCCTL);	/* Reset program count 0 */
-	bios_addr -= 0x1000;	/* Reset the BIOS adddress      */
+	bios_addr -= 0x1000;	/* Reset the BIOS address      */
 	for (i = 0, data32_ptr = (u8 *) & data32;	/* Check the code       */
 	     i < 0x1000;	/* Firmware code size = 4K      */
 	     i++, bios_addr++) {
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
index 8c1c282..04d897e 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -121,7 +121,7 @@ struct hw_profile {
 	int    num_phys;	  /* ENABLEABLE */
 	int    max_phys;	  /* REPORTED + ENABLEABLE */
 
-	unsigned addr_range;	  /* max # of addrs; max # of possible ports */
+	unsigned addr_range;	  /* max # of address; max # of possible ports */
 	unsigned port_name_base;
 	unsigned dev_name_base;
 	unsigned sata_name_base;
diff --git a/drivers/scsi/aic94xx/aic94xx_reg_def.h b/drivers/scsi/aic94xx/aic94xx_reg_def.h
index 28aaf34..40273a7 100644
--- a/drivers/scsi/aic94xx/aic94xx_reg_def.h
+++ b/drivers/scsi/aic94xx/aic94xx_reg_def.h
@@ -1689,7 +1689,7 @@
 #define		PHY_START_CAL		0x01
 
 /*
- * HST_PCIX2 Registers, Addresss Range: (0x00-0xFC)
+ * HST_PCIX2 Registers, Address Range: (0x00-0xFC)
  */
 #define PCIX_REG_BASE_ADR		0xB8040000
 
@@ -1802,7 +1802,7 @@
 #define PCIC_TP_CTRL	0xFC
 
 /*
- * EXSI Registers, Addresss Range: (0x00-0xFC)
+ * EXSI Registers, Address Range: (0x00-0xFC)
  */
 #define EXSI_REG_BASE_ADR		REG_BASE_ADDR_EXSI
 
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 6b624e7..9951422 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -167,7 +167,7 @@ struct generic_pdu_resc {
  * @link:               list head to link elements
  * @max_ptrs:           maximun pointers that can be stored in this page
  * @num_valid:          number of pointer valid in this page
- * @page:               base addess for page pointer array
+ * @page:               base address for page pointer array
  *
  * structure to track DMA'able memory allocated for command BD tables
  */
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index 3ddb4dc..b82adfb 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -416,7 +416,7 @@ static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *mat
 	int proplen, rc = -ENODEV;
 
 	if (macio_resource_count(mdev) != 2 || macio_irq_count(mdev) != 2) {
-		printk(KERN_ERR "mac53c94: expected 2 addrs and intrs"
+		printk(KERN_ERR "mac53c94: expected 2 address and intrs"
 		       " (got %d/%d)\n",
 		       macio_resource_count(mdev), macio_irq_count(mdev));
 		return -ENODEV;
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 1f784fd..ddd219c 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1863,7 +1863,7 @@ static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	}
 
 	if (macio_resource_count(mdev) != 2 || macio_irq_count(mdev) != 2) {
-       		printk(KERN_ERR "mesh: expected 2 addrs and 2 intrs"
+       		printk(KERN_ERR "mesh: expected 2 address and 2 intrs"
 	       	       " (got %d,%d)\n", macio_resource_count(mdev),
 		       macio_irq_count(mdev));
 		return -ENODEV;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 41c29a8..05bb783 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -455,7 +455,7 @@ typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
  * @tmp_string: tmp string used for logging
  * @pdev: pci pdev object
  * @chip: memory mapped register space
- * @chip_phys: physical addrss prior to mapping
+ * @chip_phys: physical address prior to mapping
  * @logging_level: see mpt2sas_debug.h
  * @fwfault_debug: debuging FW timeouts
  * @ir_firmware: IR firmware present
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index aaa4fd0..fa753a8 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -143,7 +143,7 @@ static int sun3scsi_detect(struct scsi_host_template * tpnt)
 	static int called = 0;
 	struct Scsi_Host *instance;
 	int i;
-	unsigned long addrs[3] = { IOBASE_SUN3_VMESCSI, 
+	unsigned long address[3] = { IOBASE_SUN3_VMESCSI, 
 				   IOBASE_SUN3_VMESCSI + 0x4000,
 				   0 };
 	unsigned long vecs[3] = { SUN3_VEC_VMESCSI0,
@@ -180,10 +180,10 @@ static int sun3scsi_detect(struct scsi_host_template * tpnt)
 	}
 	
 	ioaddr = 0;
-	for(i = 0; addrs[i] != 0; i++) {
+	for(i = 0; address[i] != 0; i++) {
 		unsigned char x;
 		
-		ioaddr = (unsigned long)sun3_ioremap(addrs[i], PAGE_SIZE,
+		ioaddr = (unsigned long)sun3_ioremap(address[i], PAGE_SIZE,
 						     SUN3_PAGE_TYPE_VME16);
 		irq = vecs[i];
 		sun3_scsi_regp = (unsigned char *)ioaddr;
diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index c4e0442..09ee7dd 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -341,9 +341,9 @@ static void atmel_spi_next_message(struct spi_master *master)
 /*
  * For DMA, tx_buf/tx_dma have the same relationship as rx_buf/rx_dma:
  *  - The buffer is either valid for CPU access, else NULL
- *  - If the buffer is valid, so is its DMA addresss
+ *  - If the buffer is valid, so is its DMA address
  *
- * This driver manages the dma addresss unless message->is_dma_mapped.
+ * This driver manages the dma address unless message->is_dma_mapped.
  */
 static int
 atmel_spi_dma_map_xfer(struct atmel_spi *as, struct spi_transfer *xfer)
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
index bea329f..16bbdba 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
@@ -635,7 +635,7 @@ void v_EepromSendCommand76(unsigned int dw_Address, unsigned int dw_EepromComman
 
 | Input Parameters  : unsigned int dw_Address : PCI eeprom base address                  |
 
-|		      unsigned short    w_offset : Offset of the adress to read             |
+|		      unsigned short    w_offset : Offset of the address to read             |
 
 |		      unsigned short *   pw_Value : PCI eeprom 16 bit read value.            |
 
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index f93ddd4..851f71b 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -1090,13 +1090,13 @@ int i_APCI3120_CyclicAnalogInput(int mode, struct comedi_device *dev,
  * and put into into an array array used may be for differnet pages
  */
 
-		/*  DMA Start Adress Low */
+		/*  DMA Start Address Low */
 		outw(APCI3120_ADD_ON_MWAR_LOW, devpriv->i_IobaseAddon + 0);
 		outw((devpriv->ul_DmaBufferHw[0] & 0xFFFF),
 			devpriv->i_IobaseAddon + 2);
 
 		/*************************/
-		/* DMA Start Adress High */
+		/* DMA Start Address High */
 		/*************************/
 		outw(APCI3120_ADD_ON_MWAR_HIGH, devpriv->i_IobaseAddon + 0);
 		outw((devpriv->ul_DmaBufferHw[0] / 65536),
@@ -1733,11 +1733,11 @@ void v_APCI3120_InterruptDma(int irq, void *d)
 		var = devpriv->ul_DmaBufferHw[next_dma_buf];
 		high_word = var / 65536;
 
-		/* DMA Start Adress Low */
+		/* DMA Start Address Low */
 		outw(APCI3120_ADD_ON_MWAR_LOW, devpriv->i_IobaseAddon + 0);
 		outw(low_word, devpriv->i_IobaseAddon + 2);
 
-		/* DMA Start Adress High */
+		/* DMA Start Address High */
 		outw(APCI3120_ADD_ON_MWAR_HIGH, devpriv->i_IobaseAddon + 0);
 		outw(high_word, devpriv->i_IobaseAddon + 2);
 
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 6a6fae5..098d796 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -382,7 +382,7 @@ enum global_interrupt_config_register_bits {
 	Global_Int_Enable_Bit = 0x80000000
 };
 
-/* Offset of the GPCT chips from the base-adress of the card */
+/* Offset of the GPCT chips from the base-address of the card */
 /* First chip is at base-address + 0x00, etc. */
 static const unsigned GPCT_OFFSET[2] = { 0x0, 0x800 };
 
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index a3cc933..1accc50 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -153,7 +153,7 @@ struct s626_private {
 	struct bufferDMA ANABuf;
 	/* DMA buffer used to receive ADC data and hold DAC data. */
 	uint32_t *pDacWBuf;
-	/* Pointer to logical adrs of DMA buffer used to hold DAC  data. */
+	/* Pointer to logical address of DMA buffer used to hold DAC  data. */
 	uint16_t Dacpol;	/* Image of DAC polarity register. */
 	uint8_t TrimSetpoint[12];	/* Images of TrimDAC setpoints */
 	uint16_t ChargeEnabled;	/* Image of MISC2 Battery */
@@ -872,7 +872,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		    devpriv->ANABuf.PhysicalBase +
 		    (DAC_WDMABUF_OS * sizeof(uint32_t));
 
-		WR7146(P_BASEA2_OUT, (uint32_t) pPhysBuf);	/*  Buffer base adrs. */
+		WR7146(P_BASEA2_OUT, (uint32_t) pPhysBuf);	/*  Buffer base address. */
 		WR7146(P_PROTA2_OUT, (uint32_t) (pPhysBuf + sizeof(uint32_t)));	/*  Protection address. */
 
 		/* Cache Audio2's output DMA buffer logical address.  This is
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 7b8a2da..4b320b1 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -111,7 +111,7 @@ sampling rate. If you sample two channels you get 4kHz and so on.
 #define VENDOR_DIR_IN  0xC0
 #define VENDOR_DIR_OUT 0x40
 
-/* internal adresses of the 8051 processor */
+/* internal addresses of the 8051 processor */
 #define USBDUXSUB_CPUCS 0xE600
 
 /*
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 29c3c01..0a164a9 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -67,7 +67,7 @@
 #define VENDOR_DIR_OUT		0x40
 
 /*
- * internal adresses of the 8051 processor
+ * internal addresses of the 8051 processor
  */
 #define USBDUXFASTSUB_CPUCS	0xE600
 
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index cf2286d..61c57f6 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -214,7 +214,7 @@ struct cx25821_i2c {
 	struct i2c_client i2c_client;
 	u32 i2c_rc;
 
-	/* cx25821 registers used for raw addess */
+	/* cx25821 registers used for raw address */
 	u32 i2c_period;
 	u32 reg_ctrl;
 	u32 reg_stat;
diff --git a/drivers/staging/dt3155/dt3155_io.c b/drivers/staging/dt3155/dt3155_io.c
index 7792e71..859c5f5 100644
--- a/drivers/staging/dt3155/dt3155_io.c
+++ b/drivers/staging/dt3155/dt3155_io.c
@@ -130,7 +130,7 @@ int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
  *
  * 1st parameter is pointer to 32-bit register base address
  * 2nd parameter is reg. index;
- * 3rd is adrs of value to be read
+ * 3rd is address of value to be read
  */
 int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal)
 {
diff --git a/drivers/staging/octeon/cvmx-fau.h b/drivers/staging/octeon/cvmx-fau.h
index 29bdce6..a6939fc 100644
--- a/drivers/staging/octeon/cvmx-fau.h
+++ b/drivers/staging/octeon/cvmx-fau.h
@@ -299,7 +299,7 @@ cvmx_fau_tagwait_fetch_and_add8(cvmx_fau_reg_8_t reg, int8_t value)
 /**
  * Builds I/O data for async operations
  *
- * @scraddr: Scratch pad byte addres to write to.  Must be 8 byte aligned
+ * @scraddr: Scratch pad byte address to write to.  Must be 8 byte aligned
  * @value:   Signed value to add.
  *                Note: When performing 32 and 64 bit access, only the low
  *                22 bits are available.
diff --git a/drivers/staging/otus/80211core/ctxrx.c b/drivers/staging/otus/80211core/ctxrx.c
index a127196..135167d 100644
--- a/drivers/staging/otus/80211core/ctxrx.c
+++ b/drivers/staging/otus/80211core/ctxrx.c
@@ -3117,7 +3117,7 @@ u16_t zfWlanRxFilter(zdev_t* dev, zbuf_t* buf)
 
     index = (src[2]+up) & (ZM_FILTER_TABLE_ROW-1);
 
-    /* TBD : filter frame with source address == own MAC adress */
+    /* TBD : filter frame with source address == own MAC address */
     if ((wd->macAddr[0] == src[0]) && (wd->macAddr[1] == src[1])
             && (wd->macAddr[2] == src[2]))
     {
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index e3f95f7..86fb0c9 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -815,7 +815,7 @@ static int pohmelfs_readpages(struct file *file, struct address_space *mapping,
 }
 
 /*
- * Small addres space operations for POHMELFS.
+ * Small address space operations for POHMELFS.
  */
 const struct address_space_operations pohmelfs_aops = {
 	.readpage		= pohmelfs_readpage,
diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index 383543d..7ef16da 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -65,7 +65,7 @@
 /* free dynamic data aalocated during table creation */
 #define SEP_IOCFREEDMATABLEDATA                _IO(SEP_IOC_MAGIC_NUMBER , 7)
 
-/* get the static pool area addersses (physical and virtual) */
+/* get the static pool area addresses (physical and virtual) */
 #define SEP_IOCGETSTATICPOOLADDR               _IO(SEP_IOC_MAGIC_NUMBER , 8)
 
 /* set flow id command */
diff --git a/drivers/staging/slicoss/slichw.h b/drivers/staging/slicoss/slichw.h
index 6275d45..12c7743 100644
--- a/drivers/staging/slicoss/slichw.h
+++ b/drivers/staging/slicoss/slichw.h
@@ -438,7 +438,7 @@ struct slic_regs {
 	u32	pad31;
 #define SLIC_RESET_IFACE 0x00f0
 
-	u32	slic_addr_upper;/* Bits 63-32 for host i/f addrs */
+	u32	slic_addr_upper;/* Bits 63-32 for host i/f address */
 	u32	pad32;
 #define SLIC_ADDR_UPPER	0x00f8 /*Register is only written when it has changed*/
 
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 681419d..8c3768c 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -700,7 +700,7 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 	Mds_initial(priv);
 
 	/*
-	 * If no user-defined address in the registry, use the addresss
+	 * If no user-defined address in the registry, use the address
 	 * "burned" on the NIC instead.
 	 */
 	pMacAddr = priv->sLocalPara.ThisMacAddress;
diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index b45c7dd..dc691e5 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -387,12 +387,12 @@ XX3( CFG_RANGE20,	hcf_16, role, hcf_16, id, CFG_RANGE_SPEC_STRCT, var_rec[20] )
  X1( CFG_CNF_PM_HOLDOVER_DURATION,	duration			 ) /*[STA] Holdover time for ESS PM							*/
  X1( CFG_CNF_OWN_NAME,				ssid[17]			 ) /*Identification text for diagnostic purposes			*/
  X1( CFG_CNF_OWN_DTIM_PERIOD,		period				 ) /*[AP] Beacon intervals between successive DTIMs			*/
- X1( CFG_CNF_WDS_ADDR1,				mac_addr[3]			 ) /*[AP] Port 1 MAC Adrs of corresponding WDS Link node	*/
- X1( CFG_CNF_WDS_ADDR2,				mac_addr[3]			 ) /*[AP] Port 2 MAC Adrs of corresponding WDS Link node	*/
- X1( CFG_CNF_WDS_ADDR3,				mac_addr[3]			 ) /*[AP] Port 3 MAC Adrs of corresponding WDS Link node	*/
- X1( CFG_CNF_WDS_ADDR4,				mac_addr[3]			 ) /*[AP] Port 4 MAC Adrs of corresponding WDS Link node	*/
- X1( CFG_CNF_WDS_ADDR5,				mac_addr[3]			 ) /*[AP] Port 5 MAC Adrs of corresponding WDS Link node	*/
- X1( CFG_CNF_WDS_ADDR6,				mac_addr[3]			 ) /*[AP] Port 6 MAC Adrs of corresponding WDS Link node	*/
+ X1( CFG_CNF_WDS_ADDR1,				mac_addr[3]			 ) /*[AP] Port 1 MAC Address of corresponding WDS Link node	*/
+ X1( CFG_CNF_WDS_ADDR2,				mac_addr[3]			 ) /*[AP] Port 2 MAC Address of corresponding WDS Link node	*/
+ X1( CFG_CNF_WDS_ADDR3,				mac_addr[3]			 ) /*[AP] Port 3 MAC Address of corresponding WDS Link node	*/
+ X1( CFG_CNF_WDS_ADDR4,				mac_addr[3]			 ) /*[AP] Port 4 MAC Address of corresponding WDS Link node	*/
+ X1( CFG_CNF_WDS_ADDR5,				mac_addr[3]			 ) /*[AP] Port 5 MAC Address of corresponding WDS Link node	*/
+ X1( CFG_CNF_WDS_ADDR6,				mac_addr[3]			 ) /*[AP] Port 6 MAC Address of corresponding WDS Link node	*/
  X1( CFG_CNF_MCAST_PM_BUF,			mcast_pm_buf		 ) /*[AP] Switch for PM buffering of Multicast Messages	*/
  X1( CFG_CNF_REJECT_ANY,			reject_any			 ) /*[AP] Switch for PM buffering of Multicast Messages	*/
 //X1( CFG_CNF_ENCRYPTION_ENABLED,	encryption			 ) /*specify encryption type of Tx/Rx messages				*/
@@ -645,12 +645,12 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 #define CFG_CNF_OWN_NAME				0xFC0E		//Identification text for diagnostic purposes
 
 #define CFG_CNF_OWN_DTIM_PERIOD			0xFC10		//[AP] Beacon intervals between successive DTIMs
-#define CFG_CNF_WDS_ADDR1				0xFC11		//[AP] Port 1 MAC Adrs of corresponding WDS Link node
-#define CFG_CNF_WDS_ADDR2				0xFC12		//[AP] Port 2 MAC Adrs of corresponding WDS Link node
-#define CFG_CNF_WDS_ADDR3				0xFC13		//[AP] Port 3 MAC Adrs of corresponding WDS Link node
-#define CFG_CNF_WDS_ADDR4				0xFC14		//[AP] Port 4 MAC Adrs of corresponding WDS Link node
-#define CFG_CNF_WDS_ADDR5				0xFC15		//[AP] Port 5 MAC Adrs of corresponding WDS Link node
-#define CFG_CNF_WDS_ADDR6				0xFC16		//[AP] Port 6 MAC Adrs of corresponding WDS Link node
+#define CFG_CNF_WDS_ADDR1				0xFC11		//[AP] Port 1 MAC Address of corresponding WDS Link node
+#define CFG_CNF_WDS_ADDR2				0xFC12		//[AP] Port 2 MAC Address of corresponding WDS Link node
+#define CFG_CNF_WDS_ADDR3				0xFC13		//[AP] Port 3 MAC Address of corresponding WDS Link node
+#define CFG_CNF_WDS_ADDR4				0xFC14		//[AP] Port 4 MAC Address of corresponding WDS Link node
+#define CFG_CNF_WDS_ADDR5				0xFC15		//[AP] Port 5 MAC Address of corresponding WDS Link node
+#define CFG_CNF_WDS_ADDR6				0xFC16		//[AP] Port 6 MAC Address of corresponding WDS Link node
 #define CFG_CNF_PM_MCAST_BUF			0xFC17		//[AP] Switch for PM buffereing of Multicast Messages
 #define CFG_CNF_MCAST_PM_BUF			CFG_CNF_PM_MCAST_BUF	//name does not match H-II spec
 #define CFG_CNF_REJECT_ANY				0xFC18		//[AP] Switch for PM buffereing of Multicast Messages
@@ -727,10 +727,10 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 #define CFG_FCBE	0xFCBE	//FW codes ahead of available documentation, so ???????
 #define CFG_FCBF	0xFCBF	//FW codes ahead of available documentation, so ???????
 
-#define CFG_HANDOVER_ADDR				0xFCC0		//[AP] Station MAC Adrress re-associated with other AP
+#define CFG_HANDOVER_ADDR				0xFCC0		//[AP] Station MAC Address re-associated with other AP
 #define CFG_SCAN_CHANNEL				0xFCC2		//Channel set for host requested scan
 //;?#define CFG_SCAN_CHANNEL_MASK			0xFCC2		// contains
-#define CFG_DISASSOCIATE_ADDR			0xFCC4		//[AP] Station MAC Adrress to be disassociated
+#define CFG_DISASSOCIATE_ADDR			0xFCC4		//[AP] Station MAC Address to be disassociated
 #define CFG_PROBE_DATA_RATE				0xFCC5		//WARP connection control
 #define CFG_FRAME_BURST_LIMIT			0xFCC6		//
 #define CFG_COEXISTENSE_BEHAVIOUR		0xFCC7		//[AP]
diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index 1aa61db..8926ead 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -1157,14 +1157,14 @@ void wl_multicast( struct net_device *dev )
 
 #else /* NEW_MULTICAST */
 
-void wl_multicast( struct net_device *dev, int num_addrs, void *addrs )
+void wl_multicast( struct net_device *dev, int num_addrs, void *address )
 {
     DBG_FUNC( "wl_multicast");
     DBG_ENTER(DbgInfo);
 
     DBG_PARAM( DbgInfo, "dev", "%s (0x%p)", dev->name, dev );
     DBG_PARAM( DbgInfo, "num_addrs", "%d", num_addrs );
-    DBG_PARAM( DbgInfo, "addrs", "0x%p", addrs );
+    DBG_PARAM( DbgInfo, "address", "0x%p", address );
 
 #error Obsolete set multicast interface!
 
diff --git a/drivers/staging/wlags49_h2/wl_netdev.h b/drivers/staging/wlags49_h2/wl_netdev.h
index 632ab2e..c19e233 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.h
+++ b/drivers/staging/wlags49_h2/wl_netdev.h
@@ -101,7 +101,7 @@ int wl_rx_dma( struct net_device *dev );
 #ifdef NEW_MULTICAST
 void wl_multicast( struct net_device *dev );
 #else
-void wl_multicast( struct net_device *dev, int num_addrs, void *addrs );
+void wl_multicast( struct net_device *dev, int num_addrs, void *address );
 #endif // NEW_MULTICAST
 
 
diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index 5b31bae..41146ad 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -3034,7 +3034,7 @@ static void u132_initialise(struct u132 *u132, struct platform_device *pdev)
 {
 	int rings = MAX_U132_RINGS;
 	int ports = MAX_U132_PORTS;
-	int addrs = MAX_U132_ADDRS;
+	int address = MAX_U132_ADDRS;
 	int udevs = MAX_U132_UDEVS;
 	int endps = MAX_U132_ENDPS;
 	u132->board = pdev->dev.platform_data;
@@ -3062,8 +3062,8 @@ static void u132_initialise(struct u132 *u132, struct platform_device *pdev)
 		port->power = 0;
 		port->Status = 0;
 	}
-	while (addrs-- > 0) {
-		struct u132_addr *addr = &u132->addr[addrs];
+	while (address-- > 0) {
+		struct u132_addr *addr = &u132->addr[address];
 		addr->address = 0;
 	}
 	while (udevs-- > 0) {
diff --git a/drivers/usb/wusbcore/wa-rpipe.c b/drivers/usb/wusbcore/wa-rpipe.c
index c7b1d81..8cb9d80 100644
--- a/drivers/usb/wusbcore/wa-rpipe.c
+++ b/drivers/usb/wusbcore/wa-rpipe.c
@@ -49,7 +49,7 @@
  *
  *  USB Stack port number    4 (1 based)
  *  WUSB code port index     3 (0 based)
- *  USB Addresss             5 (2 based -- 0 is for default, 1 for root hub)
+ *  USB Address             5 (2 based -- 0 is for default, 1 for root hub)
  *
  *  Now, because we don't use the concept as default address exactly
  *  like the (wired) USB code does, we need to kind of skip it. So we
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 3c1e13e..94c1318 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2193,7 +2193,7 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	rinfo->is_mobility = (ent->driver_data & CHIP_IS_MOBILITY) != 0;
 	rinfo->is_IGP = (ent->driver_data & CHIP_IS_IGP) != 0;
 
-	/* Set base addrs */
+	/* Set base address */
 	rinfo->fb_base_phys = pci_resource_start (pdev, 0);
 	rinfo->mmio_base_phys = pci_resource_start (pdev, 2);
 
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 1e71c35..63e038e 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -171,7 +171,7 @@ static void lcdtg_set_common_voltage(struct corgi_lcd *lcd,
 	lcdtg_i2c_send_stop(lcd, base_data);
 }
 
-static int corgi_ssp_lcdtg_send(struct corgi_lcd *lcd, int adrs, uint8_t data)
+static int corgi_ssp_lcdtg_send(struct corgi_lcd *lcd, int address, uint8_t data)
 {
 	struct spi_message msg;
 	struct spi_transfer xfer = {
@@ -180,7 +180,7 @@ static int corgi_ssp_lcdtg_send(struct corgi_lcd *lcd, int adrs, uint8_t data)
 		.tx_buf		= lcd->buf,
 	};
 
-	lcd->buf[0] = ((adrs & 0x07) << 5) | (data & 0x1f);
+	lcd->buf[0] = ((address & 0x07) << 5) | (data & 0x1f);
 	spi_message_init(&msg);
 	spi_message_add_tail(&xfer, &msg);
 
diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index 772f601..7654a2b 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -43,7 +43,7 @@ struct tosa_lcd_data {
 	bool is_vga;
 };
 
-static int tosa_tg_send(struct spi_device *spi, int adrs, uint8_t data)
+static int tosa_tg_send(struct spi_device *spi, int address, uint8_t data)
 {
 	u8 buf[1];
 	struct spi_message msg;
@@ -53,7 +53,7 @@ static int tosa_tg_send(struct spi_device *spi, int adrs, uint8_t data)
 		.tx_buf		= buf,
 	};
 
-	buf[0] = ((adrs & 0x07) << 5) | (data & 0x1f);
+	buf[0] = ((address & 0x07) << 5) | (data & 0x1f);
 	spi_message_init(&msg);
 	spi_message_add_tail(&xfer, &msg);
 
diff --git a/drivers/video/controlfb.h b/drivers/video/controlfb.h
index 6026c60..e0b1e31 100644
--- a/drivers/video/controlfb.h
+++ b/drivers/video/controlfb.h
@@ -64,7 +64,7 @@ struct control_regs {
 	struct preg cnttst;
 	struct preg ctrl;	/* display control */
 	struct preg start_addr;	/* start address: 5 lsbs zero */
-	struct preg pitch;	/* addrs diff between scan lines */
+	struct preg pitch;	/* address diff between scan lines */
 	struct preg mon_sense;	/* monitor sense bits */
 	struct preg vram_attr;	/* enable vram banks */
 	struct preg mode;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..07952d3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -548,7 +548,7 @@ struct ext4_mount_options {
 #endif
 };
 
-/* Max physical block we can addres w/o extents */
+/* Max physical block we can address w/o extents */
 #define EXT4_MAX_BLOCK_FILE_PHYS	0xFFFFFFFF
 
 /*
diff --git a/fs/freevxfs/vxfs_inode.h b/fs/freevxfs/vxfs_inode.h
index 240aeb1..9ff5b38 100644
--- a/fs/freevxfs/vxfs_inode.h
+++ b/fs/freevxfs/vxfs_inode.h
@@ -40,8 +40,8 @@
 
 #define VXFS_ISIZE		0x100		/* Inode size */
 
-#define VXFS_NDADDR		10		/* Number of direct addrs in inode */
-#define VXFS_NIADDR		2		/* Number of indirect addrs in inode */
+#define VXFS_NDADDR		10		/* Number of direct address in inode */
+#define VXFS_NIADDR		2		/* Number of indirect address in inode */
 #define VXFS_NIMMED		96		/* Size of immediate data in inode */
 #define VXFS_NTYPED		6		/* Num of typed extents */
 
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index c637b75..cd77aa7 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -119,7 +119,7 @@ struct acpi_whea_header {
 struct acpi_table_bert {
 	struct acpi_table_header header;	/* Common ACPI table header */
 	u32 region_length;	/* Length of the boot error region */
-	u64 address;		/* Physical addresss of the error region */
+	u64 address;		/* Physical address of the error region */
 };
 
 /* Boot Error Region (not a subtable, pointed to by Address field above) */
diff --git a/include/linux/i2c-dev.h b/include/linux/i2c-dev.h
index fd53bfd..80925e8 100644
--- a/include/linux/i2c-dev.h
+++ b/include/linux/i2c-dev.h
@@ -41,7 +41,7 @@
 #define I2C_SLAVE	0x0703	/* Use this slave address */
 #define I2C_SLAVE_FORCE	0x0706	/* Use this slave address, even if it
 				   is already in use by a driver! */
-#define I2C_TENBIT	0x0704	/* 0 for 7 bit addrs, != 0 for 10 bit */
+#define I2C_TENBIT	0x0704	/* 0 for 7 bit address, != 0 for 10 bit */
 
 #define I2C_FUNCS	0x0705	/* Get the adapter functionality mask */
 
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 21067b4..711a9f0 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -412,8 +412,8 @@ static inline void i2c_unlock_adapter(struct i2c_adapter *adapter)
 #define ANY_I2C_BUS		0xffff
 
 /* Construct an I2C_CLIENT_END-terminated array of i2c addresses */
-#define I2C_ADDRS(addr, addrs...) \
-	((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })
+#define I2C_ADDRS(addr, address...) \
+	((const unsigned short []){ addr, ## address, I2C_CLIENT_END })
 
 
 /* ----- functions exported by i2c.o */
diff --git a/include/linux/if_ppp.h b/include/linux/if_ppp.h
index fcef103..9e0b2cc 100644
--- a/include/linux/if_ppp.h
+++ b/include/linux/if_ppp.h
@@ -54,7 +54,7 @@
 #define SC_COMP_AC	0x00000002	/* header compression (output) */
 #define	SC_COMP_TCP	0x00000004	/* TCP (VJ) compression (output) */
 #define SC_NO_TCP_CCID	0x00000008	/* disable VJ connection-id comp. */
-#define SC_REJ_COMP_AC	0x00000010	/* reject adrs/ctrl comp. on input */
+#define SC_REJ_COMP_AC	0x00000010	/* reject address/ctrl comp. on input */
 #define SC_REJ_COMP_TCP	0x00000020	/* reject TCP (VJ) comp. on input */
 #define SC_CCP_OPEN	0x00000040	/* Look at CCP packets */
 #define SC_CCP_UP	0x00000080	/* May send/recv compressed packets */
diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index bc8c490..904ba02 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -72,7 +72,7 @@ struct inet_diag_hostcond {
 	__be32	addr[0];
 };
 
-/* Base info structure. It contains socket identity (addrs/ports/cookie)
+/* Base info structure. It contains socket identity (address/ports/cookie)
  * and, alas, the information shown by netstat. */
 struct inet_diag_msg {
 	__u8	idiag_family;
diff --git a/include/linux/netfilter_ipv6/ip6t_rt.h b/include/linux/netfilter_ipv6/ip6t_rt.h
index ab91bfd..389a7ba 100644
--- a/include/linux/netfilter_ipv6/ip6t_rt.h
+++ b/include/linux/netfilter_ipv6/ip6t_rt.h
@@ -11,7 +11,7 @@ struct ip6t_rt {
 	u_int32_t hdrlen;			/* Header Length */
 	u_int8_t  flags;			/*  */
 	u_int8_t  invflags;			/* Inverse flags */
-	struct in6_addr addrs[IP6T_RT_HOPS];	/* Hops */
+	struct in6_addr address[IP6T_RT_HOPS];	/* Hops */
 	u_int8_t addrnr;			/* Nr of Addresses */
 };
 
diff --git a/include/linux/spi/eeprom.h b/include/linux/spi/eeprom.h
index 306e7b1..66253b0 100644
--- a/include/linux/spi/eeprom.h
+++ b/include/linux/spi/eeprom.h
@@ -15,9 +15,9 @@ struct spi_eeprom {
 	char		name[10];
 	u16		page_size;		/* for writes */
 	u16		flags;
-#define	EE_ADDR1	0x0001			/*  8 bit addrs */
-#define	EE_ADDR2	0x0002			/* 16 bit addrs */
-#define	EE_ADDR3	0x0004			/* 24 bit addrs */
+#define	EE_ADDR1	0x0001			/*  8 bit address */
+#define	EE_ADDR2	0x0002			/* 16 bit address */
+#define	EE_ADDR3	0x0004			/* 24 bit address */
 #define	EE_READONLY	0x0008			/* disallow writes */
 
 	/* for exporting this chip's data to other kernel code */
diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 8ed9642..e2e4921 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -249,7 +249,7 @@ static inline bool __rpc_copy_addr6(struct sockaddr *dst,
  * @sap2: second sockaddr
  *
  * Just compares the family and address portion. Ignores port, scope, etc.
- * Returns true if the addrs are equal, false if they aren't.
+ * Returns true if the address are equal, false if they aren't.
  */
 static inline bool rpc_cmp_addr(const struct sockaddr *sap1,
 				const struct sockaddr *sap2)
@@ -291,7 +291,7 @@ static inline bool rpc_copy_addr(struct sockaddr *dst,
  * rpc_get_scope_id - return scopeid for a given sockaddr
  * @sa: sockaddr to get scopeid from
  *
- * Returns the value of the sin6_scope_id for AF_INET6 addrs, or 0 if
+ * Returns the value of the sin6_scope_id for AF_INET6 address, or 0 if
  * not an AF_INET6 address.
  */
 static inline u32 rpc_get_scope_id(const struct sockaddr *sa)
diff --git a/include/linux/tboot.h b/include/linux/tboot.h
index 1dba6ee..d6c1497 100644
--- a/include/linux/tboot.h
+++ b/include/linux/tboot.h
@@ -102,7 +102,7 @@ struct tboot {
 	u32 tboot_base;
 	u32 tboot_size;
 
-	/* memory regions (phys addrs) for tboot to MAC on S3 */
+	/* memory regions (phys address) for tboot to MAC on S3 */
 	u8 num_mac_regions;
 	struct tboot_mac_region mac_regions[MAX_TB_MAC_REGIONS];
 
diff --git a/include/media/tvaudio.h b/include/media/tvaudio.h
index 1ac8184..a351815 100644
--- a/include/media/tvaudio.h
+++ b/include/media/tvaudio.h
@@ -31,7 +31,7 @@
 
 static inline const unsigned short *tvaudio_addrs(void)
 {
-	static const unsigned short addrs[] = {
+	static const unsigned short address[] = {
 		I2C_ADDR_TDA8425   >> 1,
 		I2C_ADDR_TEA6300   >> 1,
 		I2C_ADDR_TEA6420   >> 1,
@@ -43,7 +43,7 @@ static inline const unsigned short *tvaudio_addrs(void)
 		I2C_CLIENT_END
 	};
 
-	return addrs;
+	return address;
 }
 
 #endif
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 2600b69..fab8782 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -427,7 +427,7 @@ static inline int __ipv6_addr_diff(const void *token1, const void *token2, int a
 
 	/*
 	 *	we should *never* get to this point since that 
-	 *	would mean the addrs are equal
+	 *	would mean the address are equal
 	 *
 	 *	However, we do get to it 8) And exacly, when
 	 *	addresses are equal 8)
diff --git a/include/net/phonet/pn_dev.h b/include/net/phonet/pn_dev.h
index d7b989c..fbf6eb6 100644
--- a/include/net/phonet/pn_dev.h
+++ b/include/net/phonet/pn_dev.h
@@ -33,7 +33,7 @@ struct phonet_device_list *phonet_device_list(struct net *net);
 struct phonet_device {
 	struct list_head list;
 	struct net_device *netdev;
-	DECLARE_BITMAP(addrs, 64);
+	DECLARE_BITMAP(address, 64);
 };
 
 int phonet_device_init(void);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 4b86011..7c21c8d 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1228,7 +1228,7 @@ int sctp_bind_addr_conflict(struct sctp_bind_addr *, const union sctp_addr *,
 int sctp_bind_addr_state(const struct sctp_bind_addr *bp,
 			 const union sctp_addr *addr);
 union sctp_addr *sctp_find_unmatch_addr(struct sctp_bind_addr	*bp,
-					const union sctp_addr	*addrs,
+					const union sctp_addr	*address,
 					int			addrcnt,
 					struct sctp_sock	*opt);
 union sctp_params sctp_bind_addrs_to_raw(const struct sctp_bind_addr *bp,
diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
index 2b2769c..ef0504a 100644
--- a/include/net/sctp/user.h
+++ b/include/net/sctp/user.h
@@ -94,13 +94,13 @@ typedef __s32 sctp_assoc_t;
 /* Internal Socket Options. Some of the sctp library functions are
  * implemented using these socket options.
  */
-#define SCTP_SOCKOPT_BINDX_ADD	100	/* BINDX requests for adding addrs */
-#define SCTP_SOCKOPT_BINDX_REM	101	/* BINDX requests for removing addrs. */
+#define SCTP_SOCKOPT_BINDX_ADD	100	/* BINDX requests for adding address */
+#define SCTP_SOCKOPT_BINDX_REM	101	/* BINDX requests for removing address. */
 #define SCTP_SOCKOPT_PEELOFF	102	/* peel off association. */
 /* Options 104-106 are deprecated and removed. Do not use this space */
 #define SCTP_SOCKOPT_CONNECTX_OLD	107	/* CONNECTX old requests. */
-#define SCTP_GET_PEER_ADDRS	108		/* Get all peer addresss. */
-#define SCTP_GET_LOCAL_ADDRS	109		/* Get all local addresss. */
+#define SCTP_GET_PEER_ADDRS	108		/* Get all peer address. */
+#define SCTP_GET_LOCAL_ADDRS	109		/* Get all local address. */
 #define SCTP_SOCKOPT_CONNECTX	110		/* CONNECTX requests. */
 #define SCTP_SOCKOPT_CONNECTX3	111	/* CONNECTX requests (updated) */
 
@@ -676,12 +676,12 @@ struct sctp_authchunks {
 struct sctp_getaddrs_old {
 	sctp_assoc_t            assoc_id;
 	int			addr_num;
-	struct sockaddr		__user *addrs;
+	struct sockaddr		__user *address;
 };
 struct sctp_getaddrs {
 	sctp_assoc_t		assoc_id; /*input*/
 	__u32			addr_num; /*output*/
-	__u8			addrs[0]; /*output, variable size*/
+	__u8			address[0]; /*output, variable size*/
 };
 
 /* These are bit fields for msghdr->msg_flags.  See section 5.1.  */
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index 39da93c..6b05553 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -343,7 +343,7 @@ DEFINE_GUEST_HANDLE_STRUCT(gnttab_query_size);
  /*
   * GNTMAP_contains_pte subflag:
   *  0 => This map request contains a host virtual address.
-  *  1 => This map request contains the machine addess of the PTE to update.
+  *  1 => This map request contains the machine address of the PTE to update.
   */
 #define _GNTMAP_contains_pte    (4)
 #define GNTMAP_contains_pte     (1<<_GNTMAP_contains_pte)
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 474a847..a68068c 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -161,7 +161,7 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 	 * just verifies it is an address we can use.
 	 *
 	 * Since the kernel does everything in page size chunks ensure
-	 * the destination addreses are page aligned.  Too many
+	 * the destination addresses are page aligned.  Too many
 	 * special cases crop of when we don't do this.  The most
 	 * insidious is getting overlapping destination addresses
 	 * simply because addresses are changed to page size
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 1357c57..d9c5fe4 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1193,7 +1193,7 @@ static ssize_t bin_dn_node_address(struct file *file,
 
 		buf[result] = '\0';
 
-		/* Convert the decnet addresss to binary */
+		/* Convert the decnet address to binary */
 		result = -EIO;
 		nodep = strchr(buf, '.') + 1;
 		if (!nodep)
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index dc008c1..c9b8e8a 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -53,7 +53,7 @@
  */
 
 /*
- * Function trace entry - function address and parent function addres:
+ * Function trace entry - function address and parent function address:
  */
 FTRACE_ENTRY(function, ftrace_entry,
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 4205b1d..05ce748 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -941,7 +941,7 @@ static int do_pages_move(struct mm_struct *mm, struct task_struct *task,
 		if (chunk_start + chunk_nr_pages > nr_pages)
 			chunk_nr_pages = nr_pages - chunk_start;
 
-		/* fill the chunk pm with addrs and nodes from user-space */
+		/* fill the chunk pm with address and nodes from user-space */
 		for (j = 0; j < chunk_nr_pages; j++) {
 			const void __user *p;
 			int node;
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 4c409b4..9b73e0b 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -1112,7 +1112,7 @@ static struct dn_dev *dn_dev_create(struct net_device *dev, int *err)
 /*
  * This processes a device up event. We only start up
  * the loopback device & ethernet devices with correct
- * MAC addreses automatically. Others must be started
+ * MAC addresses automatically. Others must be started
  * specifically.
  *
  * FIXME: How should we configure the loopback address ? If we could dispense
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index b9d84e8..a1f4cc6 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1521,7 +1521,7 @@ static int __init ic_proto_name(char *name)
 	return 0;
 }
 
-static int __init ip_auto_config_setup(char *addrs)
+static int __init ip_auto_config_setup(char *address)
 {
 	char *cp, *ip, *dp;
 	int num = 0;
@@ -1533,19 +1533,19 @@ static int __init ip_auto_config_setup(char *addrs)
 	 * If any dhcp, bootp etc options are set, leave autoconfig on
 	 * and skip the below static IP processing.
 	 */
-	if (ic_proto_name(addrs))
+	if (ic_proto_name(address))
 		return 1;
 
 	/* If no static IP is given, turn off autoconfig and bail.  */
-	if (*addrs == 0 ||
-	    strcmp(addrs, "off") == 0 ||
-	    strcmp(addrs, "none") == 0) {
+	if (*address == 0 ||
+	    strcmp(address, "off") == 0 ||
+	    strcmp(address, "none") == 0) {
 		ic_enable = 0;
 		return 1;
 	}
 
 	/* Parse string for static IP assignment.  */
-	ip = addrs;
+	ip = address;
 	while (ip && *ip) {
 		if ((cp = strchr(ip, ':')))
 			*cp++ = '\0';
@@ -1596,14 +1596,14 @@ static int __init ip_auto_config_setup(char *addrs)
 	return 1;
 }
 
-static int __init nfsaddrs_config_setup(char *addrs)
+static int __init nfsaddrs_config_setup(char *address)
 {
-	return ip_auto_config_setup(addrs);
+	return ip_auto_config_setup(address);
 }
 
-static int __init vendor_class_identifier_setup(char *addrs)
+static int __init vendor_class_identifier_setup(char *address)
 {
-	if (strlcpy(vendor_class_identifier, addrs,
+	if (strlcpy(vendor_class_identifier, address,
 		    sizeof(vendor_class_identifier))
 	    >= sizeof(vendor_class_identifier))
 		printk(KERN_WARNING "DHCP: vendorclass too long, truncated to \"%s\"",
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e1a698d..c7dd07b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2397,7 +2397,7 @@ static void addrconf_sit_config(struct net_device *dev)
 	/*
 	 * Configure the tunnel with one of our IPv4
 	 * addresses... we should configure all of
-	 * our v4 addrs in the tunnel
+	 * our v4 address in the tunnel
 	 */
 
 	if ((idev = ipv6_find_idev(dev)) == NULL) {
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index ee82d4e..bc94254 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -223,7 +223,7 @@ static void ipv6_rearrange_destopt(struct ipv6hdr *iph, struct ipv6_opt_hdr *des
 static void ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
 {
 	int segments, segments_left;
-	struct in6_addr *addrs;
+	struct in6_addr *address;
 	struct in6_addr final_addr;
 
 	segments_left = rthdr->segments_left;
@@ -240,13 +240,13 @@ static void ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
 	 */
 	segments = rthdr->hdrlen >> 1;
 
-	addrs = ((struct rt0_hdr *)rthdr)->addr;
-	ipv6_addr_copy(&final_addr, addrs + segments - 1);
+	address = ((struct rt0_hdr *)rthdr)->addr;
+	ipv6_addr_copy(&final_addr, address + segments - 1);
 
-	addrs += segments - segments_left;
-	memmove(addrs + 1, addrs, (segments_left - 1) * sizeof(*addrs));
+	address += segments - segments_left;
+	memmove(address + 1, address, (segments_left - 1) * sizeof(*address));
 
-	ipv6_addr_copy(addrs, &iph->daddr);
+	ipv6_addr_copy(address, &iph->daddr);
 	ipv6_addr_copy(&iph->daddr, &final_addr);
 }
 
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 92a122b..3cde924 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -512,7 +512,7 @@ insert_above:
 
 	pn = fn->parent;
 
-	/* find 1st bit in difference between the 2 addrs.
+	/* find 1st bit in difference between the 2 address.
 
 	   See comment in __ipv6_addr_diff: bit may be an invalid value,
 	   but if it is >= plen, the value is ignored in any case.
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index d8488c5..c5ea40d 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -139,7 +139,7 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 
 				BUG_ON(ap == NULL);
 
-				if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
+				if (ipv6_addr_equal(ap, &rtinfo->address[i])) {
 					pr_debug("i=%d temp=%d;\n", i, temp);
 					i++;
 				}
@@ -168,7 +168,7 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 							&_addr);
 				BUG_ON(ap == NULL);
 
-				if (!ipv6_addr_equal(ap, &rtinfo->addrs[temp]))
+				if (!ipv6_addr_equal(ap, &rtinfo->address[temp]))
 					break;
 			}
 			pr_debug("temp=%d #%d\n", temp, rtinfo->addrnr);
diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index c33da65..6501828 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -67,7 +67,7 @@ static struct phonet_device *__phonet_device_alloc(struct net_device *dev)
 	if (pnd == NULL)
 		return NULL;
 	pnd->netdev = dev;
-	bitmap_zero(pnd->addrs, 64);
+	bitmap_zero(pnd->address, 64);
 
 	BUG_ON(!mutex_is_locked(&pndevs->lock));
 	list_add_rcu(&pnd->list, &pndevs->list);
@@ -115,7 +115,7 @@ static void phonet_device_destroy(struct net_device *dev)
 	if (pnd) {
 		u8 addr;
 
-		for_each_set_bit(addr, pnd->addrs, 64)
+		for_each_set_bit(addr, pnd->address, 64)
 			phonet_address_notify(RTM_DELADDR, dev, addr);
 		kfree(pnd);
 	}
@@ -156,7 +156,7 @@ int phonet_address_add(struct net_device *dev, u8 addr)
 		pnd = __phonet_device_alloc(dev);
 	if (unlikely(pnd == NULL))
 		err = -ENOMEM;
-	else if (test_and_set_bit(addr >> 2, pnd->addrs))
+	else if (test_and_set_bit(addr >> 2, pnd->address))
 		err = -EEXIST;
 	mutex_unlock(&pndevs->lock);
 	return err;
@@ -170,10 +170,10 @@ int phonet_address_del(struct net_device *dev, u8 addr)
 
 	mutex_lock(&pndevs->lock);
 	pnd = __phonet_get(dev);
-	if (!pnd || !test_and_clear_bit(addr >> 2, pnd->addrs)) {
+	if (!pnd || !test_and_clear_bit(addr >> 2, pnd->address)) {
 		err = -EADDRNOTAVAIL;
 		pnd = NULL;
-	} else if (bitmap_empty(pnd->addrs, 64))
+	} else if (bitmap_empty(pnd->address, 64))
 		list_del_rcu(&pnd->list);
 	else
 		pnd = NULL;
@@ -195,13 +195,13 @@ u8 phonet_address_get(struct net_device *dev, u8 daddr)
 	rcu_read_lock();
 	pnd = __phonet_get_rcu(dev);
 	if (pnd) {
-		BUG_ON(bitmap_empty(pnd->addrs, 64));
+		BUG_ON(bitmap_empty(pnd->address, 64));
 
 		/* Use same source address as destination, if possible */
-		if (test_bit(daddr >> 2, pnd->addrs))
+		if (test_bit(daddr >> 2, pnd->address))
 			saddr = daddr;
 		else
-			saddr = find_first_bit(pnd->addrs, 64) << 2;
+			saddr = find_first_bit(pnd->address, 64) << 2;
 	} else
 		saddr = PN_NO_ADDR;
 	rcu_read_unlock();
@@ -233,7 +233,7 @@ int phonet_address_lookup(struct net *net, u8 addr)
 				((pnd->netdev->flags & IFF_UP)) != IFF_UP)
 			continue;
 
-		if (test_bit(addr >> 2, pnd->addrs)) {
+		if (test_bit(addr >> 2, pnd->address)) {
 			err = 0;
 			goto found;
 		}
diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
index 58b3b1f..7fc9de2 100644
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -142,7 +142,7 @@ static int getaddr_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 			continue;
 
 		addr_idx = 0;
-		for_each_set_bit(addr, pnd->addrs, 64) {
+		for_each_set_bit(addr, pnd->address, 64) {
 			if (addr_idx++ < addr_start_idx)
 				continue;
 
diff --git a/net/rds/iw_rdma.c b/net/rds/iw_rdma.c
index 13dc186..c1da1f1 100644
--- a/net/rds/iw_rdma.c
+++ b/net/rds/iw_rdma.c
@@ -301,7 +301,7 @@ static u64 *rds_iw_map_scatterlist(struct rds_iw_device *rds_iwdev,
 		sg->dma_npages += (end_addr - dma_addr) >> PAGE_SHIFT;
 	}
 
-	/* Now gather the dma addrs into one list */
+	/* Now gather the dma address into one list */
 	if (sg->dma_npages > fastreg_message_size)
 		goto out_unmap;
 
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 795a00b..f133c5d 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -153,7 +153,7 @@ static void rds_recv_incoming_exthdrs(struct rds_incoming *inc, struct rds_sock
  *
  * The caller passes in saddr and daddr instead of us getting it from the
  * conn.  This lets loopback, who only has one conn for both directions,
- * tell us which roles the addrs in the conn are playing for this message.
+ * tell us which roles the address in the conn are playing for this message.
  */
 void rds_recv_incoming(struct rds_connection *conn, __be32 saddr, __be32 daddr,
 		       struct rds_incoming *inc, gfp_t gfp, enum km_type km)
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index faf71d1..ee359be 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -412,10 +412,10 @@ int sctp_bind_addr_state(const struct sctp_bind_addr *bp,
 }
 
 /* Find the first address in the bind address list that is not present in
- * the addrs packed array.
+ * the address packed array.
  */
 union sctp_addr *sctp_find_unmatch_addr(struct sctp_bind_addr	*bp,
-					const union sctp_addr	*addrs,
+					const union sctp_addr	*address,
 					int			addrcnt,
 					struct sctp_sock	*opt)
 {
@@ -430,7 +430,7 @@ union sctp_addr *sctp_find_unmatch_addr(struct sctp_bind_addr	*bp,
 	 * can't change.
 	 */
 	list_for_each_entry(laddr, &bp->address_list, list) {
-		addr_buf = (union sctp_addr *)addrs;
+		addr_buf = (union sctp_addr *)address;
 		for (i = 0; i < addrcnt; i++) {
 			addr = (union sctp_addr *)addr_buf;
 			af = sctp_get_af_specific(addr->v4.sin_family);
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 7326891..b0932a4 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -793,7 +793,7 @@ static int sctp_inet6_cmp_addr(const union sctp_addr *addr1,
 	if (!af1 || !af2)
 		return 0;
 
-	/* If the socket is IPv6 only, v4 addrs will not match */
+	/* If the socket is IPv6 only, v4 address will not match */
 	if (__ipv6_only_sock(sk) && af1 != af2)
 		return 0;
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index bd2a50b..c1e98fb 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -197,7 +197,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 			     gfp_t gfp, int vparam_len)
 {
 	sctp_inithdr_t init;
-	union sctp_params addrs;
+	union sctp_params address;
 	size_t chunksize;
 	struct sctp_chunk *retval = NULL;
 	int num_types, addrs_len = 0;
@@ -219,7 +219,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	retval = NULL;
 
 	/* Convert the provided bind address list to raw format. */
-	addrs = sctp_bind_addrs_to_raw(bp, &addrs_len, gfp);
+	address = sctp_bind_addrs_to_raw(bp, &addrs_len, gfp);
 
 	init.init_tag		   = htonl(asoc->c.my_vtag);
 	init.a_rwnd		   = htonl(asoc->rwnd);
@@ -301,7 +301,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	retval->subh.init_hdr =
 		sctp_addto_chunk(retval, sizeof(init), &init);
 	retval->param_hdr.v =
-		sctp_addto_chunk(retval, addrs_len, addrs.v);
+		sctp_addto_chunk(retval, addrs_len, address.v);
 
 	/* RFC 2960 3.3.2 Initiation (INIT) (1)
 	 *
@@ -351,7 +351,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 					auth_chunks);
 	}
 nodata:
-	kfree(addrs.v);
+	kfree(address.v);
 	return retval;
 }
 
@@ -361,7 +361,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 {
 	sctp_inithdr_t initack;
 	struct sctp_chunk *retval;
-	union sctp_params addrs;
+	union sctp_params address;
 	struct sctp_sock *sp;
 	int addrs_len;
 	sctp_cookie_param_t *cookie;
@@ -378,7 +378,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	retval = NULL;
 
 	/* Note: there may be no addresses to embed. */
-	addrs = sctp_bind_addrs_to_raw(&asoc->base.bind_addr, &addrs_len, gfp);
+	address = sctp_bind_addrs_to_raw(&asoc->base.bind_addr, &addrs_len, gfp);
 
 	initack.init_tag	        = htonl(asoc->c.my_vtag);
 	initack.a_rwnd			= htonl(asoc->rwnd);
@@ -390,7 +390,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	 * into the packet instead of allocating more fresh memory.
 	 */
 	cookie = sctp_pack_cookie(asoc->ep, asoc, chunk, &cookie_len,
-				  addrs.v, addrs_len);
+				  address.v, addrs_len);
 	if (!cookie)
 		goto nomem_cookie;
 
@@ -458,7 +458,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 
 	retval->subh.init_hdr =
 		sctp_addto_chunk(retval, sizeof(initack), &initack);
-	retval->param_hdr.v = sctp_addto_chunk(retval, addrs_len, addrs.v);
+	retval->param_hdr.v = sctp_addto_chunk(retval, addrs_len, address.v);
 	sctp_addto_chunk(retval, cookie_len, cookie);
 	if (asoc->peer.ecn_capable)
 		sctp_addto_chunk(retval, sizeof(ecap_param), &ecap_param);
@@ -497,7 +497,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 nomem_chunk:
 	kfree(cookie);
 nomem_cookie:
-	kfree(addrs.v);
+	kfree(address.v);
 	return retval;
 }
 
@@ -2728,7 +2728,7 @@ static struct sctp_chunk *sctp_make_asconf(struct sctp_association *asoc,
  */
 struct sctp_chunk *sctp_make_asconf_update_ip(struct sctp_association *asoc,
 					      union sctp_addr	      *laddr,
-					      struct sockaddr	      *addrs,
+					      struct sockaddr	      *address,
 					      int		      addrcnt,
 					      __be16		      flags)
 {
@@ -2744,7 +2744,7 @@ struct sctp_chunk *sctp_make_asconf_update_ip(struct sctp_association *asoc,
 	int 			i;
 
 	/* Get total length of all the address parameters. */
-	addr_buf = addrs;
+	addr_buf = address;
 	for (i = 0; i < addrcnt; i++) {
 		addr = (union sctp_addr *)addr_buf;
 		af = sctp_get_af_specific(addr->v4.sin_family);
@@ -2762,7 +2762,7 @@ struct sctp_chunk *sctp_make_asconf_update_ip(struct sctp_association *asoc,
 		return NULL;
 
 	/* Add the address parameters to the asconf chunk. */
-	addr_buf = addrs;
+	addr_buf = address;
 	for (i = 0; i < addrcnt; i++) {
 		addr = (union sctp_addr *)addr_buf;
 		af = sctp_get_af_specific(addr->v4.sin_family);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ca44917..74ebece 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -449,7 +449,7 @@ out:
 /* Add a list of addresses as bind addresses to local endpoint or
  * association.
  *
- * Basically run through each address specified in the addrs/addrcnt
+ * Basically run through each address specified in the address/addrcnt
  * array/length pair, determine if it is IPv6 or IPv4 and call
  * sctp_do_bind() on it.
  *
@@ -458,7 +458,7 @@ out:
  *
  * Only sctp_setsockopt_bindx() is supposed to call this function.
  */
-static int sctp_bindx_add(struct sock *sk, struct sockaddr *addrs, int addrcnt)
+static int sctp_bindx_add(struct sock *sk, struct sockaddr *address, int addrcnt)
 {
 	int cnt;
 	int retval = 0;
@@ -466,10 +466,10 @@ static int sctp_bindx_add(struct sock *sk, struct sockaddr *addrs, int addrcnt)
 	struct sockaddr *sa_addr;
 	struct sctp_af *af;
 
-	SCTP_DEBUG_PRINTK("sctp_bindx_add (sk: %p, addrs: %p, addrcnt: %d)\n",
-			  sk, addrs, addrcnt);
+	SCTP_DEBUG_PRINTK("sctp_bindx_add (sk: %p, address: %p, addrcnt: %d)\n",
+			  sk, address, addrcnt);
 
-	addr_buf = addrs;
+	addr_buf = address;
 	for (cnt = 0; cnt < addrcnt; cnt++) {
 		/* The list may contain either IPv4 or IPv6 address;
 		 * determine the address length for walking thru the list.
@@ -490,7 +490,7 @@ err_bindx_add:
 		if (retval < 0) {
 			/* Failed. Cleanup the ones that have been added */
 			if (cnt > 0)
-				sctp_bindx_rem(sk, addrs, cnt);
+				sctp_bindx_rem(sk, address, cnt);
 			return retval;
 		}
 	}
@@ -509,7 +509,7 @@ err_bindx_add:
  * Only sctp_setsockopt_bindx() is supposed to call this function.
  */
 static int sctp_send_asconf_add_ip(struct sock		*sk,
-				   struct sockaddr	*addrs,
+				   struct sockaddr	*address,
 				   int 			addrcnt)
 {
 	struct sctp_sock		*sp;
@@ -532,8 +532,8 @@ static int sctp_send_asconf_add_ip(struct sock		*sk,
 	sp = sctp_sk(sk);
 	ep = sp->ep;
 
-	SCTP_DEBUG_PRINTK("%s: (sk: %p, addrs: %p, addrcnt: %d)\n",
-			  __func__, sk, addrs, addrcnt);
+	SCTP_DEBUG_PRINTK("%s: (sk: %p, address: %p, addrcnt: %d)\n",
+			  __func__, sk, address, addrcnt);
 
 	list_for_each_entry(asoc, &ep->asocs, asocs) {
 
@@ -551,7 +551,7 @@ static int sctp_send_asconf_add_ip(struct sock		*sk,
 		 * do not send the asconf chunk to its peer, but continue with
 		 * other associations.
 		 */
-		addr_buf = addrs;
+		addr_buf = address;
 		for (i = 0; i < addrcnt; i++) {
 			addr = (union sctp_addr *)addr_buf;
 			af = sctp_get_af_specific(addr->v4.sin_family);
@@ -574,7 +574,7 @@ static int sctp_send_asconf_add_ip(struct sock		*sk,
 		bp = &asoc->base.bind_addr;
 		p = bp->address_list.next;
 		laddr = list_entry(p, struct sctp_sockaddr_entry, list);
-		chunk = sctp_make_asconf_update_ip(asoc, &laddr->a, addrs,
+		chunk = sctp_make_asconf_update_ip(asoc, &laddr->a, address,
 						   addrcnt, SCTP_PARAM_ADD_IP);
 		if (!chunk) {
 			retval = -ENOMEM;
@@ -588,7 +588,7 @@ static int sctp_send_asconf_add_ip(struct sock		*sk,
 		/* Add the new addresses to the bind address list with
 		 * use_as_src set to 0.
 		 */
-		addr_buf = addrs;
+		addr_buf = address;
 		for (i = 0; i < addrcnt; i++) {
 			addr = (union sctp_addr *)addr_buf;
 			af = sctp_get_af_specific(addr->v4.sin_family);
@@ -606,7 +606,7 @@ out:
 /* Remove a list of addresses from bind addresses list.  Do not remove the
  * last address.
  *
- * Basically run through each address specified in the addrs/addrcnt
+ * Basically run through each address specified in the address/addrcnt
  * array/length pair, determine if it is IPv6 or IPv4 and call
  * sctp_del_bind() on it.
  *
@@ -618,7 +618,7 @@ out:
  *
  * Only sctp_setsockopt_bindx() is supposed to call this function.
  */
-static int sctp_bindx_rem(struct sock *sk, struct sockaddr *addrs, int addrcnt)
+static int sctp_bindx_rem(struct sock *sk, struct sockaddr *address, int addrcnt)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_endpoint *ep = sp->ep;
@@ -629,10 +629,10 @@ static int sctp_bindx_rem(struct sock *sk, struct sockaddr *addrs, int addrcnt)
 	union sctp_addr *sa_addr;
 	struct sctp_af *af;
 
-	SCTP_DEBUG_PRINTK("sctp_bindx_rem (sk: %p, addrs: %p, addrcnt: %d)\n",
-			  sk, addrs, addrcnt);
+	SCTP_DEBUG_PRINTK("sctp_bindx_rem (sk: %p, address: %p, addrcnt: %d)\n",
+			  sk, address, addrcnt);
 
-	addr_buf = addrs;
+	addr_buf = address;
 	for (cnt = 0; cnt < addrcnt; cnt++) {
 		/* If the bind address list is empty or if there is only one
 		 * bind address, there is nothing more to be removed (we need
@@ -675,7 +675,7 @@ err_bindx_rem:
 		if (retval < 0) {
 			/* Failed. Add the ones that has been removed back */
 			if (cnt > 0)
-				sctp_bindx_add(sk, addrs, cnt);
+				sctp_bindx_add(sk, address, cnt);
 			return retval;
 		}
 	}
@@ -694,7 +694,7 @@ err_bindx_rem:
  * Only sctp_setsockopt_bindx() is supposed to call this function.
  */
 static int sctp_send_asconf_del_ip(struct sock		*sk,
-				   struct sockaddr	*addrs,
+				   struct sockaddr	*address,
 				   int			addrcnt)
 {
 	struct sctp_sock	*sp;
@@ -716,8 +716,8 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 	sp = sctp_sk(sk);
 	ep = sp->ep;
 
-	SCTP_DEBUG_PRINTK("%s: (sk: %p, addrs: %p, addrcnt: %d)\n",
-			  __func__, sk, addrs, addrcnt);
+	SCTP_DEBUG_PRINTK("%s: (sk: %p, address: %p, addrcnt: %d)\n",
+			  __func__, sk, address, addrcnt);
 
 	list_for_each_entry(asoc, &ep->asocs, asocs) {
 
@@ -735,7 +735,7 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 		 * If so, do not send the asconf chunk to its peer, but
 		 * continue with other associations.
 		 */
-		addr_buf = addrs;
+		addr_buf = address;
 		for (i = 0; i < addrcnt; i++) {
 			laddr = (union sctp_addr *)addr_buf;
 			af = sctp_get_af_specific(laddr->v4.sin_family);
@@ -758,7 +758,7 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 		 * association.
 		 */
 		bp = &asoc->base.bind_addr;
-		laddr = sctp_find_unmatch_addr(bp, (union sctp_addr *)addrs,
+		laddr = sctp_find_unmatch_addr(bp, (union sctp_addr *)address,
 					       addrcnt, sp);
 		if (!laddr)
 			continue;
@@ -767,7 +767,7 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 		 * because this is done under a socket lock from the
 		 * setsockopt call.
 		 */
-		chunk = sctp_make_asconf_update_ip(asoc, laddr, addrs, addrcnt,
+		chunk = sctp_make_asconf_update_ip(asoc, laddr, address, addrcnt,
 						   SCTP_PARAM_DEL_IP);
 		if (!chunk) {
 			retval = -ENOMEM;
@@ -777,7 +777,7 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 		/* Reset use_as_src flag for the addresses in the bind address
 		 * list that are to be deleted.
 		 */
-		addr_buf = addrs;
+		addr_buf = address;
 		for (i = 0; i < addrcnt; i++) {
 			laddr = (union sctp_addr *)addr_buf;
 			af = sctp_get_af_specific(laddr->v4.sin_family);
@@ -808,7 +808,7 @@ out:
 /* Helper for tunneling sctp_bindx() requests through sctp_setsockopt()
  *
  * API 8.1
- * int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt,
+ * int sctp_bindx(int sd, struct sockaddr *address, int addrcnt,
  *                int flags);
  *
  * If sd is an IPv4 socket, the addresses passed must be IPv4 addresses.
@@ -818,7 +818,7 @@ out:
  * A single address may be specified as INADDR_ANY or IN6ADDR_ANY, see
  * Section 3.1.2 for this usage.
  *
- * addrs is a pointer to an array of one or more socket addresses. Each
+ * address is a pointer to an array of one or more socket addresses. Each
  * address is contained in its appropriate structure (i.e. struct
  * sockaddr_in or struct sockaddr_in6) the family of the address type
  * must be used to distinguish the address length (note that this
@@ -874,15 +874,15 @@ out:
  * it.
  *
  * sk        The sk of the socket
- * addrs     The pointer to the addresses in user land
- * addrssize Size of the addrs buffer
+ * address     The pointer to the addresses in user land
+ * addrssize Size of the address buffer
  * op        Operation to perform (add or remove, see the flags of
  *           sctp_bindx)
  *
  * Returns 0 if ok, <0 errno code on error.
  */
 SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
-				      struct sockaddr __user *addrs,
+				      struct sockaddr __user *address,
 				      int addrs_size, int op)
 {
 	struct sockaddr *kaddrs;
@@ -893,14 +893,14 @@ SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
 	void *addr_buf;
 	struct sctp_af *af;
 
-	SCTP_DEBUG_PRINTK("sctp_setsocktopt_bindx: sk %p addrs %p"
-			  " addrs_size %d opt %d\n", sk, addrs, addrs_size, op);
+	SCTP_DEBUG_PRINTK("sctp_setsocktopt_bindx: sk %p address %p"
+			  " addrs_size %d opt %d\n", sk, address, addrs_size, op);
 
 	if (unlikely(addrs_size <= 0))
 		return -EINVAL;
 
 	/* Check the user passed a healthy pointer.  */
-	if (unlikely(!access_ok(VERIFY_READ, addrs, addrs_size)))
+	if (unlikely(!access_ok(VERIFY_READ, address, addrs_size)))
 		return -EFAULT;
 
 	/* Alloc space for the address array in kernel memory.  */
@@ -908,12 +908,12 @@ SCTP_STATIC int sctp_setsockopt_bindx(struct sock* sk,
 	if (unlikely(!kaddrs))
 		return -ENOMEM;
 
-	if (__copy_from_user(kaddrs, addrs, addrs_size)) {
+	if (__copy_from_user(kaddrs, address, addrs_size)) {
 		kfree(kaddrs);
 		return -EFAULT;
 	}
 
-	/* Walk through the addrs buffer and count the number of addresses. */
+	/* Walk through the address buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
 		sa_addr = (struct sockaddr *)addr_buf;
@@ -999,7 +999,7 @@ static int __sctp_connect(struct sock* sk,
 		goto out_free;
 	}
 
-	/* Walk through the addrs buffer and count the number of addresses. */
+	/* Walk through the address buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
 		sa_addr = (union sctp_addr *)addr_buf;
@@ -1151,7 +1151,7 @@ out_free:
 /* Helper for tunneling sctp_connectx() requests through sctp_setsockopt()
  *
  * API 8.9
- * int sctp_connectx(int sd, struct sockaddr *addrs, int addrcnt,
+ * int sctp_connectx(int sd, struct sockaddr *address, int addrcnt,
  * 			sctp_assoc_t *asoc);
  *
  * If sd is an IPv4 socket, the addresses passed must be IPv4 addresses.
@@ -1161,7 +1161,7 @@ out_free:
  * A single address may be specified as INADDR_ANY or IN6ADDR_ANY, see
  * Section 3.1.2 for this usage.
  *
- * addrs is a pointer to an array of one or more socket addresses. Each
+ * address is a pointer to an array of one or more socket addresses. Each
  * address is contained in its appropriate structure (i.e. struct
  * sockaddr_in or struct sockaddr_in6) the family of the address type
  * must be used to distengish the address length (note that this
@@ -1205,27 +1205,27 @@ out_free:
  * it.
  *
  * sk        The sk of the socket
- * addrs     The pointer to the addresses in user land
- * addrssize Size of the addrs buffer
+ * address     The pointer to the addresses in user land
+ * addrssize Size of the address buffer
  *
  * Returns >=0 if ok, <0 errno code on error.
  */
 SCTP_STATIC int __sctp_setsockopt_connectx(struct sock* sk,
-				      struct sockaddr __user *addrs,
+				      struct sockaddr __user *address,
 				      int addrs_size,
 				      sctp_assoc_t *assoc_id)
 {
 	int err = 0;
 	struct sockaddr *kaddrs;
 
-	SCTP_DEBUG_PRINTK("%s - sk %p addrs %p addrs_size %d\n",
-			  __func__, sk, addrs, addrs_size);
+	SCTP_DEBUG_PRINTK("%s - sk %p address %p addrs_size %d\n",
+			  __func__, sk, address, addrs_size);
 
 	if (unlikely(addrs_size <= 0))
 		return -EINVAL;
 
 	/* Check the user passed a healthy pointer.  */
-	if (unlikely(!access_ok(VERIFY_READ, addrs, addrs_size)))
+	if (unlikely(!access_ok(VERIFY_READ, address, addrs_size)))
 		return -EFAULT;
 
 	/* Alloc space for the address array in kernel memory.  */
@@ -1233,7 +1233,7 @@ SCTP_STATIC int __sctp_setsockopt_connectx(struct sock* sk,
 	if (unlikely(!kaddrs))
 		return -ENOMEM;
 
-	if (__copy_from_user(kaddrs, addrs, addrs_size)) {
+	if (__copy_from_user(kaddrs, address, addrs_size)) {
 		err = -EFAULT;
 	} else {
 		err = __sctp_connect(sk, kaddrs, addrs_size, assoc_id);
@@ -1249,10 +1249,10 @@ SCTP_STATIC int __sctp_setsockopt_connectx(struct sock* sk,
  * to the option that doesn't provide association id.
  */
 SCTP_STATIC int sctp_setsockopt_connectx_old(struct sock* sk,
-				      struct sockaddr __user *addrs,
+				      struct sockaddr __user *address,
 				      int addrs_size)
 {
-	return __sctp_setsockopt_connectx(sk, addrs, addrs_size, NULL);
+	return __sctp_setsockopt_connectx(sk, address, addrs_size, NULL);
 }
 
 /*
@@ -1262,13 +1262,13 @@ SCTP_STATIC int sctp_setsockopt_connectx_old(struct sock* sk,
  * always positive.
  */
 SCTP_STATIC int sctp_setsockopt_connectx(struct sock* sk,
-				      struct sockaddr __user *addrs,
+				      struct sockaddr __user *address,
 				      int addrs_size)
 {
 	sctp_assoc_t assoc_id = 0;
 	int err = 0;
 
-	err = __sctp_setsockopt_connectx(sk, addrs, addrs_size, &assoc_id);
+	err = __sctp_setsockopt_connectx(sk, address, addrs_size, &assoc_id);
 
 	if (err)
 		return err;
@@ -1299,7 +1299,7 @@ SCTP_STATIC int sctp_getsockopt_connectx3(struct sock* sk, int len,
 		return -EFAULT;
 
 	err = __sctp_setsockopt_connectx(sk,
-			(struct sockaddr __user *)param.addrs,
+			(struct sockaddr __user *)param.address,
 			param.addr_num, &assoc_id);
 
 	if (err == 0 || err == -EINPROGRESS) {
@@ -4377,8 +4377,8 @@ static int sctp_getsockopt_peer_addrs(struct sock *sk, int len,
 	if (!asoc)
 		return -EINVAL;
 
-	to = optval + offsetof(struct sctp_getaddrs,addrs);
-	space_left = len - offsetof(struct sctp_getaddrs,addrs);
+	to = optval + offsetof(struct sctp_getaddrs,address);
+	space_left = len - offsetof(struct sctp_getaddrs,address);
 
 	list_for_each_entry(from, &asoc->peer.transport_addr_list,
 				transports) {
@@ -4462,7 +4462,7 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	int err = 0;
 	size_t space_left;
 	int bytes_copied = 0;
-	void *addrs;
+	void *address;
 	void *buf;
 
 	if (len < sizeof(struct sctp_getaddrs))
@@ -4486,11 +4486,11 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 		bp = &asoc->base.bind_addr;
 	}
 
-	to = optval + offsetof(struct sctp_getaddrs,addrs);
-	space_left = len - offsetof(struct sctp_getaddrs,addrs);
+	to = optval + offsetof(struct sctp_getaddrs,address);
+	space_left = len - offsetof(struct sctp_getaddrs,address);
 
-	addrs = kmalloc(space_left, GFP_KERNEL);
-	if (!addrs)
+	address = kmalloc(space_left, GFP_KERNEL);
+	if (!address)
 		return -ENOMEM;
 
 	/* If the endpoint is bound to 0.0.0.0 or ::0, get the valid
@@ -4500,7 +4500,7 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 		addr = list_entry(bp->address_list.next,
 				  struct sctp_sockaddr_entry, list);
 		if (sctp_is_any(sk, &addr->a)) {
-			cnt = sctp_copy_laddrs(sk, bp->port, addrs,
+			cnt = sctp_copy_laddrs(sk, bp->port, address,
 						space_left, &bytes_copied);
 			if (cnt < 0) {
 				err = cnt;
@@ -4510,7 +4510,7 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 		}
 	}
 
-	buf = addrs;
+	buf = address;
 	/* Protection on the bound address list is not needed since
 	 * in the socket option context we hold a socket lock and
 	 * thus the bound address list can't change.
@@ -4531,7 +4531,7 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
 	}
 
 copy_getaddrs:
-	if (copy_to_user(to, addrs, bytes_copied)) {
+	if (copy_to_user(to, address, bytes_copied)) {
 		err = -EFAULT;
 		goto out;
 	}
@@ -4542,7 +4542,7 @@ copy_getaddrs:
 	if (put_user(bytes_copied, optlen))
 		err = -EFAULT;
 out:
-	kfree(addrs);
+	kfree(address);
 	return err;
 }
 
diff --git a/sound/pci/ca0106/ca0106.h b/sound/pci/ca0106/ca0106.h
index 14b8d9a..afee506 100644
--- a/sound/pci/ca0106/ca0106.h
+++ b/sound/pci/ca0106/ca0106.h
@@ -188,7 +188,7 @@
 #define PLAYBACK_LIST_PTR	0x02		/* Pointer to the current period being played */
 						/* PTR[5:0], Default: 0x0 */
 #define PLAYBACK_UNKNOWN3	0x03		/* Not used ?? */
-#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA addresss */
+#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA address */
 						/* DMA[31:0], Default: 0x0 */
 #define PLAYBACK_PERIOD_SIZE	0x05		/* Playback period size. win2000 uses 0x04000000 */
 						/* SIZE[31:16], Default: 0x0 */
diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 51966d7..52da76c 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -9,7 +9,7 @@
 
 #define CS5535AUDIO_MAX_DESCRIPTORS	128
 
-/* acc_codec bar0 reg addrs */
+/* acc_codec bar0 reg address */
 #define ACC_GPIO_STATUS			0x00
 #define ACC_CODEC_STATUS		0x08
 #define ACC_CODEC_CNTL			0x0C
diff --git a/sound/pci/echoaudio/echoaudio_dsp.h b/sound/pci/echoaudio/echoaudio_dsp.h
index cb7d75a..d76c9b6 100644
--- a/sound/pci/echoaudio/echoaudio_dsp.h
+++ b/sound/pci/echoaudio/echoaudio_dsp.h
@@ -653,7 +653,7 @@ struct comm_page {		/*				Base	Length*/
 	u32 cmd_reset;		/* Chs. to reset mask		0x01c	4 */
 	u16 audio_format[DSP_MAXPIPES];	/* Chs. audio format	0x020	32*2 */
 	struct sg_entry sglist_addr[DSP_MAXPIPES];
-				/* Chs. Physical sglist addrs	0x060	32*8 */
+				/* Chs. Physical sglist address	0x060	32*8 */
 	u32 position[DSP_MAXPIPES];
 				/* Positions for ea. ch.	0x160	32*4 */
 	s8 vu_meter[DSP_MAXPIPES];
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index df47f73..0c701e4 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -114,7 +114,7 @@ MODULE_PARM_DESC(enable, "Enable the EMU10K1X soundcard.");
 						 */
 #define PLAYBACK_LIST_SIZE	0x01		/* Size of list in bytes << 16. E.g. 8 periods -> 0x00380000  */
 #define PLAYBACK_LIST_PTR	0x02		/* Pointer to the current period being played */
-#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA addresss */
+#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA address */
 #define PLAYBACK_PERIOD_SIZE	0x05		/* Playback period size */
 #define PLAYBACK_POINTER	0x06		/* Playback period pointer. Sample currently in DAC */
 #define PLAYBACK_UNKNOWN1       0x07
diff --git a/sound/pci/emu10k1/p16v.h b/sound/pci/emu10k1/p16v.h
index 1532149..00f4817 100644
--- a/sound/pci/emu10k1/p16v.h
+++ b/sound/pci/emu10k1/p16v.h
@@ -96,7 +96,7 @@
 #define PLAYBACK_LIST_SIZE	0x01		/* Size of list in bytes << 16. E.g. 8 periods -> 0x00380000  */
 #define PLAYBACK_LIST_PTR	0x02		/* Pointer to the current period being played */
 #define PLAYBACK_UNKNOWN3	0x03		/* Not used */
-#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA addresss */
+#define PLAYBACK_DMA_ADDR	0x04		/* Playback DMA address */
 #define PLAYBACK_PERIOD_SIZE	0x05		/* Playback period size. win2000 uses 0x04000000 */
 #define PLAYBACK_POINTER	0x06		/* Playback period pointer. Used with PLAYBACK_LIST_PTR to determine buffer position currently in DAC */
 #define PLAYBACK_FIFO_END_ADDRESS	0x07		/* Playback FIFO end address */
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 23a58f0..7c17f45 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -220,7 +220,7 @@ MODULE_PARM_DESC(joystick, "Enable joystick.");
 #define	RINGB_EN_2CODEC		0x0020
 #define RINGB_SING_BIT_DUAL	0x0040
 
-/* ****Port Adresses**** */
+/* ****Port Addresses**** */
 
 /*   Write & Read */
 #define ESM_INDEX		0x02
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 547b713..541f3c0 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -550,7 +550,7 @@ static inline int HDSPM_bit2freq(int n)
 	return bit2freq_tab[n];
 }
 
-/* Write/read to/from HDSPM with Adresses in Bytes
+/* Write/read to/from HDSPM with Addresses in Bytes
    not words but only 32Bit writes are allowed */
 
 static inline void hdspm_write(struct hdspm * hdspm, unsigned int reg,
-- 
1.7.1

