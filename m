Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab2AEVjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:39:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab2AEVjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:39:15 -0500
Date: Thu, 5 Jan 2012 22:39:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1201052220200.24984@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive updates queued in trivial tree. Apart from usual typo / 
spelling / comment fixes, it includes some latin1 -> utf8 conversions from 
Al, and Kconfig cleanup of unused symbols by Paul.

Thanks.

Al Viro (1):
      misc latin1 to utf8 conversions

Arun Thomas (1):
      tools/power turbostat: update fields in manpage

Arvind R (1):
      edac:i82975x fix 32bit compile and cleanup

Axel Lin (1):
      devres: Fix a typo in devm_kfree comment

Geert Uytterhoeven (1):
      fat: Spelling s/obsolate/obsolete/g

Javi Merino (1):
      irq: Fix comment typo ist->is

Jesper Juhl (2):
      SCSI, qla2xxx: remove redundant semicolon
      SCSI, pmcraid: Fix spelling error in a pmcraid_err() call

Jiri Kosina (3):
      Merge branch 'master' into for-next
      MAINTAINERS: update ipwireless entry
      mac80211: drop spelling fix

Justin P. Mattock (3):
      treewide: Fix typos in various parts of the kernel, and fix some comments.
      btrfs: free-space-cache.c: remove extra semicolon.
      Kconfig: acpi: Fix typo in comment.

K. Y. Srinivasan (1):
      hyper-v: Update MAINTAINERS

Kautuk Consul (1):
      namespace: mnt_want_write: Remove unused label 'out'

Mark Einon (1):
      types.h: fix comment spelling for 'architectures'

Michael Witten (4):
      Docs: Pedantry: [Cc]ordic -> CORDIC
      Docs: wording: functions -> algorithm
      Docs: wording: Insert `the'
      Docs: Kconfig: CORDIC description

Paul Bolle (27):
      h8300: drivers/serial/Kconfig was moved
      treewide: remove commented out Kconfig entries
      snd-aoa: remove commented out Kconfig entry
      powerpc: 4xx: remove commented out Kconfig entries
      ARM: pxa: Fix typo 'CONFIG_BACKLIGHT_PWM__MODULE'
      Kconfig: remove a few puzzling comments
      isdn: hisax: Fix wrong macro name 'HISAX_DE_AOC'
      ARM: imx: Fix typo 'MACH_MX31_3DS_MXC_NAND_USE_BBT'
      Doc: cpufreq: Fix typo and outdated line
      Doc: 53c700: drop never defined (Kconfig) macros
      powerpc/4xx: Fix typo 'PCC4xx_MSI'
      s390: drop "select HAVE_GET_USER_PAGES_FAST"
      crypto: drop selects of bogus Kconfig symbol
      mtd: drop select of MTD_PARTITIONS
      powerpc/mpc5121: drop "select MPC5121_ADS_CPLD"
      drop "select GCD" from three Kconfig files
      MIPS: Sibyte: drop select of SIBYTE_CFE
      usb: gadget: drop "select USB_GADGET_S3C_HSOTG_PIO"
      spi: drop "select SPI_MASTER_OF"
      serial: Kconfig: drop unknown symbol 'ARCH_IMX'
      sound: Kconfig: drop unknown symbol ARCH_CLPS7500
      leds: Kconfig: Fix typo 'D2NET_V2'
      gpio: Kconfig: drop unknown symbol 'CS5535_GPIO'
      clockevents: drop unknown Kconfig symbol GENERIC_CLOCKEVENTS_MIGR
      treewide: Fix comment and string typo 'bufer'
      decompress_bunzip2: remove invalid vi modeline
      sis900: Fix enum typo 'sis900_rx_bufer_status'

Paul Menzel (1):
      scripts/package/Makefile: Fix typo: an deb -> a deb

Thomas Meyer (1):
      qnx4fs: Use kmemdup rather than duplicating its implementation

Vinson Lee (1):
      devices.txt: Fix typo of 'VMware'.

Vsevolod Alekseev (1):
      security.h: fix misc typos/grammar errors in comments

Wang Sheng-Hui (1):
      mm: cleanup the comment for head/tail pages of compound pages in mm/page_alloc.c

Wang YanQing (1):
      typo fixes: aera -> area, exntension -> extension

 .../ABI/testing/sysfs-driver-hid-logitech-lg4ff    |    2 +-
 Documentation/cpu-freq/governors.txt               |    4 +--
 Documentation/devices.txt                          |    2 +-
 Documentation/scsi/53c700.txt                      |   21 +----------
 Documentation/vgaarbiter.txt                       |    2 +-
 MAINTAINERS                                        |   19 ++++++----
 arch/arm/Kconfig                                   |    3 +-
 arch/arm/mach-pxa/colibri-pxa270-income.c          |    2 +-
 arch/arm/plat-omap/include/plat/serial.h           |    2 +-
 arch/cris/Kconfig.debug                            |    1 -
 arch/frv/Kconfig                                   |   10 -----
 arch/mips/Kconfig                                  |    5 ---
 arch/mips/sgi-ip27/Kconfig                         |    6 ---
 arch/mips/sibyte/Kconfig                           |    1 -
 arch/powerpc/include/asm/io.h                      |    2 +-
 arch/powerpc/include/asm/keylargo.h                |    2 +-
 arch/powerpc/mm/numa.c                             |    2 +-
 arch/powerpc/platforms/40x/Kconfig                 |   38 --------------------
 arch/powerpc/platforms/44x/Kconfig                 |   18 +---------
 arch/powerpc/platforms/512x/Kconfig                |    1 -
 arch/s390/Kconfig                                  |    1 -
 arch/sparc/kernel/smp_64.c                         |    2 +-
 arch/x86/pci/pcbios.c                              |    2 +-
 crypto/Kconfig                                     |    2 -
 drivers/acpi/Kconfig                               |    2 +-
 drivers/acpi/acpica/hwxface.c                      |    2 +-
 drivers/base/devres.c                              |    2 +-
 drivers/block/xen-blkback/xenbus.c                 |    2 +-
 drivers/char/ipmi/ipmi_bt_sm.c                     |    2 +-
 drivers/edac/i82975x_edac.c                        |   30 ++++++++++------
 drivers/edac/ppc4xx_edac.c                         |    2 +-
 drivers/gpio/Kconfig                               |    2 +-
 drivers/gpu/drm/i915/intel_sdvo_regs.h             |    2 +-
 drivers/hid/hid-pl.c                               |    4 +-
 drivers/hid/hid-twinhan.c                          |    2 +-
 drivers/i2c/busses/i2c-xiic.c                      |    2 +-
 drivers/isdn/hisax/enternow_pci.c                  |    2 +-
 drivers/leds/Kconfig                               |    3 +-
 drivers/media/rc/ene_ir.c                          |    2 +-
 drivers/media/rc/ene_ir.h                          |    2 +-
 drivers/media/rc/winbond-cir.c                     |    2 +-
 drivers/media/video/zoran/zoran_driver.c           |    2 +-
 drivers/message/fusion/lsi/mpi_ioc.h               |    2 +-
 drivers/misc/ibmasm/command.c                      |    2 +-
 drivers/misc/ibmasm/dot_command.c                  |    2 +-
 drivers/misc/ibmasm/dot_command.h                  |    2 +-
 drivers/misc/ibmasm/event.c                        |    2 +-
 drivers/misc/ibmasm/heartbeat.c                    |    2 +-
 drivers/misc/ibmasm/i2o.h                          |    2 +-
 drivers/misc/ibmasm/ibmasm.h                       |    2 +-
 drivers/misc/ibmasm/ibmasmfs.c                     |    2 +-
 drivers/misc/ibmasm/lowlevel.c                     |    2 +-
 drivers/misc/ibmasm/lowlevel.h                     |    2 +-
 drivers/misc/ibmasm/module.c                       |    2 +-
 drivers/misc/ibmasm/r_heartbeat.c                  |    2 +-
 drivers/misc/ibmasm/remote.h                       |    2 +-
 drivers/misc/ibmasm/uart.c                         |    2 +-
 drivers/mmc/host/omap.c                            |    4 +-
 drivers/mtd/nand/Kconfig                           |    1 -
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c         |    2 +-
 drivers/net/ethernet/sis/sis900.h                  |    2 +-
 drivers/net/irda/nsc-ircc.c                        |    2 +-
 drivers/net/irda/via-ircc.c                        |    4 +-
 drivers/net/irda/w83977af_ir.c                     |    2 +-
 drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |    4 +-
 drivers/parisc/Kconfig                             |    7 ----
 drivers/parport/parport_mfc3.c                     |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm.c               |    2 +-
 drivers/scsi/gdth.h                                |    2 +-
 drivers/scsi/ips.c                                 |    2 +-
 drivers/scsi/jazz_esp.c                            |    2 +-
 drivers/scsi/pmcraid.c                             |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |    2 +-
 drivers/scsi/qla4xxx/ql4_fw.h                      |    2 +-
 drivers/scsi/sni_53c710.c                          |    2 +-
 drivers/scsi/vmw_pvscsi.c                          |    2 +-
 drivers/spi/Kconfig                                |    3 +-
 drivers/staging/bcm/target_params.h                |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 drivers/staging/cxt1e1/libsbew.h                   |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    2 +-
 drivers/staging/iio/industrialio-trigger.c         |    2 +-
 drivers/staging/keucr/smilmain.c                   |    4 +-
 drivers/staging/sep/sep_driver.c                   |    2 +-
 drivers/staging/tidspbridge/Kconfig                |    2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    2 +-
 drivers/staging/wlags49_h2/debug.h                 |    2 +-
 drivers/staging/wlags49_h2/dhfcfg.h                |    2 +-
 drivers/staging/wlags49_h2/hcf.c                   |    6 ++--
 drivers/staging/wlags49_h2/hcf.h                   |    6 ++--
 drivers/staging/wlags49_h2/hcfcfg.h                |    6 ++--
 drivers/staging/wlags49_h2/hcfdef.h                |    6 ++--
 drivers/staging/wlags49_h2/mdd.h                   |    6 ++--
 drivers/staging/wlags49_h2/mmd.c                   |    2 +-
 drivers/staging/wlags49_h2/mmd.h                   |    2 +-
 drivers/staging/wlags49_h2/wl_cs.h                 |    4 +-
 drivers/staging/wlags49_h2/wl_enc.c                |    4 +-
 drivers/staging/wlags49_h2/wl_enc.h                |    4 +-
 drivers/staging/wlags49_h2/wl_if.h                 |    4 +-
 drivers/staging/wlags49_h2/wl_internal.h           |    4 +-
 drivers/staging/wlags49_h2/wl_main.c               |    4 +-
 drivers/staging/wlags49_h2/wl_main.h               |    4 +-
 drivers/staging/wlags49_h2/wl_netdev.c             |    4 +-
 drivers/staging/wlags49_h2/wl_netdev.h             |    4 +-
 drivers/staging/wlags49_h2/wl_pci.c                |    4 +-
 drivers/staging/wlags49_h2/wl_pci.h                |    4 +-
 drivers/staging/wlags49_h2/wl_priv.c               |    4 +-
 drivers/staging/wlags49_h2/wl_priv.h               |    4 +-
 drivers/staging/wlags49_h2/wl_profile.c            |    4 +-
 drivers/staging/wlags49_h2/wl_profile.h            |    4 +-
 drivers/staging/wlags49_h2/wl_util.c               |    4 +-
 drivers/staging/wlags49_h2/wl_util.h               |    4 +-
 drivers/staging/wlags49_h2/wl_version.h            |    4 +-
 drivers/staging/wlags49_h2/wl_wext.c               |    4 +-
 drivers/staging/wlags49_h2/wl_wext.h               |    4 +-
 drivers/tty/serial/Kconfig                         |    2 +-
 drivers/usb/gadget/Kconfig                         |    1 -
 drivers/usb/gadget/s3c2410_udc.c                   |    4 +-
 drivers/usb/gadget/s3c2410_udc.h                   |    2 +-
 drivers/usb/host/hwa-hc.c                          |    2 +-
 drivers/usb/host/imx21-hcd.c                       |    2 +-
 drivers/usb/musb/cppi_dma.c                        |    2 +-
 drivers/usb/otg/fsl_otg.c                          |    2 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |    6 ++--
 drivers/usb/storage/isd200.c                       |    2 +-
 drivers/usb/storage/unusual_devs.h                 |    2 +-
 drivers/uwb/i1480/dfu/usb.c                        |    2 +-
 drivers/video/bf54x-lq043fb.c                      |    2 +-
 drivers/video/bfin-t350mcqb-fb.c                   |    2 +-
 drivers/video/console/Kconfig                      |    2 -
 drivers/video/omap/rfbi.c                          |    2 +-
 drivers/video/omap/sossi.c                         |    2 +-
 drivers/watchdog/w83627hf_wdt.c                    |    4 +-
 drivers/zorro/zorro.ids                            |    2 +-
 fs/btrfs/free-space-cache.c                        |    2 +-
 fs/btrfs/inode.c                                   |    2 +-
 fs/ext3/inode.c                                    |    2 +-
 fs/ext4/inode.c                                    |    4 +-
 fs/fat/inode.c                                     |   26 +++++++-------
 fs/jbd/checkpoint.c                                |    2 +-
 fs/jbd2/checkpoint.c                               |    2 +-
 fs/namespace.c                                     |    2 -
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/ocfs2/file.c                                    |    2 +-
 fs/qnx4/inode.c                                    |    7 ++--
 fs/xfs/xfs_buf.c                                   |    2 +-
 fs/xfs/xfs_file.c                                  |    6 ++--
 fs/xfs/xfs_log_cil.c                               |    2 +-
 include/drm/drmP.h                                 |    2 +-
 include/linux/cordic.h                             |    4 +-
 include/linux/security.h                           |   26 +++++++-------
 include/linux/types.h                              |    2 +-
 include/linux/wanrouter.h                          |    2 +-
 include/net/mac80211.h                             |    2 +-
 kernel/events/core.c                               |    2 +-
 kernel/events/ring_buffer.c                        |    2 +-
 kernel/irq/manage.c                                |    2 +-
 kernel/time/Kconfig                                |    2 +-
 lib/Kconfig                                        |    7 ++--
 lib/cordic.c                                       |    2 +-
 lib/decompress_bunzip2.c                           |    5 +--
 lib/decompress_unlzma.c                            |    2 +-
 mm/page_alloc.c                                    |    4 +-
 net/ipv4/Kconfig                                   |    2 -
 net/ipv4/ip_fragment.c                             |    2 +-
 net/ipv4/netfilter/nf_nat_core.c                   |    2 +-
 net/netfilter/ipvs/Kconfig                         |    1 -
 net/sctp/endpointola.c                             |    2 +-
 scripts/package/Makefile                           |    2 +-
 sound/aoa/codecs/Kconfig                           |    8 ----
 sound/core/Kconfig                                 |    1 -
 sound/oss/Kconfig                                  |    2 +-
 tools/power/x86/turbostat/turbostat.8              |    8 ++--
 tools/testing/ktest/sample.conf                    |    2 +-
 176 files changed, 266 insertions(+), 384 deletions(-)

-- 
Jiri Kosina
SUSE Labs
