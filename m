Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1EWMdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:33:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:55826 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab1EWMdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:33:33 -0400
Date: Mon, 23 May 2011 14:33:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1105231409310.28291@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive fixes queued in trivial tree for .40 merge window.

It's as usual mostly small typo fixes in comments and simple documentation 
updates.

Thanks.

Alessio Igor Bogani (2):
      ufs: Fix a typo
      xtensa: remove obsolete BKL kernel option from defconfig

Antonio Ospite (1):
      include/linux/leds-regulator.h: fix syntax in example code

Jean Delvare (1):
      Haavard Skinnemoen has left Atmel

Jesper Juhl (3):
      ARM: Remove duplicate linux/sched.h include from arch/arm/plat-iop/time.c
      md, raid5: Fix spelling error in comment ('Ofcourse' --> 'Of course').
      perf: Only include annotate.h once in tools/perf/util/ui/browsers/annotate.c

Jim Cromie (2):
      add printk.time=1 boot-time hint to Kconfig.debug help text
      b43: fix comment typo reqest -> request

Jiri Kosina (3):
      ath9k_hw: don't touch with treewide double semicolon removal
      rtlwifi: don't touch with treewide double semicolon removal
      Revert "arm: mach-u300/gpio: Fix mem_region resource size miscalculations"

Joe Perches (4):
      MAINTAINERS: Add "K:" pattern for trivial
      arm: mach-u300/gpio: Fix mem_region resource size miscalculations
      treewide: Fix iomap resource size miscalculations
      treewide: cleanup continuations and remove logging message whitespace

Johannes Berg (1):
      CREDITS: update Johannes Berg's gpg key

Jonathan Neuschäfer (1):
      doc: timers-howto: fix a typo ("unsgined")

Justin P. Mattock (7):
      doc: stable_api_nonsense.txt: fix paragraph to make more sense.
      update David Miller's old email address
      ibmasm: fix comment typo
      treewide: remove extra semicolons
      arch:Kconfig.locks Remove unused config option.
      m68k: fix comment typo 'occcured'
      treewide: fix a few typos in comments

Nikanth Karthikesan (4):
      mm: Fix section mismatch for setup_zone_pageset()
      cs5535: Fix section mismatch
      ldm: Silence "ldm_validate_partition_table(): Disk read failed" when booting with "quiet"
      sysfs-memory: fix uninitialized variable warning and clean-up code.

Paul Bolle (4):
      doc: fix 3 typos in sysctl/vm.txt
      openezx-devel is moderated for non-subscribers
      drm: minor kref_put() nits
      drm: radeon: Fix printk typo 'ib poll'

Rafi Rubin (1):
      Kconfig: fix copy/paste-ism for dell-wmi-aio driver

Sarah Nadi (1):
      cris: typo in mach-fs Makefile

Tony Jones (1):
      audit: acquire creds selectively to reduce atomic op overhead

Uwe Kleine-König (2):
      vsprintf: make comment about vs{n,cn,}printf more understandable
      tty: fix typo in descripton of tty_termios_encode_baud_rate

Wanlong Gao (1):
      regulator: change debug statement be consistent with the style of the rest

 CREDITS                                            |    2 +-
 .../devicetree/bindings/powerpc/nintendo/wii.txt   |    2 +-
 Documentation/feature-removal-schedule.txt         |    2 +-
 Documentation/stable_api_nonsense.txt              |    2 +-
 Documentation/sysctl/vm.txt                        |    4 +-
 Documentation/timers/timers-howto.txt              |    2 +-
 MAINTAINERS                                        |    3 +-
 arch/Kconfig                                       |    3 --
 arch/arm/mach-at91/at91cap9_devices.c              |    2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    2 +-
 arch/arm/mach-msm/include/mach/msm_iomap.h         |    2 +-
 arch/arm/mach-omap2/control.h                      |    2 +-
 arch/arm/mach-tegra/tegra2_clocks.c                |    2 +-
 arch/arm/mach-ux500/mbox-db5500.c                  |    6 +---
 arch/arm/plat-iop/time.c                           |    1 -
 arch/arm/plat-mxc/cpufreq.c                        |    4 +-
 arch/cris/arch-v32/mach-fs/Makefile                |    2 +-
 arch/ia64/hp/common/sba_iommu.c                    |    2 +-
 arch/m68k/include/asm/MC68EZ328.h                  |    2 +-
 arch/m68k/include/asm/MC68VZ328.h                  |    2 +-
 arch/mips/fw/arc/cmdline.c                         |    2 +-
 arch/mips/fw/arc/env.c                             |    2 +-
 arch/mips/fw/arc/identify.c                        |    2 +-
 arch/mips/fw/arc/init.c                            |    2 +-
 arch/mips/fw/arc/misc.c                            |    2 +-
 arch/mips/fw/arc/salone.c                          |    2 +-
 arch/mips/fw/arc/time.c                            |    2 +-
 arch/mips/fw/arc/tree.c                            |    2 +-
 arch/mips/include/asm/asmmacro-32.h                |    2 +-
 arch/mips/include/asm/asmmacro-64.h                |    2 +-
 arch/mips/include/asm/cpu.h                        |    2 +-
 arch/mips/include/asm/r4kcache.h                   |    2 +-
 arch/mips/include/asm/sgialib.h                    |    2 +-
 arch/mips/include/asm/sgiarcs.h                    |    2 +-
 arch/mips/kernel/octeon_switch.S                   |    2 +-
 arch/mips/kernel/r2300_fpu.S                       |    2 +-
 arch/mips/kernel/r2300_switch.S                    |    2 +-
 arch/mips/kernel/r4k_fpu.S                         |    2 +-
 arch/mips/kernel/r4k_switch.S                      |    2 +-
 arch/mips/kernel/r6000_fpu.S                       |    2 +-
 arch/mips/mm/c-r3k.c                               |    2 +-
 arch/mips/mm/c-r4k.c                               |    2 +-
 arch/mips/mm/c-tx39.c                              |    2 +-
 arch/mips/mm/sc-ip22.c                             |    2 +-
 arch/mips/mm/sc-r5k.c                              |    2 +-
 arch/mips/mm/tlb-r3k.c                             |    2 +-
 arch/mips/mm/tlb-r4k.c                             |    2 +-
 arch/mips/mm/tlb-r8k.c                             |    2 +-
 arch/mips/sgi-ip22/ip22-hpc.c                      |    2 +-
 arch/mips/sgi-ip22/ip22-int.c                      |    2 +-
 arch/mips/sgi-ip22/ip22-mc.c                       |    2 +-
 arch/mips/sgi-ip22/ip22-setup.c                    |    2 +-
 arch/powerpc/include/asm/pte-hash64-64k.h          |    2 +-
 arch/powerpc/kernel/kgdb.c                         |    2 +-
 arch/s390/hypfs/hypfs.h                            |    2 +-
 arch/um/drivers/mmapper_kern.c                     |    2 +-
 arch/x86/xen/pci-swiotlb-xen.c                     |    2 +-
 arch/xtensa/configs/s6105_defconfig                |    1 -
 drivers/acpi/acpica/utresrc.c                      |    2 +-
 drivers/acpi/video.c                               |    2 +-
 drivers/base/memory.c                              |    9 +++---
 drivers/dma/dmatest.c                              |    6 ++--
 drivers/dma/dw_dmac.c                              |    2 +-
 drivers/firmware/efivars.c                         |    2 +-
 drivers/firmware/iscsi_ibft.c                      |    4 +-
 drivers/gpio/ab8500-gpio.c                         |    7 ++---
 drivers/gpio/langwell_gpio.c                       |    2 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |    2 +-
 drivers/gpu/drm/ttm/ttm_object.c                   |    2 +-
 drivers/i2c/busses/i2c-gpio.c                      |    2 +-
 drivers/leds/leds-mc13783.c                        |    2 +-
 drivers/macintosh/therm_pm72.c                     |    4 +-
 drivers/md/raid5.c                                 |    2 +-
 drivers/media/dvb/dvb-usb/dw2102.c                 |    2 +-
 drivers/media/video/msp3400-driver.c               |    2 +-
 drivers/media/video/saa7164/saa7164-encoder.c      |    2 +-
 drivers/media/video/saa7164/saa7164-vbi.c          |    2 +-
 drivers/media/video/usbvision/usbvision-video.c    |    5 ++-
 drivers/message/fusion/mptbase.c                   |   22 +++++++---------
 drivers/message/i2o/README.ioctl                   |    2 +-
 drivers/misc/bh1780gli.c                           |    8 +++---
 drivers/misc/cs5535-mfgpt.c                        |    4 +-
 drivers/misc/ibmasm/ibmasmfs.c                     |    2 +-
 drivers/misc/spear13xx_pcie_gadget.c               |    4 +-
 drivers/mmc/host/atmel-mci.c                       |    2 +-
 drivers/net/atlx/atl1.c                            |    5 ++-
 drivers/net/can/pch_can.c                          |    2 +-
 drivers/net/can/softing/softing_main.c             |    2 +-
 drivers/net/irda/ali-ircc.c                        |    2 +-
 drivers/net/macb.c                                 |    2 +-
 drivers/net/s2io.c                                 |    2 +-
 drivers/net/sgiseeq.c                              |    2 +-
 drivers/net/sgiseeq.h                              |    2 +-
 drivers/net/ucc_geth_ethtool.c                     |    2 +-
 drivers/net/usb/usbnet.c                           |    2 +-
 drivers/net/wan/pc300_drv.c                        |    2 +-
 drivers/net/wireless/airo.c                        |   27 ++++++++++---------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    8 +++---
 drivers/net/wireless/b43/b43.h                     |    4 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |    2 +-
 drivers/net/wireless/rtlwifi/core.c                |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |    4 +-
 drivers/platform/x86/Kconfig                       |    2 +-
 drivers/power/intel_mid_battery.c                  |    2 +-
 drivers/regulator/max8998.c                        |    4 +-
 drivers/regulator/mc13783-regulator.c              |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c        |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h        |    2 +-
 drivers/scsi/be2iscsi/be_main.c                    |    4 +-
 drivers/scsi/constants.c                           |    2 +-
 drivers/scsi/esp_scsi.c                            |    2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |    2 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |    2 +-
 drivers/scsi/nsp32_debug.c                         |    2 +-
 drivers/scsi/pcmcia/nsp_debug.c                    |    2 +-
 drivers/scsi/pm8001/pm8001_init.c                  |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |    4 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |    2 +-
 drivers/scsi/sgiwd93.c                             |    2 +-
 drivers/spi/atmel_spi.c                            |    2 +-
 drivers/target/target_core_alua.c                  |    4 +-
 drivers/target/target_core_transport.c             |    2 +-
 drivers/tty/n_gsm.c                                |    2 +-
 drivers/tty/serial/bfin_sport_uart.c               |    3 +-
 drivers/tty/serial/mfd.c                           |    4 +-
 drivers/tty/serial/mrst_max3110.c                  |    2 +-
 drivers/tty/tty_ioctl.c                            |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
 drivers/usb/host/imx21-dbg.c                       |    2 +-
 drivers/usb/host/uhci-hcd.c                        |    7 +++--
 drivers/usb/misc/usbtest.c                         |    2 +-
 drivers/usb/storage/ene_ub6250.c                   |    4 +-
 drivers/video/backlight/ltv350qv.c                 |    2 +-
 drivers/video/console/newport_con.c                |    2 +-
 drivers/video/msm/mddi.c                           |    2 +-
 drivers/video/mxsfb.c                              |    2 +-
 drivers/watchdog/bcm63xx_wdt.c                     |    2 +-
 drivers/xen/evtchn.c                               |    2 +-
 drivers/xen/swiotlb-xen.c                          |    2 +-
 fs/btrfs/relocation.c                              |    2 +-
 fs/freevxfs/vxfs_inode.c                           |    2 +-
 fs/logfs/readwrite.c                               |    2 +-
 fs/nfsd/stats.c                                    |    2 +-
 fs/ocfs2/refcounttree.c                            |    2 +-
 fs/partitions/ldm.c                                |    2 +-
 fs/squashfs/Kconfig                                |    4 +-
 fs/squashfs/cache.c                                |    2 +-
 fs/ufs/inode.c                                     |    2 +-
 fs/xfs/xfs_inode.c                                 |    2 +-
 include/linux/leds-regulator.h                     |    2 +-
 include/linux/posix-clock.h                        |    2 +-
 include/net/genetlink.h                            |    2 +-
 include/net/netlink.h                              |    2 +-
 include/video/newport.h                            |    2 +-
 kernel/Kconfig.locks                               |    2 +-
 kernel/auditsc.c                                   |   27 ++++++++++++-------
 kernel/pm_qos_params.c                             |    2 +-
 lib/Kconfig.debug                                  |    3 +-
 lib/vsprintf.c                                     |    9 ++----
 mm/hugetlb.c                                       |    2 +-
 mm/page_alloc.c                                    |    2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |    2 +-
 net/sunrpc/addr.c                                  |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |    2 +-
 scripts/checkstack.pl                              |    2 +-
 security/selinux/selinuxfs.c                       |    8 +++---
 tools/perf/util/ui/browsers/annotate.c             |    1 -
 tools/power/x86/turbostat/turbostat.c              |    2 +-
 175 files changed, 254 insertions(+), 257 deletions(-)
