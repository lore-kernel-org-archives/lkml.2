Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1H2VA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:00:27 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51315 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743Ab1H2VAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:00:25 -0400
X-Sasl-enc: 5VDlrpq2qx/OO7ivRz5ZJMhOXNk7nGyzH7d6ArC3FmQW 1314651624
Date: Mon, 29 Aug 2011 13:59:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.4
Message-ID: <20110829205949.GA19245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 3.0.4 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-3.0.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-3.0.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 -
 arch/x86/include/asm/xen/page.h            |    4 +--
 arch/x86/kernel/apic/x2apic_uv_x.c         |    1 
 arch/x86/kernel/cpu/intel.c                |   10 +++----
 arch/x86/kernel/cpu/mtrr/main.c            |   23 +++++++++++++++++
 arch/x86/platform/olpc/olpc.c              |    4 +--
 arch/x86/vdso/vdso32/sysenter.S            |    2 -
 arch/x86/xen/enlighten.c                   |    4 +--
 arch/x86/xen/mmu.c                         |   12 ++++++---
 arch/x86/xen/smp.c                         |    4 +--
 drivers/block/loop.c                       |    6 +++-
 drivers/block/xen-blkfront.c               |    6 ++--
 drivers/edac/i7core_edac.c                 |    2 -
 drivers/gpu/drm/radeon/radeon_connectors.c |   10 +++++++
 drivers/gpu/drm/ttm/ttm_bo.c               |    4 ++-
 drivers/mmc/host/sdhci.c                   |    3 --
 drivers/net/igb/e1000_82575.c              |    1 
 drivers/net/wireless/rt2x00/rt2x00usb.c    |   17 +++++-------
 fs/befs/linuxvfs.c                         |   23 ++++++++++-------
 fs/btrfs/extent-tree.c                     |   12 +++++++--
 fs/btrfs/tree-log.c                        |   28 ++++++++++++++++++---
 fs/btrfs/volumes.c                         |   17 ++++++++++++
 fs/btrfs/volumes.h                         |    2 +
 fs/cifs/connect.c                          |    3 +-
 fs/cifs/dir.c                              |    4 +--
 fs/ext4/ext4_jbd2.h                        |    4 +--
 fs/ext4/inode.c                            |   26 ++++++++++++++++++-
 fs/ext4/page-io.c                          |    6 +++-
 fs/ext4/super.c                            |    1 
 fs/fuse/dev.c                              |    4 +++
 fs/nfs/callback.h                          |    2 -
 fs/nfs/callback_proc.c                     |   25 ++++++++++++++-----
 fs/nfs/callback_xdr.c                      |   24 +++++-------------
 fs/nfs/objlayout/objio_osd.c               |   28 +++++++++------------
 fs/nfs/objlayout/pnfs_osd_xdr_cli.c        |    3 ++
 include/linux/personality.h                |    1 
 include/linux/stop_machine.h               |    2 +
 kernel/irq/generic-chip.c                  |    4 +--
 kernel/stop_machine.c                      |    2 -
 kernel/sys.c                               |   38 +++++++++++++++++++++++++++++
 sound/pci/ac97/ac97_patch.c                |    1 
 sound/usb/caiaq/audio.c                    |   31 ++++++++++++++++++++---
 sound/usb/caiaq/device.h                   |    1 
 sound/usb/mixer.c                          |    3 +-
 44 files changed, 297 insertions(+), 113 deletions(-)

Aaron Lu (1):
      mmc: sdhci: fix retuning timer wrongly deleted in sdhci_tasklet_finish

Andi Kleen (1):
      Add a personality to report 2.6.x version numbers

Boaz Harrosh (2):
      pnfs-obj: Fix the comp_index != 0 case
      pnfs-obj: Bug when we are running out of bio

Carolyn Wyborny (1):
      igb: Fix lack of flush after register write and before delay

Curt Wohlgemuth (1):
      ext4: Fix ext4_should_writeback_data() for no-journal mode

Daniel Mack (1):
      ALSA: snd_usb_caiaq: track submitted output urbs

Daniel T Chen (1):
      ALSA: ac97: Add HP Compaq dc5100 SFF(PT003AW) to Headphone Jack Sense whitelist

Greg Kroah-Hartman (1):
      Linux 3.0.4

H. Peter Anvin (1):
      x86-32, vdso: On system call restart after SYSENTER, use int $0x80

Jack Steiner (1):
      x86, UV: Remove UV delay in starting slave cpus

Jan Beulich (1):
      xen/x86: replace order-based range checking of M2P table by linear one

Jeff Layton (1):
      cifs: demote cERROR in build_path_from_dentry to cFYI

Jiaying Zhang (1):
      ext4: call ext4_ioend_wait and ext4_flush_completed_IO in ext4_evict_inode

Josef Bacik (1):
      Btrfs: detect wether a device supports discard

Kay Sievers (1):
      loop: fix deadlock when sysfs and LOOP_CLR_FD race against each other

Len Brown (1):
      x86, intel, power: Correct the MSR_IA32_ENERGY_PERF_BIAS message

Marcin Slusarz (1):
      drm/ttm: fix ttm_bo_add_ttm(user) failure path

Mathias Krause (1):
      i7core_edac: fixed typo in error count calculation

Miklos Szeredi (1):
      fuse: check size of FUSE_NOTIFY_INVAL_ENTRY message

Paul Fox (1):
      x86, olpc: Wait for last byte of EC command to be accepted

Stanislaw Gruszka (1):
      rt2x00: fix order of entry flags modification

Stefan Bader (2):
      xen-blkfront: Drop name and minor adjustments for emulated scsi devices
      xen-blkfront: Fix one off warning about name clash

Stefano Stabellini (1):
      xen: Do not enable PV IPIs when vector callback not present

Steve French (1):
      possible memory corruption on mount

Suresh Siddha (1):
      x86, mtrr: lock stop machine during MTRR rendezvous sequence

Takashi Iwai (1):
      ALSA: usb-audio - Fix missing mixer dB information

Tao Ma (1):
      ext4: Resolve the hang of direct i/o read in handling EXT4_IO_END_UNWRITTEN.

Theodore Ts'o (1):
      ext4: fix nomblk_io_submit option so it correctly converts uninit blocks

Thomas Reim (1):
      drm/radeon: Extended DDC Probing for Toshiba L300D Radeon Mobility X1100 HDMI-A Connector

Timo Warns (1):
      befs: Validate length of long symbolic links.

Trond Myklebust (2):
      NFSv4.1: Fix the callback 'highest_used_slotid' behaviour
      NFSv4.1: Return NFS4ERR_BADSESSION to callbacks during session resets

jhbird.choi@samsung.com (1):
      genirq: Fix wrong bit operation

liubo (1):
      Btrfs: fix an oops of log replay

