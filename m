Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2LQTfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:35:05 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:41359 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2LQTfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:35:03 -0500
Date: Mon, 17 Dec 2012 11:34:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.24
Message-ID: <20121217193459.GA22039@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.24 kernel.

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

 Makefile                             |    2=20
 arch/arm/include/asm/hwcap.h         |    3 -
 arch/arm/include/asm/vfpmacros.h     |   12 ++---
 arch/arm/vfp/vfpmodule.c             |    9 ++--
 arch/x86/kernel/hpet.c               |    4 -
 drivers/acpi/battery.c               |   77 ++++++++++++++++++++++++++++++=
+++++
 drivers/acpi/sleep.c                 |    8 +++
 drivers/acpi/video.c                 |   14 ++++++
 drivers/gpu/drm/i915/intel_bios.c    |   11 -----
 drivers/gpu/drm/i915/intel_display.c |   11 +++++
 drivers/hwmon/fam15h_power.c         |    4 +
 drivers/mmc/host/sh_mmcif.c          |    8 ---
 drivers/pnp/pnpacpi/core.c           |    3 +
 drivers/staging/telephony/ixj.c      |   24 +++++-----
 drivers/usb/class/cdc-acm.c          |   38 +++++++++++++++++
 drivers/usb/host/ohci-q.c            |   19 ++++++++
 drivers/usb/host/xhci-pci.c          |    7 ++-
 drivers/usb/serial/cp210x.c          |    1=20
 drivers/usb/serial/ftdi_sio.c        |    3 -
 drivers/usb/serial/ftdi_sio_ids.h    |    6 ++
 drivers/usb/serial/option.c          |   25 +++++++++++
 drivers/usb/storage/Kconfig          |    2=20
 include/linux/mempolicy.h            |   16 -------
 kernel/rcutree.c                     |   14 +++---
 kernel/trace/ftrace.c                |    2=20
 kernel/workqueue.c                   |    4 -
 mm/dmapool.c                         |   31 +++-----------
 mm/mempolicy.c                       |   22 ----------
 mm/shmem.c                           |   26 +++++++----
 sound/soc/Makefile                   |    5 +-
 tools/perf/builtin-test.c            |   38 +++++------------
 31 files changed, 295 insertions(+), 154 deletions(-)

Alan Stern (1):
      USB: OHCI: workaround for hardware bug: retired TDs not added to the =
Done Queue

Bj=F8rn Mork (1):
      USB: option: blacklist network interface on Huawei E173

Boris Ostrovsky (1):
      x86,AMD: Power driver support for AMD's family 16h processors

Chris Ball (1):
      Revert misapplied "mmc: sh-mmcif: avoid oops on spurious interrupts"

Dan Carpenter (2):
      telephony: ijx: buffer overflow in ixj_write_cid()
      ftrace: Clear bits properly in reset_iter_read()

Dan Williams (1):
      cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)

Eric Dumazet (1):
      rcu: Fix batch-limit size problem

Greg Kroah-Hartman (2):
      USB: mark uas driver as BROKEN
      Linux 3.4.24

Guennadi Liakhovetski (1):
      mmc: sh-mmcif: avoid oops on spurious interrupts (second try)

Jan Beulich (1):
      x86: hpet: Fix masking of MSI interrupts

Jani Nikula (2):
      drm/i915: do not ignore eDP bpc settings from vbt
      drm/i915: do not default to 18 bpp for eDP if missing from VBT

Kamil Iskra (1):
      ACPI / battery: Correct battery capacity values on Thinkpads

Lan Tianyu (1):
      ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.

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

Peter Ujfalusi (1):
      ASoC: dmaengine: Correct Makefile when sound is built as module

Rafael J. Wysocki (1):
      ACPI / PNP: Do not crash due to stale pointer use during system resume

Sarah Sharp (1):
      xhci: Extend Fresco Logic MSI quirk.

Tejun Heo (1):
      workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONC=
E()s

Zhang Rui (1):
      ACPI / video: ignore BIOS initial backlight value for HP Folio 13-2000

Zheng Liu (1):
      perf test: fix a build error on builtin-test

li.rui27@zte.com.cn (1):
      USB: add new zte 3g-dongle's pid to option.c


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQz3PjAAoJEDjbvchgkmk+Q+YQAJMlE4O5lcTbopfo7XlH2upe
Rbw5dvU/BBGiY2t8EIbbj2K7svdNytMTCqlArY87Kn96psWtUxOflrlIIu3ipPHy
epS48aYhHqYNZSOYYS4tcQOn0E5WkwcpN1KIRGMYVzK969yfWV7lgHTfj/nHyr6n
kHsLIlJhXv87Q5yAuZSGKy0FyiPARdigewHisfc6HlPmvOjKb+YgYRQmd3h3RYKy
zgQ4l76JJK4Ke3shljkGUXmtY7K7TFr+BJgwy7kc6VDbNHtQ2vjMjurpzB7Y5pX/
+UPVGODfE9YI4DaD9tHvYwEkheQNKnrXeThepQp3MSHjBxMYgptYDHjp7uu/kpMk
ukH+UXxsrAbFuZU2uNjwwUTpbxtek7x4yDtm0IRq7m5p0dzVpuI9uqy5NKsq7FiW
wLjxEsLtXUx0pQH5ExVDsJwICFpcxj81cbJY+wpIn9WZjvnjN1rOk32vbpPP/Gj+
lG97vz3n5fMsRackLxovWh8fVh3+u4WbQPoLAOWbZPnnL4AoVGta52z69hmUIpF/
RwY5KRHKckJW3fXnp4rd93AA811yRiUlzdmeu6CXCWn8WcnRUmo1BqbAT3SEFROF
WjvyVhkzS1ZVgVPig2FpF/kL3N1HW1ctGKYrLL1h/CkqYIngzYwMtKuAIwHeUvzE
t+/c2wSlsgIFxu2Pw0jG
=jAYn
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
