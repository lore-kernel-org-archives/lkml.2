Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab2LNBrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:47:39 -0500
Received: from ring0.de ([91.143.88.219]:57389 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab2LNBri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:47:38 -0500
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Fri, 14 Dec 2012 02:47:34 +0100
From: Sebastian Reichel <sre@debian.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RESEND PATCH v3 1/6] watchdog: omap_wdt: convert to new
 watchdog core
Message-ID: <20121214014734.GC402@earth.universe>
References: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
 <1352746025-1669-2-git-send-email-aaro.koskinen@iki.fi>
 <20121112224703.GT6801@atomide.com>
 <20121214012336.GA402@earth.universe>
 <20121214013256.GM4989@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
Content-Disposition: inline
In-Reply-To: <20121214013256.GM4989@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Thu, Dec 13, 2012 at 05:32:57PM -0800, Tony Lindgren wrote:
> * Sebastian Reichel <sre@debian.org> [121213 17:26]:
> > What's the status of this patchset? If I'm not mistaken it is
> > neither included in linux-omap, nor in linux-watchdog-next.
>=20
> It should be all linux-watchdog-next with what got merged into
> the mainline kernel today. No more arch/arm/*omap*/ dependencies
> AFAIK.

I can see the dependency fixes, but the driver itself is still using
miscdevice instead of the new watchdog core:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dblob;f=
=3Ddrivers/watchdog/omap_wdt.c;b=3Dmaster

This patch is not needed for using the watchdog on a multiplatform
kernel, but using multiple watchdogs (i.e. twl4030_wdt and omap_wdt)
at the same time. It also simplifies the driver.

-- Sebastian

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQyoU2AAoJENju1/PIO/qaj4YP/06pKztyZeEYd8x2hs7t8Gry
mbyjweisxBHmsyuZcYzKeElb72fzufvTBvsqPwxdD1MkJmnUDpcJslQs1842a8lP
AXl0zKUtED5Zt5xwMYoMFRyVpA80qF1zs1er2/cn2k6IlRfHpGne3yz3Od/f47nw
mCnrqv7PG09jtQODP7Pf2O0JsnzgHH8EWvVuuxu9qFmo3mydVTHuiQLsv/u9SFUg
NmFSIVupkRA4llJIxuZQ7FgXUsOKRObcUrezq1p23FXH7ytl1AT4CHza/zRWkzev
xThsxOSgydcHxwjhuQMTyPlIzZ993TX/8EWnQMidMDbSG82xFtGbUGbsd05dYWZP
oCpFIdd4BpJj/JwXLh8IIQNChsWGYXuGrTWAYF9SX1C4CBkhtlCy/quzuOD4cw4m
jQss9NRi9fd1VgOm+1ig8Z9qn1UONZPEYnHl7tDP6Vgf8BtUmZojsmXoKrTFtk69
UPSG8a9qMOBXAPhYDTWziwcVd6OQBekJQ8nRtlLuvE6B8kPwoH3QQmwRNyhStpZe
jwbznziC1fMwTQ7vipp4NvBupph88ZrJo4lo6HwA4itYzAaBVwR0tYAtlIIpF6EA
LPM8r6xFcgVY8l86GvQTrfsBIjuS+Bvp8B2ZbfG8Je1N4HMbnHge5GvI8CRBOOf2
EiYvn7rNLCooQ3EqQxsz
=Untw
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
