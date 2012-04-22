Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2DVXuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 19:50:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2DVXuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 19:50:21 -0400
Date: Sun, 22 Apr 2012 16:50:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.3.3
Message-ID: <20120422235018.GA20237@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.3.3 kernel.

All users of the 3.3 kernel series must upgrade.

The updated 3.3.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.3.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                   |    2=20
 arch/arm/boot/compressed/head.S            |    2=20
 arch/arm/mm/proc-v7.S                      |   12 +++
 arch/ia64/include/asm/futex.h              |    9 +-
 arch/s390/Kconfig                          |    1=20
 arch/s390/include/asm/pgalloc.h            |    3=20
 arch/s390/include/asm/tlb.h                |   22 -----
 arch/s390/mm/pgtable.c                     |   63 +++++++++++++++
 arch/sparc/kernel/ds.c                     |    2=20
 arch/sparc/kernel/rtrap_64.S               |    7 -
 arch/x86/include/asm/cmpxchg.h             |    4 -
 drivers/block/cciss_scsi.c                 |    3=20
 drivers/bluetooth/ath3k.c                  |    4 +
 drivers/bluetooth/btusb.c                  |    2=20
 drivers/bluetooth/hci_ldisc.c              |    4 -
 drivers/gpu/drm/i915/i915_drv.c            |    2=20
 drivers/gpu/drm/i915/intel_dp.c            |   49 ++++++++----
 drivers/gpu/drm/i915/intel_fb.c            |    4 +
 drivers/gpu/drm/i915/intel_ringbuffer.c    |    2=20
 drivers/gpu/drm/i915/intel_sprite.c        |    1=20
 drivers/gpu/drm/radeon/atombios_encoders.c |    4 +
 drivers/gpu/drm/radeon/radeon_connectors.c |    4 -
 drivers/gpu/drm/radeon/radeon_i2c.c        |    4 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c    |    6 +
 drivers/infiniband/ulp/srpt/ib_srpt.c      |    1=20
 drivers/md/bitmap.c                        |    2=20
 drivers/md/raid1.c                         |    3=20
 drivers/md/raid10.c                        |    4 -
 drivers/net/wireless/rtlwifi/pci.c         |    7 +
 drivers/net/wireless/rtlwifi/usb.c         |   34 ++++----
 drivers/net/wireless/rtlwifi/wifi.h        |    6 +
 drivers/rtc/rtc-pl031.c                    |    3=20
 drivers/spi/spi-topcliff-pch.c             |   33 ++++----
 drivers/staging/iio/magnetometer/hmc5843.c |    4 -
 drivers/tty/serial/8250/8250.c             |   12 +--
 drivers/tty/serial/8250/8250_pci.c         |   16 ----
 drivers/tty/serial/altera_uart.c           |    4 -
 drivers/tty/serial/amba-pl011.c            |   15 ++-
 drivers/tty/serial/pch_uart.c              |    1=20
 drivers/tty/serial/samsung.c               |    1=20
 drivers/usb/core/driver.c                  |    9 +-
 drivers/usb/core/hub.c                     |   16 ++++
 drivers/usb/core/message.c                 |   11 +-
 drivers/usb/gadget/pch_udc.c               |   91 +++++++++++++++++++++-
 drivers/usb/host/pci-quirks.c              |   10 +-
 drivers/usb/host/xhci-ext-caps.h           |    5 -
 drivers/usb/host/xhci-mem.c                |    9 --
 drivers/usb/host/xhci-pci.c                |    2=20
 drivers/usb/host/xhci-ring.c               |    2=20
 drivers/usb/host/xhci.c                    |    9 +-
 drivers/usb/host/xhci.h                    |    4 +
 drivers/usb/serial/ftdi_sio.c              |   36 +++++----
 drivers/usb/serial/option.c                |    1=20
 drivers/usb/serial/pl2303.c                |    2=20
 drivers/usb/serial/sierra.c                |    1=20
 drivers/usb/serial/usb-serial.c            |    8 ++
 drivers/video/uvesafb.c                    |   11 ++
 fs/btrfs/backref.c                         |  115 ++++++++++++++++--------=
-----
 fs/btrfs/backref.h                         |    5 -
 fs/btrfs/extent-tree.c                     |    2=20
 fs/btrfs/ioctl.c                           |    4 -
 fs/btrfs/scrub.c                           |    4 -
 fs/ext4/ext4.h                             |    3=20
 fs/ext4/extents.c                          |    4 -
 fs/ext4/super.c                            |   16 ----
 include/linux/serial_core.h                |    2=20
 include/net/bluetooth/hci.h                |    1=20
 kernel/futex.c                             |   36 +++------
 kernel/futex_compat.c                      |   36 +++------
 kernel/panic.c                             |    2=20
 kernel/time/tick-sched.c                   |    4 -
 mm/hugetlb.c                               |    2=20
 mm/memcontrol.c                            |    1=20
 net/bluetooth/hci_conn.c                   |    5 -
 net/bluetooth/hci_core.c                   |    7 +
 security/commoncap.c                       |    6 +
 sound/pci/hda/patch_realtek.c              |    1=20
 tools/perf/util/hist.c                     |   12 +++
 78 files changed, 538 insertions(+), 319 deletions(-)

Alan Stern (2):
      USB: don't clear urb->dev in scatter-gather library
      USB: don't ignore suspend errors for root hubs

Alex Deucher (2):
      drm/radeon/kms: fix DVO setup on some r4xx chips
      drm/radeon: only add the mm i2c bus if the hw_i2c module param is set

Alex He (1):
      xHCI: Correct the #define XHCI_LEGACY_DISABLE_SMI

Andre Guedes (1):
      Bluetooth: Remove unneeded locking

Anton Samokhvalov (1):
      USB: sierra: add support for Sierra Wireless MC7710

Cho, Yu-Chen (1):
      Bluetooth: Add Atheros maryann PIDVID support

Chris Mason (1):
      Revert "Btrfs: increase the global block reserve estimates"

Chris Metcalf (1):
      hugetlb: fix race condition in hugetlb_fault()

Chris Wilson (2):
      drm/i915/ringbuffer: Exclude last 2 cachlines of ring on 845g
      drm/i915: Hold mode_config lock whilst changing mode for lastclose()

Dan Williams (3):
      Revert "serial/8250_pci: init-quirk msi support for kt serial control=
ler"
      Revert "serial/8250_pci: setup-quirk workaround for the kt serial con=
troller"
      serial/8250_pci: add a "force background timer" flag and use it for t=
he "kt" serial port

Daniel Vetter (1):
      drm/i915: properly compute dp dithering for user-created modes

Danny Kukawka (1):
      spi-topcliff-pch: fix -Wuninitialized warning

Dave Airlie (2):
      drm/radeon: disable MSI on RV515
      drm/radeon: fix load detect on rn50 with hardcoded EDIDs.

David Miller (1):
      perf hists: Catch and handle out-of-date hist entry maps.

David S. Miller (1):
      sparc64: Fix bootup crash on sun4v.

Elric Fu (2):
      USB: fix bug of device descriptor got from superspeed device
      xHCI: add XHCI_RESET_ON_RESUME quirk for VIA xHCI host

Eran (1):
      Bluetooth: Adding USB device 13d3:3375 as an Atheros AR3012.

Eric Paris (1):
      fcaps: clear the same personality flags as suid when fcaps are used

Felipe Balbi (1):
      xhci: don't re-enable IE constantly

Greg Kroah-Hartman (1):
      Linux 3.3.3

H. Peter Anvin (1):
      x86: Use correct byte-sized register constraint in __add()

Hugh Dickins (1):
      memcg: fix Bad page state after replace_page_cache

Jan Schmidt (1):
      Btrfs: fix regression in scrub path resolving

Jason Wessel (1):
      panic: fix stack dump print on direct call to panic()

Jeremy Fitzhardinge (1):
      x86: Use correct byte-sized register constraint in __xchg_op()

Jesse Barnes (1):
      drm/i915: make rc6 module parameter read-only

Johan Hovold (5):
      Bluetooth: uart-ldisc: Fix memory leak
      Bluetooth: hci_ldisc: fix NULL-pointer dereference on tty_close
      Bluetooth: hci_core: fix NULL-pointer dereference at unregister
      USB: serial: fix race between probe and open
      USB: pl2303: fix DTR/RTS being raised on baud rate change

Jonathan Austin (1):
      ARM: 7384/1: ThumbEE: Disable userspace TEEHBR access for !CONFIG_ARM=
_THUMBEE

Jonghwan Choi (1):
      security: fix compile error in commoncap.c

Kees Cook (1):
      futex: Do not leak robust list to unprivileged process

Kukjin Kim (1):
      serial: samsung: fix omission initialize ulcon in reset port fn()

Larry Finger (2):
      rtlwifi: Preallocate USB read buffers and eliminate kalloc in read ro=
utine
      rtlwifi: Add missing DMA buffer unmapping for PCI drivers

Linus Walleij (3):
      drivers/rtc/rtc-pl031.c: enable clock on all ST variants
      serial: PL011: clear pending interrupts
      serial: PL011: move interrupt clearing

Marc Zyngier (1):
      ARM: 7379/1: DT: fix atags_to_fdt() second call site

Marek Belisko (1):
      staging: iio: hmc5843: Fix crash in probe function.

Martin Schwidefsky (1):
      fix tlb flushing for page table pages

Neal Cardwell (1):
      nohz: Fix stale jiffies update in tick_nohz_restart()

NeilBrown (1):
      md/bitmap: prevent bitmap_daemon_work running while initialising bitm=
ap

Paul E. McKenney (1):
      sparc64: Eliminate obsolete __handle_softirq() function

Roland Dreier (1):
      IB/srpt: Set srq_type to IB_SRQT_BASIC

Santiago Garcia Mantinan (1):
      USB: option: re-add NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED to option_=
id array

Sarah Sharp (3):
      xhci: Don't write zeroed pointers to xHC registers.
      xhci: Restore event ring dequeue pointer on resume.
      xhci: Fix register save/restore order.

Simon Arlott (2):
      USB: ftdi_sio: fix status line change handling for TIOCMIWAIT and TIO=
CGICOUNT
      USB: ftdi_sio: fix race condition in TIOCMIWAIT, and abort of TIOCMIW=
AIT when the device is removed

Stephen M. Cameron (2):
      cciss: Initialize scsi host max_sectors for tape drive support
      cciss: Fix scsi tape io with more than 255 scatter gather elements

Takashi Iwai (2):
      ALSA: hda/realtek - Add a fixup entry for Acer Aspire 8940G
      drm/radeon/kms: fix the regression of DVI connector check

Theodore Ts'o (1):
      ext4: address scalability issue by removing extent cache statistics

Tomoya MORINAGA (6):
      pch_uart: Fix MSI setting issue
      usb: gadget: pch_udc: Fix disconnect issue
      usb: gadget: pch_udc: Fix wrong return value
      usb: gadget: pch_udc: Fix USB suspend issue
      usb: gadget: pch_udc: Fix usb/gadget/pch_udc: Fix ether gadget connec=
t/disconnect issue
      usb: gadget: pch_udc: Reduce redundant interrupt

Tony Luck (1):
      ia64: fix futex_atomic_cmpxchg_inatomic()

Wang YanQing (1):
      video:uvesafb: Fix oops that uvesafb try to execute NX-protected page

Yuriy Kozlov (1):
      tty: serial: altera_uart: Check for NULL platform_data in probe.

acreese (1):
      drm/i915: Removed IVB forced enable of sprite dest key.

majianpeng (1):
      md/raid1,raid10: Fix calculation of 'vcnt' when processing error reco=
very.


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPlJk6AAoJEDjbvchgkmk+pDkQAJm8m/YO2GZI9vdQRU2c6Qx2
GRFYOIaTcQloyYGN5Sf56YkdXX7BnnLZwyYrxsxCgPSQWbIUbr85J0d4J2y1+krC
6iJQI0x1T9vNAJy0NwMAdlbpq7mdKmEStcwKeVA4oEv2bCSlL/YUQ05YNe16u+B9
ZirlEHdcB+xRKUd+c9hIfGMOa7V2ns/wGn/ZrHdbsuUe4P/RBTJzRcWXeD0m1M2s
bKM7rLoH47PIBCg+ocrACyV/s9g9fEIfjR84BZLvyvivTLCDiQt4LZm6S1v7CMUl
d1ofJb9NVmurqcKWJOF8kfZaf4ezANimv4RGrp5hMvNfwuYewc6TqKwSZjVfC+Qz
VY4e7HgEW4QTXQESYMIBWMBRM1yG/jtl9t82dJaUnJmtmM54V22Cc2WohJ9Om6TB
ZVmPFK7bitwTvwiiFhJdRoJmxFLhJhVJtY8dx5VKJkeOxUqz+a2IIzaV1y4tnrKv
2PBkaELu843Zm7hne2wG07liInTfenMIQO9YTfmpfN/mn2EbEwP168CwHqxUMARR
G2wEVDqnNEaxcV2vBHsd4ws88F1xa0j4Gbj6rnx6jT/tnvg/Xq7kDSofKTkGu6My
oydGXdjyMAui2V8NQgFXBuwBRiHER7pUpxy2pO8igCjhvYRx8j0fFsNwQYFauI1o
XfXPg2VP4shGzfEe8mxv
=HeQN
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
