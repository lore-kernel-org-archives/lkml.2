Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2HESEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 14:04:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45657 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796Ab2HESEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 14:04:39 -0400
Message-ID: <1344189872.13142.2.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.26
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Sun, 05 Aug 2012 19:04:32 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Xjz3neIFHsMzaJAKVwgc"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xjz3neIFHsMzaJAKVwgc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.26 kernel.

This has a single fix for a build regression on x86 non-SMP
configurations in 3.2.25.  If 3.2.25 works for you, there is no reason
to upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Makefile                             |    2 +-
 arch/x86/include/asm/processor.h     |    2 --
 arch/x86/kernel/amd_nb.c             |    8 ++------
 arch/x86/kernel/cpu/amd.c            |    2 --
 arch/x86/kernel/cpu/common.c         |    5 -----
 arch/x86/kernel/cpu/intel.c          |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c     |    2 --
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    5 +----
 arch/x86/kernel/cpu/proc.c           |    4 +---
 drivers/edac/sb_edac.c               |    2 --
 drivers/hwmon/coretemp.c             |    7 +++----
 11 files changed, 8 insertions(+), 33 deletions(-)

Ben Hutchings (1):
      Linux 3.2.26

Kevin Winchester (1):
      x86: Simplify code by removing a !SMP #ifdefs from 'struct cpuinfo_x8=
6'



--=-Xjz3neIFHsMzaJAKVwgc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUB61sOe/yOyVhhEJAQoVZQ/7BBIbMKE4S+4QBfiEe0FboeLLxsLCWYU6
5IvcjVdHrzZbor5dRS0H8w6I/gGcByEv2dP5GYLbc1TP3TOKIvAdkUDVDwlgl/zG
nw95fqcmnGLQ/cskGd1yqS6KhALgRl7/gHSunF62w09zGO/Ho5ZSMl3RSUFZC62H
WCsh45dl8lvBCrh/VkD4qwsF5lzufAZ5HA+HxC6FCXVWIpxG2EpnvpTbMzxCwqoP
5jcwACTxIVczPDF2BhUrQHj7cBNhuPTcnR+2BLfV+mp3jI6O2qSo5Ah2vU7Jmaek
9cX+SWvBjxOVbo06kk4BphX+0QzsqSOIIFXK16HmFmaTMPL3VghPI6NZDn086J1p
XgR/AGxbtteqhJOjJO5EdoZa6ZSek9V72BgRFeTvDtftPQ9F3KR4E8JRpK8fMRby
x97kO3TXO+QMtIzwYrD/iP+/4TY6KHI364cA24QqhDvWAIXY4wiXCdoJdsBYG/UT
ubxR0c1Oct93Js1mAyhB3hGOvBYLTI4OSUODuQXtpPHl7HNePFfmOpT+iWlCy8mQ
Kijhxkr8Q06eoS+DYqg4WLGxPRki17KHrRhMtD1esI7w93QRZRFx1HHMV1DVAYs2
rKQHqJN96h13066ot95Ql08csgGygyiOoJ0s5XR3HweVJTwxJbAAJ3ZW+5sTcoGy
pZCa/cm9UpA=
=KBVJ
-----END PGP SIGNATURE-----

--=-Xjz3neIFHsMzaJAKVwgc--
