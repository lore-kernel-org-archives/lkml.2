Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab2JGPqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:46:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2JGPpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:45:52 -0400
Date: Sun, 7 Oct 2012 08:45:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.45
Message-ID: <20121007154548.GA26328@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.45 kernel.

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

 Makefile                                       |    2=20
 arch/x86/kernel/alternative.c                  |    2=20
 drivers/char/ttyprintk.c                       |    2=20
 drivers/firmware/efivars.c                     |   17 ++++++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2=20
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   19 ++++----
 drivers/infiniband/ulp/srp/ib_srp.c            |    3 -
 drivers/md/dm.c                                |   56 ++++++++++++++++----=
-----
 drivers/mtd/ubi/build.c                        |    5 ++
 drivers/net/can/mscan/mpc5xxx_can.c            |    4 -
 drivers/net/wireless/b43legacy/main.c          |    2=20
 drivers/pci/setup-bus.c                        |   26 +++++++++++
 drivers/scsi/device_handler/scsi_dh_alua.c     |    3 -
 drivers/scsi/hpsa.c                            |    2=20
 drivers/scsi/ibmvscsi/ibmvscsi.c               |    3 +
 drivers/scsi/isci/init.c                       |    1=20
 drivers/scsi/isci/probe_roms.c                 |    1=20
 drivers/scsi/scsi_sysfs.c                      |   30 ++++++-------
 drivers/staging/comedi/comedi_fops.c           |    5 +-
 drivers/staging/comedi/drivers/jr3_pci.c       |    2=20
 drivers/staging/comedi/drivers/s626.c          |    2=20
 drivers/staging/speakup/speakup_soft.c         |   13 +----
 drivers/tty/n_gsm.c                            |   15 ++++--
 drivers/tty/n_tty.c                            |    3 -
 drivers/tty/serial/8250_pci.c                  |    9 +++-
 drivers/tty/serial/amba-pl011.c                |   15 ++++++
 drivers/usb/host/xhci-pci.c                    |    1=20
 drivers/usb/host/xhci-ring.c                   |    4 +
 drivers/usb/host/xhci.c                        |    2=20
 drivers/usb/host/xhci.h                        |    1=20
 drivers/usb/serial/ftdi_sio.c                  |    2=20
 drivers/usb/serial/ftdi_sio_ids.h              |    5 ++
 drivers/usb/serial/option.c                    |    3 -
 drivers/usb/serial/qcaux.c                     |   10 +---
 fs/binfmt_elf.c                                |   19 +-------
 fs/dcache.c                                    |    6 ++
 include/linux/pci_ids.h                        |    1=20
 37 files changed, 193 insertions(+), 105 deletions(-)

Antonio Ospite (1):
      USB: ftdi_sio: add TIAO USB Multi-Protocol Adapter (TUMPA) support

Artem Bityutskiy (1):
      UBI: fix autoresize handling in R/O mode

Avi Kivity (1):
      x86/alternatives: Fix p6 nops on non-modular kernels

Bart Van Assche (3):
      IB/srp: Fix use-after-free in srp_reset_req()
      IB/srp: Avoid having aborted requests hang
      SCSI: scsi_dh_alua: Enable STPG for unavailable ports

Ben Hutchings (1):
      staging: speakup_soft: Fix reading of init string

Benjamin Herrenschmidt (1):
      SCSI: ibmvscsi: Fix host config length field overflow

Bj=F8rn Mork (2):
      USB: option: blacklist QMI interface on ZTE MF683
      USB: qcaux: add Pantech vendor class match

Dan Williams (2):
      isci: fix isci_pci_probe() generates warning on efi failure path
      SCSI: scsi_remove_target: fix softlockup regression on hot remove

Denys Vlasenko (1):
      coredump: prevent double-free on an error path in core dumper

Flavio Leitner (1):
      serial: set correct baud_base for EXSYS EX-41092 Dual 16950

Greg Kroah-Hartman (1):
      Linux 3.0.45

Ian Abbott (4):
      staging: comedi: s626: don't dereference insn->data
      staging: comedi: jr3_pci: fix iomem dereference
      staging: comedi: don't dereference user memory for INSN_INTTRIG
      staging: comedi: fix memory leak for saved channel list

Jiri Slaby (1):
      TTY: ttyprintk, don't touch behind tty->write_buf

Khalid Aziz (1):
      firmware: Add missing attributes to EFI variable attribute print out =
=66rom sysfs

Larry Finger (1):
      b43legacy: Fix crash on unload when firmware not available

Linus Walleij (1):
      serial: pl011: handle corruption at high clock speeds

Michael Spang (1):
      Increase XHCI suspend timeout to 16ms

Mike Snitzer (1):
      dm: handle requests beyond end of device instead of using BUG_ON

Miklos Szeredi (1):
      vfs: dcache: fix deadlock in tree traversal

Patrick McHardy (1):
      IPoIB: Fix use-after-free of multicast object

Russ Gorby (2):
      n_gsm: added interlocking for gsm_data_lock for certain code paths
      n_gsm: memory leak in uplink error path

Sarah Sharp (1):
      xhci: Intel Panther Point BEI quirk.

Stanislav Kozina (1):
      Remove BUG_ON from n_tty_read()

Stephen M. Cameron (1):
      SCSI: hpsa: Use LUN reset instead of target reset

Wei Yongjun (1):
      can: mscan-mpc5xxx: fix return value check in mpc512x_can_get_clock()

Yinghai Lu (1):
      PCI: honor child buses add_size in hot plug configuration


--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQcaOsAAoJEDjbvchgkmk+Y8UQANZRt+xVj+ucH007m95VskXY
JJeFYNWnnOnPjGMtloCJA1+KuAlCMeGrOYmLDoFv0zQDTAyN8+RqU57KNvx5jpDN
r7kVEtwv+DT597yM1bNaGDrIRDz0uqYSKWs+fwHcwE0yBPVTj/3D5Jukp1tdCCI/
WDmsSTO5PkRydn4c2JuHRlgSy2Yua19qwJOkORJpRd73WyYsk2IWSTBNtPi+K9LA
2b7lhQcbncqc7avQNYws5WkcPA1PEkuygYa0MCZP4yhUb5QmsVLSWnSaD4XdWtW1
Nuk2+FGgA1z/RHCd3t5GiNzMvtQecFptq9rJtuR5tpXO0bSIpvNJ+YbSJLigax4E
j+KHJhLeU+d5SiGLLLPQgnJKLhsnzAmM2FblfJhWOudxzhX/KZfhG3fbGq8OxTSV
bBe0spEzm8z+ntwZQSGp0xIxWbrd368ubdts3ATg/mJpdR+Udh4L00G1tt6Q9QwZ
TsL0U0ROsGhSpkUmo+AK3HN5lt7SjPUErE/aUYdHb9jnCHbX9RwFaQ9GMEu/njPf
FtOvkzCWOMgvWaklYDQD00YEyQZa0SzPyFo1gEJBMqhQjsHkcCwbLq4KrY+x69QS
sAMUZJ7IVP3Mwtg4+6Gkj7XFIqnbsDfEVaQbj7FqV3B5MscYn/R8dH3Ah9HJd5Vh
oVqesunH/1qCNlX10JDQ
=p1KM
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
