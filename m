Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1JYJYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:24:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab1JYJX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:23:57 -0400
Date: Tue, 25 Oct 2011 11:23:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1110251015260.3541@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive patches queued in trivial tree (in case you'd like me to resend 
this later during the merge window, just let me know) Thanks.


Bart Van Assche (1):
      futex: Fix spelling in a source code comment

Christian Dietrich (2):
      drivers/char/rtc: use printk_ratelimited instead of printk_ratelimit
      scsi/sg: use printk_ratelimited instead of printk_ratelimit

Dan Carpenter (1):
      USB: serial: remove duplicate returns

Jesper Juhl (12):
      Documentation/ABI/: update version number references from 2.6.x to 3.x
      Remove unneeded version.h include from lib/
      Remove unneeded version.h includes from include/
      Remove unneeded version.h include from arch/x86/
      Remove unneeded version.h includes from arch/arm/
      Remove unneeded version.h includes from drivers/block/
      Remove unneeded version.h includes from drivers/scsi/
      Remove unneeded version.h includes from drivers/target/
      Remove unneeded version.h includes (and add where needed) for drivers/usb/
      Remove unneeded version.h include from drivers/uwb/
      viacam: Don't explode if pci_find_bus() returns NULL
      CIFS: Don't free volume_info->UNC until we are entirely done with it.

Joe Perches (11):
      s390: Convert vmalloc/memset to vzalloc
      atm: Convert vmalloc/memset to vzalloc
      drbd: Convert vmalloc/memset to vzalloc
      char: Convert vmalloc/memset to vzalloc
      isdn: Convert vmalloc/memset to vzalloc
      fs: Convert vmalloc/memset to vzalloc
      mm: Convert vmalloc/memset to vzalloc
      net: Convert vmalloc/memset to vzalloc
      drbd: Use angle brackets for system includes
      aix94xx: Use angle brackets for system includes
      treewide: Correct spelling of successfully in comments

Johann Felix Soden (2):
      Fix file references in drivers/ide/
      Fix file references in Kconfig files

Justin P. Mattock (4):
      lib: Kconfig.debug: Typo remove extra "it"
      mm/vmscan.c: fix a typo in a comment "relaimed" to "reclaimed"
      ipw2x00: comment typo fix encryptiong to encryption
      treewide: remove extra semicolons from various parts of the kernel

Kamalesh Babulal (1):
      sched: x86_32 Fix typo in switch_to() description

Kartik Mohta (1):
      libertas_tf: deb_defs.h: Fix typo in include guard

Michael Witten (1):
      Kconfig: Copyedit: DEBUG_SECTION_MISMATCH

Paul Bolle (19):
      eventpoll: fix comment typo 'evenpoll'
      Fix kernel-doc comment typo '@id'
      Fix documentation and comment typo 'no_hz'
      doc: fix broken references
      btmrvl_sdio: fix typo 'btmrvl_sdio_sd6888'
      bcmring: drop commented out line in Kconfig
      thinkpad_acpi: Fix printk typo 'bluestooth'
      aic7xxx: fix Kconfig references to READMEs
      ARM: mxc: fix Kconfig typo 'i.MX51'
      tty: drop superfluous dependency in Kconfig
      MAINTAINERS: microblaze-uclinux@itee.uq.edu.au is moderated for non-subscribers
      h8300: drop puzzling Kconfig dependencies
      microblaze: add missing CONFIG_ prefixes
      cris: remove arch/cris/arch-v32/lib/nand_init.S
      Kconfig: remove redundant CONFIG_ prefix on two symbols
      parisc: Kconfig: cleanup Kernel page size default
      Drop default from "DM365 codec select" choice
      linux@lists.openrisc.net is moderated for non-subscribers
      MAINTAINERS: linux-m32r is moderated for non-subscribers

Sean M. Collins (1):
      doc: raw1394: Trivial typo fix

Vitaliy Ivanov (3):
      treewide: typo 'interrrupt' word corrections.
      async: uninitialized warning corrections
      futex: uninitialized warning corrections

 Documentation/ABI/removed/o2cb                     |    2 +-
 Documentation/ABI/removed/raw1394                  |    2 +-
 Documentation/ABI/testing/sysfs-bus-bcma           |    8 +-
 .../testing/sysfs-class-backlight-driver-adp8870   |   16 +-
 Documentation/PCI/pci.txt                          |    2 +-
 Documentation/blackfin/bfin-gpio-notes.txt         |    2 +-
 Documentation/block/biodoc.txt                     |    2 +-
 Documentation/bus-virt-phys-mapping.txt            |    2 +-
 Documentation/cdrom/packet-writing.txt             |    2 +-
 Documentation/cpu-freq/governors.txt               |    2 +-
 Documentation/development-process/4.Coding         |    2 +-
 Documentation/devicetree/bindings/gpio/led.txt     |    2 +-
 Documentation/filesystems/caching/object.txt       |    6 +-
 Documentation/filesystems/locks.txt                |   11 +-
 Documentation/filesystems/nfs/idmapper.txt         |    2 +-
 .../filesystems/pohmelfs/design_notes.txt          |    5 +-
 Documentation/filesystems/proc.txt                 |    2 +-
 Documentation/filesystems/vfs.txt                  |    3 -
 Documentation/frv/booting.txt                      |    6 -
 Documentation/input/input.txt                      |    2 +-
 Documentation/kernel-docs.txt                      |    4 +-
 Documentation/kernel-parameters.txt                |   12 +-
 Documentation/laptops/thinkpad-acpi.txt            |    4 +-
 Documentation/media-framework.txt                  |    4 +-
 Documentation/memory-barriers.txt                  |    2 +-
 Documentation/networking/scaling.txt               |    2 +-
 Documentation/power/basic-pm-debugging.txt         |    2 +-
 Documentation/power/userland-swsusp.txt            |    3 +-
 Documentation/rfkill.txt                           |    3 +-
 Documentation/scsi/aic7xxx_old.txt                 |    2 +-
 Documentation/scsi/scsi_mid_low_api.txt            |    5 -
 Documentation/security/keys-trusted-encrypted.txt  |    3 +-
 Documentation/sound/oss/PAS16                      |    3 +-
 Documentation/spi/pxa2xx                           |    4 +-
 Documentation/timers/highres.txt                   |    2 +-
 Documentation/usb/dma.txt                          |    6 +-
 Documentation/virtual/lguest/lguest.c              |    2 +-
 Documentation/vm/numa                              |    4 +-
 Documentation/vm/slub.txt                          |    2 +-
 MAINTAINERS                                        |    6 +-
 arch/alpha/kernel/srm_env.c                        |    5 +-
 arch/arm/Kconfig                                   |    2 +-
 arch/arm/include/asm/io.h                          |    2 +-
 arch/arm/mach-bcmring/Kconfig                      |    2 -
 arch/arm/mach-bcmring/irq.c                        |    1 -
 arch/arm/mach-bcmring/timer.c                      |    1 -
 arch/arm/mach-nuc93x/time.c                        |    2 +-
 arch/arm/mach-omap2/smartreflex.c                  |    2 +-
 arch/arm/mach-pxa/xcep.c                           |    3 +-
 arch/arm/mach-w90x900/cpu.c                        |    2 +-
 arch/arm/plat-mxc/Kconfig                          |    2 +-
 arch/cris/Kconfig                                  |    4 +-
 arch/cris/arch-v10/Kconfig                         |   12 +-
 arch/cris/arch-v32/lib/nand_init.S                 |  178 --------------------
 arch/h8300/Kconfig                                 |    2 +-
 arch/ia64/hp/common/sba_iommu.c                    |   12 +-
 arch/m68k/q40/README                               |    2 +-
 arch/microblaze/include/asm/dma-mapping.h          |    2 +-
 arch/microblaze/mm/init.c                          |    6 +-
 arch/mips/include/asm/lasat/lasat.h                |    6 +-
 arch/mn10300/Kconfig                               |    2 +-
 arch/mn10300/kernel/irq.c                          |    1 -
 arch/openrisc/Kconfig                              |    2 +-
 arch/openrisc/include/asm/dma-mapping.h            |    2 +-
 arch/parisc/Kconfig                                |    4 +-
 arch/parisc/include/asm/dma-mapping.h              |    2 +-
 arch/parisc/kernel/pci-dma.c                       |    2 +-
 arch/powerpc/include/asm/qe.h                      |    2 +-
 arch/powerpc/platforms/85xx/Kconfig                |    2 +-
 arch/powerpc/platforms/embedded6xx/storcenter.c    |    2 +-
 arch/powerpc/sysdev/qe_lib/qe.c                    |    2 +-
 arch/s390/hypfs/hypfs_diag.c                       |    3 +-
 arch/unicore32/include/asm/io.h                    |    2 +-
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/Kconfig.debug                             |    2 +-
 arch/x86/boot/header.S                             |    2 +-
 arch/x86/include/asm/dma-mapping.h                 |    2 +-
 arch/x86/kernel/amd_gart_64.c                      |    2 +-
 arch/x86/kernel/apm_32.c                           |    2 -
 arch/x86/kernel/pci-dma.c                          |    4 +-
 arch/x86/kernel/process_32.c                       |    2 +-
 arch/x86/mm/mmio-mod.c                             |    1 -
 drivers/atm/idt77252.c                             |   11 +-
 drivers/atm/lanai.c                                |    3 +-
 drivers/block/drbd/drbd_bitmap.c                   |    5 +-
 drivers/block/drbd/drbd_int.h                      |    3 +-
 drivers/block/drbd/drbd_nl.c                       |    4 +-
 drivers/block/rbd.c                                |    2 +-
 drivers/block/xen-blkback/common.h                 |    1 -
 drivers/bluetooth/btmrvl_sdio.c                    |    4 +-
 drivers/char/agp/backend.c                         |    3 +-
 drivers/char/apm-emulation.c                       |    5 +-
 drivers/char/raw.c                                 |    3 +-
 drivers/char/rtc.c                                 |    7 +-
 drivers/cpufreq/cpufreq_ondemand.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |    2 +-
 drivers/i2c/busses/i2c-designware.c                |    2 +-
 drivers/ide/Kconfig                                |    2 +-
 drivers/input/misc/rotary_encoder.c                |    2 +-
 drivers/isdn/i4l/isdn_common.c                     |    4 +-
 drivers/isdn/mISDN/dsp_core.c                      |    3 +-
 drivers/isdn/mISDN/l1oip_codec.c                   |    6 +-
 drivers/leds/Kconfig                               |    2 +-
 drivers/media/dvb/dvb-usb/af9005-remote.c          |    2 +-
 drivers/media/dvb/dvb-usb/af9005.c                 |    2 +-
 drivers/media/dvb/frontends/dib3000.h              |    2 +-
 drivers/media/dvb/frontends/dib3000mb.c            |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    2 +-
 drivers/media/video/cx18/cx18-mailbox.h            |    2 +-
 drivers/mtd/Kconfig                                |    2 +-
 drivers/net/Kconfig                                |    3 +-
 drivers/net/arm/ks8695net.c                        |    2 +-
 drivers/net/atlx/atl1.c                            |    2 +-
 drivers/net/bnx2.h                                 |   12 +-
 drivers/net/can/sja1000/sja1000_of_platform.c      |    2 +-
 drivers/net/igb/e1000_mbx.c                        |    2 +-
 drivers/net/igbvf/mbx.c                            |    2 +-
 drivers/net/irda/Kconfig                           |    2 +-
 drivers/net/ixgbe/ixgbe_mbx.c                      |    2 +-
 drivers/net/ixgbevf/mbx.c                          |    2 +-
 drivers/net/phy/broadcom.c                         |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/tile/tilepro.c                         |    2 +-
 drivers/net/tulip/21142.c                          |    3 -
 drivers/net/tulip/eeprom.c                         |    2 -
 drivers/net/tulip/interrupt.c                      |    3 -
 drivers/net/tulip/media.c                          |    3 -
 drivers/net/tulip/pnic.c                           |    3 -
 drivers/net/tulip/pnic2.c                          |    3 -
 drivers/net/tulip/timer.c                          |    3 -
 drivers/net/tulip/tulip.h                          |    3 -
 drivers/net/tulip/tulip_core.c                     |    3 -
 drivers/net/wireless/ipw2x00/libipw_tx.c           |    2 +-
 drivers/net/wireless/libertas_tf/deb_defs.h        |    2 +-
 drivers/net/wireless/rtlwifi/pci.c                 |    6 +-
 drivers/parisc/sba_iommu.c                         |   16 +-
 drivers/platform/x86/Kconfig                       |    5 +-
 drivers/platform/x86/thinkpad_acpi.c               |    2 +-
 drivers/s390/cio/blacklist.c                       |    3 +-
 drivers/scsi/aacraid/src.c                         |    1 -
 drivers/scsi/aic7xxx/Kconfig.aic79xx               |    3 +-
 drivers/scsi/aic7xxx/Kconfig.aic7xxx               |    3 +-
 drivers/scsi/aic94xx/aic94xx_dump.c                |    2 +-
 drivers/scsi/bfa/bfad_drv.h                        |    1 -
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |    1 -
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |    1 -
 drivers/scsi/fcoe/fcoe.c                           |    1 -
 drivers/scsi/isci/phy.c                            |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c                |    1 -
 drivers/scsi/mpt2sas/mpt2sas_config.c              |    1 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c                 |    1 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    1 -
 drivers/scsi/mvsas/mv_sas.h                        |    1 -
 drivers/scsi/pmcraid.c                             |    1 -
 drivers/scsi/pmcraid.h                             |    1 -
 drivers/scsi/sg.c                                  |   18 +-
 drivers/staging/cxt1e1/Kconfig                     |    3 +-
 drivers/staging/iio/addac/adt7316-i2c.c            |    2 +-
 drivers/staging/iio/dds/ad9832.c                   |    2 +-
 drivers/target/iscsi/iscsi_target_nego.c           |    2 +-
 drivers/target/target_core_alua.c                  |    1 -
 drivers/target/target_core_configfs.c              |    1 -
 drivers/target/target_core_fabric_configfs.c       |    1 -
 drivers/target/target_core_file.c                  |    1 -
 drivers/target/target_core_iblock.c                |    1 -
 drivers/target/target_core_pr.c                    |    1 -
 drivers/target/target_core_pscsi.c                 |    1 -
 drivers/target/target_core_rd.c                    |    1 -
 drivers/target/target_core_stat.c                  |    1 -
 drivers/target/target_core_tmr.c                   |    1 -
 drivers/target/target_core_tpg.c                   |    2 +-
 drivers/target/target_core_transport.c             |    1 -
 drivers/target/target_core_ua.c                    |    1 -
 drivers/target/tcm_fc/tfc_cmd.c                    |    1 -
 drivers/target/tcm_fc/tfc_conf.c                   |    1 -
 drivers/target/tcm_fc/tfc_io.c                     |    1 -
 drivers/target/tcm_fc/tfc_sess.c                   |    1 -
 drivers/tty/Kconfig                                |    2 +-
 drivers/tty/serial/mrst_max3110.c                  |    2 +-
 drivers/usb/gadget/langwell_udc.c                  |    2 +-
 drivers/usb/gadget/mv_udc_core.c                   |    4 +-
 drivers/usb/gadget/net2280.c                       |    2 +-
 drivers/usb/gadget/uvc.h                           |    1 +
 drivers/usb/gadget/uvc_v4l2.c                      |    1 -
 drivers/usb/musb/musb_gadget.c                     |    2 +-
 drivers/usb/serial/digi_acceleport.c               |    2 +-
 drivers/usb/serial/mos7720.c                       |    1 -
 drivers/usb/serial/mos7840.c                       |    1 -
 drivers/usb/storage/realtek_cr.c                   |    1 -
 drivers/uwb/uwb-internal.h                         |    1 -
 drivers/video/igafb.c                              |    2 +-
 drivers/watchdog/smsc37b787_wdt.c                  |    2 +-
 fs/cifs/connect.c                                  |    2 +-
 fs/coda/coda_linux.h                               |    5 +-
 fs/configfs/inode.c                                |    3 +-
 fs/configfs/item.c                                 |    2 +-
 fs/eventpoll.c                                     |    2 +-
 fs/locks.c                                         |    2 +-
 fs/reiserfs/journal.c                              |    9 +-
 fs/reiserfs/resize.c                               |    4 +-
 fs/squashfs/Kconfig                                |    6 +-
 fs/xfs/kmem.h                                      |    7 +-
 include/linux/ceph/messenger.h                     |    1 -
 include/linux/drbd_tag_magic.h                     |    2 +-
 include/linux/io-mapping.h                         |    2 +-
 include/linux/isdn.h                               |    2 +-
 include/linux/platform_data/ntc_thermistor.h       |    2 +-
 include/media/pwc-ioctl.h                          |    1 -
 include/media/videobuf-dma-sg.h                    |    2 +-
 include/target/configfs_macros.h                   |    4 +-
 kernel/async.c                                     |    4 +-
 kernel/futex.c                                     |   10 +-
 kernel/sched.c                                     |    2 +-
 lib/Kconfig.debug                                  |   40 +++---
 lib/dynamic_debug.c                                |    1 -
 lib/idr.c                                          |    2 +-
 mm/page_cgroup.c                                   |    3 +-
 mm/vmscan.c                                        |    2 +-
 net/netfilter/Kconfig                              |    2 +-
 net/netfilter/x_tables.c                           |    5 +-
 net/rds/ib_cm.c                                    |    6 +-
 scripts/checkpatch.pl                              |    4 +-
 sound/core/memalloc.c                              |    4 +-
 sound/oss/Kconfig                                  |    4 +-
 sound/soc/davinci/Kconfig                          |    1 -
 tools/perf/util/config.c                           |    4 +-
 227 files changed, 293 insertions(+), 594 deletions(-)
 delete mode 100644 arch/cris/arch-v32/lib/nand_init.S

-- 
Jiri Kosina
SUSE Labs
