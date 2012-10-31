Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab2JaRfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:35:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61873 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2JaRfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:35:03 -0400
Date: Wed, 31 Oct 2012 10:34:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.50
Message-ID: <20121031173459.GA12769@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.50 kernel.

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

 Makefile                                     |    2=20
 arch/arm/kernel/smp.c                        |   14 +++--
 arch/arm/mach-at91/at91rm9200_devices.c      |    2=20
 arch/arm/mach-at91/at91sam9260_devices.c     |    2=20
 arch/arm/mach-at91/at91sam9261_devices.c     |    2=20
 arch/arm/mach-at91/at91sam9263_devices.c     |    2=20
 arch/arm/mach-at91/at91sam9rl_devices.c      |    2=20
 arch/x86/mm/init.c                           |   69 +++++++++++++++-------=
-----
 drivers/bcma/main.c                          |    5 +
 drivers/cpufreq/powernow-k8.c                |    9 ---
 drivers/gpu/drm/i915/intel_lvds.c            |    8 +++
 drivers/rtc/rtc-imxdi.c                      |    2=20
 drivers/staging/comedi/drivers/amplc_pc236.c |    2=20
 drivers/usb/core/hub.c                       |    7 +-
 drivers/usb/host/pci-quirks.c                |    9 +++
 drivers/usb/host/xhci-ring.c                 |   11 ++++
 drivers/usb/serial/mos7840.c                 |   30 +----------
 drivers/usb/serial/opticon.c                 |   11 +++-
 drivers/usb/serial/sierra.c                  |   26 +++++++---
 drivers/usb/serial/whiteheat.c               |    1=20
 drivers/usb/storage/unusual_devs.h           |    6 ++
 drivers/vhost/net.c                          |    3 -
 fs/compat_ioctl.c                            |    2=20
 fs/sysfs/dir.c                               |   16 +++---
 lib/genalloc.c                               |    2=20
 net/mac80211/wpa.c                           |    3 -
 net/sunrpc/xprtsock.c                        |   41 +++-------------
 usr/gen_init_cpio.c                          |   43 +++++++++-------
 28 files changed, 180 insertions(+), 152 deletions(-)

Andreas Herrmann (1):
      cpufreq / powernow-k8: Remove usage of smp_processor_id() in preempti=
ble code

Anisse Astier (2):
      ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS vers=
ions
      ehci: Add yet-another Lucid nohandoff pci quirk

Bo Shen (1):
      ARM: at91/i2c: change id to let i2c-gpio work

Geert Uytterhoeven (1):
      sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

Greg Kroah-Hartman (1):
      Linux 3.0.50

Ian Abbott (1):
      staging: comedi: amplc_pc236: fix invalid register access during deta=
ch

Jacob Shin (1):
      x86, mm: Find_early_table_space based on ranges that are actually bei=
ng mapped

Jan Luebbe (1):
      drivers/rtc/rtc-imxdi.c: add missing spin lock initialization

Johan Hovold (9):
      USB: whiteheat: fix memory leak in error path
      USB: opticon: fix DMA from stack
      USB: opticon: fix memory leak in error path
      USB: sierra: fix memory leak in attach error path
      USB: sierra: fix memory leak in probe error path
      USB: mos7840: fix urb leak at release
      USB: mos7840: fix port-device leak in error path
      USB: mos7840: remove NULL-urb submission
      USB: mos7840: remove invalid disconnect handling

Kees Cook (2):
      gen_init_cpio: avoid stack overflow when expanding
      fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

Lennart Sorensen (1):
      USB: serial: Fix memory leak in sierra_release()

Michael S. Tsirkin (1):
      vhost: fix mergeable bufs on BE hosts

Michael Shigorin (1):
      usb-storage: add unusual_devs entry for Casio EX-N1 digital camera

Octavian Purdila (1):
      usb hub: send clear_tt_buffer_complete events when canceling TT clear=
 work

Piotr Haber (1):
      bcma: fix unregistration of cores

Sarah Sharp (1):
      xhci: Fix potential NULL ptr deref in command cancellation.

Sjoerd Simons (1):
      drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13

Stanislaw Gruszka (1):
      mac80211: check if key has TKIP type before updating IV

Thadeu Lima de Souza Cascardo (1):
      genalloc: stop crashing the system when destroying a pool

Trond Myklebust (4):
      SUNRPC: Get rid of the xs_error_report socket callback
      SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT
      Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
      SUNRPC: Prevent races in xs_abort_connection()

Will Deacon (1):
      ARM: 7559/1: smp: switch away from the idmap before updating init_mm.=
mm_count

Yinghai Lu (1):
      x86, mm: Undo incorrect revert in arch/x86/mm/init.c


--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQkWFDAAoJEDjbvchgkmk+nQEP/R0fNP6P677sOOUNlXLSFRp7
aDmSbiJEVGz2yddvWmLMQNf3FuReBV/fAEe2CDQRhEprXGmc/x/X/zicLePektE1
r0YrY2ksTt3gXjgrp8GfkldpHLBoUdwcWQ8U/MaMAhJjH8CAE9RcugMac89SPOYf
uQsFRe3aPEoqwMOlhd/U0ttqLHZRTlSauj1e8VFKW2APNLTHsj3DFxQeG4TEPZ5M
lXGrzNCGVmm85tZkK75L389fUqj3WR6Ehug/nd5Vzj0zmq4xSE4GqZuLi716lMff
2TIucHK2tGuVqR85P/V2A8LGEXmS9nSWRHDS+PEW5wQGMCcKMdLW9WnxRHUAkHOZ
qFMYLKmFiEjHzxag2D1umXxwzsXxr1mSMvzPbXYwbLqgL9SLBmR1ZKqu1/0PVxIs
5UsOQ5Hqs12TjL40ezhl1EH47wXvN63nZqwM9OE2QVfs1hkMEnqIUq7wBfiQntGl
WfuUq01EaESj4x4kAa4imLVoF6/aaZRymtlBW5JLjOHu55S4bu07SlBW6kEdZpJV
JpapBd+emAn+bay74K7TwQ/7Bblx0KCheNvPOnNuzsB8394fx7OPaNisv3sIFC+P
doYOn3fYFo4m3kXIEnjc2BTVQZGYhOux6yfpgh1iQ+1Gk4qCJLtKjE5pcgJH3dyC
lNxfNw0yeaxRstQ4gaIT
=lxPp
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
