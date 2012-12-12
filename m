Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab2LLVx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:53:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab2LLVx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:53:56 -0500
Date: Wed, 12 Dec 2012 22:53:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1212122213110.19767@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive patches queued in trivial tree.


Usual stuff -- comment/printk typo fixes, documentation updates, dead code 
elimination.


Thanks.

Adam Buchbinder (4):
      various: Fix spelling of "registered" in comments.
      eisa: Fix spelling of "asynchronous".
      Fix misspellings of "whether" in comments.
      various: Fix spelling of "asynchronous" in comments.

Alan Cox (5):
      parport: dead code in pp_write
      iscsi: fix check keys
      rfkill: error cannot be set here so simplify
      keys: Fix unreachable code
      i2400m: debugfs return code is wrong

Anthony G. Basile (1):
      doc: Remove unnecessary declarations from Documentation/accounting/getdelays.c

Borislav Petkov (1):
      krealloc: Fix kernel-doc comment

Cesar Eduardo Barros (1):
      firmware: use noinline_for_stack

Chad Reese (1):
      RapidIO: Fix comment error.

Cristian Stoica (1):
      HOWTO: fix double words typo

Hyeonjun Lim (1):
      doc: Update the name of profiling based on sysfs

Jesper Juhl (1):
      gen_init_cpio: remove redundant empty line

Jiri Kosina (1):
      Merge branch 'master' into for-next

Kees Cook (1):
      README: document "make olddefconfig"

Liu Bo (1):
      btrfs: unpin_extent_cache: fix the typo and unnecessary arguements

Masanari Iida (14):
      tty: Fix typo in tty drivers
      isdn: Fix typo in isdn drivers
      md: Fix typo in drivers/md
      qla2xxx: Fix typo in qla2xxx drivers
      Btrfs: Fix printk and variable name
      treewide: fix printk typo in multiple drivers
      treewide: fix typo of "suppport" in various comments
      treewide: fix typo of "suport" in various comments and Kconfig
      target: iscsi: fix comment typos in target/iscsi drivers
      doc: fix quite a few typos within Documentation
      messages: i2o: Fix typo in messages/i2o
      wireless: mwifiex: Fix typo in wireless/mwifiex driver
      treewide: Fix typos in various Kconfig
      treewide: Fix typos in various drivers

Nadia Yvette Chambers (1):
      propagate name change to comments in kernel source

Olaf Hering (1):
      x86 mtrr: fix comment typo in mtrr_bp_init

Paul Bolle (2):
      x86: remove offsets.h from .gitignore and dontdiff
      radeon: Fix typo and copy/paste error in comments

Sasha Levin (1):
      alpha: use BUG_ON where possible

Yacine Belkadi (2):
      Kernel-doc: Convention: Use a "Return" section to describe return values
      scripts/kernel-doc: check that non-void fcts describe their return value

 Documentation/ABI/testing/dev-kmsg                 |    2 +-
 Documentation/ABI/testing/sysfs-devices-power      |    2 +-
 Documentation/ABI/testing/sysfs-driver-ppi         |    2 +-
 Documentation/ABI/testing/sysfs-profiling          |    6 ++--
 Documentation/HOWTO                                |    2 +-
 Documentation/accounting/getdelays.c               |    1 -
 Documentation/dma-buf-sharing.txt                  |    4 +-
 Documentation/dontdiff                             |    1 -
 .../fault-injection/notifier-error-inject.txt      |    4 +-
 Documentation/hid/uhid.txt                         |    2 +-
 Documentation/hwmon/pmbus                          |    2 +-
 Documentation/input/alps.txt                       |    2 +-
 Documentation/kbuild/modules.txt                   |    2 +-
 Documentation/kernel-doc-nano-HOWTO.txt            |   13 ++++++--
 Documentation/misc-devices/mei/mei-amt-version.c   |    4 +-
 Documentation/video4linux/bttv/Cards               |    2 +-
 Documentation/video4linux/bttv/Sound-FAQ           |    2 +-
 Documentation/vm/frontswap.txt                     |    2 +-
 MAINTAINERS                                        |    2 +-
 README                                             |    4 ++
 arch/alpha/include/asm/mmzone.h                    |    2 +-
 arch/alpha/kernel/pci_iommu.c                      |   12 ++-----
 arch/arm/kernel/kprobes-test.c                     |    2 +-
 arch/arm/mach-netx/xc.c                            |    2 +-
 arch/arm/mach-s3c24xx/include/mach/bast-map.h      |    2 +-
 arch/arm/mach-s3c24xx/include/mach/dma.h           |    2 +-
 arch/arm/mach-s3c24xx/include/mach/vr1000-map.h    |    2 +-
 arch/arm/mach-s3c24xx/pm.c                         |    2 +-
 arch/arm/mach-tegra/Kconfig                        |    2 +-
 arch/arm/plat-s3c24xx/dma.c                        |    2 +-
 arch/blackfin/mach-bf609/Kconfig                   |    2 +-
 arch/blackfin/mm/sram-alloc.c                      |    2 +-
 arch/cris/include/arch-v10/arch/irq.h              |    2 +-
 arch/cris/include/arch-v32/arch/irq.h              |    2 +-
 arch/frv/mm/pgalloc.c                              |    2 +-
 arch/ia64/kvm/kvm-ia64.c                           |    2 +-
 arch/m68k/math-emu/fp_log.c                        |    2 +-
 arch/mips/txx9/generic/pci.c                       |    2 +-
 arch/mn10300/mm/pgtable.c                          |    2 +-
 arch/openrisc/Kconfig                              |    2 +-
 arch/powerpc/include/asm/oprofile_impl.h           |    2 +-
 arch/powerpc/include/asm/pte-hash64-64k.h          |    2 +-
 arch/powerpc/include/asm/smu.h                     |    4 +-
 arch/powerpc/kernel/legacy_serial.c                |    2 +-
 arch/powerpc/kernel/of_platform.c                  |    2 +-
 arch/powerpc/kernel/signal_64.c                    |    2 +-
 arch/powerpc/mm/slice.c                            |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c          |    2 +-
 arch/powerpc/platforms/cell/iommu.c                |    2 +-
 arch/powerpc/platforms/cell/spider-pic.c           |    6 ++--
 arch/powerpc/platforms/powermac/pic.c              |    2 +-
 arch/sh/boards/board-espt.c                        |    2 +-
 arch/x86/boot/.gitignore                           |    1 -
 arch/x86/kernel/cpu/mtrr/main.c                    |    2 +-
 arch/x86/mm/pgtable.c                              |    2 +-
 drivers/acpi/acpica/dsopcode.c                     |    2 +-
 drivers/char/ipmi/ipmi_msghandler.c                |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |    2 +-
 drivers/char/ppdev.c                               |    6 +---
 drivers/eisa/eisa.ids                              |    4 +-
 drivers/firewire/init_ohci1394_dma.c               |    4 +-
 drivers/firewire/ohci.c                            |    2 +-
 drivers/gpio/Kconfig                               |    2 +-
 drivers/gpu/drm/radeon/evergreen.c                 |    2 +-
 drivers/gpu/drm/radeon/ni.c                        |    4 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |    4 +-
 drivers/gpu/drm/radeon/si.c                        |    6 ++--
 drivers/i2c/busses/i2c-nuc900.c                    |    2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |    4 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |    2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c            |    2 +-
 drivers/isdn/hisax/amd7930_fn.c                    |    2 +-
 drivers/isdn/hisax/hfc_pci.c                       |    2 +-
 drivers/isdn/hisax/hfc_sx.c                        |    2 +-
 drivers/isdn/hisax/isar.c                          |    2 +-
 drivers/isdn/pcbit/layer2.c                        |    2 +-
 drivers/md/md.c                                    |    2 +-
 drivers/md/persistent-data/dm-block-manager.c      |    4 +-
 drivers/md/persistent-data/dm-btree.h              |    2 +-
 drivers/md/raid5.c                                 |    2 +-
 drivers/media/dvb-frontends/drxk_hard.c            |    2 +-
 drivers/media/platform/mx2_emmaprp.c               |    2 +-
 drivers/message/i2o/README.ioctl                   |   12 +++---
 drivers/message/i2o/i2o_block.c                    |    2 +-
 drivers/message/i2o/i2o_config.c                   |    2 +-
 drivers/mmc/host/Kconfig                           |    2 +-
 drivers/mtd/maps/plat-ram.c                        |    2 +-
 drivers/mtd/nand/s3c2410.c                         |    2 +-
 drivers/net/bonding/bonding.h                      |    2 +-
 drivers/net/ethernet/8390/ax88796.c                |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c     |    2 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |    2 +-
 drivers/net/ethernet/micrel/ksz884x.c              |    2 +-
 .../myricom/myri10ge/myri10ge_mcp_gen_header.h     |    2 +-
 drivers/net/sungem_phy.c                           |    8 ++--
 drivers/net/wimax/i2400m/debugfs.c                 |    1 +
 drivers/net/wireless/atmel.c                       |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.h             |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |    2 +-
 drivers/net/wireless/mwifiex/usb.c                 |    2 +-
 drivers/net/wireless/zd1211rw/zd_chip.c            |    2 +-
 drivers/regulator/palmas-regulator.c               |    2 +-
 drivers/remoteproc/remoteproc_elf_loader.c         |    4 +-
 drivers/rtc/rtc-isl1208.c                          |    2 +-
 drivers/rtc/rtc-s3c.c                              |    2 +-
 drivers/s390/block/dasd_devmap.c                   |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |    2 +-
 drivers/scsi/libsas/sas_expander.c                 |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |    4 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   12 +++---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |    2 +-
 drivers/staging/comedi/drivers/usbdux.c            |    2 +-
 drivers/staging/tidspbridge/rmgr/node.c            |    2 +-
 drivers/target/iscsi/iscsi_target_configfs.c       |    2 +-
 drivers/target/iscsi/iscsi_target_erl0.c           |    6 ++--
 drivers/target/iscsi/iscsi_target_parameters.c     |    1 +
 drivers/target/iscsi/iscsi_target_util.c           |    2 +-
 drivers/thermal/Kconfig                            |    2 +-
 drivers/tty/hvc/hvc_opal.c                         |    2 +-
 drivers/tty/hvc/hvc_vio.c                          |    2 +-
 drivers/tty/ipwireless/setup_protocol.h            |    2 +-
 drivers/tty/serial/8250/Kconfig                    |    2 +-
 drivers/tty/serial/bfin_uart.c                     |    2 +-
 drivers/tty/serial/icom.c                          |    2 +-
 drivers/usb/core/driver.c                          |    2 +-
 drivers/usb/gadget/at91_udc.c                      |    2 +-
 drivers/usb/storage/realtek_cr.c                   |    2 +-
 drivers/vhost/tcm_vhost.c                          |    2 +-
 drivers/watchdog/booke_wdt.c                       |    2 +-
 drivers/xen/xen-pciback/pci_stub.c                 |    2 +-
 fs/btrfs/ctree.h                                   |    2 +-
 fs/btrfs/extent-tree.c                             |    2 +-
 fs/btrfs/extent_map.c                              |    3 +-
 fs/btrfs/ordered-data.h                            |    2 +-
 fs/btrfs/volumes.c                                 |    2 +-
 fs/cifs/README                                     |    2 +-
 fs/ext4/ext4.h                                     |    2 +-
 fs/fhandle.c                                       |    4 +-
 fs/hugetlbfs/inode.c                               |    2 +-
 fs/jbd/transaction.c                               |    2 +-
 fs/jbd2/transaction.c                              |    2 +-
 fs/logfs/inode.c                                   |    2 +-
 fs/ncpfs/mmap.c                                    |    2 +-
 fs/notify/fanotify/Kconfig                         |    2 +-
 fs/notify/notification.c                           |    2 +-
 include/linux/dlm.h                                |    2 +-
 include/linux/hash.h                               |    2 +-
 include/linux/ipmi_smi.h                           |    2 +-
 include/linux/lru_cache.h                          |    4 +-
 include/linux/netdevice.h                          |    2 +-
 include/linux/stmmac.h                             |    2 +-
 include/linux/vgaarb.h                             |    4 +-
 include/linux/watchdog.h                           |    2 +-
 include/net/irda/irlmp.h                           |    2 +-
 include/net/sock.h                                 |    2 +-
 kernel/pid.c                                       |    4 +-
 kernel/profile.c                                   |    7 ++--
 kernel/trace/ftrace.c                              |    2 +-
 kernel/trace/trace.c                               |    2 +-
 kernel/trace/trace_functions.c                     |    2 +-
 kernel/trace/trace_irqsoff.c                       |    2 +-
 kernel/trace/trace_sched_wakeup.c                  |    2 +-
 kernel/wait.c                                      |    2 +-
 lib/Kconfig.debug                                  |   10 +++---
 lib/bitmap.c                                       |    2 +-
 mm/hugetlb.c                                       |    2 +-
 mm/memory_hotplug.c                                |    6 ++--
 mm/page_alloc.c                                    |    4 +-
 mm/util.c                                          |    2 +-
 net/can/proc.c                                     |    2 +-
 net/ipv4/tcp_cong.c                                |    2 +-
 net/mac80211/driver-ops.h                          |    2 +-
 net/netfilter/nf_log.c                             |    2 +-
 net/rfkill/core.c                                  |    4 +-
 net/sctp/endpointola.c                             |    2 +-
 net/sctp/sm_statefuns.c                            |    2 +-
 scripts/kernel-doc                                 |   34 ++++++++++++++++++++
 security/keys/process_keys.c                       |    2 -
 sound/core/seq/seq_device.c                        |    2 +-
 sound/pci/emu10k1/emu10k1_patch.c                  |    2 +-
 sound/pci/es1968.c                                 |    2 +-
 sound/pci/ice1712/delta.c                          |    2 +-
 sound/pci/sis7019.c                                |    2 +-
 sound/usb/quirks.c                                 |    2 +-
 tools/perf/Documentation/perf-record.txt           |    2 +-
 usr/gen_init_cpio.c                                |    1 -
 188 files changed, 280 insertions(+), 247 deletions(-)

-- 
Jiri Kosina
SUSE Labs
