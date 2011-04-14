Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab1DNU0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:26:31 -0400
Received: from kroah.org ([198.145.64.141]:53660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1DNU01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:26:27 -0400
Date: Thu, 14 Apr 2011 13:25:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.38.3
Message-ID: <20110414202559.GA10634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.38.3 kernel.

All users of the 2.6.38 kernel series must upgrade.

The updated 2.6.38.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.38.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/powerpc/kernel/time.c                |    2 
 arch/x86/crypto/aesni-intel_asm.S         |    5 +
 arch/x86/crypto/aesni-intel_glue.c        |   14 ++++
 arch/x86/kernel/cpu/mtrr/main.c           |   20 +++++-
 arch/x86/kernel/head64.c                  |    3 +
 arch/x86/kernel/setup.c                   |    5 -
 arch/x86/mm/init.c                        |   19 ++++++
 arch/x86/mm/init_64.c                     |   11 +--
 drivers/acpi/pci_root.c                   |    2 
 drivers/atm/solos-pci.c                   |   35 +++--------
 drivers/block/cciss.h                     |    1 
 drivers/bluetooth/btusb.c                 |    3 +
 drivers/char/tpm/tpm.c                    |    2 
 drivers/edac/amd64_edac.c                 |    2 
 drivers/gpu/drm/radeon/radeon_atombios.c  |   13 ++--
 drivers/hid/hid-magicmouse.c              |    2 
 drivers/input/mouse/synaptics.c           |    4 -
 drivers/leds/leds-lp5521.c                |   14 ++--
 drivers/leds/leds-lp5523.c                |   20 +++---
 drivers/media/radio/Kconfig               |    1 
 drivers/media/video/tlg2300/pd-video.c    |    4 -
 drivers/mfd/ab3100-core.c                 |    4 -
 drivers/mfd/ab3550-core.c                 |    6 +-
 drivers/mfd/ab8500-debugfs.c              |    6 +-
 drivers/misc/ep93xx_pwm.c                 |    6 +-
 drivers/net/myri10ge/myri10ge.c           |    1 
 drivers/net/netxen/netxen_nic_ethtool.c   |    2 
 drivers/net/qlcnic/qlcnic_ethtool.c       |    2 
 drivers/net/s2io.c                        |    2 
 drivers/net/vmxnet3/vmxnet3_ethtool.c     |    4 -
 drivers/net/vxge/vxge-ethtool.c           |    4 -
 drivers/net/wireless/ath/ath9k/main.c     |    4 +
 drivers/net/wireless/ath/ath9k/xmit.c     |    4 -
 drivers/net/wireless/b43/dma.c            |    2 
 drivers/net/wireless/b43/dma.h            |    2 
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    2 
 drivers/net/wireless/p54/p54usb.c         |    2 
 drivers/net/wireless/rt2x00/rt2800lib.c   |    6 --
 drivers/net/wireless/rt2x00/rt2800pci.c   |   36 +++---------
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    6 +-
 drivers/net/wireless/wl12xx/testmode.c    |    5 +
 drivers/pci/pcie/aspm.c                   |    7 ++
 drivers/platform/x86/acer-wmi.c           |   19 ++++--
 drivers/rtc/rtc-ds1511.c                  |    2 
 drivers/scsi/scsi_transport_iscsi.c       |    2 
 drivers/scsi/ses.c                        |    4 -
 drivers/staging/hv/channel.c              |    8 +-
 drivers/staging/hv/connection.c           |    4 -
 drivers/staging/hv/netvsc_drv.c           |   24 ++++++++
 drivers/staging/hv/vmbus_drv.c            |    2 
 drivers/staging/hv/vmbus_private.h        |    1 
 drivers/staging/iio/imu/adis16400.h       |    3 -
 drivers/staging/iio/imu/adis16400_core.c  |   12 +---
 drivers/staging/iio/imu/adis16400_ring.c  |   12 ++--
 drivers/staging/usbip/stub_rx.c           |   40 +++++--------
 drivers/staging/usbip/stub_tx.c           |   74 ++++++++++++++++++++----
 drivers/staging/usbip/usbip_common.c      |   64 +++++++++++++++++++++
 drivers/staging/usbip/usbip_common.h      |    2 
 drivers/staging/usbip/vhci_rx.c           |    3 +
 drivers/watchdog/davinci_wdt.c            |   22 +++----
 drivers/watchdog/max63xx_wdt.c            |   20 ++----
 drivers/watchdog/pnx4008_wdt.c            |   28 ++++-----
 drivers/watchdog/s3c2410_wdt.c            |   19 ++----
 drivers/watchdog/sp5100_tco.c             |   16 ++++-
 fs/btrfs/ctree.h                          |    4 +
 fs/btrfs/disk-io.c                        |    4 +
 fs/btrfs/ioctl.c                          |    4 +
 fs/btrfs/root-tree.c                      |   18 ++++++
 fs/btrfs/transaction.c                    |    1 
 fs/ecryptfs/keystore.c                    |    1 
 fs/ecryptfs/mmap.c                        |    5 +
 fs/ext4/inode.c                           |   11 +--
 fs/ext4/super.c                           |    6 ++
 fs/nfsd/lockd.c                           |    1 
 fs/nfsd/nfs4state.c                       |    9 ++-
 fs/nilfs2/file.c                          |   11 +--
 fs/notify/inotify/inotify_fsnotify.c      |    1 
 fs/notify/inotify/inotify_user.c          |   39 ++++---------
 fs/ocfs2/aops.c                           |    6 ++
 fs/quota/dquot.c                          |   13 +---
 fs/squashfs/dir.c                         |    9 +++
 fs/squashfs/namei.c                       |   12 ++++
 fs/squashfs/zlib_wrapper.c                |    6 +-
 fs/ubifs/commit.c                         |    2 
 fs/ubifs/debug.c                          |   41 ++++++++++++-
 fs/ubifs/lpt.c                            |    7 +-
 fs/xfs/linux-2.6/xfs_super.c              |   34 ++++++++---
 include/drm/drm_pciids.h                  |    2 
 include/linux/atmdev.h                    |    1 
 include/linux/ethtool.h                   |    1 
 include/linux/pci.h                       |    7 +-
 include/scsi/scsi_device.h                |    2 
 include/sound/pcm.h                       |    4 -
 include/sound/soc-dapm.h                  |   16 ++---
 kernel/perf_event.c                       |    8 ++
 kernel/signal.c                           |    4 -
 mm/mremap.c                               |   11 +++
 net/atm/common.c                          |    1 
 net/bluetooth/bnep/sock.c                 |    1 
 net/bluetooth/sco.c                       |    1 
 net/bridge/netfilter/ebtables.c           |    2 
 net/core/ethtool.c                        |   17 +++++
 net/econet/af_econet.c                    |    2 
 net/ipv4/netfilter/arp_tables.c           |    3 +
 net/ipv4/netfilter/ip_tables.c            |    7 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c        |    5 +
 net/ipv6/netfilter/ip6_tables.c           |    7 +-
 net/irda/iriap.c                          |    6 ++
 net/irda/irnet/irnet_ppp.c                |    3 +
 net/mac80211/rc80211_minstrel_ht.c        |   25 ++++++--
 net/mac80211/sta_info.c                   |    1 
 net/netfilter/nf_conntrack_h323_asn1.c    |    2 
 net/rose/rose_subr.c                      |   18 +++++-
 net/sunrpc/auth_gss/gss_krb5_mech.c       |    2 
 sound/core/init.c                         |    4 +
 sound/core/pcm_lib.c                      |    4 +
 sound/core/pcm_native.c                   |    9 ---
 sound/oss/dev_table.h                     |    2 
 sound/oss/midi_synth.c                    |   30 ++++------
 sound/oss/midi_synth.h                    |    2 
 sound/oss/opl3.c                          |   23 +++++--
 sound/oss/sequencer.c                     |    2 
 sound/pci/ens1370.c                       |   23 ++++++-
 sound/pci/hda/patch_analog.c              |   89 ++++++++++++++++++++++++++++++
 sound/pci/hda/patch_conexant.c            |    2 
 sound/pci/hda/patch_hdmi.c                |   70 ++++++++++++++---------
 sound/pci/hda/patch_realtek.c             |    4 -
 sound/soc/imx/imx-pcm-dma-mx2.c           |    9 ++-
 sound/soc/imx/imx-ssi.h                   |    3 -
 sound/soc/pxa/corgi.c                     |    2 
 131 files changed, 913 insertions(+), 447 deletions(-)

Aaron Plattner (1):
      ALSA: hda - HDMI: Fix MCP7x audio infoframe checksums

Alex Deucher (1):
      drm/radeon/kms: add some new ontario pci ids

Alexander Strakh (1):
      drivers/media/video/tlg2300/pd-video.c: Remove second mutex_unlock in pd_vidioc_s_fmt

Anton Blanchard (1):
      powerpc: Fix accounting of softirq time when idle

Arjan Mels (3):
      staging: usbip: bugfixes related to kthread conversion
      staging: usbip: bugfix add number of packets for isochronous frames
      staging: usbip: bugfix for isochronous packets and optimization

Artem Bityutskiy (3):
      UBIFS: do not read flash unnecessarily
      UBIFS: fix oops on error path in read_pnode
      UBIFS: fix debugging failure in dbg_check_space_info

Benjamin Herrenschmidt (1):
      ALSA: vmalloc buffers should use normal mmap

Borislav Petkov (1):
      amd64_edac: Fix potential memleak

Bud Brown (1):
      cciss: fix lost command issue

Chase Douglas (1):
      HID: hid-magicmouse: Increase evdev buffer size

Christian Lamparter (1):
      p54usb: IDs for two new devices

Chun-Yi Lee (1):
      acer-wmi: does not set persistence state by rfkill_init_sw_state

Clemens Ladisch (1):
      ALSA: ens1371: fix Creative Ectiva support

Dan Rosenberg (5):
      sound/oss/opl3: validate voice and channel indexes
      irda: validate peer name and attribute lengths
      irda: prevent heap corruption on invalid nickname
      ROSE: prevent heap corruption with bad facilities
      sound/oss: remove offset from load_patch callbacks

Dave Chinner (1):
      xfs: register the inode cache shrinker before quotachecks

David Henningsson (4):
      ALSA: HDA: New AD1984A model for Dell Precision R5500
      ALSA: HDA: Add dock mic quirk for Lenovo Thinkpad X220
      ALSA: HDA: Fix dock mic for Lenovo X220-tablet
      ALSA: HDA: Fix single internal mic on ALC275 (Sony Vaio VPCSB1C5E)

David Sterba (1):
      netfilter: h323: bug in parsing of ASN1 SEQOF field

Eric Dumazet (1):
      netfilter: xtables: fix reentrancy

Eric Paris (1):
      inotify: fix double free/corruption of stuct user

Felix Fietkau (3):
      mac80211: initialize sta->last_rx in sta_info_alloc
      ath9k: fix a chip wakeup related crash in ath9k_start
      mac80211: fix a crash in minstrel_ht in HT mode with no supported MCS rates

Frederic Weisbecker (2):
      perf: Better fit max unprivileged mlock pages for tools needs
      perf: Rebase max unprivileged mlock threshold on top of page size

Goldwyn Rodrigues (1):
      Treat writes as new when holes span across page boundaries

Greg Kroah-Hartman (2):
      Revert "x86: Cleanup highmap after brk is concluded"
      Linux 2.6.38.3

Haiyang Zhang (1):
      staging: hv: Fix GARP not sent after Quick Migration

J. Bruce Fields (2):
      nfsd: fix auth_domain reference leak on nlm operations
      nfsd4: fix oops on lock failure

Jan Beulich (1):
      Input: synaptics - fix crash in synaptics_module_init()

Jan Kara (1):
      quota: Don't write quota info in dquot_commit()

John Hughes (1):
      ses: show devices for enclosures with no page 7

John Lindgren (1):
      drm/radeon/kms: add some sanity checks to obj info record parsingi (v2)

John W. Linville (2):
      iwlwifi: accept EEPROM version 0x423 for iwl6000
      b43: allocate receive buffers big enough for max frame len + offset

Julia Lawall (2):
      watchdog: s3c2410_wdt.c: Convert release_resource to release_region/release_mem_region
      watchdog: Convert release_resource to release_region/release_mem_region

Kelly Anderson (1):
      ALSA: pcm: fix infinite loop in snd_pcm_update_hw_ptr0()

Krishnasamy, Somasundaram (1):
      ses: Avoid kernel panic when lun 0 is not mapped

Li Zefan (1):
      Btrfs: Fix uninitialized root flags for subvolumes

Linus Torvalds (1):
      mm: avoid wrapping vm_pgoff in mremap()

Luciano Coelho (1):
      wl12xx: fix potential buffer overflow in testmode nvs push

Marc-Antoine Perennou (1):
      Bluetooth: add support for Apple MacBook Pro 8,2

Mark Brown (2):
      ASoC: Explicitly say registerless widgets have no register
      ASoC: Fix CODEC device name for Corgi

Michael Hennerich (4):
      staging: IIO: IMU: ADIS16400: Fix up SPI messages cs_change behavior
      staging: IIO: IMU: ADIS16400: Add delay after self test
      staging: IIO: IMU: ADIS16400: Fix addresses of GYRO and ACCEL calibration offset
      staging: IIO: IMU: ADIS16400: Make sure only enabled scan_elements are pushed into the ring

Mohammed Shafi Shajakhan (1):
      ath9k: Fix kernel panic in AR2427

Olaf Hering (1):
      staging: hv: use sync_bitops when interacting with the hypervisor

Peter Huewe (1):
      char/tpm: Fix unitialized usage of data buffer

Peter Zijlstra (1):
      perf: Fix task_struct reference leak

Philip A. Prindeville (2):
      atm/solos-pci: Don't include frame pseudo-header on transmit hex-dump
      atm/solos-pci: Don't flap VCs when carrier state changes

Phillip Lougher (2):
      Squashfs: Use vmalloc rather than kmalloc for zlib workspace
      Squashfs: handle corruption of directory structure

RA-Jay Hung (1):
      rt2x00: Fix radio off hang issue for PCIE interface

Rafael J. Wysocki (1):
      PCI/ACPI: Report ASPM support to BIOS if not disabled from command line

Randy Dunlap (1):
      media/radio/wl1273: fix build errors

Roberto Sassu (1):
      eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix

Roland Dreier (1):
      Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo

Ryusuke Konishi (1):
      nilfs2: fix data loss in mmap page write for hole blocks

Stanislaw Gruszka (3):
      myri10ge: fix rmmod crash
      net: fix ethtool->set_flags not intended -EINVAL return value
      rt2x00: fix cancelling uninitialized work

Suresh Siddha (1):
      x86, mtrr, pat: Fix one cpu getting out of sync during resume

Tadeusz Struk (1):
      crypto: aesni-intel - fixed problem with packets that are not multiple of 64bytes

Takashi Iwai (2):
      ALSA: hda - Fix SPDIF out regression on ALC889
      ALSA: Fix yet another race in disconnection

Tao Ma (1):
      ext4: fix a double free in ext4_register_li_request

Trond Myklebust (1):
      Revert "net/sunrpc: Use static const char arrays"

Tyler Hicks (1):
      eCryptfs: Unlock page in write_begin error path

Vasiliy Kulikov (16):
      Bluetooth: sco: fix information leak to userspace
      bridge: netfilter: fix information leak
      Bluetooth: bnep: fix buffer overflow
      netfilter: ip_tables: fix infoleak to userspace
      netfilter: arp_tables: fix infoleak to userspace
      netfilter: ipt_CLUSTERIP: fix buffer overflow
      ipv6: netfilter: ip6_tables: fix infoleak to userspace
      scsi_transport_iscsi: make priv_sess file writeable only by root
      mfd: ab8500: world-writable debugfs register-* files
      mfd: ab3500: world-writable debugfs register-* files
      mfd: ab3100: world-writable debugfs *_priv files
      drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
      drivers/misc/ep93xx_pwm.c: world-writable sysfs files
      drivers/leds/leds-lp5523.c: world-writable engine* sysfs files
      drivers/leds/leds-lp5521.c: world-writable sysfs engine* files
      econet: 4 byte infoleak to the network

Wolfram Sang (2):
      ASoC: imx: set watermarks for mx2-dma
      ASoC: imx: fix burstsize for DMA

Yinghai Lu (1):
      watchdog: sp5100_tco.c: Check if firmware has set correct value in tcobase.

Yongqiang Yang (1):
      ext4: fix credits computing for indirect mapped files

