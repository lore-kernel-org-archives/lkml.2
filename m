Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2JGPqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:46:43 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54784 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab2JGPqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:46:36 -0400
Date: Sun, 7 Oct 2012 08:46:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.13
Message-ID: <20121007154633.GA26382@kroah.com>
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

I'm announcing the release of the 3.4.13 kernel.

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

 Makefile                                       |    2=20
 arch/arm/plat-omap/include/plat/omap-serial.h  |    4=20
 arch/x86/kernel/alternative.c                  |    2=20
 drivers/char/ttyprintk.c                       |    2=20
 drivers/firmware/efivars.c                     |   17 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2=20
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   19 -
 drivers/infiniband/ulp/srp/ib_srp.c            |    3=20
 drivers/md/dm-table.c                          |   26 +-
 drivers/md/dm-verity.c                         |    8=20
 drivers/md/dm.c                                |   56 +++-
 drivers/mtd/ubi/build.c                        |    5=20
 drivers/net/can/mscan/mpc5xxx_can.c            |    4=20
 drivers/net/wireless/ath/ath9k/pci.c           |    5=20
 drivers/net/wireless/b43legacy/main.c          |    2=20
 drivers/remoteproc/Kconfig                     |    1=20
 drivers/remoteproc/remoteproc_core.c           |   22 -
 drivers/scsi/device_handler/scsi_dh_alua.c     |    3=20
 drivers/scsi/hpsa.c                            |    2=20
 drivers/scsi/ibmvscsi/ibmvscsi.c               |    3=20
 drivers/scsi/isci/init.c                       |    1=20
 drivers/scsi/isci/probe_roms.c                 |    1=20
 drivers/scsi/scsi_sysfs.c                      |   30 +-
 drivers/staging/comedi/comedi_fops.c           |    5=20
 drivers/staging/comedi/drivers/jr3_pci.c       |    2=20
 drivers/staging/comedi/drivers/s626.c          |    2=20
 drivers/staging/rtl8712/rtl8712_recv.c         |    5=20
 drivers/staging/speakup/speakup_soft.c         |   13 -
 drivers/tty/n_gsm.c                            |   26 +-
 drivers/tty/n_tty.c                            |    3=20
 drivers/tty/serial/8250/8250_pci.c             |    9=20
 drivers/tty/serial/amba-pl011.c                |   15 +
 drivers/tty/serial/omap-serial.c               |   12 -
 drivers/tty/vt/keyboard.c                      |    3=20
 drivers/usb/gadget/dummy_hcd.c                 |    8=20
 drivers/usb/host/xhci-mem.c                    |    7=20
 drivers/usb/host/xhci-pci.c                    |    1=20
 drivers/usb/host/xhci-ring.c                   |  286 ++++++++++++++++++++=
++++-
 drivers/usb/host/xhci.c                        |   38 ++-
 drivers/usb/host/xhci.h                        |   20 +
 drivers/usb/serial/ftdi_sio.c                  |    2=20
 drivers/usb/serial/ftdi_sio_ids.h              |    5=20
 drivers/usb/serial/option.c                    |    3=20
 drivers/usb/serial/qcaux.c                     |   10=20
 fs/binfmt_elf.c                                |   19 -
 fs/dcache.c                                    |    6=20
 include/linux/pci_ids.h                        |    1=20
 security/yama/yama_lsm.c                       |    2=20
 tools/hv/hv_kvp_daemon.c                       |   45 ++-
 49 files changed, 593 insertions(+), 175 deletions(-)

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

Ben Hutchings (4):
      staging: speakup_soft: Fix reading of init string
      tools/hv: Fix file handle leak
      tools/hv: Fix exit() error code
      tools/hv: Check for read/write errors

Benjamin Herrenschmidt (1):
      SCSI: ibmvscsi: Fix host config length field overflow

Bj=F8rn Mork (2):
      USB: option: blacklist QMI interface on ZTE MF683
      USB: qcaux: add Pantech vendor class match

Christopher Brannon (1):
      tty: keyboard.c: Remove locking from vt_get_leds.

Dan Carpenter (1):
      remoteproc: fix a potential NULL-dereference on cleanup

Dan Williams (2):
      isci: fix isci_pci_probe() generates warning on efi failure path
      SCSI: scsi_remove_target: fix softlockup regression on hot remove

Denys Vlasenko (1):
      coredump: prevent double-free on an error path in core dumper

Elric Fu (4):
      xHCI: add cmd_ring_state
      xHCI: add aborting command ring function
      xHCI: cancel command after command timeout
      xHCI: handle command after aborting the command ring

Flavio Leitner (1):
      serial: set correct baud_base for EXSYS EX-41092 Dual 16950

Greg Kroah-Hartman (1):
      Linux 3.4.13

Ian Abbott (4):
      staging: comedi: s626: don't dereference insn->data
      staging: comedi: jr3_pci: fix iomem dereference
      staging: comedi: don't dereference user memory for INSN_INTTRIG
      staging: comedi: fix memory leak for saved channel list

Jiri Slaby (1):
      TTY: ttyprintk, don't touch behind tty->write_buf

Kees Cook (1):
      Yama: handle 32-bit userspace prctl

Khalid Aziz (1):
      firmware: Add missing attributes to EFI variable attribute print out =
=66rom sysfs

Larry Finger (2):
      staging: r8712u: Do not queue cloned skb
      b43legacy: Fix crash on unload when firmware not available

Linus Walleij (1):
      serial: pl011: handle corruption at high clock speeds

Michael Spang (1):
      Increase XHCI suspend timeout to 16ms

Mike Snitzer (1):
      dm: handle requests beyond end of device instead of using BUG_ON

Miklos Szeredi (1):
      vfs: dcache: fix deadlock in tree traversal

Mikulas Patocka (1):
      dm verity: fix overflow check

Milan Broz (1):
      dm table: clear add_random unless all devices have it set

Ohad Ben-Cohen (1):
      remoteproc: select VIRTIO to avoid build breakage

Patrick McHardy (1):
      IPoIB: Fix use-after-free of multicast object

Russ Gorby (3):
      n_gsm: uplink SKBs accumulate on list
      n_gsm: added interlocking for gsm_data_lock for certain code paths
      n_gsm: memory leak in uplink error path

Sarah Sharp (1):
      xhci: Intel Panther Point BEI quirk.

Sebastian Andrzej Siewior (1):
      usb: gadget: dummy_hcd: fixup error probe path

Stanislav Kozina (1):
      Remove BUG_ON from n_tty_read()

Stephen M. Cameron (1):
      SCSI: hpsa: Use LUN reset instead of target reset

Sujith Manoharan (1):
      ath9k: Disable ASPM only for AR9285

Vikram Pandita (1):
      serial: omap: fix software flow control

Vivek Gautam (1):
      usb: host: xhci: Fix Null pointer dereferencing with 71c731a for non-=
x86 systems

Wei Yongjun (1):
      can: mscan-mpc5xxx: fix return value check in mpc512x_can_get_clock()

xiaojin (1):
      n_gsm.c: Implement 3GPP27.010 DLC start-up procedure in MUX


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQcaPZAAoJEDjbvchgkmk+saMQALYOiApllq6boA2lBZGLvR5p
scuUMof1pBDjoiFc90y0Ls/VzuQcjA51vK0dLaTcLOnZp93IHF9mRoKiS5AVLKzP
kj1izO1qUJcbuE7K9ceWwz78glOlLNoUZwKlLZ8hH8g/lO3WBfLHam9AwUyWIJs/
/ueSFdmjOiOfH/r0Kg7Rku4sWUGpQywl/rQKIiRudrr/73D6lISIWjNiRJC6nEk6
NPTQ6zarUNg8S908hhjg+mNlfhObF1pT8F/5eK99eh9rPyH/K1z93H95hgJ6hng5
Suh+A79w2mncam0gt2q4YmEe5Eu1C0bWfG+1Uewet+zMxq+00h8sc1jHiMatZWR4
mZRkgOjvXufyvoA6mHWyRq+KBAlu9+JaWMP0gB50TfX427/AFDQjwHGokRZXUPJw
P80uOsBuJewiyu44RFoye2+/o0bLMjEzWGOPJE2WocsVMgng7/RsRyIUBKz5LpHi
YAqSLkisKlUMM1qHZw8haDkKd/j6fUk6bI5tFvLn3xYai01+5Jcm09WCbvZFgH8Y
TVO6wXABENdGXuQl38dU/iqvOjmeQX1aSlM7eClFLn55hKAP6YuEtfm71xAJ8TyT
jtIu4Ib39IE8/bq/R+G7SVI9t/0VnJUZQq/pQs6cZ0OWc7y7srHEd2sTXl3+Wn/u
nCiDdnzOLz5snfc0MASu
=AzGi
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
