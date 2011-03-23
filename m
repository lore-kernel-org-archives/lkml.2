Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab1CWUhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:37:46 -0400
Received: from kroah.org ([198.145.64.141]:56319 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933340Ab1CWUg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:36:28 -0400
Date: Wed, 23 Mar 2011 13:34:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.37.5
Message-ID: <20110323203459.GE7709@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.37.5 kernel.

All users of the 2.6.37 kernel series must upgrade.

The updated 2.6.37.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/i2c/instantiating-devices               |    2 
 Makefile                                              |    2 
 arch/microblaze/include/asm/uaccess.h                 |    8 -
 arch/mips/alchemy/mtx-1/platform.c                    |    9 +
 arch/parisc/kernel/irq.c                              |    2 
 arch/powerpc/include/asm/reg.h                        |    1 
 arch/powerpc/kernel/perf_event.c                      |   24 +++
 arch/x86/include/asm/pgtable-3level.h                 |   11 -
 arch/x86/kernel/alternative.c                         |    7 -
 arch/x86/kernel/check.c                               |    8 -
 arch/x86/kernel/e820.c                                |   10 +
 arch/x86/kernel/early-quirks.c                        |    7 -
 arch/x86/kernel/entry_64.S                            |    2 
 arch/x86/mm/fault.c                                   |   14 +-
 arch/x86/mm/init_64.c                                 |    6 
 arch/x86/mm/pageattr.c                                |   18 +-
 arch/x86/mm/pgtable.c                                 |   14 --
 arch/x86/xen/mmu.c                                    |   10 -
 block/blk-lib.c                                       |   19 +--
 drivers/ata/ahci.c                                    |    4 
 drivers/ata/libata-eh.c                               |    2 
 drivers/gpu/drm/drm_sysfs.c                           |    7 +
 drivers/gpu/drm/i915/intel_panel.c                    |    1 
 drivers/hid/Kconfig                                   |    4 
 drivers/hid/hid-core.c                                |    1 
 drivers/hid/hid-ids.h                                 |    1 
 drivers/hid/hid-magicmouse.c                          |    4 
 drivers/hid/hid-ortek.c                               |    3 
 drivers/hwmon/f71882fg.c                              |    2 
 drivers/hwmon/sht15.c                                 |    4 
 drivers/infiniband/core/cm.c                          |    1 
 drivers/infiniband/core/cma.c                         |   15 ++
 drivers/mmc/core/sdio.c                               |    8 +
 drivers/mmc/host/sdhci-pci.c                          |    8 +
 drivers/mtd/chips/cfi_cmdset_0001.c                   |   43 +++---
 drivers/mtd/chips/jedec_probe.c                       |   35 ++---
 drivers/mtd/mtd_blkdevs.c                             |    1 
 drivers/mtd/nand/omap2.c                              |    2 
 drivers/mtd/onenand/generic.c                         |    2 
 drivers/mtd/onenand/omap2.c                           |    2 
 drivers/net/ixgbe/ixgbe_common.c                      |    3 
 drivers/net/ixgbe/ixgbe_fcoe.c                        |   51 +++++++-
 drivers/net/ixgbe/ixgbe_fcoe.h                        |    2 
 drivers/net/ixgbe/ixgbe_sriov.c                       |    2 
 drivers/net/wireless/ath/ath9k/hw.c                   |   21 +--
 drivers/net/wireless/ath/ath9k/recv.c                 |    4 
 drivers/net/wireless/rt2x00/rt2x00dev.c               |   12 +
 drivers/net/wireless/rt2x00/rt2x00usb.c               |   22 ++-
 drivers/pci/pci-sysfs.c                               |    2 
 drivers/pci/quirks.c                                  |  113 ++++++++----------
 drivers/scsi/device_handler/scsi_dh_alua.c            |    3 
 drivers/staging/tidspbridge/rmgr/proc.c               |   19 ++-
 drivers/staging/winbond/core.h                        |    1 
 drivers/usb/core/hcd-pci.c                            |   13 --
 drivers/usb/core/hcd.c                                |   55 ++++++--
 drivers/usb/core/urb.c                                |   11 +
 drivers/usb/host/ehci-hub.c                           |   23 +++
 drivers/usb/host/isp1760-hcd.c                        |   22 ++-
 drivers/usb/host/isp1760-hcd.h                        |    1 
 drivers/usb/host/xhci-ring.c                          |   43 ++++++
 drivers/usb/host/xhci.h                               |    9 +
 drivers/usb/serial/ch341.c                            |    1 
 drivers/usb/serial/kobil_sct.c                        |    2 
 drivers/usb/serial/option.c                           |    3 
 drivers/usb/serial/usb-serial.c                       |    5 
 fs/btrfs/file.c                                       |   13 ++
 fs/ext3/namei.c                                       |    2 
 fs/nfs/nfs2xdr.c                                      |    6 
 fs/nfs/nfs3xdr.c                                      |    6 
 fs/nfs/nfs4proc.c                                     |    2 
 fs/nfs/nfsroot.c                                      |   29 ++--
 fs/partitions/osf.c                                   |   12 +
 include/linux/ftrace.h                                |    2 
 include/linux/usb/ch9.h                               |    2 
 include/linux/usb/hcd.h                               |    4 
 include/linux/usb/serial.h                            |    3 
 kernel/perf_event.c                                   |    4 
 kernel/sched.c                                        |    2 
 kernel/smp.c                                          |   55 +++++++-
 kernel/trace/ftrace.c                                 |   52 +++++++-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |    2 
 net/netfilter/nf_conntrack_netlink.c                  |   25 ++-
 net/netfilter/nf_conntrack_standalone.c               |    2 
 net/sunrpc/clnt.c                                     |    4 
 net/sunrpc/sched.c                                    |   14 --
 net/sunrpc/xprtsock.c                                 |    3 
 security/tomoyo/file.c                                |    5 
 sound/drivers/aloop.c                                 |   19 +--
 sound/pci/asihpi/hpioctl.c                            |    5 
 sound/pci/ctxfi/ctatc.c                               |    2 
 sound/pci/ctxfi/ctdaio.c                              |    2 
 sound/pci/ctxfi/ctmixer.c                             |   19 ---
 sound/pci/hda/patch_realtek.c                         |   56 +++++---
 sound/pci/hda/patch_sigmatel.c                        |   11 +
 sound/soc/codecs/wm8978.c                             |   14 +-
 tools/perf/util/PERF-VERSION-GEN                      |    8 -
 96 files changed, 773 insertions(+), 379 deletions(-)

Alan Stern (2):
      USB: serial drivers need to use larger bulk-in buffers
      USB: move usbcore away from hcd->state

Alexander Duyck (1):
      ixgbe: limit VF access to network traffic

Alexander van Heukelum (1):
      x86, binutils, xen: Fix another wrong size directive

Amir Hanania (1):
      ixgbe: work around for DDP last buffer size

Andrea Arcangeli (1):
      x86/mm: Fix pgd_lock deadlock

Andreas Herrmann (1):
      x86, quirk: Fix SB600 revision check

Andrey Vagin (1):
      x86/mm: Handle mm_fault_error() in kernel space

Anton Blanchard (1):
      perf, powerpc: Handle events that raise an exception without overflowing

Antony Pavlov (2):
      mtd: jedec_probe: Change variable name from cfi_p to cfi
      mtd: jedec_probe: initialise make sector erase command variable

Axel Lin (1):
      mtd: add "platform:" prefix for platform modalias

Ben Hutchings (2):
      sunrpc: Propagate errors from xs_bind() through xs_create_sock()
      PCI: sysfs: Fix failure path for addition of "vpd" attribute

Brandeburg, Jesse (1):
      PCI: remove quirk for pre-production systems

Chris Mason (1):
      Btrfs: deal with short returns from copy_from_user

Chris Wilson (1):
      drm: Hold the mode mutex whilst probing for sysfs status

Chuck Lever (1):
      NFS: NFSROOT should default to "proto=udp"

Dan Rosenberg (1):
      ALSA: sound/pci/asihpi: check adapter index in hpi_ioctl

David Henningsson (1):
      ALSA: HDA: Realtek ALC88x: Do not over-initialize speakers and hp that are primary outputs

Eric Sandeen (1):
      ext3: Always set dx_node's fake_dirent explicitly.

Felipe Contreras (1):
      staging: tidspbridge: protect dmm_map properly

Felix Fietkau (1):
      ath9k: remove support for the FIF_PROMISC_IN_BSS filter flag

Florian Fainelli (1):
      MIPS: MTX-1: Make au1000_eth probe all PHY addresses

Frederic Weisbecker (2):
      perf: Fix the software events state check
      perf: Handle stopped state with tracepoints

Greg Kroah-Hartman (1):
      Linux 2.6.37.5

Hans de Goede (1):
      hwmon/f71882fg: Set platform drvdata to NULL later

Henrik Rydberg (1):
      HID: hid-magicmouse: Correct touch orientation direction

Herton Ronaldo Krzesinski (2):
      USB: serial: option: Apply OPTION_BLACKLIST_SENDSETUP also for ZTE MF626
      HID: add support for Ortek PKB-1700

Ivo van Doorn (1):
      rt2x00: Fix crash on USB unplug

Jeff Mahoney (1):
      staging: winbond: needs <linux/delay.h> for msleep and friends

Jiri Slaby (3):
      USB: serial/kobil_sct, fix potential tty NULL dereference
      PCI: add more checking to ICH region quirks
      PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH

Joakim Tjernlund (1):
      mtd: fix race in cfi_cmdset_0001 driver

Johannes Stezenbach (1):
      rt2x00: fix hang when unplugging USB device in use

Joseph Gruher (1):
      scsi_dh_alua: fix deadlock in stpg_endio

Josh Hunt (1):
      perf tools: Version incorrect with some versions of grep

Jovi Zhang (1):
      nfs: fix compilation warning

Kamal Mostafa (2):
      x86: Fix panic when handling "mem={invalid}" param
      x86: Emit "mem=nopentium ignored" warning when not supported

Linus Torvalds (1):
      Increase OSF partition limit from 8 to 18

Lukas Czerner (1):
      block: fix mis-synchronisation in blkdev_issue_zeroout()

Manoj Iyer (1):
      mmc: sdhci: Add Ricoh e823 PCI ID

Mark Brown (1):
      ASoC: Fix broken bitfield definitions in WM8978

Mathieu Desnoyers (1):
      x86: stop_machine_text_poke() should issue sync_core()

Matthew Garrett (1):
      ehci: Check individual port status registers on resume

Maxim Levitsky (1):
      mtd: mtd_blkdevs: fix double free on error path

Milton Miller (3):
      call_function_many: fix list delete vs add race
      call_function_many: add missing ordering
      smp_call_function_many: handle concurrent clearing of mask

Naga Chumbalkar (1):
      x86: Don't check for BIOS corruption in first 64K when there's no need to

Pablo Neira Ayuso (1):
      netfilter: fix export secctx error handling

Paul Zimmerman (1):
      USB: Add support for SuperSpeed isoc endpoints

Per Jessen (1):
      ahci: recognize Marvell 88se9125 PCIe SATA 6.0 Gb/s controller

Przemyslaw Bruski (3):
      ALSA: ctxfi - Fix incorrect SPDIF status bit mask
      ALSA: ctxfi - Fix SPDIF status retrieval
      ALSA: ctxfi - Clear input settings before initialization

Roman Fietze (1):
      i2c: Fix typo in instantiating-devices document

Sarah Sharp (2):
      xhci: Update internal dequeue pointers after stalls.
      xhci: Fix cycle bit calculation during stall handling.

Sean Hefty (2):
      RDMA/cma: Fix crash in request handlers
      IB/cm: Bump reference count on cm_id before invoking callback

Sebastian Andrzej Siewior (1):
      USB: isp1760: Implement solution for erratum 2

Senthil Balasubramanian (2):
      ath9k_hw: read and backup AR_WA register value even before chip reset on.
      ath9k_hw: Fix incorrect macversion and macrev checks

Seth Heasley (2):
      ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs
      ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller

Shaohua Li (1):
      x86: Flush TLB if PGD entry is changed in i386 PAE mode

Stanislav Kinsbursky (1):
      RPC: killing RPC tasks races fixed

Stefan Nilsson XK (1):
      mmc: sdio: remember new card RCA when redetecting card

Steven J. Magnani (1):
      microblaze: Fix /dev/zero corruption from __clear_user()

Steven Rostedt (1):
      ftrace: Fix memory leak with function graph and cpu hotplug

Takashi Iwai (3):
      drm/i915: Fix calculation of backlight value in combined mode
      ALSA: hda - Initialize special cases for input src in init phase
      ALSA: aloop - Fix possible IRQ lock inversion

Tejun Heo (1):
      libata: fix hotplug for drivers which don't implement LPM

Tetsuo Handa (1):
      TOMOYO: Fix memory leak upon file open.

Thomas Gleixner (1):
      fix per-cpu flag problem in the cpu affinity checkers

Timo Warns (1):
      Fix corrupted OSF partition table parsing

Trond Myklebust (2):
      NFS: Fix a decoding problem in nfs3_decode_dirent
      SUNRPC: Ensure we always run the tk_callback before tk_action

Vitaliy Kulikov (1):
      ALSA: hda - fix digital mic selection in mixer on 92HD8X codecs

Vivien Didelot (1):
      hwmon: (sht15) Fix integer overflow in humidity calculation

wangyanqing (1):
      USB: serial: ch341: add new id

