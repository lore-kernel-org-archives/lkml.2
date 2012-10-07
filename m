Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2JGPsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:48:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45068 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2JGPr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:47:58 -0400
Date: Sun, 7 Oct 2012 08:47:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.5.6
Message-ID: <20121007154754.GA26443@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.5.6 kernel.

Note, there will probably only be one more 3.5.y kernel release, please
move to the 3.6 kernel branch at this time.

All users of the 3.5 kernel series must upgrade.

The updated 3.5.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.5.y
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
 drivers/hid/hid-core.c                         |   16 +
 drivers/hid/usbhid/hid-core.c                  |    6=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2=20
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   19 -
 drivers/infiniband/ulp/srp/ib_srp.c            |    3=20
 drivers/md/dm-mpath.c                          |   11=20
 drivers/md/dm-table.c                          |   26 +-
 drivers/md/dm-verity.c                         |    8=20
 drivers/md/dm.c                                |   56 +++-
 drivers/mtd/ubi/attach.c                       |    2=20
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
 drivers/usb/gadget/printer.c                   |  128 +++++------
 drivers/usb/gadget/tcm_usb_gadget.c            |   33 +-
 drivers/usb/gadget/tcm_usb_gadget.h            |   14 -
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
 drivers/usb/serial/usb-serial.c                |    3=20
 drivers/xen/xen-pciback/pci_stub.c             |    1=20
 fs/binfmt_elf.c                                |   19 -
 fs/dcache.c                                    |    6=20
 include/linux/pci_ids.h                        |    1=20
 security/yama/yama_lsm.c                       |    2=20
 tools/hv/hv_kvp_daemon.c                       |   45 ++-
 57 files changed, 709 insertions(+), 265 deletions(-)

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

Greg Kroah-Hartman (2):
      USB: serial: fix up bug with missing {}
      Linux 3.5.6

Ian Abbott (4):
      staging: comedi: s626: don't dereference insn->data
      staging: comedi: jr3_pci: fix iomem dereference
      staging: comedi: don't dereference user memory for INSN_INTTRIG
      staging: comedi: fix memory leak for saved channel list

Jiri Slaby (1):
      TTY: ttyprintk, don't touch behind tty->write_buf

Kees Cook (1):
      Yama: handle 32-bit userspace prctl

Kevin Daughtridge (1):
      HID: keep dev_rdesc unmodified and use it for comparisons

Khalid Aziz (1):
      firmware: Add missing attributes to EFI variable attribute print out =
=66rom sysfs

Konrad Rzeszutek Wilk (1):
      xen/pciback: Restore the PCI config space after an FLR.

Larry Finger (2):
      staging: r8712u: Do not queue cloned skb
      b43legacy: Fix crash on unload when firmware not available

Linus Walleij (1):
      serial: pl011: handle corruption at high clock speeds

Matthieu CASTET (1):
      UBI: erase free PEB with bitflip in EC header

Michael Spang (1):
      Increase XHCI suspend timeout to 16ms

Mike Snitzer (2):
      dm mpath: only retry ioctl when no paths if queue_if_no_path set
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

Sebastian Andrzej Siewior (2):
      usb: gadget: make g_printer enumerate again
      usb: gadget: initialize the strings in tcm_usb_gadget properly

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


--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQcaQqAAoJEDjbvchgkmk+CbkP/jfgCnKMA16vjMlvdCb+w1pJ
Hn5SBPvY5g671GsX3YtLVXT5zJtOWN37ulW6mACJEZO97gOJaYz9ln4fHrGH7hgZ
pePP0173v7pUygiOgRx9bLmbCAAwjoHea+mAVV2S7HuI+fBVemFlopR9aZgVp+Ea
H36Nnpi1RVqkE2T0zfXNee2ZF1ixhUV0OnHteyhQMn24pKhm16b8qQzHr39WxpKG
m+gePEkYbcBTVYzAHXosTX1smmRjIcnjDFhACClSYR61UsTrAriPaNFjgTZlU1JW
l9RLrFBv7btYg+hA17LgotigcCTmN2b3jt/bGuKYxa/KgolH45lwdoPbVIfhWZF+
eNVvLDgk4Eg4BQTG1uqkV5gSSiCMzZkcGYyagumMncn3Ou196XuohhQmQ3lG6jms
zT0eyP3xek+Cylg/UzToywN0Q3ZDjesFsNZQkDSkimwWsXCOYxwcpUgGwuaPex8c
46U6LbCjeBq0dP6bUgADkfg1DExIb19OYrXfkl8/VvrTRYz0rbeeS8Pz7AvcWt5J
ulO/8DrFXxIUdTE3+TBdl3TnurLFkr5cNsUGd/yMe6fap5+goLvsCoHp6FbKNm5t
65wJZytjrCAX2t4gCkilGMYhjKEObMwQ86BGbC2ioF1su4lFEjZ/JVKD6kcbiX00
Mv4g9vtwc3LV1I9cGBcu
=OLyo
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
