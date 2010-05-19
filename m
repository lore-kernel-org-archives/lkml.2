Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab0ESM7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:59:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:55200 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052Ab0ESM7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:59:20 -0400
Date: Wed, 19 May 2010 14:59:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1005191443020.28092@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from for-linus branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive patches from trivial tree. Mostly comment and typo fixes all 
over the place.


Anand Gadiyar (1):
      fix "seperate" typos in comments

Andreas Dilger (1):
      add descriptive comment for TIF_MEMDIE task flag declaration.

Arce, Abraham (3):
      EEPROM: Header file cleanup
      EEPROM: 93cx6: Header file cleanup
      EEPROM: max6875: Header file cleanup

Bill Pemberton (6):
      doc: Change urls for sparse
      cciss: fix shadows sparse warning
      jbd2: use NULL instead of 0 when pointer is needed
      PCI: make bitfield unsigned
      rtc-v3020: make bitfield unsigned
      agp: use NULL instead of 0 when pointer is needed

Dan Carpenter (2):
      wd7000: typo spin_unlock_irq() => spin_lock_irq()
      i2o: cleanup some exit paths

Francis Galiegue (1):
      Documentation/: it's -> its where appropriate

Gilles Espinasse (1):
      Fix comment and Kconfig typos for 'require' and 'fragment'

Greg Thelen (3):
      mm: fix typo in refill_stock() comment
      memcg: fix typo in memcg documentation
      cpuset: Fix documentation punctuation

Henrik Kretzschmar (1):
      cocbalt_lcdfb: correct sections

Huang Weiyi (1):
      omfs: remove unused version.h include

Jan Kiszka (5):
      UML: Remove unused variable from line driver
      UML: Clean up asm/system.h
      UML: Drop private round_down definition
      UML: Fix compiler warning due to missing task_struct declaration
      uml: i386: Avoid redefinition of NR_syscalls

Jani Nikula (1):
      powerpc/BSR: fix device_create() return value check

Jiri Kosina (3):
      hpet: x86_64 and i386 are not different code any more
      UML: add kernel.h include to signal.c
      Merge branch 'master' into for-next

Justin P. Mattock (3):
      fix comment typo in sound/pci/hda/hda_local.h
      Remove empty comment in acpi/power.c
      Fix comment typo in percpu.h

Martyn Welch (2):
      rtc: e-mail corrections following split of GE Fanuc joint venture
      stk17ta8: renaming e-mail corrections following split of GE Fanuc joint venture

Rob Landley (1):
      Documentation/filesystems/proc.txt typo fix.

Robert P. J. Day (2):
      kobj: add comment and multiple inclusion protection
      kobj: kref.h incorrectly describes itself as kref.c.

Thadeu Lima de Souza Cascardo (1):
      doc: inode uses a mutex instead of a semaphore.

Thomas Weber (4):
      kconfig: util: Fix typo in comment
      Fix typos in comments
      i2c: twl.h: Fix comment typos and tab
      Powerpc: wii: Fix typo in comment

Venkatesh Pallipadi (1):
      HPET maintainer email update

Viral Mehta (1):
      kfifo: fix kerneldoc for kfifo_avail and kfifo_in_locked

Wolfram Sang (1):
      vlynq: make whole Kconfig-menu dependant on architecture

 Documentation/ABI/testing/sysfs-devices-memory     |    2 +-
 Documentation/DMA-API-HOWTO.txt                    |    2 +-
 Documentation/DocBook/libata.tmpl                  |    2 +-
 Documentation/PCI/pci-error-recovery.txt           |    4 +-
 Documentation/Smack.txt                            |    2 +-
 Documentation/arm/SA1100/ADSBitsy                  |    2 +-
 Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen     |    2 +-
 Documentation/atomic_ops.txt                       |    2 +-
 Documentation/blackfin/bfin-gpio-notes.txt         |    2 +-
 Documentation/cachetlb.txt                         |    6 +-
 Documentation/cgroups/cgroups.txt                  |    2 +-
 Documentation/cgroups/cpusets.txt                  |   38 +++++++-------
 Documentation/cgroups/memcg_test.txt               |    2 +-
 Documentation/cgroups/memory.txt                   |    2 +-
 Documentation/connector/connector.txt              |    2 +-
 Documentation/dvb/ci.txt                           |    2 +-
 Documentation/dvb/contributors.txt                 |    2 +-
 Documentation/filesystems/Locking                  |    4 +-
 .../filesystems/autofs4-mount-control.txt          |    2 +-
 Documentation/filesystems/ceph.txt                 |    2 +-
 Documentation/filesystems/dlmfs.txt                |    2 +-
 Documentation/filesystems/fiemap.txt               |   12 ++--
 Documentation/filesystems/fuse.txt                 |    4 +-
 Documentation/filesystems/hpfs.txt                 |    2 +-
 Documentation/filesystems/logfs.txt                |    8 ++--
 Documentation/filesystems/nfs/rpc-cache.txt        |    2 +-
 Documentation/filesystems/proc.txt                 |    6 +-
 Documentation/filesystems/smbfs.txt                |    2 +-
 Documentation/filesystems/vfs.txt                  |    2 +-
 Documentation/hwmon/lm85                           |    2 +-
 Documentation/input/joystick.txt                   |    2 +-
 Documentation/intel_txt.txt                        |    2 +-
 Documentation/kbuild/kconfig-language.txt          |    2 +-
 Documentation/kbuild/kconfig.txt                   |    2 +-
 Documentation/kernel-docs.txt                      |   10 ++--
 Documentation/kprobes.txt                          |    2 +-
 Documentation/laptops/laptop-mode.txt              |    2 +-
 Documentation/lguest/lguest.c                      |    2 +-
 Documentation/md.txt                               |    2 +-
 Documentation/netlabel/lsm_interface.txt           |    2 +-
 Documentation/networking/ifenslave.c               |    2 +-
 Documentation/networking/packet_mmap.txt           |    4 +-
 Documentation/power/regulator/consumer.txt         |   10 ++--
 Documentation/power/regulator/machine.txt          |    2 +-
 Documentation/power/regulator/overview.txt         |    6 +-
 Documentation/powerpc/booting-without-of.txt       |    2 +-
 Documentation/powerpc/dts-bindings/xilinx.txt      |    2 +-
 Documentation/powerpc/phyp-assisted-dump.txt       |    2 +-
 Documentation/rt-mutex-design.txt                  |    2 +-
 Documentation/scsi/ChangeLog.lpfc                  |    4 +-
 Documentation/scsi/FlashPoint.txt                  |    2 +-
 Documentation/scsi/dtc3x80.txt                     |    2 +-
 Documentation/scsi/ncr53c8xx.txt                   |    2 +-
 Documentation/scsi/osst.txt                        |    2 +-
 Documentation/scsi/scsi_fc_transport.txt           |    4 +-
 Documentation/scsi/sym53c8xx_2.txt                 |    2 +-
 Documentation/sound/alsa/soc/dapm.txt              |    4 +-
 Documentation/sound/alsa/soc/machine.txt           |    2 +-
 Documentation/sound/alsa/soc/overview.txt          |    2 +-
 Documentation/sparse.txt                           |    4 +-
 Documentation/sysfs-rules.txt                      |    2 +-
 Documentation/trace/events.txt                     |    8 ++--
 Documentation/usb/WUSB-Design-overview.txt         |    2 +-
 Documentation/vm/numa_memory_policy.txt            |    4 +-
 Documentation/w1/w1.generic                        |    2 +-
 MAINTAINERS                                        |    8 +--
 arch/alpha/include/asm/thread_info.h               |    2 +-
 arch/arm/include/asm/thread_info.h                 |    2 +-
 arch/arm/mach-s3c2443/clock.c                      |    2 +-
 arch/arm/plat-samsung/include/plat/gpio-core.h     |    2 +-
 arch/avr32/include/asm/thread_info.h               |    2 +-
 arch/blackfin/include/asm/thread_info.h            |    2 +-
 arch/cris/include/asm/thread_info.h                |    2 +-
 arch/frv/include/asm/thread_info.h                 |    2 +-
 arch/h8300/include/asm/thread_info.h               |    2 +-
 arch/ia64/include/asm/thread_info.h                |    2 +-
 arch/m32r/include/asm/thread_info.h                |    2 +-
 arch/m68k/include/asm/thread_info_mm.h             |    2 +-
 arch/m68k/include/asm/thread_info_no.h             |    2 +-
 arch/microblaze/include/asm/thread_info.h          |    2 +-
 arch/mips/include/asm/thread_info.h                |    2 +-
 arch/mips/sibyte/bcm1480/irq.c                     |    2 +-
 arch/mips/sibyte/sb1250/irq.c                      |    2 +-
 arch/mn10300/include/asm/thread_info.h             |    2 +-
 arch/parisc/include/asm/thread_info.h              |    2 +-
 arch/powerpc/include/asm/thread_info.h             |    2 +-
 arch/powerpc/platforms/embedded6xx/wii.c           |    4 +-
 arch/s390/include/asm/thread_info.h                |    2 +-
 arch/score/include/asm/thread_info.h               |    2 +-
 arch/sh/include/asm/thread_info.h                  |    2 +-
 arch/sparc/include/asm/thread_info_32.h            |    2 +-
 arch/sparc/include/asm/thread_info_64.h            |    2 +-
 arch/um/drivers/line.c                             |    1 -
 arch/um/include/asm/system.h                       |    3 -
 arch/um/include/asm/thread_info.h                  |    7 +--
 arch/um/kernel/skas/syscall.c                      |    4 +-
 arch/um/sys-i386/asm/elf.h                         |    2 +
 arch/um/sys-x86_64/asm/elf.h                       |    2 +
 arch/um/sys-x86_64/signal.c                        |    3 +-
 arch/x86/include/asm/percpu.h                      |    2 +-
 arch/x86/include/asm/thread_info.h                 |    2 +-
 arch/xtensa/include/asm/thread_info.h              |    2 +-
 crypto/Kconfig                                     |    2 +-
 drivers/acpi/osl.c                                 |    4 +-
 drivers/acpi/power.c                               |    1 -
 drivers/ata/ata_piix.c                             |    2 +-
 drivers/block/cciss.c                              |    3 +-
 drivers/char/agp/generic.c                         |    2 +-
 drivers/char/bsr.c                                 |    2 +-
 drivers/firewire/ohci.c                            |    2 +-
 drivers/gpu/drm/drm_bufs.c                         |    2 +-
 drivers/gpu/drm/i915/intel_display.c               |    4 +-
 drivers/gpu/drm/radeon/atombios.h                  |    4 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6120.c        |    4 +-
 drivers/infiniband/hw/ipath/ipath_iba7220.c        |    2 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |    2 +-
 drivers/isdn/hisax/hfc4s8s_l1.c                    |    2 +-
 drivers/macintosh/windfarm_pm81.c                  |    2 +-
 drivers/media/dvb/dvb-usb/friio-fe.c               |    2 +-
 drivers/message/i2o/i2o_config.c                   |   16 ++----
 drivers/misc/eeprom/eeprom.c                       |   36 ++++++--------
 drivers/misc/eeprom/eeprom_93cx6.c                 |   39 ++++++---------
 drivers/misc/eeprom/max6875.c                      |   52 ++++++++++----------
 drivers/net/bnx2x_hsi.h                            |    2 +-
 drivers/net/ps3_gelic_wireless.c                   |    2 +-
 drivers/net/smsc911x.c                             |    4 +-
 drivers/pci/hotplug/cpqphp_core.c                  |    2 +-
 drivers/pci/pci.c                                  |    2 +-
 drivers/pci/pci.h                                  |    2 +-
 drivers/ps3/ps3-sys-manager.c                      |    2 +-
 drivers/regulator/core.c                           |    2 +-
 drivers/rtc/rtc-rx8581.c                           |    6 +-
 drivers/rtc/rtc-stk17ta8.c                         |    4 +-
 drivers/s390/char/sclp_cpi_sys.c                   |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_cee.h       |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_status.h    |    4 +-
 drivers/spi/spi_mpc8xxx.c                          |    2 +-
 drivers/staging/vt6655/rxtx.c                      |   14 +++---
 drivers/staging/vt6656/rxtx.c                      |    6 +-
 drivers/usb/host/ehci-omap.c                       |    2 +-
 drivers/usb/wusbcore/wa-xfer.c                     |    2 +-
 drivers/video/cobalt_lcdfb.c                       |    2 +-
 drivers/virtio/virtio_pci.c                        |    2 +-
 drivers/vlynq/Kconfig                              |    2 +-
 fs/jbd2/journal.c                                  |    2 +-
 fs/jfs/jfs_dmap.c                                  |    2 +-
 fs/logfs/dir.c                                     |    2 +-
 fs/logfs/logfs.h                                   |    2 +-
 fs/logfs/logfs_abi.h                               |   10 ++--
 fs/omfs/inode.c                                    |    1 -
 include/linux/i2c/twl.h                            |    8 ++--
 include/linux/kfifo.h                              |    4 +-
 include/linux/kobj_map.h                           |    9 +++
 include/linux/kref.h                               |    2 +-
 include/linux/rtc-v3020.h                          |    2 +-
 kernel/cgroup.c                                    |    2 +-
 mm/memcontrol.c                                    |    2 +-
 mm/page_alloc.c                                    |    2 +-
 net/ipv4/ipmr.c                                    |    2 +-
 net/wimax/op-rfkill.c                              |    2 +-
 scripts/kconfig/util.c                             |    2 +-
 scripts/package/mkspec                             |    2 +-
 sound/pci/emu10k1/emu10k1_main.c                   |    2 +-
 sound/pci/hda/hda_local.h                          |    2 +-
 165 files changed, 313 insertions(+), 328 deletions(-)
