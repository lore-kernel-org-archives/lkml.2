Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1CRNYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:24:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab1CRNYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:24:32 -0400
Date: Fri, 18 Mar 2011 14:24:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1103181341070.19969@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive merge window updates from trivial tree.

It's mostly documentation updates, comment/printk typo fixes, and a few 
minor patches from respective maintainers in re-transmission mode (dcdbas, 
edac).


You are going to get one super-simple conflict in fs/eventpoll.c, as the 
context for 'toepoll_ctl -> to epoll_ctl' change has been changed in your 
tree recently.

Thanks.


Alexander Kurz (1):
      Documentation/filesystems/romfs.txt: fixing link to genromfs

Andrea Gelmini (1):
      Documentation: dm-crypt: update cryptsetup homepage

Arvind R (4):
      edac: i82975x author/maintainer email address change
      edac: correct commented info
      edac: correct i82975x mci initialisation
      edac: correct i82975x error-info reported

Daniel Baluta (1):
      fs/eventpoll.c: fix spelling

GeunSik Lim (1):
      Update cpuset info & webiste for cgroups

Gilles Espinasse (1):
      kbuild, mtd, net: a few comment typo fixes and rewording

Greg Thelen (1):
      memcg: clarify use_hierarchy documentation

Harry Wei (1):
      MAINTAINERS: fix sorting

Jesper Juhl (7):
      GPU DRM: Remove unnecessary casts of void ptr returning alloc function return values
      drivers/message/, i2o: Remove unnecessary casts of void ptr returning alloc function return values
      scsi: Remove unnecessary casts of void ptr returning alloc function return values
      Kill off warning: ¡inline¢ is not at beginning of declaration
      X86, Acer, WMI: Do not double include linux/dmi.h in acer-wmi.c
      target: remove duplicate include of target/target_core_device.h from drivers/target/target_core_hba.c
      serial, pch uart: Remove duplicate inclusion of linux/pci.h header

Jim Cromie (1):
      replace obsolete CONFIG_DYNAMIC_PRINTK_DEBUG with CONFIG_DYNAMIC_DEBUG

Justin P. Mattock (8):
      Comment typo fixes for 'descriptor'
      fix typos 'comamnd' -> 'command' in comments
      cris: fix comment typo occationally to occasionally
      mbox-db5500.c Change initate to initiate.
      coh901318.c: Change initate to initiate.
      drivers:scsi Change printk typo initate -> initiate
      Remove one to many n's in a word
      arch/arm/Kconfig: remove one to many l's in the word.

Michael Witten (2):
      Kconfig: Typo: seti -> set
      Kconfig: BLK_THROTTLE -> BLK_DEV_THROTTLING

Michal Hocko (1):
      doc: CONFIG_UNEVICTABLE_LRU doesn't exist anymore

Namhyung Kim (2):
      dio: fix typos in comments
      fs: update comments to point correct document

Paul Bolle (9):
      Documentation: default_message_level is a typo
      x86: Fix printk typo WARING
      hvcs: fix typo in comment
      mISDN: fix printk typo fushing
      fuse/cuse: fix comment typo initilaization
      doc: Fix numbering of KVM API description sections
      ext4: fix comment typo uninitized
      drm: Fix printk typo 'failled'
      drm: fix printk typo 'sracth'

Pete Zaitcev (1):
      fix comment spelling becausse => because

Ryota Ozaki (1):
      mm: Fix out-of-date comments which refers non-existent functions

Stuart Hayes (1):
      dcdbas: force SMI to happen when expected

Tao Ma (1):
      ext4: Fix comment typo "especiially".

Tobias Klauser (1):
      asm-generic/user.h: Fix spelling in comment

Wolfram Sang (1):
      MAINTAINERS: add second list for IRDA

 Documentation/cgroups/cpusets.txt         |   17 +++---
 Documentation/cgroups/memory.txt          |    5 +-
 Documentation/device-mapper/dm-crypt.txt  |    2 +-
 Documentation/filesystems/romfs.txt       |    3 +-
 Documentation/kbuild/kbuild.txt           |    2 +-
 Documentation/kbuild/makefiles.txt        |    3 +-
 Documentation/kvm/api.txt                 |   96 ++++++++++++++--------------
 Documentation/sysctl/kernel.txt           |    2 +-
 Documentation/vm/unevictable-lru.txt      |    3 +-
 MAINTAINERS                               |   15 +++--
 Makefile                                  |    2 +-
 arch/alpha/include/asm/cacheflush.h       |    2 +-
 arch/arm/mach-ux500/mbox-db5500.c         |    2 +-
 arch/arm/plat-omap/Kconfig                |    2 +-
 arch/avr32/mm/cache.c                     |    2 +-
 arch/cris/arch-v10/mm/init.c              |    2 +-
 arch/ia64/include/asm/perfmon.h           |    2 +-
 arch/x86/kernel/apic/io_apic.c            |    2 +-
 arch/x86/oprofile/op_model_p4.c           |    2 +-
 arch/xtensa/configs/s6105_defconfig       |    2 +-
 drivers/atm/firestream.c                  |    2 +-
 drivers/block/smart1,2.h                  |    2 +-
 drivers/bluetooth/btusb.c                 |    4 +-
 drivers/cpuidle/sysfs.c                   |    2 +-
 drivers/dma/coh901318.c                   |    4 +-
 drivers/dma/shdma.c                       |    2 +-
 drivers/dma/timb_dma.c                    |    2 +-
 drivers/edac/i7300_edac.c                 |    2 +-
 drivers/edac/i82975x_edac.c               |   69 +++++++++++++--------
 drivers/firmware/dcdbas.c                 |    4 +-
 drivers/gpu/drm/drm_sman.c                |    4 +-
 drivers/gpu/drm/radeon/evergreen.c        |    2 +-
 drivers/gpu/drm/radeon/r100.c             |   10 ++--
 drivers/gpu/drm/radeon/r300.c             |    4 +-
 drivers/gpu/drm/radeon/r420.c             |    4 +-
 drivers/gpu/drm/radeon/r520.c             |    4 +-
 drivers/gpu/drm/radeon/r600.c             |    2 +-
 drivers/gpu/drm/radeon/radeon_ring.c      |    2 +-
 drivers/gpu/drm/radeon/rs400.c            |    4 +-
 drivers/gpu/drm/radeon/rs600.c            |    4 +-
 drivers/gpu/drm/radeon/rs690.c            |    4 +-
 drivers/gpu/drm/radeon/rv515.c            |    4 +-
 drivers/gpu/drm/radeon/rv770.c            |    2 +-
 drivers/isdn/mISDN/hwchannel.c            |    6 +-
 drivers/message/i2o/i2o_config.c          |    3 +-
 drivers/mtd/nand/mxc_nand.c               |    5 +-
 drivers/net/atl1c/atl1c.h                 |    4 +-
 drivers/net/qla3xxx.c                     |    2 +-
 drivers/net/sungem.h                      |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c    |    2 +-
 drivers/platform/x86/acer-wmi.c           |    1 -
 drivers/scsi/aic7xxx/aic79xx.h            |    2 +-
 drivers/scsi/aic7xxx/aic7xxx.h            |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c       |    2 +-
 drivers/scsi/megaraid.c                   |    4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
 drivers/scsi/osst.c                       |   10 +--
 drivers/scsi/qla4xxx/ql4_isr.c            |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c             |    2 +-
 drivers/target/target_core_hba.c          |    1 -
 drivers/tty/hvc/hvcs.c                    |    2 +-
 drivers/tty/serial/pch_uart.c             |    1 -
 drivers/usb/core/hub.c                    |    2 +-
 drivers/usb/host/uhci-hcd.c               |    2 +-
 drivers/usb/wusbcore/rh.c                 |    2 +-
 drivers/watchdog/sbc_epx_c3.c             |    2 +-
 fs/btrfs/disk-io.c                        |    2 +-
 fs/dcache.c                               |    4 +-
 fs/direct-io.c                            |    6 +-
 fs/eventpoll.c                            |   12 ++--
 fs/ext4/extents.c                         |    4 +-
 fs/fuse/cuse.c                            |    2 +-
 fs/notify/fanotify/fanotify_user.c        |    2 +-
 fs/notify/inotify/inotify_user.c          |    2 +-
 fs/ocfs2/dir.c                            |    2 +-
 include/asm-generic/user.h                |    4 +-
 include/linux/mmzone.h                    |    2 +-
 init/Kconfig                              |    6 +-
 kernel/trace/ring_buffer.c                |    2 +-
 mm/memory.c                               |    6 +-
 mm/mempolicy.c                            |    2 +-
 mm/shmem.c                                |    2 +-
 net/core/dev_addr_lists.c                 |    4 +-
 net/ipv6/inet6_hashtables.c               |    2 +-
 net/mac80211/tx.c                         |    2 +-
 sound/pci/au88x0/au88x0.h                 |    4 +-
 sound/pci/au88x0/au88x0_core.c            |    4 +-
 87 files changed, 232 insertions(+), 218 deletions(-)
