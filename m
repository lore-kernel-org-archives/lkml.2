Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab2LCVyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:54:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61787 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2LCVyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 16:54:16 -0500
Date: Mon, 3 Dec 2012 13:54:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.21
Message-ID: <20121203215412.GA5178@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.21 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/dvb/get_dvb_firmware               |    2=20
 Makefile                                         |    2=20
 arch/arm/plat-omap/counter_32k.c                 |   21 +++--
 arch/parisc/kernel/signal32.c                    |    6 -
 arch/parisc/kernel/sys_parisc.c                  |    2=20
 arch/powerpc/platforms/pseries/eeh_driver.c      |   95 +++++++++++++++++-=
-----
 arch/sparc/kernel/signal_64.c                    |    4=20
 arch/x86/boot/compressed/eboot.c                 |    2=20
 arch/x86/include/asm/ptrace.h                    |   15 ---
 arch/x86/kernel/microcode_amd.c                  |    4=20
 arch/x86/kernel/ptrace.c                         |   28 ++++++
 arch/x86/kvm/cpuid.h                             |    3=20
 arch/x86/kvm/x86.c                               |    3=20
 block/scsi_ioctl.c                               |    5 -
 drivers/ata/sata_svw.c                           |   35 ++++++++
 drivers/base/power/qos.c                         |    2=20
 drivers/block/nvme.c                             |    2=20
 drivers/gpu/drm/radeon/radeon_agp.c              |    5 -
 drivers/isdn/gigaset/bas-gigaset.c               |   19 +++-
 drivers/leds/leds-lp5521.c                       |   12 +-
 drivers/md/dm.c                                  |    8 +
 drivers/md/md.c                                  |   11 +-
 drivers/md/raid10.c                              |    2=20
 drivers/mmc/host/sdhci-s3c.c                     |    2=20
 drivers/mtd/devices/slram.c                      |    2=20
 drivers/mtd/ofpart.c                             |    2=20
 drivers/net/can/usb/peak_usb/pcan_usb.c          |    8 +
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c      |    8 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c  |    1=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |    1=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h    |    1=20
 drivers/net/wireless/ipw2x00/ipw2200.c           |    2=20
 drivers/net/wireless/iwlwifi/iwl-6000.c          |   33 +++++--
 drivers/net/wireless/mwifiex/cmdevt.c            |   11 +-
 drivers/net/wireless/mwifiex/sdio.c              |   11 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c      |    1=20
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c     |    3=20
 drivers/nfc/pn533.c                              |   16 +--
 drivers/scsi/aha152x.c                           |    4=20
 drivers/scsi/isci/request.c                      |    2=20
 drivers/scsi/mvsas/mv_sas.c                      |    1=20
 drivers/usb/serial/mct_u232.c                    |   14 +--
 fs/jbd/transaction.c                             |    2=20
 fs/jffs2/file.c                                  |   39 +++++----
 fs/ubifs/dir.c                                   |    2=20
 include/drm/drm_pciids.h                         |    1=20
 kernel/futex.c                                   |   18 ++++
 kernel/time/timekeeping.c                        |    2=20
 kernel/watchdog.c                                |    4=20
 lib/mpi/longlong.h                               |   19 ++++
 net/bluetooth/l2cap_core.c                       |   14 +--
 net/can/bcm.c                                    |    3=20
 net/mac80211/ibss.c                              |    8 -
 net/nfc/llcp/llcp.c                              |    2=20
 sound/pci/hda/patch_cirrus.c                     |    1=20
 sound/pci/hda/patch_realtek.c                    |    4=20
 sound/usb/caiaq/device.c                         |    2=20
 sound/usb/midi.c                                 |    8 +
 59 files changed, 392 insertions(+), 150 deletions(-)

Al Viro (2):
      PARISC: fix user-triggerable panic on parisc
      sparc64: not any error from do_sigaltstack() should fail rt_sigreturn=
()

Albert Pool (1):
      rtlwifi: rtl8192cu: Add new USB ID

Alex Deucher (1):
      drm/radeon: add new SI pci id

Alexandre Pereira da Silva (1):
      UBIFS: fix compilation warning

Bing Zhao (2):
      mwifiex: report error to MMC core if we cannot suspend
      mwifiex: fix system hang issue in cmd timeout error case

Boris Ostrovsky (1):
      x86, microcode, AMD: Add support for family 16h processors

Chuansheng Liu (1):
      watchdog: using u64 in get_sample_period()

Clemens Ladisch (1):
      ALSA: ua101, usx2y: fix broken MIDI output

Colin Cross (1):
      ARM: OMAP: counter: add locking to read_persistent_clock

Dan Carpenter (3):
      drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
      mvsas: remove unused variable in mvs_task_exec()
      timekeeping: Cast raw_interval to u64 to avoid shift overflow

Daniel Mack (1):
      ALSA: snd-usb-caiaq: initialize card pointer

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

Gavin Shan (1):
      powerpc/eeh: Lock module while handling EEH event

Greg Kroah-Hartman (1):
      Linux 3.4.21

Guennadi Liakhovetski (1):
      PM / QoS: fix wrong error-checking condition

Jaehoon Chung (1):
      mmc: sdhci-s3c: fix the wrong number of max bus clocks

James Bottomley (1):
      PARISC: fix virtual aliasing issue in get_shared_area()

Jan Kara (2):
      jbd: Fix lock ordering bug in journal_unmap_buffer()
      scsi: Silence unnecessary warnings about ioctl to partition

Jens Axboe (1):
      dm: fix deadlock with request based dm and queue request_fn recursion

Jiri Engelthaler (1):
      mtd: slram: invalid checking of absolute end address

Johan Hovold (1):
      USB: mct_u232: fix broken close

Johannes Berg (1):
      iwlwifi: fix 6000 series channel switch command

Kailang Yang (1):
      ALSA: hda - Add new codec ALC283 ALC290 support

Keith Busch (1):
      NVMe: Fix uninitialized iod compiler warning

Krzysztof Wilczynski (1):
      scsi: aha152x: Fix sparse warning and make printing pointer address m=
ore portable.

Larry Finger (1):
      rtlwifi: rtl8192se: Fix gcc 4.7.x warning

Maciej Patelczyk (1):
      SCSI: isci: copy fis 0x34 response into proper buffer

Manuel Lauss (1):
      MPI: Fix compilation on MIPS with GCC 4.4 and newer

Matt Fleming (1):
      x86, efi: Fix processor-specific memcpy() build error

Mauro Carvalho Chehab (1):
      get_dvb_firmware: fix download site for tda10046 firmware

NeilBrown (1):
      md/raid10: decrement correct pending counter when writing to replacem=
ent.

Oliver Hartkopp (2):
      can: peak_usb: fix hwtstamp assignment
      can: bcm: initialize ifindex for timeouts without previous frame rece=
ption

Paul Bolle (1):
      radeon: add AGPMode 1 quirk for RV250

Petr Matousek (1):
      KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set (CVE-=
2012-4461)

Robert Richter (1):
      x86-32: Fix invalid stack address while in softirq

Sachin Kamat (1):
      mtd: ofpart: Fix incorrect NULL check in parse_ofoldpart_partitions()

Simon Wunderlich (1):
      mac80211: deinitialize ibss-internals after emptiness check

Stanislav Yakovlev (1):
      net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_=
tx()

Szymon Janc (2):
      Bluetooth: Fix using uninitialized option in RFCMode
      NFC: pn533: Fix use after free

Thierry Escande (1):
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


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQvR+EAAoJEDjbvchgkmk+t+wP/ilsk5z3/A1G6ghwRGCTsgqu
WPE1dE13H/AsGeXT1b/Wh9FChuWgpPmitad/PCePFCJMzO/wbtNvFJdv+YDc1Kdq
6c6Vz7bCfC1j+z+oD7BqTEn8qzL7nENnlObQuNn/UaVfV/WDhWzmLZKd2XRGgsYP
QxvDhjuYPFsU+ZLWfVDf388jj2HSUy9/1l+qdYMqjP0YdG1V4aXvdckUOhCuTNdC
8nwsPCE6r8ChPxdfT2xEBAcfJjKHOOZQnJ5xDikbD1VEvLDP4avKjUmfXdJIeQ0g
IIensaKn/dBeiDEOKfBzZI/ddWRbt7uief6o+L09kNa8krIHbAUmYuBuCS+5qOIA
0ZktXBUG02FWR7wCKu7yW7LMoSvXO8thmNi0LOdim3KJG9jt3s4Yv4fgha6J3yMP
niqsVCk3iwA08KjoqwrlZHAfON1ua8TBN0OxYLRMFT2nV+KxVGLDdMNYPPsWJAEP
Ak/SHY+UYUtcl48pGIR4phX3KTq8HgpJw0pdIwOJiyLQzL0WfCSThS9mGZKG5qcb
1FutdcTB7FqsA5oKQOVEK5OYjBg9xs0GTa/b4cr3KEFZQywHvULejQKDjcKWg6fD
Xza7j4AHUtGxBZrdFwym31MQBihe+wsmBjovmox6RfN232UfqcDev/PdMSruE7ol
Zj+agaAT+lK8dR0oqQ/E
=2qVm
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
