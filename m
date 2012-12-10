Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2LJTrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:47:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2LJTrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:47:17 -0500
Date: Mon, 10 Dec 2012 11:47:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.23
Message-ID: <20121210194705.GA19757@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.23 kernel.

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

 Makefile                                         |    2=20
 arch/arm/Kconfig                                 |    1=20
 arch/arm/mach-dove/include/mach/pm.h             |    2=20
 arch/arm/mach-dove/irq.c                         |   14 +
 arch/arm/mach-kirkwood/pcie.c                    |   11 -
 arch/x86/include/asm/fpu-internal.h              |   15 +
 arch/x86/kernel/smpboot.c                        |    5=20
 drivers/acpi/processor_driver.c                  |    1=20
 drivers/edac/i7300_edac.c                        |    8=20
 drivers/gpu/drm/i915/intel_lvds.c                |   16 +
 drivers/gpu/drm/radeon/evergreen.c               |  191 +++++++++++-------=
-----
 drivers/gpu/drm/radeon/evergreen_reg.h           |    2=20
 drivers/gpu/drm/radeon/evergreend.h              |    7=20
 drivers/gpu/drm/radeon/radeon_asic.h             |    1=20
 drivers/md/raid10.c                              |  100 ++++++------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   11 -
 fs/nfs/blocklayout/blocklayout.c                 |  176 ++++++++++++++++++=
+--
 fs/nfs/blocklayout/blocklayout.h                 |    1=20
 kernel/sched/auto_group.c                        |    4=20
 kernel/sched/auto_group.h                        |    5=20
 kernel/workqueue.c                               |    4=20
 mm/memory-failure.c                              |    8=20
 mm/sparse.c                                      |   10 -
 scripts/package/buildtar                         |    2=20
 24 files changed, 406 insertions(+), 191 deletions(-)

Alan Cox (1):
      ACPI: missing break

Alex Deucher (3):
      drm/radeon/dce4+: don't use radeon_crtc for vblank callback
      drm/radeon: properly handle mc_stop/mc_resume on evergreen+ (v2)
      drm/radeon: properly track the crtc not_enabled case evergreen_mc_sto=
p()

Ariel Elior (1):
      bnx2x: remove redundant warning log

Calvin Walton (1):
      i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard

Chris Wilson (1):
      drm/i915: Add no-lvds quirk for Supermicro X7SPA-H

Greg Kroah-Hartman (1):
      Linux 3.4.23

Jason Gunthorpe (1):
      ARM: Kirkwood: Update PCI-E fixup

Jean Delvare (1):
      i7300_edac: Fix error flag testing

Jianguo Wu (1):
      mm/vmemmap: fix wrong use of virt_to_page

Michal Marek (1):
      kbuild: Do not package /boot and /lib in make tar-pkg

Mike Galbraith (2):
      workqueue: exit rescuer_thread() as TASK_RUNNING
      Revert "sched, autogroup: Stop going ahead if autogroup is disabled"

Naoya Horiguchi (1):
      mm: soft offline: split thp at the beginning of soft_offline_page()

NeilBrown (1):
      md/raid10: close race that lose writes lost when replacement complete=
s.

Peng Tao (1):
      pnfsblock: fix partial page buffer wirte

Russell King - ARM Linux (2):
      Dove: Attempt to fix PMU/RTC interrupts
      Dove: Fix irq_to_pmu()

Vincent Palatin (1):
      x86, fpu: Avoid FPU lazy restore after suspend


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxjw5AAoJEDjbvchgkmk+ec8QAIyl0MWrlesWdTh1j51eOTBZ
X+R5JixIjFRgpzBT2d0DmcWKXjS2WakXhuts5KNKtOyobPxoXzT1Wbs7ZBjfrBhw
Jqmvlh4j9oq9HL+DSHjFjQi3z4g7skcGx05az/vWFRR5W8Ti75bTedcvJNwYLHZf
N21ZrkpgTDeLYbC0tmH4lM6BjE9OD82A4YEplmwQRHT+580bxDzAlBQFUEKH+Kp9
hq7nhcyHm0xjqMqHrNfJd6KzANzzbe3lTDhrVImdBdIxcG58FTKvsRpwpd0RA8g4
pooHITqCAwW/oGfmPpttcmhE7Wfx2vJFkS9sEx/tXWH5LRcJ+NcGDFEbTAz7MBGF
TdDtEmRy52tIRm1xZ2q3W5HaKkHzsDhldQvZPK0yE6uwbzy2FgnLuFpQIy2Fde8C
xH7eiSrFQnk2932ip4Z8kSW78vn1e00wuxQXLiQMtCnTgKBMCbbEDTeXPEpTixWb
+1ELOUaYP+fwgnAkEUyvPxleSbouGOiMTERcyR6G8TwHkwveH7i9JjsybIkqZPKT
7g8toePFBX/UjksZYHeNlCu4lD/o8dMXqeAF++2qxMbJx1szDttTPWrad5UDg3/Z
69o8HLQBK9YmTzBIGGib+nVvjJTzC0aONLAakOcvUsg4wi5gc0iQEpx3g2p/GowA
vjChEorasJjILhJC1A4b
=Oadc
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
