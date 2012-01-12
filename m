Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2ALU0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:26:00 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58463 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755326Ab2ALUZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:25:36 -0500
X-Sasl-enc: ob9IoMjqk9g1wKI5ZDcljxER54Fq9sLFJGzEmlpbHvTN 1326399935
Date: Thu, 12 Jan 2012 12:25:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.1
Message-ID: <20120112202505.GA15676@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.1 kernel.

All users of the 3.2 kernel series must upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/HOWTO                               |    4 -
 Documentation/development-process/5.Posting       |    8 +-
 Documentation/usb/usbmon.txt                      |   14 ++-
 MAINTAINERS                                       |    2=20
 Makefile                                          |    2=20
 arch/powerpc/include/asm/time.h                   |    2=20
 arch/powerpc/kernel/irq.c                         |   15 +---
 arch/powerpc/kernel/time.c                        |    9 ++
 arch/powerpc/platforms/pseries/hvCall_inst.c      |    4 -
 arch/powerpc/platforms/pseries/lpar.c             |    2=20
 drivers/base/firmware_class.c                     |   14 +--
 drivers/bcma/bcma_private.h                       |    3=20
 drivers/bcma/host_pci.c                           |   37 ++++++++++
 drivers/bcma/main.c                               |   16 ++++
 drivers/hv/vmbus_drv.c                            |   17 ++++
 drivers/infiniband/core/uverbs_cmd.c              |   21 ++++-
 drivers/infiniband/hw/qib/qib_iba6120.c           |    4 -
 drivers/infiniband/hw/qib/qib_iba7220.c           |    4 -
 drivers/infiniband/hw/qib/qib_iba7322.c           |    6 +
 drivers/net/bonding/bond_main.c                   |    9 +-
 drivers/net/usb/asix.c                            |    2=20
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    2=20
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2=20
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   73 ++++++++---------=
---
 drivers/net/wireless/libertas/cfg.c               |   10 +-
 drivers/net/wireless/rt2x00/rt2800usb.c           |    2=20
 drivers/net/wireless/wl12xx/boot.c                |   14 +++
 drivers/net/wireless/wl12xx/cmd.c                 |   22 ++++++
 drivers/net/wireless/wl12xx/testmode.c            |    1=20
 drivers/tty/serial/atmel_serial.c                 |    5 -
 drivers/usb/class/cdc-acm.c                       |   16 +++-
 drivers/usb/core/devio.c                          |    3=20
 drivers/usb/core/hcd.c                            |    5 -
 drivers/usb/core/quirks.c                         |    5 +
 drivers/usb/host/ehci-pxa168.c                    |    2=20
 drivers/usb/host/ehci-q.c                         |    2=20
 drivers/usb/host/uhci-q.c                         |    2=20
 drivers/usb/host/whci/qset.c                      |    4 -
 drivers/usb/host/xhci-ring.c                      |    4 -
 drivers/usb/host/xhci.c                           |    4 -
 drivers/usb/host/xhci.h                           |    1=20
 drivers/usb/misc/isight_firmware.c                |    6 +
 drivers/usb/musb/musb_core.c                      |    2=20
 drivers/usb/serial/cp210x.c                       |    1=20
 drivers/usb/serial/omninet.c                      |    2=20
 drivers/usb/serial/option.c                       |    5 +
 drivers/usb/storage/usb.c                         |    1=20
 drivers/video/offb.c                              |   52 ++++++--------
 fs/Kconfig                                        |    2=20
 fs/exofs/Kconfig                                  |   11 ---
 fs/exofs/Kconfig.ore                              |   12 +++
 fs/exofs/ore.c                                    |    8 +-
 fs/exofs/ore_raid.c                               |   78 +++++++++++++++++=
+----
 fs/ext3/inode.c                                   |   24 +++++-
 fs/reiserfs/super.c                               |   27 ++++---
 fs/udf/file.c                                     |    6 -
 fs/udf/inode.c                                    |   21 +++++
 fs/xfs/xfs_acl.c                                  |    2=20
 include/linux/usb.h                               |    1=20
 include/linux/usb/ch9.h                           |   20 +++++
 kernel/cgroup.c                                   |    6 -
 net/ipv4/igmp.c                                   |    2=20
 tools/perf/util/trace-event-parse.c               |    2=20
 63 files changed, 465 insertions(+), 200 deletions(-)

Alan Stern (1):
      USB: update documentation for usbmon

Andres Salomon (1):
      libertas: clean up scan thread handling

Anton Blanchard (1):
      powerpc/time: Handle wrapping of decrementer

Aurelien Jacobs (1):
      asix: fix infinite loop in rx_fixup()

Ben Hutchings (1):
      igmp: Avoid zero delay when receiving odd mixture of IGMP queries

Benjamin Herrenschmidt (2):
      offb: Fix setting of the pseudo-palette for >8bpp
      offb: Fix bug in calculating requested vram size

Boaz Harrosh (4):
      ore: Fix crash in case of an IO error.
      ore: fix BUG_ON, too few sgs when reading
      ore: Must support none-PAGE-aligned IO
      ore: FIX breakage when MISC_FILESYSTEMS is not set

Claudio Scordino (1):
      atmel_serial: fix spinlock lockup in RS485 code

Clemens Ladisch (1):
      usb: fix number of mapped SG DMA entries

Eli Cohen (1):
      IB/uverbs: Protect QP multicast list

Felipe Balbi (1):
      usb: ch9: fix up MaxStreams helper

Felipe Contreras (1):
      usb: musb: fix pm_runtime mismatch

Greg Kroah-Hartman (2):
      USB: isight: fix kernel bug when loading firmware
      Linux 3.2.1

Hans de Goede (1):
      xhci: Properly handle COMP_2ND_BW_ERR

Huajun Li (1):
      usb: usb-storage doesn't support dynamic id currently, the patch disa=
bles the feature to fix an oops

Jan Kara (3):
      reiserfs: Fix quota mount option parsing
      ext3: Don't warn from writepage when readonly inode is spotted after =
error
      udf: Fix deadlock when converting file from in-ICB one to normal one

Janne Snabb (1):
      usb: option: add ZD Incorporated HSPA modem

Jeff Mahoney (1):
      reiserfs: Force inode evictions before umount to avoid crash

Joe Perches (2):
      MAINTAINERS: stable: Update address
      Documentation: Update stable address

Johan Hovold (1):
      USB: omninet: fix write_room

Johannes Berg (2):
      iwlagn: fix TID use bug
      iwlagn: fix (remove) use of PAGE_SIZE

Julia Lawall (1):
      drivers/usb/class/cdc-acm.c: clear dangling pointer

K. Y. Srinivasan (2):
      drivers: hv: Don't OOPS when you cannot init vmbus
      Drivers:hv: Fix a bug in vmbus_driver_unregister()

Larry Finger (1):
      rt2800usb: Move ID out of unknown

Li Zefan (1):
      cgroup: fix to allow mounting a hierarchy by name

Li Zhong (1):
      powerpc: Fix unpaired probe_hcall_entry and probe_hcall_exit

Malte Schr=C3=B6der (1):
      USB: Add USB-ID for Multiplex RC serial adapter to cp210x.c

Neil Horman (1):
      firmware: Fix an oops on reading fw_priv->fw in sysfs loading file

Oliver Neukum (1):
      USB: add quirk for another camera

Pontus Fuchs (3):
      wl12xx: Validate FEM index from ini file and FW
      wl12xx: Check buffer bound when processing nvs data
      wl12xx: Restore testmode ABI

Rafa=C5=82 Mi=C5=82ecki (1):
      bcma: support for suspend and resume

Ram Vepa (1):
      IB/qib: Fix a possible data corruption when receiving packets

Sarah Sharp (1):
      usbfs: Fix oops related to user namespace conversion.

Steven Rostedt (1):
      perf: Fix parsing of __print_flags() in TP_printk()

Tanmay Upadhyay (1):
      USB: pxa168: Fix compilation error

Thilo-Alexander Ginkel (1):
      usb: cdc-acm: Fix acm_tty_hangup() vs. acm_tty_close() race

Xi Wang (1):
      xfs: fix acl count validation in xfs_acl_from_disk()

stephen hemminger (1):
      bonding: fix error handling if slave is busy (v2)


--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPD0GhAAoJEDjbvchgkmk+MukQALnwuvmay42thM2GB+FvA2Dr
/9Vhh/X/IGWeJY/v0q7TfklE43pwYUiBISrNHfNb+qIzauJCGuH0AyJO803SUKv2
C+B2PROvk5evi9A+Y7nF+QoYH0P14BBQMJL4DhJ3TIByfGIHHxGplSy1FzUD7gE3
Gwl/29HTy+/LUw8YHwOkAlgucl8XYc+Z7WsLEgrG6JaZiXHdIGcnTu9GetfjjtEH
tE2yORuCa+nfAbgqeHUD2YkmGb3kq/sEA6ycCMISX/Ap/l8cVtz3fGTrUcCeEiiK
tiM9aMtZahuckr3lkUAs3XDFKFugYwVZWFcCXwxCBOZzId4hCIvGpPbnPIfCHr13
QMzJPtjKrnTv2wvLuSGP7jAfj6W/8gy0euJy7z6TweAwq0ZP8bqdJqsy8I6V8uNJ
1yZfOH7lQaoqPm4CHgaR2XLOMEi7P7wM92znCEGBNHj72GBvZPLwOxxA9aK9RghF
lV8Xt0Ez6gDxKxOAzqFU2tLDXpLDeueAIHgeNSca5EPGKBVRyV0aiYlMET6pWOE/
tCn9chPo0z+KoAKg+OXvFUzZwQzb8exWQ91J31udyBDMAp9tNH2JE1uUyJpUwmfF
i+uL3DPaWiD6kourkOtgLBZgoneTDyc7asgR/izwXo6jXCPws8yhcuWG1VSVrEjs
vmmCZ5K/QlTs6lZS3HS7
=pMxE
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
