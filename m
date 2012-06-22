Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762668Ab2FVTZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:25:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58551 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab2FVTZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:25:55 -0400
Date: Fri, 22 Jun 2012 12:25:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.36
Message-ID: <20120622192551.GA23124@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.36 kernel.

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

 Makefile                          |    2=20
 arch/arm/mach-imx/mach-mx21ads.c  |    2=20
 arch/x86/xen/enlighten.c          |    8 +++
 drivers/pci/pci.c                 |    5 +
 drivers/pci/quirks.c              |   26 ++++++++++
 drivers/usb/class/cdc-acm.c       |    8 +++
 drivers/usb/core/hcd-pci.c        |    9 ---
 drivers/usb/core/message.c        |    3 -
 drivers/usb/host/ehci-pci.c       |    8 ---
 drivers/usb/host/xhci.c           |    8 +--
 drivers/usb/serial/cp210x.c       |    1=20
 drivers/usb/serial/ftdi_sio.c     |    1=20
 drivers/usb/serial/ftdi_sio_ids.h |    1=20
 drivers/usb/serial/mct_u232.c     |   13 +++--
 drivers/usb/serial/mos7840.c      |    2=20
 drivers/usb/serial/option.c       |   96 ++++++++++++++++++---------------=
-----
 drivers/usb/serial/qcserial.c     |    6 ++
 drivers/usb/serial/sierra.c       |    4 +
 drivers/usb/serial/usb-serial.c   |    6 +-
 fs/hfsplus/wrapper.c              |    2=20
 include/linux/pci.h               |    2=20
 include/linux/usb/hcd.h           |    2=20
 net/sunrpc/svc.c                  |    3 -
 23 files changed, 133 insertions(+), 85 deletions(-)

Alan Cox (1):
      USB: mct_u232: Fix incorrect TIOCMSET return

Alan Stern (1):
      USB: add NO_D3_DURING_SLEEP flag and revert 151b61284776be2

Andiry Xu (1):
      xHCI: Increase the timeout for controller save/restore state operation

Andre Przywara (1):
      xen/setup: filter APERFMPERF cpuid feature out

Andrew Bird (1):
      USB: option: Updated Huawei K4605 has better id

Bj=C3=B8rn Mork (3):
      USB: option: Add Vodafone/Huawei K5005 support
      USB: qcserial: Add Sierra Wireless device IDs
      USB: serial: Enforce USB driver and USB serial driver match

Daniel Mack (1):
      USB: fix gathering of interface associations

Evan McNabb (1):
      USB: ftdi-sio: Add support for RT Systems USB-RTS01 serial adapter

Greg Kroah-Hartman (1):
      Linux 3.0.36

Jaccon Bastiaansen (1):
      ARM i.MX imx21ads: Fix overlapping static i/o mappings

Janne Kalliom=C3=A4ki (1):
      hfsplus: fix overflow in sector calculations in hfsplus_submit_bio

Johan Hovold (2):
      USB: option: fix memory leak
      USB: option: fix port-data abuse

Mikko Tuumanen (1):
      USB: serial: cp210x: add Optris MS Pro usb id

Otto Meta (1):
      usb: cdc-acm: fix devices not unthrottled on open

Tom Cassidy (1):
      USB: serial: sierra: Add support for Sierra Wireless AirCard 320U mod=
em

Tony Zelenoff (1):
      USB: mos7840: Fix compilation of usb serial driver

Trond Myklebust (1):
      NFSv4.1: Fix a request leak on the back channel

=E8=AF=B4=E4=B8=8D=E5=BE=97 (1):
      USB: option: add more YUGA device ids


--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJP5Ma/AAoJEDjbvchgkmk+RSEP/10BJB641NLv+sR6LIy0qsY4
gTvSRIJaQV1BNxn8Ww9jfutURJEyHw/qFpfBBNp6DC9D+uunUnx7qlDlxTxRmA2/
bUaI42s3h0TbJBrSLsxX/LctVHw9koJfu6WBdiJjChvf5FV1wa6v3uE/NB7ILp7J
5Z29aE80fy9PtqiWdjNM7d51QGvuG7u4rmWcJxscEJNlyasn7DUwVD0wR8kl9TqV
qmjct9rcTIMNsHFWTcU5AVxHcsctjSrM4hLqTlBJqZHpHP4E/8/FuyS0rH6szuh2
9mQWZ0QwIbgYeb4AosxFNtfemgIPT6vmTW6HCViJITMesGgYkAaeOEbGx8JLe5ut
TvOL8uTYUtM63Xjnf5IjHr9UhhSt49Ixe/niV5FM5xZux78R4p0S48IJrpo9WYLT
BoBKNGWZ6F/cms0smzVegEXUGKz6srsx4IybAhD/4YyDh/pYOuoooR2C2QmgpYt7
UcJJtm+qAv5bq+L94bWt2nrN7f4paL4b0bFT4rBp6onsxuOCNoA9yAN1yXMNfriN
TX6ROYYLQNxTUl2sU95S/ERTHyFGKOm2sTriUWAeELybcsv7WANNpK3hp2F8KEH+
1dbZ4DuWZ91Hw8JBP26G1d6nDraw2bu+fLOvdwt/q5/36jQfbjR1xeowzNE6pTLE
MDJ19SvDR7UbZgRL5z4T
=2kx0
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
