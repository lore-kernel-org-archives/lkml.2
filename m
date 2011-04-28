Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab1D1PeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:34:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:21304 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab1D1PeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:34:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,281,1301900400"; 
   d="scan'208";a="915660129"
Date: Thu, 28 Apr 2011 08:33:04 -0700
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, lwn@lwn.net, stable@kernel.org
Subject: [ANNOUNCE] The 2.6.35.13 longterm Linux kernel is released
Message-ID: <20110428153304.GA13806@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new longterm 2.6.35.13 Linux kernel is released. This release
contains security fixes and all 2.6.35 users are encouraged to update.
Thanks to all contributors.

-Andi


Full tarball
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/linux-2.6.35.13.tar.gz
SHA1: 0a7f7a9abe20e897668e127cf5527168f9753986

Patch against 2.6.35:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/patch-2.6.35.13.gz
SHA1: 5198927b2c56ed631bb0f7f9b246e8ab3295dab2

Patch against 2.6.35.12
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/incr/patch-2.6.35.12-13.gz
SHA1: 0e1718603f74090854147cda3e48bdd91ace6671

Full ChangeLog against 2.6.35.12
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/ChangeLog-2.6.35.13

Git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.35.y.git

Alan Stern (1):
      USB: EHCI: unlink unused QHs when the controller is stopped

Alex Deucher (1):
      drm/radeon/kms: fix bad shift in atom iio table parser

Alex Elder (1):
      xfs: zero proper structure size for geometry calls

Alex Williamson (2):
      intel-iommu: Unlink domain from iommu
      intel-iommu: Fix get_domain_for_dev() error path

Andi Kleen (1):
      release-2.6.35.13

Andrew Vasquez (1):
      qla2xxx: Make the FC port capability mutual exclusive.

Andy Gospodarek (1):
      gro: reset skb_iif on reuse

Arjan Mels (3):
      staging: usbip: bugfixes related to kthread conversion
      staging: usbip: bugfix add number of packets for isochronous frames
      staging: usbip: bugfix for isochronous packets and optimization

Artem Bityutskiy (5):
      UBIFS: do not read flash unnecessarily
      UBIFS: fix oops on error path in read_pnode
      UBIFS: fix debugging failure in dbg_check_space_info
      UBIFS: fix oops when R/O file-system is fsync'ed
      UBIFS: fix master node recovery

Ben Hutchings (1):
      kconfig: Avoid buffer underrun in choice input

Bob Liu (1):
      ramfs: fix memleak on no-mmu arch

Boris Ostrovsky (1):
      x86, AMD: Set ARAT feature on AMD processors

Borislav Petkov (1):
      x86, microcode, AMD: Extend ucode size verification

Christian Lamparter (2):
      p54usb: IDs for two new devices
      ath: add missing regdomain pair 0x5c mapping

Christian Simon (1):
      USB: ftdi_sio: Added IDs for CTI USB Serial Devices

Chuck Ebbert (1):
      2.6.35.13 longterm review

Clemens Ladisch (1):
      ALSA: ens1371: fix Creative Ectiva support

Dan Rosenberg (7):
      xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1
      irda: validate peer name and attribute lengths
      irda: prevent heap corruption on invalid nickname
      ROSE: prevent heap corruption with bad facilities
      sound/oss: remove offset from load_patch callbacks
      irda: prevent integer underflow in IRLMP_ENUMDEVICES
      CAN: Use inode instead of kernel address for /proc file

Dmitry Torokhov (4):
      USB: fix formatting of SuperSpeed endpoints in /proc/bus/usb/devices
      USB: xhci - fix unsafe macro definitions
      USB: xhci - fix math in xhci_get_endpoint_interval()
      USB: xhci - also free streams when resetting devices

Enrico Mioso (1):
      USB: option: Add new ONDA vendor id and product id for ONDA MT825UP

Felix Fietkau (1):
      ath9k: fix a chip wakeup related crash in ath9k_start

Fry, Donald H (1):
      iwlagn: Support new 5000 microcode.

Goldwyn Rodrigues (1):
      Treat writes as new when holes span across page boundaries

Greg Kroah-Hartman (1):
      Revert "intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang"

Greg Rose (1):
      Remove extra struct page member from the buffer info structure

Haiyang Zhang (1):
      staging: hv: Fix GARP not sent after Quick Migration

Hans Rosenfeld (3):
      x86, cpu: AMD errata checking framework
      x86, cpu: Clean up AMD erratum 400 workaround
      x86, cpu: Fix regression in AMD errata checking code

Herbert Xu (1):
      gro: Reset dev pointer on reuse

J. Bruce Fields (1):
      nfsd: fix auth_domain reference leak on nlm operations

Jan Beulich (2):
      x86: Fix a bogus unwind annotation in lib/semaphore_32.S
      Input: synaptics - fix crash in synaptics_module_init()

Jan Kara (1):
      quota: Don't write quota info in dquot_commit()

Jan Kiszka (1):
      intel-iommu: Fix use after release during device attach

Jason Conti (1):
      p54: Initialize extra_len in p54_tx_80211

Jeff Layton (1):
      cifs: always do is_path_accessible check in cifs_mount

Jeff Mahoney (2):
      tioca: Fix assignment from incompatible pointer warnings
      mca.c: Fix cast from integer to pointer warning

Jiri Slaby (1):
      NET: cdc-phonet, handle empty phonet header

Joerg Roedel (2):
      x86, amd: Disable GartTlbWlkErr when BIOS forgets it
      x86, gart: Make sure GART does not map physmem above 1TB

Johan Hovold (1):
      USB: ftdi_sio: add PID for OCT DK201 docking station

John W. Linville (1):
      b43: allocate receive buffers big enough for max frame len + offset

Kees Cook (1):
      net: ax25: fix information leak to userland harder

Kulikov Vasiliy (2):
      sound: oss: midi_synth: check get_user() return value
      net: tipc: fix information leak to userland

Laurent Pinchart (1):
      uvcvideo: Fix descriptor parsing for video output devices

Li Zefan (1):
      Btrfs: Fix uninitialized root flags for subvolumes

Linus Torvalds (6):
      mm: avoid wrapping vm_pgoff in mremap()
      net: fix rds_iovec page count overflow
      next_pidmap: fix overflow condition
      proc: do proper range check on readdir offset
      Revert "TPM: Long default timeout fix"
      Revert "tpm_tis: Use timeouts returned from TPM"

Liu Yuan (1):
      block, blk-sysfs: Fix an err return path in blk_register_queue()

Lydia Wang (2):
      ALSA: hda - VIA: Add missing support for VT1718S in A-A path
      ALSA: hda - VIA: Fix stereo mixer recording no sound issue

Marc-Antoine Perennou (1):
      Bluetooth: add support for Apple MacBook Pro 8,2

Marius B. Kotsbak (1):
      USB: option: Added support for Samsung GT-B3730/GT-B3710 LTE USB modem.

Mark Brown (2):
      ASoC: Explicitly say registerless widgets have no register
      ASoC: Fix output PGA enabling in wm_hubs CODECs

Matthew Wilcox (1):
      USB: Fix unplug of device with active streams

Mel Gorman (1):
      mm: page allocator: adjust the per-cpu counter threshold when memory is low

Nelson Elhage (1):
      inet_diag: Make sure we actually run the same bytecode we audited.

Olaf Hering (1):
      staging: hv: use sync_bitops when interacting with the hypervisor

Paul Friedrich (1):
      USB: ftdi_sio: add ids for Hameg HO720 and HO730

Peter Huewe (1):
      char/tpm: Fix unitialized usage of data buffer

Phil Edworthy (1):
      2.6.35.y: Revert "SH: Add missing consts to sys_execve() declaration"

Philip A. Prindeville (1):
      atm/solos-pci: Don't include frame pseudo-header on transmit hex-dump

Phillip Lougher (1):
      Squashfs: handle corruption of directory structure

Randy Dunlap (1):
      MAINTAINERS: update STABLE BRANCH info

Ryusuke Konishi (1):
      nilfs2: fix data loss in mmap page write for hole blocks

Stanislaw Gruszka (1):
      iwlwifi: fix skb usage after free

Stefan Haberland (1):
      dasd: correct device table

Suresh Siddha (1):
      x86, mtrr, pat: Fix one cpu getting out of sync during resume

Trond Myklebust (1):
      NFS: nfs_wcc_update_inode() should set nfsi->attr_gencount

Uwe Kleine-König (1):
      serial/imx: read cts state only after acking cts change irq

Vasiliy Kulikov (13):
      Bluetooth: sco: fix information leak to userspace
      bridge: netfilter: fix information leak
      Bluetooth: bnep: fix buffer overflow
      netfilter: ip_tables: fix infoleak to userspace
      netfilter: arp_tables: fix infoleak to userspace
      netfilter: ipt_CLUSTERIP: fix buffer overflow
      ipv6: netfilter: ip6_tables: fix infoleak to userspace
      mfd: ab3100: world-writable debugfs *_priv files
      drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
      drivers/misc/ep93xx_pwm.c: world-writable sysfs files
      econet: 4 byte infoleak to the network
      video: sn9c102: world-wirtable sysfs files
      UBIFS: restrict world-writable debugfs files

Yongqiang Yang (1):
      ext4: fix credits computing for indirect mapped files

 MAINTAINERS                                |    1 -
 Makefile                                   |    2 +-
 arch/ia64/kernel/mca.c                     |    3 +-
 arch/ia64/sn/pci/tioca_provider.c          |    2 +-
 arch/sh/include/asm/syscalls_32.h          |    4 +-
 arch/x86/include/asm/msr-index.h           |    4 +
 arch/x86/include/asm/processor.h           |   19 ++++++
 arch/x86/kernel/cpu/amd.c                  |   88 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mtrr/main.c            |   20 +++++--
 arch/x86/kernel/microcode_amd.c            |   65 ++++++++++++++------
 arch/x86/kernel/pci-gart_64.c              |    9 +++-
 arch/x86/kernel/process.c                  |   39 +------------
 arch/x86/lib/semaphore_32.S                |    2 +-
 block/blk-sysfs.c                          |    4 +-
 drivers/atm/solos-pci.c                    |    9 +++-
 drivers/bluetooth/btusb.c                  |    3 +
 drivers/char/tpm/tpm.c                     |   30 ++-------
 drivers/char/tpm/tpm.h                     |    2 -
 drivers/char/tpm/tpm_tis.c                 |    4 +-
 drivers/gpu/drm/radeon/atom.c              |    6 +-
 drivers/input/mouse/synaptics.c            |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c |    6 +-
 drivers/media/video/uvc/uvc_driver.c       |    8 +++
 drivers/mfd/ab3100-core.c                  |    4 +-
 drivers/misc/ep93xx_pwm.c                  |    6 +-
 drivers/net/igbvf/igbvf.h                  |    1 -
 drivers/net/usb/cdc-phonet.c               |    9 +--
 drivers/net/wireless/ath/ath9k/main.c      |    4 +
 drivers/net/wireless/ath/regd_common.h     |    1 +
 drivers/net/wireless/b43/dma.c             |    2 +-
 drivers/net/wireless/b43/dma.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |    7 ++-
 drivers/net/wireless/p54/p54usb.c          |    2 +
 drivers/net/wireless/p54/txrx.c            |    2 +-
 drivers/pci/intel-iommu.c                  |   17 +++++-
 drivers/pci/quirks.c                       |   20 ------
 drivers/rtc/rtc-ds1511.c                   |    2 +-
 drivers/s390/block/dasd_eckd.c             |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c             |    4 +-
 drivers/serial/imx.c                       |    3 +-
 drivers/staging/hv/channel.c               |    8 +-
 drivers/staging/hv/connection.c            |    6 +-
 drivers/staging/hv/netvsc_drv.c            |   24 ++++++++
 drivers/staging/hv/vmbus.c                 |    2 +-
 drivers/staging/hv/vmbus_private.h         |    1 +
 drivers/staging/usbip/stub_rx.c            |   40 +++++--------
 drivers/staging/usbip/stub_tx.c            |   74 +++++++++++++++++++-----
 drivers/staging/usbip/usbip_common.c       |   64 ++++++++++++++++++++-
 drivers/staging/usbip/usbip_common.h       |    2 +
 drivers/staging/usbip/vhci_rx.c            |    3 +
 drivers/usb/core/devices.c                 |   10 ++-
 drivers/usb/core/hcd.c                     |    2 +-
 drivers/usb/host/ehci-q.c                  |   15 +++--
 drivers/usb/host/xhci-mem.c                |   83 ++++++++++++++++++--------
 drivers/usb/host/xhci.c                    |   16 ++++-
 drivers/usb/host/xhci.h                    |    6 +-
 drivers/usb/serial/ftdi_sio.c              |    5 ++
 drivers/usb/serial/ftdi_sio_ids.h          |   12 ++++
 drivers/usb/serial/option.c                |   12 ++++
 fs/btrfs/ctree.h                           |    4 +
 fs/btrfs/disk-io.c                         |    4 +-
 fs/btrfs/ioctl.c                           |    4 +
 fs/btrfs/root-tree.c                       |   18 ++++++
 fs/btrfs/transaction.c                     |    1 +
 fs/cifs/connect.c                          |    2 +-
 fs/ext4/inode.c                            |   11 ++--
 fs/nfs/inode.c                             |   26 +++++---
 fs/nfsd/lockd.c                            |    1 -
 fs/nilfs2/file.c                           |   12 ++--
 fs/ocfs2/aops.c                            |    6 ++
 fs/proc/base.c                             |    9 ++-
 fs/quota/dquot.c                           |   13 +---
 fs/ramfs/file-nommu.c                      |    1 +
 fs/squashfs/dir.c                          |    9 +++
 fs/squashfs/namei.c                        |   12 ++++
 fs/ubifs/commit.c                          |    2 +-
 fs/ubifs/debug.c                           |   47 ++++++++++++---
 fs/ubifs/file.c                            |    3 +
 fs/ubifs/lpt.c                             |    7 +-
 fs/ubifs/recovery.c                        |   26 ++++++++
 fs/xfs/linux-2.6/xfs_ioctl.c               |   11 +++-
 fs/xfs/xfs_fsops.c                         |    3 +
 include/linux/mmzone.h                     |   10 +--
 include/linux/pid.h                        |    2 +-
 include/linux/vmstat.h                     |    5 ++
 include/net/netlink.h                      |    2 +-
 include/sound/soc-dapm.h                   |   16 +++---
 kernel/pid.c                               |    5 +-
 mm/mmzone.c                                |   21 -------
 mm/mremap.c                                |   11 +++-
 mm/page_alloc.c                            |   35 +++++++++---
 mm/vmscan.c                                |   25 +++++----
 mm/vmstat.c                                |   68 +++++++++++++++++++++-
 net/ax25/af_ax25.c                         |    2 +-
 net/bluetooth/bnep/sock.c                  |    1 +
 net/bluetooth/sco.c                        |    1 +
 net/bridge/netfilter/ebtables.c            |    2 +
 net/can/bcm.c                              |    4 +-
 net/core/dev.c                             |    2 +
 net/econet/af_econet.c                     |    2 +-
 net/ipv4/inet_diag.c                       |   27 +++++----
 net/ipv4/netfilter/arp_tables.c            |    3 +
 net/ipv4/netfilter/ip_tables.c             |    3 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c         |    5 +-
 net/ipv6/netfilter/ip6_tables.c            |    3 +
 net/irda/af_irda.c                         |   16 +++--
 net/irda/iriap.c                           |    6 ++
 net/irda/irnet/irnet_ppp.c                 |    3 +
 net/netlink/af_netlink.c                   |   14 +---
 net/rds/rdma.c                             |   11 ++++
 net/rose/rose_subr.c                       |   18 +++++-
 net/tipc/socket.c                          |    1 +
 scripts/kconfig/conf.c                     |    2 +-
 sound/oss/dev_table.h                      |    2 +-
 sound/oss/midi_synth.c                     |   34 +++++------
 sound/oss/midi_synth.h                     |    2 +-
 sound/oss/opl3.c                           |    8 +--
 sound/oss/sequencer.c                      |    2 +-
 sound/pci/ens1370.c                        |   23 ++++++-
 sound/pci/hda/patch_via.c                  |   14 ++++-
 sound/soc/codecs/wm_hubs.c                 |    8 +-
 122 files changed, 1029 insertions(+), 429 deletions(-)
-- 
ak@linux.intel.com -- Speaking for myself only
