Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0H0AAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:00:48 -0400
Received: from kroah.org ([198.145.64.141]:54765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab0H0AAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:00:43 -0400
Date: Thu, 26 Aug 2010 16:57:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.21
Message-ID: <20100826235719.GC13527@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826235552.GA13527@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.21 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/arm/include/asm/ptrace.h               |   17 +++-
 arch/powerpc/Makefile                       |    2 
 arch/sparc/include/asm/atomic_64.h          |   10 +-
 arch/sparc/include/asm/parport.h            |    4 
 arch/sparc/include/asm/rwsem-const.h        |    2 
 arch/x86/Kconfig                            |    5 +
 arch/x86/kernel/apic/apic.c                 |   41 ++++++++--
 arch/x86/kernel/apic/io_apic.c              |    2 
 arch/x86/kernel/smpboot.c                   |   19 ++++
 arch/x86/oprofile/nmi_int.c                 |   17 +++-
 drivers/gpu/drm/drm_drv.c                   |    4 
 drivers/gpu/drm/i915/i915_gem.c             |    3 
 drivers/gpu/drm/i915/intel_display.c        |    1 
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    2 
 drivers/hwmon/pc87360.c                     |   31 ++++---
 drivers/isdn/sc/ioctl.c                     |   10 +-
 drivers/md/dm-ioctl.c                       |   44 ++++++----
 drivers/md/dm-mpath.c                       |    1 
 drivers/memstick/core/mspro_block.c         |    5 -
 drivers/mtd/nand/pxa3xx_nand.c              |    2 
 drivers/net/wireless/ath/ath5k/base.c       |   21 +++++
 drivers/pcmcia/pcmcia_resource.c            |    5 -
 drivers/usb/host/xhci-ring.c                |    2 
 drivers/usb/serial/cp210x.c                 |    4 
 drivers/usb/serial/ftdi_sio.c               |    5 -
 drivers/usb/serial/ftdi_sio_ids.h           |    9 ++
 drivers/usb/serial/io_ti.c                  |    2 
 drivers/usb/serial/navman.c                 |    1 
 drivers/usb/serial/option.c                 |    7 +
 drivers/usb/serial/pl2303.c                 |    1 
 drivers/usb/serial/pl2303.h                 |    4 
 drivers/video/sunxvr500.c                   |   24 ++++-
 firmware/Makefile                           |    2 
 fs/ext4/balloc.c                            |    3 
 fs/ext4/ext4.h                              |    2 
 fs/ext4/extents.c                           |    4 
 fs/ext4/mballoc.h                           |    2 
 fs/nfs/super.c                              |    7 +
 fs/ocfs2/acl.c                              |   33 ++++++--
 fs/ocfs2/dlm/dlmmaster.c                    |    9 --
 fs/ocfs2/dlm/dlmrecovery.c                  |   22 ++---
 fs/ocfs2/dlm/dlmthread.c                    |  114 +++++++++++++---------------
 fs/ocfs2/refcounttree.c                     |   20 +++-
 include/linux/mm_types.h                    |    2 
 include/sound/emu10k1.h                     |    1 
 kernel/fork.c                               |    7 +
 mm/memory.c                                 |   15 ++-
 mm/mlock.c                                  |   21 +++--
 mm/mmap.c                                   |   21 ++++-
 mm/nommu.c                                  |    7 +
 mm/slab.c                                   |    4 
 mm/vmscan.c                                 |   53 +++++++++++--
 net/can/bcm.c                               |   41 ++++++----
 net/core/dev.c                              |    2 
 net/netlink/af_netlink.c                    |   46 +++--------
 net/sched/act_nat.c                         |    2 
 scripts/mkmakefile                          |    4 
 sound/core/pcm_native.c                     |    4 
 sound/pci/emu10k1/emu10k1.c                 |    4 
 sound/pci/emu10k1/emupcm.c                  |   30 ++++++-
 sound/pci/emu10k1/memory.c                  |    4 
 sound/pci/hda/patch_realtek.c               |    1 
 sound/pci/intel8x0.c                        |    6 +
 sound/pci/riptide/riptide.c                 |   11 +-
 sound/soc/codecs/wm8580.c                   |    6 -
 sound/soc/codecs/wm8776.c                   |    7 -
 67 files changed, 553 insertions(+), 273 deletions(-)

Akinobu Mita (1):
      ext4: consolidate in_range() definitions

Alasdair G Kergon (1):
      dm mpath: fix NULL pointer dereference when path parameters missing

Alex Deucher (1):
      drm/radeon/kms: fix typo in radeon_compute_pll_gain

Anatolij Gustschin (1):
      powerpc: Fix typo in uImage target

Axel Lin (1):
      pxa3xx: fix ns2cycle equation

Borislav Petkov (1):
      x86, hotplug: Serialize CPU hotplug to avoid bringup concurrency issues

Carsten Otte (1):
      slab: fix object alignment

Changli Gao (1):
      act_nat: the checksum of ICMP doesn't have pseudo header

Chris Wilson (1):
      drm/i915/edp: Flush the write before waiting for PLLs

Craig Shelley (1):
      USB: CP210x Fix Break On/Off

Dan Carpenter (1):
      isdn: fix information leak

Daniel Kiper (1):
      x86, apic: Fix apic=debug boot crash

Daniel T Chen (1):
      ALSA: intel8x0: Mute External Amplifier by default for ThinkPad X31

Dave Airlie (1):
      drm: stop information leak of old kernel stack.

David S. Miller (4):
      sunxvr500: Ignore secondary output PCI devices.
      sparc64: Add missing ID to parport probing code.
      sparc64: Fix rwsem constant bug leading to hangs.
      sparc64: Fix atomic64_t routine return values.

Dominik Brodowski (1):
      pcmcia: avoid buffer overflow in pcmcia_setup_isa_irq

Galen Seitz (1):
      USB: ftdi_sio: add product ID for Lenz LI-USB

Greg Kroah-Hartman (2):
      USB: io_ti: check firmware version before updating
      Linux 2.6.32.21

Jan Beulich (1):
      fixes for using make 3.82

Jarek Poplawski (1):
      net: Fix a memmove bug in dev_gro_receive()

Jaroslav Kysela (1):
      ALSA: emu10k1 - delay the PCM interrupts (add pcm_irq_delay parameter)

Jean Delvare (1):
      hwmon: (pc87360) Fix device resource declaration

Jef Driesen (1):
      USB: pl2303: New vendor and product id

Jiaju Zhang (1):
      Fix the nested PR lock calling issue in ACL

Johannes Berg (1):
      netlink: fix compat recvmsg

John Villalovos (1):
      Oprofile: Change CPUIDS from decimal to hex, and add some comments

John Youn (1):
      USB: xhci: Remove buggy assignment in next_trb()

Jonathan Woithe (1):
      ALSA: hda - Fix missing stream for second ADC on Realtek ALC260 HDA codec

Josh Hunt (1):
      oprofile: add support for Intel processor model 30

Kerstin Jonsson (1):
      x86, apic: ack all pending irqs when crashed/on kexec

Kiyoshi Ueda (1):
      dm ioctl: release _hash_lock between devices in remove_all

Linus Torvalds (5):
      mm: make the vma list be doubly linked
      mm: make the mlock() stack guard page checks stricter
      mm: make stack guard page logic use vm_prev pointer
      drm/i915: fix hibernation since i915 self-reclaim fixes
      drm/i915: add 'reclaimable' to i915 self-reclaimable page allocations

Mark Brown (2):
      ASoC: Fix inverted mute controls for WM8580
      ASoC: Remove DSP mode support for WM8776

Martin Michlmayr (1):
      USB: ftdi_sio: Add ID for Ionics PlugComputer

Maxim Levitsky (2):
      memstick: fix hangs on unexpected device removal in mspro_blk
      ath5k: disable ASPM L0s for all cards

Michael Tokarev (1):
      USB: option: add Celot CT-650

Michael Wileczka (1):
      USB: ftdi_sio: fix endianess of max packet size

Oliver Hartkopp (1):
      can: add limit for nframes and clean up signed/unsigned variables

Patrick J. LoPresti (1):
      nfs: Add "lookupcache" to displayed mount options

Ross Burton (1):
      USB: add device IDs for igotu to navman

Russell King (1):
      ARM: Tighten check for allowable CPSR values

Srinivas Eeda (1):
      ocfs2 fix o2dlm dlm run purgelist (rev 3)

Takashi Iwai (1):
      ALSA: riptide - Fix detection / load of firmware files

Tao Ma (1):
      ocfs2: Count more refcount records in file system fragmentation.

Tiger Yang (1):
      ocfs2: do not overwrite error codes in ocfs2_init_acl

Wengang Wang (3):
      ocfs2/dlm: fix a dead lock
      ocfs2/dlm: avoid incorrect bit set in refmap on recovery master
      ocfs2/dlm: remove potential deadlock -V3

Wu Fengguang (1):
      vmscan: raise the bar to PAGEOUT_IO_SYNC stalls

