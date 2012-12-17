Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2LQTeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:34:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37965 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2LQTe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:34:29 -0500
Date: Mon, 17 Dec 2012 11:34:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.57
Message-ID: <20121217193424.GA21978@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.57 kernel.

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
 arch/arm/include/asm/hwcap.h      |    3 -
 arch/arm/include/asm/vfpmacros.h  |   12 ++---
 arch/arm/vfp/vfpmodule.c          |    9 ++--
 arch/powerpc/kernel/ptrace.c      |   18 ++++++--
 arch/powerpc/kernel/sysfs.c       |   10 ++++
 arch/powerpc/kernel/traps.c       |    3 -
 arch/x86/kernel/hpet.c            |    4 -
 drivers/acpi/battery.c            |   77 +++++++++++++++++++++++++++++++++=
+++++
 drivers/acpi/video.c              |   14 ++++++
 drivers/hwmon/fam15h_power.c      |    4 +
 drivers/pnp/pnpacpi/core.c        |    3 +
 drivers/telephony/ixj.c           |   24 +++++------
 drivers/usb/host/ohci-q.c         |   19 +++++++++
 drivers/usb/host/xhci-pci.c       |    7 ++-
 drivers/usb/serial/cp210x.c       |    1=20
 drivers/usb/serial/ftdi_sio.c     |    3 -
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++
 drivers/usb/serial/option.c       |   25 ++++++++++++
 drivers/usb/storage/Kconfig       |    2=20
 include/linux/mempolicy.h         |   16 -------
 kernel/trace/ftrace.c             |    2=20
 kernel/workqueue.c                |    4 -
 mm/dmapool.c                      |   31 +++------------
 mm/mempolicy.c                    |   22 ----------
 mm/shmem.c                        |   22 ++++++----
 26 files changed, 235 insertions(+), 108 deletions(-)

Alan Stern (1):
      USB: OHCI: workaround for hardware bug: retired TDs not added to the =
Done Queue

Anton Blanchard (2):
      powerpc: Update DSCR on all CPUs when writing sysfs dscr_default
      powerpc: Keep thread.dscr and thread.dscr_inherit in sync

Benjamin Herrenschmidt (1):
      powerpc/ptrace: Fix build with gcc 4.6

Bj=F8rn Mork (1):
      USB: option: blacklist network interface on Huawei E173

Boris Ostrovsky (1):
      x86,AMD: Power driver support for AMD's family 16h processors

Dan Carpenter (2):
      telephony: ijx: buffer overflow in ixj_write_cid()
      ftrace: Clear bits properly in reset_iter_read()

Greg Kroah-Hartman (2):
      USB: mark uas driver as BROKEN
      Linux 3.0.57

Jan Beulich (1):
      x86: hpet: Fix masking of MSI interrupts

Kamil Iskra (1):
      ACPI / battery: Correct battery capacity values on Thinkpads

Marek Szyprowski (1):
      mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls

Markus Becker (1):
      USB: cp210x: add Virtenio Preon32 device id

Martin Teichmann (1):
      USB: ftdi_sio: Add support for Newport AGILIS motor drivers

Mel Gorman (1):
      tmpfs: fix shared mempolicy leak

Paul Walmsley (1):
      ARM: 7566/1: vfp: fix save and restore when running on pre-VFPv3 and =
CONFIG_VFPv3 set

Peter Korsgaard (1):
      usb: ftdi_sio: fixup BeagleBone A5+ quirk

Rafael J. Wysocki (1):
      ACPI / PNP: Do not crash due to stale pointer use during system resume

Sarah Sharp (1):
      xhci: Extend Fresco Logic MSI quirk.

Tejun Heo (1):
      workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONC=
E()s

Zhang Rui (1):
      ACPI / video: ignore BIOS initial backlight value for HP Folio 13-2000

li.rui27@zte.com.cn (1):
      USB: add new zte 3g-dongle's pid to option.c


--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQz3PAAAoJEDjbvchgkmk+/N4QAIm+iizZzPywnpLbMPnu748w
ajdNGxti7OVw4qYmquzdPlylPkmrSy85/1q2BeZF5y8DBxVHcXMpy69IJVNSERPH
kPR5cVPtds8WyLr2PQB3ZNxc3tXHun738tXieTqK6z1alBsNkbRajeaGvJyA20rI
C4kqJ9RnB50ajUocuTlkKDDGhd4qK3yo2YamOlR4z/8cMC7/UD1rhJtq6QFkCLXB
Pov00NmodE5J2JPV3xtJnTVevQw+Oo59tfzfwjiIpgjN9D4DFRV916EFZsxaNCs/
WCUBOpNm3PRf00TDNo+59TKzvjdz7N0wyAjittluXUS2RQwZ3JhKw8GRst57vwSe
t8nIQO9OhdPADW6k+XWzl1CCmnKaF4t7JCGluMzN1+66ZPro7D0mo4ogj9dJkCEw
98N7y3hSGuTzfauYbY4/lzYUn8qODn/w+PZL4YOpkzJ9QMqdefWvpIXB7UeAalY3
BeVFj5m9Md6rHqV5cYfgKC9+jQ/2P2ydrjcKLArbJV+z2Wz+5qNr0HPOTuZf5fRK
N4VBxC0S5SaCv+qolxX3paNGx7ixR+mP2Gn4cs2QIyNlmQ4g0HvPLESswrC9OfBa
kCf3G2LhlVw7UiFWztOpT0E9G4lJ1i5UmyF5WbASTc1KGeIcVofjKvmSaujHkspb
/yU1GnTpHG7PCtx9Ewc3
=VWhR
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
