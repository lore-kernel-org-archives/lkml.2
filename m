Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab2CTW5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:57:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759266Ab2CTW5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:57:34 -0400
Date: Tue, 20 Mar 2012 23:57:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1203202348530.18356@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive trivial queue patches listed below. It's indeed trivial -- 
mostly documentation updates and a bunch of typo fixes from Masanari.

There are also several linux/version.h include removals from Jesper.

I am not aware of any conflicts with other trees in linux-next.

Thanks.


Al Viro (1):
      constify struct pci_dev * in obvious cases

Alexander Stein (1):
      compiler.h: Fix typo

Andrew Morton (1):
      writeback: fix typo in the writeback_control comment

Cong Wang (1):
      kernel/resource.c: move EXPORT_SYMBOL right after definition

Danny Kukawka (1):
      hdaps: fix for -Wuninitialized

Fabio Baltieri (1):
      usb: gadget: Kconfig: fix typo for 'different'

Fengguang Wu (1):
      writeback: fix fn name in writeback_inodes_sb_nr_if_idle() comment header

Geunsik Lim (1):
      Doc: Update numastat.txt

Javier Martinez Canillas (1):
      security: struct security_operations kerneldoc fix

Jesper Juhl (15):
      dm-bufio.c: there's no need to include linux/version.h
      ab5500-core.c: Don't needlessly include linux/version.h
      Fix up version number reference in include/trace/events/power.h
      drivers/media/dvb/frontends/drxk_hard.c does not need to include linux/version.h
      gma500, lvds: Fix use after free and mem leak in psb_intel_lvds_init()
      Remove incorrect comment from include/trace/events/power.h
      ARM, KS8695: Only include linux/gpio.h once in arch/arm/mach-ks8695/leds.c
      ARM: Remove duplicate asm/memblock.h include from arch/arm/mm/init.c
      BTRFS: Don't include disk-io.h twice in check-integrity.c
      power, max8998: Include linux/module.h just once in drivers/power/max8998_charger.c
      SCSI, ISCSI: Just #include "host.h" once in host.c
      Staging: The header linux/module.h is included twice in drivers/staging/iio/dac/ad5686.c
      bonding: Fix misspelling of "since"
      Only include linux/sched.h once in arch/arm/mach-bcmring/dma.c
      NVM Express: Remove unneeded include of linux/version.h from nvme.c

Jim Cromie (3):
      scx200_32: use PCI_VDEVICE
      scx200_32: replace printks with pr_<level>s
      init: fix wording error in mm_init comment

Jiri Kosina (5):
      Merge branch 'master' into for-next
      Revert "media: Fix typo in mixer_drv.c and hdmi_drv.c"
      tpm_tis: fix tis_lock with respect to RCU
      Revert "power, max8998: Include linux/module.h just once in drivers/power/max8998_charger.c"
      Revert "char: Fix typo in viotape.c"

Justin P. Mattock (1):
      Typos: change aditional to additional.

Laura Vasilescu (1):
      kcore: fix spelling in read_kcore() comment

Liu Bo (1):
      mm: fix comment typo of truncate_inode_pages_range

Masanari Iida (61):
      tty: fix comment typo in synclink_gt.c
      mpt2sas: Fix typo in mpt2sas_config.c
      reiserfs: fix printk typo in lbalance.c
      macintosh: fix string typo in mediabay.c
      ntfs: fix printk typos in mft.c
      media: Fix typo in mixer_drv.c and hdmi_drv.c
      iwmc3200wifi: fix printk typo in trace.h
      pm8001: fix printk typo in pm8001_hwi.c
      qla2xxx: fix printk typo in qla_bsg.c
      net: fix printk typo in ipw2x00/libipw_rx.c
      iommu: Fix typo in intel-iommu.c
      staging: Fix typo in ieee80211_rx.c
      staging: Fix typo in mei/interrupt.c
      aic7xxx: Fix typo in aic7xxx
      media: Fix typo in lmedm04.c
      dma: Fix typo in iop-adma.c
      media: Fix typo in ov6650.c
      mips: Fix typo in bcm63xx/setup.c
      mmc: Fix typo in s3cmci.c
      frontends: Fix typo in tda1004x.c
      sh: Fix typo in pci-sh7780.c
      score: Fix typo in Kconfig.debug
      drm: Fix typo in vmwgfx_drv.c
      drm: Fix typo in rv515.c
      mach-omap1: Fix typo in lcd_dma.c
      btrfs: Fix typo in free-space-cache.c
      char: Fix typo in viotape.c
      char: Fix typo in tlclk.c
      mantis: Fix typo in mantis_hif.c
      jffs2: Fix typo in compr.c
      mm: Fix typo in unevictable-lru.txt
      rds: Fix typo in iw_recv.c and ib_recv.c
      aeroflex: Fix typo in greth.c
      SRP: Fix typo in ib_srpt.c
      Documentation: Fix typo in tcm_mod_builder.py
      zd1211rw: Fix typo in zd_usb.c and zd_mac.c
      mm: Fix typo in cleancache.txt
      Documentation: Fix typo in watchdog-kernel-api.txt
      watchdog: Fix typo in Kconfig
      watchdog: Fix typo in pnx4008_wdt.c
      hostap: Fix typo in hostap_hw.c
      cramfs: Fix typo in inode.c
      tools: Fix typo in ktest.pl
      simtec: Fix typo in pm-simtec.c
      mach-orion5x: Fix typo in db88f5281-setup.c and rd88f5182-setup.c
      media: Fix typo in radio-sf16fmr2.c
      Documentation: Fix typo in power-management.txt
      scsi: Fix typo in pmcraid.h
      Documentation: Fix typo in thin-provisioning.txt
      ia64: Fix typo in irq_xen.c
      Documentation: Fix typo in events-power.txt
      wireless: Fix typo in mac80211_hwsim.c
      usb: Fix typo in ehci-dbg.c
      Documentation: Fix typo in proc_usb_info.txt
      serial: Fix typo in sn_console.c
      davinci: Fix typo in dm355_ccdvc.c
      Documentation: Fix Broken URL "freshmeat"
      Documentation: Fix broken URL "JF"
      arm: Fix typo in spear3[012]0.c
      Documentation: Fix typo in kernel-parameters.txt
      Documentation: Fix multiple typo in Documentation

Michael Opdenacker (2):
      Documentation: broken URL in filesystems.tmpl
      Documentation: broken URL in libata.tmpl

Michael Witten (1):
      drivers/char: comment fix: CMOS RTC update code is now in kernel/time/ntp.c

Petr Uzel (1):
      qla4xxx: Add missing spaces to error messages

Thomas Weber (1):
      power: bq27x00: Fix typos in comment

Uwe Kleine-König (1):
      mtd: simplify return logic in do_map_probe()

 Documentation/00-INDEX                             |    4 +-
 Documentation/ABI/obsolete/sysfs-class-rfkill      |    2 +-
 Documentation/ABI/stable/sysfs-module              |    2 +-
 Documentation/DocBook/filesystems.tmpl             |    2 +-
 Documentation/DocBook/libata.tmpl                  |    8 +++---
 Documentation/DocBook/media/v4l/compat.xml         |    4 +-
 Documentation/arm/kernel_user_helpers.txt          |    2 +-
 Documentation/cgroups/blkio-controller.txt         |   18 ++++++------
 Documentation/device-mapper/dm-raid.txt            |    2 +-
 Documentation/device-mapper/persistent-data.txt    |    2 +-
 Documentation/device-mapper/thin-provisioning.txt  |    2 +-
 .../devicetree/bindings/arm/omap/omap.txt          |    2 +-
 Documentation/devicetree/bindings/arm/sirf.txt     |    2 +-
 Documentation/devicetree/booting-without-of.txt    |    2 +-
 Documentation/dmaengine.txt                        |    2 +-
 Documentation/fb/matroxfb.txt                      |    8 +++---
 Documentation/filesystems/ext4.txt                 |    4 +-
 Documentation/filesystems/gfs2-uevents.txt         |    2 +-
 .../filesystems/pohmelfs/network_protocol.txt      |    2 +-
 .../filesystems/ramfs-rootfs-initramfs.txt         |    2 +-
 Documentation/filesystems/vfs.txt                  |    2 +-
 Documentation/hwmon/adm1275                        |    2 +-
 Documentation/hwmon/max16064                       |    4 +-
 Documentation/hwmon/max34440                       |    4 +-
 Documentation/hwmon/max8688                        |    4 +-
 Documentation/hwmon/ucd9000                        |    6 ++--
 Documentation/hwmon/ucd9200                        |   10 +++---
 Documentation/hwmon/zl6100                         |    4 +-
 Documentation/i2o/ioctl                            |   12 ++++----
 Documentation/ide/ChangeLog.ide-cd.1994-2004       |    2 +-
 Documentation/input/alps.txt                       |    4 +-
 Documentation/input/joystick.txt                   |    2 +-
 Documentation/ioctl/hdio.txt                       |    4 +-
 Documentation/kbuild/kconfig-language.txt          |    2 +-
 Documentation/kernel-parameters.txt                |    6 ++--
 Documentation/networking/fore200e.txt              |    2 +-
 Documentation/numastat.txt                         |   27 +++++++++++--------
 Documentation/scsi/ChangeLog.lpfc                  |    2 +-
 Documentation/scsi/ChangeLog.megaraid_sas          |    2 +-
 Documentation/scsi/scsi-generic.txt                |    2 +-
 Documentation/scsi/tmscsim.txt                     |    2 +-
 Documentation/security/Smack.txt                   |    2 +-
 Documentation/security/keys-trusted-encrypted.txt  |    2 +-
 Documentation/security/keys.txt                    |    2 +-
 Documentation/sound/alsa/ALSA-Configuration.txt    |    2 +-
 Documentation/target/tcm_mod_builder.py            |    2 +-
 Documentation/trace/events-power.txt               |    2 +-
 Documentation/usb/mtouchusb.txt                    |    2 +-
 Documentation/usb/power-management.txt             |    2 +-
 Documentation/usb/proc_usb_info.txt                |    2 +-
 Documentation/video4linux/uvcvideo.txt             |    2 +-
 Documentation/virtual/kvm/mmu.txt                  |    4 +-
 Documentation/virtual/virtio-spec.txt              |    8 +++---
 Documentation/vm/cleancache.txt                    |    2 +-
 Documentation/vm/unevictable-lru.txt               |    8 +++---
 Documentation/watchdog/watchdog-kernel-api.txt     |    2 +-
 arch/alpha/include/asm/machvec.h                   |    2 +-
 arch/alpha/kernel/sys_dp264.c                      |    2 +-
 arch/arm/mach-bcmring/dma.c                        |    1 -
 arch/arm/mach-ks8695/leds.c                        |    1 -
 arch/arm/mach-omap1/lcd_dma.c                      |    2 +-
 arch/arm/mach-orion5x/db88f5281-setup.c            |    4 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c            |    4 +-
 arch/arm/mach-spear3xx/spear300.c                  |    2 +-
 arch/arm/mach-spear3xx/spear310.c                  |    2 +-
 arch/arm/mach-spear3xx/spear320.c                  |    2 +-
 arch/arm/mm/init.c                                 |    1 -
 arch/arm/plat-s3c24xx/pm-simtec.c                  |    2 +-
 arch/ia64/xen/irq_xen.c                            |    2 +-
 arch/mips/bcm63xx/setup.c                          |    2 +-
 arch/powerpc/include/asm/keylargo.h                |    2 +-
 arch/score/Kconfig.debug                           |    2 +-
 arch/x86/platform/scx200/scx200_32.c               |   24 ++++++++---------
 drivers/block/nvme.c                               |    1 -
 drivers/char/nvram.c                               |    2 +-
 drivers/char/rtc.c                                 |    4 +-
 drivers/char/tlclk.c                               |    2 +-
 drivers/char/tpm/tpm_tis.c                         |   10 +++---
 drivers/dma/iop-adma.c                             |    2 +-
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |    9 +++---
 drivers/gpu/drm/radeon/rv515.c                     |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    2 +-
 drivers/hwmon/tmp401.c                             |    2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    2 +-
 drivers/iommu/intel-iommu.c                        |    2 +-
 drivers/macintosh/mediabay.c                       |    2 +-
 drivers/md/dm-bufio.c                              |    1 -
 drivers/media/dvb/dvb-usb/lmedm04.c                |    2 +-
 drivers/media/dvb/frontends/drxk_hard.c            |    1 -
 drivers/media/dvb/frontends/tda1004x.c             |    4 +-
 drivers/media/dvb/mantis/mantis_hif.c              |    2 +-
 drivers/media/radio/radio-sf16fmr2.c               |    2 +-
 drivers/media/video/davinci/dm355_ccdc.c           |    2 +-
 drivers/media/video/ov6650.c                       |    2 +-
 drivers/mfd/ab5500-core.c                          |    1 -
 drivers/mmc/host/s3cmci.c                          |    4 +-
 drivers/mtd/chips/chipreg.c                        |    5 +---
 drivers/net/bonding/bond_3ad.c                     |    2 +-
 drivers/net/ethernet/aeroflex/greth.c              |    2 +-
 drivers/net/wireless/hostap/hostap_hw.c            |    4 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c           |    2 +-
 drivers/net/wireless/iwmc3200wifi/trace.h          |    2 +-
 drivers/net/wireless/mac80211_hwsim.c              |    8 +++---
 drivers/net/wireless/zd1211rw/zd_mac.c             |    2 +-
 drivers/net/wireless/zd1211rw/zd_usb.c             |    2 +-
 drivers/platform/x86/hdaps.c                       |    4 +-
 drivers/power/bq27x00_battery.c                    |    4 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |    4 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 +-
 drivers/scsi/isci/host.c                           |    1 -
 drivers/scsi/mpt2sas/mpt2sas_config.c              |    2 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |    2 +-
 drivers/scsi/pmcraid.h                             |    6 ++--
 drivers/scsi/qla2xxx/qla_bsg.c                     |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |    4 +-
 drivers/staging/iio/dac/ad5686.c                   |    1 -
 drivers/staging/mei/interrupt.c                    |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    2 +-
 drivers/tty/serial/sn_console.c                    |    4 +-
 drivers/tty/synclink_gt.c                          |    2 +-
 drivers/usb/gadget/Kconfig                         |    2 +-
 drivers/usb/host/ehci-dbg.c                        |    2 +-
 fs/btrfs/check-integrity.c                         |    1 -
 fs/btrfs/free-space-cache.c                        |    2 +-
 fs/cramfs/inode.c                                  |    6 ++--
 fs/fs-writeback.c                                  |    2 +-
 fs/jffs2/compr.c                                   |    2 +-
 fs/ntfs/layout.h                                   |    4 +-
 fs/proc/kcore.c                                    |    2 +-
 fs/reiserfs/lbalance.c                             |    2 +-
 include/linux/compiler.h                           |    2 +-
 include/linux/pci.h                                |   12 ++++----
 include/linux/security.h                           |    2 +-
 include/linux/writeback.h                          |    2 +-
 include/trace/events/power.h                       |    1 -
 init/main.c                                        |    4 +-
 kernel/resource.c                                  |    3 +-
 mm/truncate.c                                      |    2 +-
 net/rds/ib_recv.c                                  |    2 +-
 net/rds/iw_recv.c                                  |    2 +-
 sound/pci/hda/patch_conexant.c                     |    2 +-
 tools/testing/ktest/ktest.pl                       |    2 +-
 142 files changed, 232 insertions(+), 245 deletions(-)

-- 
Jiri Kosina
SUSE Labs
