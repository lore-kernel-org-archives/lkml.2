Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1DOQuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:50:21 -0400
Received: from kroah.org ([198.145.64.141]:50298 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1DOQuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:50:18 -0400
Date: Fri, 15 Apr 2011 09:49:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.37
Message-ID: <20110415164914.GA10357@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.37 kernel.

All users of the 2.6.32 series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/powerpc/kernel/crash.c           |    4 +
 arch/x86/kernel/cpu/mtrr/main.c       |   20 ++++++---
 arch/x86/kernel/head64.c              |    3 +
 arch/x86/kernel/microcode_amd.c       |   72 ++++++++++++++++++++-------------
 arch/x86/kernel/setup.c               |    5 --
 arch/x86/mm/init.c                    |   19 ++++++++
 arch/x86/mm/init_64.c                 |   11 ++---
 drivers/atm/solos-pci.c               |    9 +++-
 drivers/block/cciss.h                 |    1 
 drivers/bluetooth/btusb.c             |    3 +
 drivers/char/tpm/tpm.c                |    2 
 drivers/mfd/ab3100-core.c             |    4 -
 drivers/misc/ep93xx_pwm.c             |    6 +-
 drivers/net/myri10ge/myri10ge.c       |    1 
 drivers/net/wireless/ath/ath9k/main.c |    4 +
 drivers/net/wireless/b43/dma.c        |    2 
 drivers/net/wireless/b43/dma.h        |    2 
 drivers/net/wireless/p54/p54usb.c     |    2 
 drivers/rtc/rtc-ds1511.c              |    2 
 drivers/scsi/ses.c                    |    4 -
 drivers/staging/hv/Channel.c          |    8 +--
 drivers/staging/hv/Connection.c       |    6 +-
 drivers/staging/hv/Vmbus.c            |    2 
 drivers/staging/hv/VmbusPrivate.h     |    1 
 drivers/staging/hv/netvsc_drv.c       |   24 +++++++++++
 drivers/staging/usbip/stub_rx.c       |   40 ++++++------------
 drivers/staging/usbip/stub_tx.c       |   74 +++++++++++++++++++++++++++-------
 drivers/staging/usbip/usbip_common.c  |   64 ++++++++++++++++++++++++++++-
 drivers/staging/usbip/usbip_common.h  |    2 
 drivers/staging/usbip/vhci_rx.c       |    3 +
 fs/btrfs/ctree.h                      |    4 +
 fs/btrfs/disk-io.c                    |    4 +
 fs/btrfs/ioctl.c                      |    4 +
 fs/btrfs/root-tree.c                  |   18 ++++++++
 fs/btrfs/transaction.c                |    1 
 fs/compat.c                           |   28 ++++++------
 fs/ecryptfs/keystore.c                |    1 
 fs/ecryptfs/mmap.c                    |    5 ++
 fs/exec.c                             |   32 ++++++++++++--
 fs/ext4/inode.c                       |   11 ++---
 fs/nfsd/lockd.c                       |    1 
 fs/nilfs2/file.c                      |   12 ++---
 fs/ocfs2/aops.c                       |    6 ++
 fs/quota/dquot.c                      |   13 +----
 fs/squashfs/dir.c                     |    9 ++++
 fs/squashfs/namei.c                   |   12 +++++
 fs/ubifs/commit.c                     |    2 
 fs/ubifs/debug.c                      |   41 ++++++++++++++++--
 fs/ubifs/lpt.c                        |    7 +--
 fs/xfs/linux-2.6/xfs_ioctl.c          |   11 +++--
 fs/xfs/xfs_fsops.c                    |    3 +
 include/linux/binfmts.h               |    5 ++
 include/scsi/scsi_device.h            |    2 
 include/sound/soc-dapm.h              |   16 +++----
 kernel/kgdb.c                         |    9 +---
 kernel/perf_event.c                   |    3 -
 kernel/signal.c                       |    4 -
 mm/mremap.c                           |   11 ++++-
 net/ax25/af_ax25.c                    |    2 
 net/bluetooth/bnep/sock.c             |    1 
 net/bluetooth/sco.c                   |    1 
 net/bridge/netfilter/ebtables.c       |    2 
 net/can/bcm.c                         |    4 -
 net/core/dev.c                        |    2 
 net/econet/af_econet.c                |    8 ++-
 net/ipv4/inet_diag.c                  |   27 +++++++-----
 net/ipv4/netfilter/arp_tables.c       |    3 +
 net/ipv4/netfilter/ip_tables.c        |    3 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c    |    5 +-
 net/ipv6/netfilter/ip6_tables.c       |    3 +
 net/irda/af_irda.c                    |   16 ++++---
 net/irda/iriap.c                      |    6 ++
 net/irda/irnet/irnet_ppp.c            |    3 +
 net/mac80211/sta_info.c               |    1 
 net/packet/af_packet.c                |    3 -
 net/rds/rdma.c                        |    8 +++
 net/rose/rose_subr.c                  |   18 +++++++-
 net/sctp/sm_make_chunk.c              |   17 ++++---
 net/tipc/socket.c                     |    1 
 sound/core/init.c                     |    4 +
 sound/oss/dev_table.h                 |    2 
 sound/oss/midi_synth.c                |   34 +++++++--------
 sound/oss/midi_synth.h                |    2 
 sound/oss/opl3.c                      |   23 ++++++----
 sound/oss/sequencer.c                 |    2 
 sound/pci/ens1370.c                   |   23 ++++++++--
 sound/pci/hda/patch_realtek.c         |    2 
 88 files changed, 659 insertions(+), 244 deletions(-)

Alex Elder (1):
      xfs: zero proper structure size for geometry calls

Andreas Herrmann (1):
      x86, amd-ucode: Remove needless log messages

Andy Gospodarek (1):
      gro: reset skb_iif on reuse

Arjan Mels (3):
      staging: usbip: bugfixes related to kthread conversion
      staging: usbip: bugfix add number of packets for isochronous frames
      staging: usbip: bugfix for isochronous packets and optimization

Artem Bityutskiy (3):
      UBIFS: do not read flash unnecessarily
      UBIFS: fix oops on error path in read_pnode
      UBIFS: fix debugging failure in dbg_check_space_info

Borislav Petkov (1):
      x86, microcode, AMD: Extend ucode size verification

Bud Brown (1):
      cciss: fix lost command issue

Christian Lamparter (1):
      p54usb: IDs for two new devices

Clemens Ladisch (1):
      ALSA: ens1371: fix Creative Ectiva support

Dan Rosenberg (8):
      sound/oss/opl3: validate voice and channel indexes
      xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1
      irda: validate peer name and attribute lengths
      irda: prevent heap corruption on invalid nickname
      ROSE: prevent heap corruption with bad facilities
      sound/oss: remove offset from load_patch callbacks
      irda: prevent integer underflow in IRLMP_ENUMDEVICES
      CAN: Use inode instead of kernel address for /proc file

David S. Miller (1):
      econet: Fix crash in aun_incoming().

Felix Fietkau (2):
      mac80211: initialize sta->last_rx in sta_info_alloc
      ath9k: fix a chip wakeup related crash in ath9k_start

Frederic Weisbecker (1):
      perf: Better fit max unprivileged mlock pages for tools needs

Goldwyn Rodrigues (1):
      Treat writes as new when holes span across page boundaries

Greg Kroah-Hartman (2):
      Revert "x86: Cleanup highmap after brk is concluded"
      Linux 2.6.32.37

Haiyang Zhang (1):
      staging: hv: Fix GARP not sent after Quick Migration

Herbert Xu (1):
      gro: Reset dev pointer on reuse

J. Bruce Fields (1):
      nfsd: fix auth_domain reference leak on nlm operations

Jan Kara (1):
      quota: Don't write quota info in dquot_commit()

Jason Wessel (1):
      repair gdbstub to match the gdbserial protocol specification

John Hughes (1):
      ses: show devices for enclosures with no page 7

John W. Linville (1):
      b43: allocate receive buffers big enough for max frame len + offset

Kamalesh Babulal (2):
      powerpc/kexec: Add ifdef CONFIG_PPC_STD_MMU_64 to PPC64 code
      powerpc: Fix default_machine_crash_shutdown #ifdef botch

Krishnasamy, Somasundaram (1):
      ses: Avoid kernel panic when lun 0 is not mapped

Kulikov Vasiliy (2):
      sound: oss: midi_synth: check get_user() return value
      net: tipc: fix information leak to userland

Li Zefan (1):
      Btrfs: Fix uninitialized root flags for subvolumes

Linus Torvalds (2):
      mm: avoid wrapping vm_pgoff in mremap()
      net: fix rds_iovec page count overflow

Marc-Antoine Perennou (1):
      Bluetooth: add support for Apple MacBook Pro 8,2

Mark Brown (1):
      ASoC: Explicitly say registerless widgets have no register

Nelson Elhage (1):
      inet_diag: Make sure we actually run the same bytecode we audited.

Olaf Hering (1):
      staging: hv: use sync_bitops when interacting with the hypervisor

Oleg Nesterov (2):
      exec: make argv/envp memory visible to oom-killer
      exec: copy-and-paste the fixes into compat_do_execve() paths

Peter Huewe (1):
      char/tpm: Fix unitialized usage of data buffer

Philip A. Prindeville (1):
      atm/solos-pci: Don't include frame pseudo-header on transmit hex-dump

Phillip Lougher (1):
      Squashfs: handle corruption of directory structure

Roberto Sassu (1):
      eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix

Roland Dreier (1):
      Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo

Ryusuke Konishi (1):
      nilfs2: fix data loss in mmap page write for hole blocks

Stanislaw Gruszka (1):
      myri10ge: fix rmmod crash

Suresh Siddha (1):
      x86, mtrr, pat: Fix one cpu getting out of sync during resume

Takashi Iwai (2):
      ALSA: hda - Fix SPDIF out regression on ALC889
      ALSA: Fix yet another race in disconnection

Tyler Hicks (1):
      eCryptfs: Unlock page in write_begin error path

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
      net: ax25: fix information leak to userland
      net: packet: fix information leak to userland

Wei Yongjun (1):
      sctp: fix to calc the INIT/INIT-ACK chunk length correctly is set

Yongqiang Yang (1):
      ext4: fix credits computing for indirect mapped files

