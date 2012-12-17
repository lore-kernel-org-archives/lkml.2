Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2LQThR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:37:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35973 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2LQThP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:37:15 -0500
Date: Mon, 17 Dec 2012 11:37:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.7.1
Message-ID: <20121217193711.GA22167@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.7.1 kernel.

All users of the 3.7 kernel series must upgrade.

The updated 3.7.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.7.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                            |    2=20
 arch/x86/kernel/hpet.c              |    4 -
 drivers/acpi/battery.c              |   77 +++++++++++++++++++++++++++++++=
+++++
 drivers/acpi/sleep.c                |    8 +++
 drivers/acpi/video.c                |   14 ++++++
 drivers/acpi/video_detect.c         |    8 +++
 drivers/clk/ux500/u8500_clk.c       |    2=20
 drivers/hwmon/fam15h_power.c        |    4 +
 drivers/pnp/pnpacpi/core.c          |    3 +
 drivers/staging/bcm/InterfaceInit.c |    3 -
 drivers/staging/bcm/InterfaceInit.h |    2=20
 drivers/staging/telephony/ixj.c     |   24 +++++------
 drivers/usb/class/cdc-acm.c         |   38 +++++++++++++++++
 drivers/usb/host/ehci-q.c           |   12 +----
 drivers/usb/host/ehci-sched.c       |    4 -
 drivers/usb/host/ohci-q.c           |   19 ++++++++
 drivers/usb/host/xhci-pci.c         |    7 ++-
 drivers/usb/misc/Kconfig            |    1=20
 drivers/usb/serial/cp210x.c         |    1=20
 drivers/usb/serial/ftdi_sio.c       |    3 -
 drivers/usb/serial/ftdi_sio_ids.h   |    6 ++
 drivers/usb/serial/option.c         |   25 +++++++++++
 drivers/usb/storage/Kconfig         |    2=20
 kernel/rcutree.c                    |   15 +++----
 kernel/trace/ftrace.c               |    2=20
 kernel/trace/ring_buffer.c          |   16 ++++++-
 mm/dmapool.c                        |   31 +++-----------
 tools/perf/builtin-test.c           |   38 +++++------------
 28 files changed, 277 insertions(+), 94 deletions(-)

Alan Stern (2):
      USB: OHCI: workaround for hardware bug: retired TDs not added to the =
Done Queue
      USB: EHCI: bugfix: urb->hcpriv should not be NULL

Bj=F8rn Mork (1):
      USB: option: blacklist network interface on Huawei E173

Boris Ostrovsky (1):
      x86,AMD: Power driver support for AMD's family 16h processors

Dan Carpenter (2):
      telephony: ijx: buffer overflow in ixj_write_cid()
      ftrace: Clear bits properly in reset_iter_read()

Dan Williams (1):
      cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)

Eric Dumazet (1):
      rcu: Fix batch-limit size problem

Greg Kroah-Hartman (2):
      USB: mark uas driver as BROKEN
      Linux 3.7.1

Jan Beulich (1):
      x86: hpet: Fix masking of MSI interrupts

Kamil Iskra (1):
      ACPI / battery: Correct battery capacity values on Thinkpads

Kevin McKinney (1):
      Staging: bcm: Add two products and remove an existing product.

Lan Tianyu (2):
      ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.
      ACPI / video: Add "Asus UL30VT" to ACPI video detect blacklist

Linus Walleij (1):
      clk: ux500: fix bit error

Marek Szyprowski (1):
      mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls

Markus Becker (1):
      USB: cp210x: add Virtenio Preon32 device id

Martin Teichmann (1):
      USB: ftdi_sio: Add support for Newport AGILIS motor drivers

Peter Korsgaard (1):
      usb: ftdi_sio: fixup BeagleBone A5+ quirk

Rafael J. Wysocki (1):
      ACPI / PNP: Do not crash due to stale pointer use during system resume

Rene Buergel (1):
      ezusb: add dependency to USB

Sarah Sharp (1):
      xhci: Extend Fresco Logic MSI quirk.

Steven Rostedt (2):
      ring-buffer: Fix NULL pointer if rb_set_head_page() fails
      ring-buffer: Fix race between integrity check and readers

Zhang Rui (1):
      ACPI / video: ignore BIOS initial backlight value for HP Folio 13-2000

Zheng Liu (1):
      perf test: fix a build error on builtin-test

li.rui27@zte.com.cn (1):
      USB: add new zte 3g-dongle's pid to option.c


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQz3RnAAoJEDjbvchgkmk+VzAP/iAg40xfdrnFDPwzEn9mJkwg
H9mZvBl6sy/W6rLUBelFBYh8ikTv3LaXWbj1v9CAkg7AY4my6UoBc34HhMz13Y29
r3oNiqI1PIWIAOyeP5joaallJ48kwE4ebOxaGKM2mgzfMrhuCeP8ufYeSVCU6HlW
nhtzwpYf+/KaxThmbyzLhs7gQLxrK8CymUQWKfXt84e1ji8j1gK+gebTCTJ0mqGn
60alfvfzWfrQ/wIf4lAyszDMWdWZT8r4AIDiJqF+cTMihUiiSzD/WDLcNQRShUwh
jkRr675dWGgxY1IxBrgugV+zqsb39gJWfnqJP06GFVghIyQFY7SCcb9b5JIVb5Bp
FaiQV1HDM2odNLnvNkV9ru4RuHUuS92FFMGBsuP9dRhYkEh7ccEZbitsoZd2GhjK
gOnif9SEQtlKTQScCPUp5Soqz9DoL7kOEE7utGQglQLoHTpUu2hU3KycubtHdkM3
fXpQpz6kia05w/YIC6wT5U9/FfCZOM/TxldXUgKrQtVs7WHeI2Xa/ExZ5cx4objG
IhTKGKIKGEccnhqjanbpsPB4KPUNBi6Gs1v5vK+v7e88y/uUaKHBAIf3BXqdN3ne
1vvf3RpV0AULGXG1gksYoyao7MOhTIdlTUhu5gkczWevh/1/hKZcMzB7TgzYyU8F
9f1DpI6CTsYRBPcWKEsd
=Nj+e
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
