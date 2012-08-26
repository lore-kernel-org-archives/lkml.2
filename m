Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab2HZXr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 19:47:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43906 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2HZXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 19:47:56 -0400
Date: Sun, 26 Aug 2012 16:47:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.42
Message-ID: <20120826234750.GA11526@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.42 kernel.

All users of the 3.0 kernel series must upgrade.

Note, there is a reported problem with the Intel graphics driver in this
release, a follow-on release might happen quite quickly to resolve this
issue after it has been tested out.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/s390/kernel/compat_linux.c         |    2=20
 arch/x86/xen/p2m.c                      |   36 ++++
 drivers/gpu/drm/i915/intel_ringbuffer.c |    7=20
 drivers/gpu/drm/radeon/evergreen.c      |   57 ------
 drivers/gpu/drm/radeon/radeon_asic.h    |    8=20
 drivers/gpu/drm/radeon/rv515.c          |   13 -
 drivers/infiniband/ulp/srp/ib_srp.c     |   87 +++++++--
 drivers/net/wireless/rt2x00/rt2800usb.c |    1=20
 drivers/usb/host/pci-quirks.c           |    7=20
 drivers/usb/host/pci-quirks.h           |    1=20
 drivers/usb/host/xhci-pci.c             |   10 +
 drivers/usb/host/xhci.c                 |    8=20
 drivers/usb/host/xhci.h                 |    1=20
 drivers/usb/serial/ftdi_sio.c           |    1=20
 drivers/usb/serial/ftdi_sio_ids.h       |    7=20
 drivers/usb/serial/mos7840.c            |    9 -
 drivers/usb/serial/option.c             |  281 ++++++++++++---------------=
-----
 fs/ext4/super.c                         |    1=20
 fs/fuse/file.c                          |    2=20
 include/linux/usb.h                     |   21 ++
 21 files changed, 283 insertions(+), 279 deletions(-)

Bart Van Assche (1):
      IB/srp: Fix a race condition

Bj=C3=B8rn Mork (1):
      USB: option: add ZTE K5006-Z

Daniel Vetter (1):
      drm/i915: correctly order the ring init sequence

Greg Kroah-Hartman (1):
      Linux 3.0.42

Gustavo Padovan (1):
      USB: add USB_VENDOR_AND_INTERFACE_INFO() macro

Heiko Carstens (1):
      s390/compat: fix mmap compat system calls

Jeongdo Son (1):
      rt2x00: Add support for BUFFALO WLI-UC-GNM2 to rt2800usb.

Jerome Glisse (1):
      drm/radeon: do not reenable crtc after moving vram start address

Mark Ferrell (1):
      usb: serial: mos7840: Fixup mos7840_chars_in_buffer()

Ozan =C3=87a=C4=9Flayan (1):
      USB: ftdi_sio: Add VID/PID for Kondo Serial USB

Sarah Sharp (3):
      xhci: Add Etron XHCI_TRUST_TX_LENGTH quirk.
      xhci: Increase reset timeout for Renesas 720201 host.
      xhci: Switch PPT ports to EHCI on shutdown.

Stefano Stabellini (1):
      xen: mark local pages as FOREIGN in the m2p_override

Theodore Ts'o (1):
      ext4: avoid kmemcheck complaint from reading uninitialized memory

Zach Brown (1):
      fuse: verify all ioctl retry iov elements

fangxiaozhi (1):
      USB: support the new interfaces of Huawei Data Card devices in option=
 driver


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQOrWmAAoJEDjbvchgkmk+jCMP/3+9b7YzBBZEHmM1Y351OmYn
ZsI7X8nkuokcY/XJTu+OfwzJ5FyhaYYfZiLVHeVddcbx8EqfI/Yl4U2UiaVKAFoJ
vJImDA8eSS+jWWPdTw+4ke4xKbeujw7gt0xpsYI07i6RqnAzsKvnGdja8Jebc7rA
FPLKQf4fudQ6onhSJuMKhX4V04WgjgeGYHM89z4iSRExpTqPh5yagiOWwCjL62SI
wP3HAkj5e5yZLgJ6Pp+FeFFhnqGlpGzEoCeoF7Gxsoo4m+voqHjwLYhCGyya91cG
kjn/xv3DEquA5iewnxymVooWaSMi8jfQr7vZ0nVCeKyEqZol79uuWLUAlWM9qGja
4TqAJX9DdE8XtgdlFyYlZHT1oaM6+qfq5mEpnyn+iLA7P0kq1WgM+Eh3sUXyNLl9
gSDHXC5sz2bB2SNfN689VebYaoVuMaXmoUHIBSttf2BbbWMX3VFu6S55E1lzWNEz
qlrJIlVTSIvrrJxq/NoEEl8wvWBchOFs8WYfscJbEeBaieW4wGpCkEDROLen9e1e
kbiCJDROBvV/14oALgFWgmsVVdZ3Mqf657irab4xVnuK8OA3Jc/nlzOZjC2Q27V0
oFF5jlNMxkcBbcLsrDs9JiM9mf6TGI6Mi/wDXB8PbGS6kmjyAVKKvqrHxVRF6aSI
QVKwrB5aaenPVFI/MdZP
=0tbn
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
