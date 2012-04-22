Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2DVXry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 19:47:54 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:48205 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2DVXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 19:47:52 -0400
Date: Sun, 22 Apr 2012 16:47:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.29
Message-ID: <20120422234747.GA18457@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.29 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                   |    2=20
 arch/arm/mm/proc-v7.S                      |   12 ++
 arch/ia64/include/asm/futex.h              |    9 +
 arch/s390/Kconfig                          |    1=20
 arch/s390/include/asm/pgalloc.h            |    3=20
 arch/s390/include/asm/tlb.h                |   22 ----
 arch/s390/mm/pgtable.c                     |   63 ++++++++++++-
 arch/sparc/kernel/ds.c                     |    2=20
 arch/sparc/kernel/rtrap_64.S               |    7 -
 drivers/acpi/acpica/acobject.h             |    1=20
 drivers/acpi/acpica/dsargs.c               |    2=20
 drivers/acpi/acpica/excreate.c             |    6 +
 drivers/block/cciss_scsi.c                 |    3=20
 drivers/bluetooth/ath3k.c                  |    4=20
 drivers/bluetooth/btusb.c                  |    2=20
 drivers/bluetooth/hci_ldisc.c              |    4=20
 drivers/dma/Kconfig                        |   13 +-
 drivers/dma/pch_dma.c                      |  137 +++++++++++++++++++++---=
-----
 drivers/gpu/drm/i915/intel_ringbuffer.c    |    2=20
 drivers/gpu/drm/radeon/radeon_connectors.c |    4=20
 drivers/gpu/drm/radeon/radeon_i2c.c        |    4=20
 drivers/gpu/drm/radeon/radeon_irq_kms.c    |    6 +
 drivers/md/bitmap.c                        |    2=20
 drivers/misc/pch_phub.c                    |   62 +++++++++----
 drivers/net/wireless/ath/ath9k/calib.c     |    5 -
 drivers/net/wireless/rtlwifi/pci.c         |    7 +
 drivers/rtc/rtc-pl031.c                    |    3=20
 drivers/staging/iio/magnetometer/hmc5843.c |    4=20
 drivers/tty/serial/8250_pci.c              |   10 ++
 drivers/tty/serial/altera_uart.c           |    4=20
 drivers/tty/serial/amba-pl011.c            |   15 ++-
 drivers/tty/serial/pch_uart.c              |    3=20
 drivers/usb/core/message.c                 |   11 +-
 drivers/usb/gadget/Kconfig                 |    7 -
 drivers/usb/gadget/pch_udc.c               |   97 +++++++++++++++++++-
 drivers/usb/host/pci-quirks.c              |   10 +-
 drivers/usb/host/xhci-ext-caps.h           |    5 -
 drivers/usb/host/xhci-mem.c                |    9 -
 drivers/usb/host/xhci-pci.c                |    2=20
 drivers/usb/host/xhci-ring.c               |    2=20
 drivers/usb/host/xhci.c                    |    9 +
 drivers/usb/host/xhci.h                    |    4=20
 drivers/usb/serial/option.c                |    1=20
 drivers/usb/serial/pl2303.c                |    2=20
 drivers/usb/serial/sierra.c                |    1=20
 drivers/usb/serial/usb-serial.c            |    8 +
 drivers/video/uvesafb.c                    |   11 +-
 include/net/bluetooth/hci.h                |    1=20
 kernel/futex.c                             |   36 ++-----
 kernel/futex_compat.c                      |   36 ++-----
 kernel/time/tick-sched.c                   |    4=20
 mm/hugetlb.c                               |    2=20
 net/bluetooth/hci_core.c                   |    7 +
 security/commoncap.c                       |    6 +
 tools/perf/util/hist.c                     |   12 ++
 55 files changed, 500 insertions(+), 207 deletions(-)

Alan Stern (1):
      USB: don't clear urb->dev in scatter-gather library

Alex Deucher (1):
      drm/radeon: only add the mm i2c bus if the hw_i2c module param is set

Alex He (1):
      xHCI: Correct the #define XHCI_LEGACY_DISABLE_SMI

Alexander Stein (1):
      pch_dma: Fix channel locking

Anton Samokhvalov (1):
      USB: sierra: add support for Sierra Wireless MC7710

Cho, Yu-Chen (1):
      Bluetooth: Add Atheros maryann PIDVID support

Chris Metcalf (1):
      hugetlb: fix race condition in hugetlb_fault()

Chris Wilson (1):
      drm/i915/ringbuffer: Exclude last 2 cachlines of ring on 845g

Dave Airlie (2):
      drm/radeon: disable MSI on RV515
      drm/radeon: fix load detect on rn50 with hardcoded EDIDs.

David Miller (1):
      perf hists: Catch and handle out-of-date hist entry maps.

David S. Miller (1):
      sparc64: Fix bootup crash on sun4v.

Elric Fu (1):
      xHCI: add XHCI_RESET_ON_RESUME quirk for VIA xHCI host

Eran (1):
      Bluetooth: Adding USB device 13d3:3375 as an Atheros AR3012.

Eric Paris (1):
      fcaps: clear the same personality flags as suid when fcaps are used

Felipe Balbi (1):
      xhci: don't re-enable IE constantly

Greg Kroah-Hartman (1):
      Linux 3.0.29

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

Marek Belisko (1):
      staging: iio: hmc5843: Fix crash in probe function.

Martin Schwidefsky (1):
      S390: fix tlb flushing for page table pages

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

Stephen M. Cameron (2):
      cciss: Initialize scsi host max_sectors for tape drive support
      cciss: Fix scsi tape io with more than 255 scatter gather elements

Takashi Iwai (1):
      drm/radeon/kms: fix the regression of DVI connector check

Tomoya MORINAGA (15):
      pch_phub: Fix register miss-setting issue
      pch_phub: Care FUNCSEL register in PM
      pch_phub: Improve ADE(Address Decode Enable) control
      usb: gadget: pch_udc: Fix disconnect issue
      usb: gadget: pch_udc: Fix wrong return value
      usb: gadget: pch_udc: Fix USB suspend issue
      usb: gadget: pch_udc: Fix usb/gadget/pch_udc: Fix ether gadget connec=
t/disconnect issue
      usb: gadget: pch_udc: Reduce redundant interrupt
      USB: pch_udc: Support new device LAPIS Semiconductor ML7831 IOH
      pch_uart: Set PCIe bus number using probe parameter
      8250_pci: Fix kernel panic when pch_uart is disabled
      pch_dma: fix DMA issue(ch8-ch11)
      pch_dma: Fix CTL register access issue
      pch_dma: Fix suspend issue
      pch_dma: Support new device LAPIS Semiconductor ML7831 IOH

Tony Luck (1):
      ia64: fix futex_atomic_cmpxchg_inatomic()

Wang YanQing (1):
      video:uvesafb: Fix oops that uvesafb try to execute NX-protected page

Yuriy Kozlov (1):
      tty: serial: altera_uart: Check for NULL platform_data in probe.


--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPlJijAAoJEDjbvchgkmk+R+kQANIkC7P8uUDfy6pEq0V9GeXz
weNtX0YaExsTJWB+ot7aBLXfr340G/SsZT2ToK2aU9qvV7B+8kOlInPVv+dpqWyv
a/3Lhxer8Gbh355zvZDHp+nypl3vH3pOOGK7By3xXogazToeRcwJWHFd1gyqBci/
SZUiZoIfPCZVLW6xDIPINB6EjFr6olZyAx6pKKG2+AFlRAGMwkAh7o9Myiwtprs5
R0ldXtZG+bc1Jo5YKS0NLltC/IDx5U1NjMZpb77vZ4dbz4jTaxKguKKUjahKQSg3
T8OMMdMAzgFNCbym7BUNYD/nlcalAzCRWCYPpBQ7QmIUhJY1kMBahvhTfgu7PXdl
J/4vOQvBE7Y/FZX1+DeSECdNBqBM11FJt9n1A/M0cqQLEJUNNM4J6XHUr+o+/hJY
V06HXG8FOzQ2TN3frGX3GeDdBOKfgZevVLOszVtfDCX86pFxmRQaoXFXOnY3C9bI
lHaZmhqhsAqD0vXZjOZ85DzyGq3CJ8ltcw+6ERl/+103WgrDKQY5530mowb8azYG
TzOQ9xFM0LMLT7D+fhJNyFX24JScZN9GGhcTcksPiYKZ12vOkGYPthmNk3G9aRug
lN/cRaVfEeRsU/4S5OdjNnuF4cqFDjnzeNEQMNAUN1vktIRMRpJ/Wbrv8O0HYn6f
sHKK9ak0Dg/YNWogmx6a
=lg1A
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
