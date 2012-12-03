Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab2LCVxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:53:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2LCVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 16:53:32 -0500
Date: Mon, 3 Dec 2012 13:53:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.6.9
Message-ID: <20121203215327.GA2223@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.6.9 kernel.

All users of the 3.6 kernel series must upgrade.

The updated 3.6.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.6.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/dvb/get_dvb_firmware              |    2=20
 Makefile                                        |    2=20
 arch/parisc/kernel/signal32.c                   |    6 -
 arch/parisc/kernel/sys_parisc.c                 |    2=20
 arch/powerpc/platforms/pseries/eeh_driver.c     |   95 +++++++++++++++-----
 arch/sparc/kernel/signal_64.c                   |    4=20
 arch/x86/boot/compressed/eboot.c                |    2=20
 arch/x86/include/asm/ptrace.h                   |   15 ---
 arch/x86/kernel/microcode_amd.c                 |    4=20
 arch/x86/kernel/ptrace.c                        |   30 ++++++
 arch/x86/kvm/cpuid.h                            |    3=20
 arch/x86/kvm/x86.c                              |    3=20
 block/blk-exec.c                                |    8 +
 drivers/ata/sata_svw.c                          |   35 +++++++
 drivers/base/power/qos.c                        |    2=20
 drivers/gpu/drm/radeon/radeon_agp.c             |    5 -
 drivers/hid/hid-ids.h                           |    3=20
 drivers/hid/usbhid/hid-quirks.c                 |    1=20
 drivers/isdn/gigaset/bas-gigaset.c              |   19 +++-
 drivers/md/dm.c                                 |    8 +
 drivers/md/md.c                                 |   11 +-
 drivers/md/raid10.c                             |  112 ++++++++++++-------=
-----
 drivers/mmc/host/sdhci-s3c.c                    |    2=20
 drivers/mtd/devices/slram.c                     |    2=20
 drivers/mtd/ofpart.c                            |    2=20
 drivers/net/can/usb/peak_usb/pcan_usb.c         |    8 +
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c     |    8 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c |    1=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h   |    1=20
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |   14 +++
 drivers/net/wireless/iwlwifi/pcie/tx.c          |    8 -
 drivers/net/wireless/mwifiex/cmdevt.c           |   11 +-
 drivers/net/wireless/mwifiex/sdio.c             |   11 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c     |    1=20
 drivers/nfc/pn533.c                             |   22 ++--
 drivers/scsi/isci/request.c                     |    2=20
 fs/ext4/resize.c                                |    2=20
 fs/fs-writeback.c                               |    2=20
 fs/inode.c                                      |   16 +++
 fs/internal.h                                   |    1=20
 fs/jbd/transaction.c                            |    2=20
 fs/jffs2/file.c                                 |   39 ++++----
 fs/pstore/ram.c                                 |    2=20
 include/drm/drm_pciids.h                        |    1=20
 kernel/futex.c                                  |   18 +++
 kernel/watchdog.c                               |    4=20
 lib/mpi/longlong.h                              |   19 +++-
 mm/vmscan.c                                     |   37 +++++--
 net/can/bcm.c                                   |    3=20
 net/core/net-sysfs.c                            |   20 ++++
 net/mac80211/ibss.c                             |    8 -
 net/nfc/llcp/llcp.c                             |    2=20
 sound/pci/hda/patch_cirrus.c                    |    1=20
 sound/pci/hda/patch_realtek.c                   |    4=20
 sound/usb/midi.c                                |    8 +
 56 files changed, 472 insertions(+), 184 deletions(-)

Al Viro (2):
      PARISC: fix user-triggerable panic on parisc
      sparc64: not any error from do_sigaltstack() should fail rt_sigreturn=
()

Albert Pool (1):
      rtlwifi: rtl8192cu: Add new USB ID

Alex Deucher (1):
      drm/radeon: add new SI pci id

Bing Zhao (2):
      mwifiex: report error to MMC core if we cannot suspend
      mwifiex: fix system hang issue in cmd timeout error case

Boris Ostrovsky (1):
      x86, microcode, AMD: Add support for family 16h processors

Chuansheng Liu (1):
      watchdog: using u64 in get_sample_period()

Clemens Ladisch (1):
      ALSA: ua101, usx2y: fix broken MIDI output

Darren Hart (1):
      futex: avoid wake_futex() for a PI futex_q

David Henningsson (2):
      ALSA: hda - Cirrus: Correctly clear line_out_pins when moving to spea=
ker
      ALSA: hda - Add support for Realtek ALC292

David Milburn (1):
      sata_svw: check DMA start bit before reset

Duncan Roe (1):
      ALSA: hda - Fix missing beep on ASUS X43U notebook

Emmanuel Grumbach (1):
      iwlwifi: don't WARN when a non empty queue is disabled

Gavin Shan (1):
      powerpc/eeh: Lock module while handling EEH event

Greg Kroah-Hartman (1):
      Linux 3.6.9

Guennadi Liakhovetski (1):
      PM / QoS: fix wrong error-checking condition

H. Peter Anvin (1):
      x86-32: Export kernel_stack_pointer() for modules

Jaehoon Chung (1):
      mmc: sdhci-s3c: fix the wrong number of max bus clocks

James Bottomley (1):
      PARISC: fix virtual aliasing issue in get_shared_area()

Jan Kara (2):
      jbd: Fix lock ordering bug in journal_unmap_buffer()
      writeback: put unused inodes to LRU after writeback completion

Jens Axboe (1):
      dm: fix deadlock with request based dm and queue request_fn recursion

Jiri Engelthaler (1):
      mtd: slram: invalid checking of absolute end address

Johannes Berg (2):
      wireless: add back sysfs directory
      iwlwifi: fix monitor mode FCS flag

Kailang Yang (1):
      ALSA: hda - Add new codec ALC283 ALC290 support

Maciej Patelczyk (1):
      SCSI: isci: copy fis 0x34 response into proper buffer

Manuel Lauss (1):
      MPI: Fix compilation on MIPS with GCC 4.4 and newer

Marek Vasut (1):
      HID: add quirk for Freescale i.MX28 ROM recovery

Matt Fleming (1):
      x86, efi: Fix processor-specific memcpy() build error

Mauro Carvalho Chehab (1):
      get_dvb_firmware: fix download site for tda10046 firmware

Mel Gorman (1):
      mm: vmscan: check for fatal signals iff the process was throttled

NeilBrown (2):
      md/raid10: decrement correct pending counter when writing to replacem=
ent.
      md/raid10: close race that lose writes lost when replacement complete=
s.

Oliver Hartkopp (2):
      can: peak_usb: fix hwtstamp assignment
      can: bcm: initialize ifindex for timeouts without previous frame rece=
ption

Paul Bolle (1):
      radeon: add AGPMode 1 quirk for RV250

Petr Matousek (1):
      KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set (CVE-=
2012-4461)

Randy Dunlap (1):
      pstore/ram: Fix printk format warning

Robert Richter (1):
      x86-32: Fix invalid stack address while in softirq

Roland Dreier (1):
      block: Don't access request after it might be freed

Sachin Kamat (1):
      mtd: ofpart: Fix incorrect NULL check in parse_ofoldpart_partitions()

Simon Wunderlich (1):
      mac80211: deinitialize ibss-internals after emptiness check

Szymon Janc (1):
      NFC: pn533: Fix use after free

Tao Ma (1):
      ext4: remove erroneous ext4_superblock_csum_set() in update_backups()

Thierry Escande (2):
      NFC: Fix pn533 target mode memory leak
      NFC: Fix nfc_llcp_local chained list insertion

Thomas Betker (1):
      jffs2: Fix lock acquisition order bug in jffs2_write_begin

Tilman Schmidt (1):
      bas_gigaset: fix pre_reset handling

Waldemar Rymarkiewicz (1):
      NFC: pn533: Fix mem leak in pn533_in_dep_link_up

joshua.a.hay@intel.com (1):
      ixgbe: add support for X540-AT1

majianpeng (2):
      md: Reassigned the parameters if read_seqretry returned true in func =
md_is_badblock.
      md: Avoid write invalid address if read_seqretry returned true.


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQvR9XAAoJEDjbvchgkmk+w7UP/255kv6+HoxeBrjVgGV1NY7w
0s7ubF7paNDKDH5agebrSJeXb11CrNqxArhwvJtyIgOSTBZTomY2AIA9uZtHxkgX
DRwBpv20H2xpJXAdNykvx/cg2sRtf5FA6K1UX/UQGYkhK5RC/06zSbmUiOU2a6tj
aMcFwPx1jN8DUcRf5RMtPIITFo5bHqamffjukKHwRcTuoB66S7MJ28T50FOIEjLO
YmjuW+Uqxg72j6HBcjQhBq22d4/7R6PgXdPKuiPQMqy8JQYsyVhN8b2/LcQ/cJ9p
keHRiDBIv0tlk4nv+CvOkcBZe10BFnjE+CIoJXp+8rPGxDbYzU9k3RP6Zpuk2AsY
8vj6GGoW5w+DBqtvKjFgAtsPfEunXO0h+gowB6aZf0iHflsGRFoQqhBl2t/ijHZ+
iRt/J5yOGPLPqmoNkFC9epgMnFSR0mw/edOKmbPHNyyikJnk9dLJAhHZBYJP2y3S
QTx7DIcjnwQiMx8wHB1VMNkfKwtz0qgnrt0bhypDWixqH1Z4mkJqrsofVPvlIDSp
CM6LPLMdAbcb980h71YGIsgXX0xBO2QquEzdpFVz2WrB8osQW0s0iRaIZ8EKb6BF
kXE8wOIy8FAdkAD0jz4mI4BiAh/CR+mlZ5ZtrB5ulB2QiFQ4OnfJFIqpkRY3/fgg
Ya2Cj32eZhOww3Ex4uST
=cIFY
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
