Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2DVXto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 19:49:44 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:35410 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab2DVXtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 19:49:42 -0400
Date: Sun, 22 Apr 2012 16:49:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Ben Hutchings <ben@decadent.org.uk>
Subject: Linux 3.2.16
Message-ID: <20120422234938.GA20146@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.16 kernel.

All users of the 3.2 kernel series must upgrade.

Note, this is the LAST 3.2-stable kernel I will be releasing.  Ben
Hutchings has agreed to pick this kernel version up and will be
maintaining it for an indefiniate amount of time.  Any future questions
about this kernel version should be directed to him and the stable
kernel mailing list.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                              |    2=20
 arch/arm/boot/compressed/head.S                       |    2=20
 arch/arm/mm/proc-v7.S                                 |   12 ++
 arch/ia64/include/asm/futex.h                         |    9 -
 arch/s390/Kconfig                                     |    1=20
 arch/s390/include/asm/pgalloc.h                       |    3=20
 arch/s390/include/asm/tlb.h                           |   22 ----
 arch/s390/mm/pgtable.c                                |   63 +++++++++++-
 arch/sparc/kernel/ds.c                                |    2=20
 arch/sparc/kernel/rtrap_64.S                          |    7 -
 drivers/acpi/acpica/acobject.h                        |    1=20
 drivers/acpi/acpica/dsargs.c                          |    2=20
 drivers/acpi/acpica/excreate.c                        |    6 +
 drivers/block/cciss_scsi.c                            |    3=20
 drivers/bluetooth/ath3k.c                             |    4=20
 drivers/bluetooth/btusb.c                             |    3=20
 drivers/bluetooth/hci_ldisc.c                         |    4=20
 drivers/dma/Kconfig                                   |   13 +-
 drivers/dma/pch_dma.c                                 |    8 +
 drivers/gpio/Kconfig                                  |   11 +-
 drivers/gpio/gpio-pch.c                               |    2=20
 drivers/gpu/drm/i915/i915_drv.c                       |    2=20
 drivers/gpu/drm/i915/intel_display.c                  |   13 +-
 drivers/gpu/drm/i915/intel_dp.c                       |   49 ++++++---
 drivers/gpu/drm/i915/intel_ringbuffer.c               |    2=20
 drivers/gpu/drm/radeon/atombios_encoders.c            |    4=20
 drivers/gpu/drm/radeon/radeon_connectors.c            |    4=20
 drivers/gpu/drm/radeon/radeon_i2c.c                   |    4=20
 drivers/gpu/drm/radeon/radeon_irq_kms.c               |    6 +
 drivers/md/bitmap.c                                   |    2=20
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |   17 ++-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c |   15 +-
 drivers/net/wireless/ath/ath9k/calib.c                |    5=20
 drivers/net/wireless/rtlwifi/pci.c                    |    7 +
 drivers/rtc/rtc-pl031.c                               |    3=20
 drivers/spi/Kconfig                                   |    6 -
 drivers/spi/spi-topcliff-pch.c                        |   38 ++++---
 drivers/staging/iio/magnetometer/hmc5843.c            |    4=20
 drivers/tty/serial/altera_uart.c                      |    4=20
 drivers/tty/serial/amba-pl011.c                       |   15 ++
 drivers/tty/serial/pch_uart.c                         |    1=20
 drivers/usb/core/driver.c                             |    9 +
 drivers/usb/core/hub.c                                |   16 +++
 drivers/usb/core/message.c                            |   11 +-
 drivers/usb/gadget/pch_udc.c                          |   91 +++++++++++++=
+++--
 drivers/usb/host/pci-quirks.c                         |   10 +
 drivers/usb/host/xhci-ext-caps.h                      |    5=20
 drivers/usb/host/xhci-mem.c                           |    9 -
 drivers/usb/host/xhci-pci.c                           |    2=20
 drivers/usb/host/xhci-ring.c                          |    2=20
 drivers/usb/host/xhci.c                               |    9 -
 drivers/usb/host/xhci.h                               |    4=20
 drivers/usb/serial/ftdi_sio.c                         |   36 +++----
 drivers/usb/serial/option.c                           |    1=20
 drivers/usb/serial/pl2303.c                           |    2=20
 drivers/usb/serial/sierra.c                           |    1=20
 drivers/usb/serial/usb-serial.c                       |    8 +
 drivers/video/uvesafb.c                               |   11 +-
 fs/ext4/ext4.h                                        |    3=20
 fs/ext4/extents.c                                     |    4=20
 fs/ext4/super.c                                       |   16 ---
 include/net/bluetooth/hci.h                           |    1=20
 kernel/futex.c                                        |   36 ++-----
 kernel/futex_compat.c                                 |   36 ++-----
 kernel/time/tick-sched.c                              |    4=20
 mm/hugetlb.c                                          |    2=20
 net/bluetooth/hci_core.c                              |    7 +
 security/commoncap.c                                  |    6 +
 tools/perf/util/hist.c                                |   12 ++
 69 files changed, 488 insertions(+), 247 deletions(-)

Alan Stern (2):
      USB: don't clear urb->dev in scatter-gather library
      USB: don't ignore suspend errors for root hubs

Alex Deucher (2):
      drm/radeon/kms: fix DVO setup on some r4xx chips
      drm/radeon: only add the mm i2c bus if the hw_i2c module param is set

Alex He (1):
      xHCI: Correct the #define XHCI_LEGACY_DISABLE_SMI

Anton Samokhvalov (1):
      USB: sierra: add support for Sierra Wireless MC7710

Axel Lin (1):
      gpio: Add missing spin_lock_init in gpio-pch driver

Cho, Yu-Chen (1):
      Bluetooth: Add Atheros maryann PIDVID support

Chris Metcalf (1):
      hugetlb: fix race condition in hugetlb_fault()

Chris Wilson (1):
      drm/i915/ringbuffer: Exclude last 2 cachlines of ring on 845g

Dan Carpenter (1):
      pch_gbe: memory corruption calling pch_gbe_validate_option()

Daniel Vetter (1):
      drm/i915: properly compute dp dithering for user-created modes

Danny Kukawka (1):
      spi-topcliff-pch: fix -Wuninitialized warning

Darren Hart (1):
      pch_gbe: Do not abort probe on bad MAC

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
      Linux 3.2.16

Jesse Barnes (2):
      drm/i915: mask transcoder select bits before setting them on LVDS
      drm/i915: make rc6 module parameter read-only

Jesse Sung (1):
      Bluetooth: Add support for BCM20702A0 [0a5c:21e3]

Johan Hovold (5):
      Bluetooth: uart-ldisc: Fix memory leak
      Bluetooth: hci_ldisc: fix NULL-pointer dereference on tty_close
      USB: serial: fix race between probe and open
      USB: pl2303: fix DTR/RTS being raised on baud rate change
      Bluetooth: hci_core: fix NULL-pointer dereference at unregister

Jonathan Austin (1):
      ARM: 7384/1: ThumbEE: Disable userspace TEEHBR access for !CONFIG_ARM=
_THUMBEE

Jonghwan Choi (1):
      security: fix compile error in commoncap.c

Kees Cook (1):
      futex: Do not leak robust list to unprivileged process

Larry Finger (1):
      rtlwifi: Add missing DMA buffer unmapping for PCI drivers

Lin Ming (1):
      ACPICA: Fix to allow region arguments to reference other scopes

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

Rajkumar Manoharan (1):
      ath9k: fix max noise floor threshold

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

Takashi Iwai (1):
      drm/radeon/kms: fix the regression of DVI connector check

Theodore Ts'o (1):
      ext4: address scalability issue by removing extent cache statistics

Tomoya MORINAGA (9):
      pch_uart: Fix MSI setting issue
      pch_gpio: Support new device LAPIS Semiconductor ML7831 IOH
      usb: gadget: pch_udc: Fix disconnect issue
      usb: gadget: pch_udc: Fix wrong return value
      usb: gadget: pch_udc: Fix USB suspend issue
      usb: gadget: pch_udc: Fix usb/gadget/pch_udc: Fix ether gadget connec=
t/disconnect issue
      usb: gadget: pch_udc: Reduce redundant interrupt
      pch_dma: Support new device LAPIS Semiconductor ML7831 IOH
      spi-topcliff-pch: Support new device LAPIS Semiconductor ML7831 IOH

Tony Luck (1):
      ia64: fix futex_atomic_cmpxchg_inatomic()

Wang YanQing (1):
      video:uvesafb: Fix oops that uvesafb try to execute NX-protected page

Yuriy Kozlov (1):
      tty: serial: altera_uart: Check for NULL platform_data in probe.


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPlJkSAAoJEDjbvchgkmk+x+IP/jt8cDFdVXsfIaEIVXlilFf0
ItBcfTTrP4mZg11jW8p7JCul+nqvrgsynSiF0AeiPK/nvxQ4pBVWV61qGJcqTqzX
DoWnOtPoC1iG3u0Yc4B9FyCKf7jevTML/GGWiE5hnO5AShcrE+aQwCv71ZNWF3FW
ZJWXNsPsyF/3PimIlnB1dWYWbkCUnQMd2UroSHLLgyLyVtTCjFwcneKL+5hl5vI9
3HRkQA07iyqWCLaUtVxQGBDbv+YMr76JmAymar7ymtKNtMMkWxIiwCTFsliuwsMT
okQjXh07F9ZDn5wyhFqFHf44aueli5YLruC1Z3qeeDPGklzfTDTuXJtO9OrI/QNV
YlMbJVlR+RKwOwVeKZ6FEr6WIygRkpMo1r1weej5ZPLfOpjA02TKXqOfeGi6iTkm
qt9irSuulYmNvdXxCBjdBMx/SzFJpkAD4fHNGpNwFp1TWKlHVNf6PIFh4VYjSn9C
Gy9DJmcPiVtqqxQu/a5zQSd7EaJo9hI3qoRXaFZIBrhBuVHUYrXrMAkVpwJl3JF7
z4n9t2nYYsPnFU0KrcwEY/t0PO1axHCTK/YWTSuN0+knGzvTPe8h7lh4TlUDRAzn
IDsrv0aZDll/eexdZ7PALw9Wcqb54JsV21BqK4Z2xiQ/a5i9+PnXkuxkRG0d8RIb
oPzrw/DsqRGpbfWBrD+v
=jmto
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
