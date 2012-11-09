Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2KIP2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:28:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:63488 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab2KIP2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:28:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,746,1344236400"; 
   d="asc'?scan'208";a="246533429"
Message-ID: <1352474951.1814.40.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] dma: add new DMA control commands
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: Marek Vasut <marex@denx.de>, Vinod Koul <vinod.koul@linux.intel.com>,
        djbw@fb.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, cjb@laptop.org, dwmw2@infradead.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Huang Shijie <shijie8@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Date: Fri, 09 Nov 2012 17:29:11 +0200
In-Reply-To: <507FBDF1.5050602@freescale.com>
References: <1350538335-29026-1-git-send-email-b32955@freescale.com>
	 <201210180914.58527.marex@denx.de> <507FB495.7050104@freescale.com>
	 <201210181016.06782.marex@denx.de> <507FBDF1.5050602@freescale.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1Ho9I/5vx63xnID433oO"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1Ho9I/5vx63xnID433oO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-18 at 16:29 +0800, Huang Shijie wrote:
> =E4=BA=8E 2012=E5=B9=B410=E6=9C=8818=E6=97=A5 16:16, Marek Vasut =E5=86=
=99=E9=81=93:
> > So we can't stream data from the chip? About time to adjust the MTD fra=
mework to
> > allow that. Maybe implement a command queue?
> >
>=20
> to Artem & David:
>     is this possible to stream the data out with a command queue?

Well, I think there was no HW which supported reading multiple pages
with DMA before, are your sure yours support this? Usually reading a
NAND page consists of 2 phases - loading the NAND array contents to a
controller buffer, and then copying that to RAM. And the second part is
something people sometimes do with DMA, AFAIU.

If your HW supports this, sure the MTD framework can be re-worked. Or
you may write your own 'mtd->_read()' / 'mtd->_write()' implementation.

--=20
Best Regards,
Artem Bityutskiy

--=-1Ho9I/5vx63xnID433oO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQnSFHAAoJECmIfjd9wqK0GowP/jz3M70GMjElaOIdPUtV+TZf
UlaiLpjwY5JNIa/2J5OHP8JA7mEsaG9QXFPHkHXbc0hdNODY1R/+l1db82JPH1WL
9Fw3ka9+9HuZ5m4OEm4XkWH9e8eodM6Ixm0mYok5yzKdQ+ToHnacaS92z6mIdH5T
SBZtH1+Lh7bRzdVDY9MlwlmrCoQ+aUx4Du1NKyXE2bh8zoEc5Z2t6URd6gT8bbWC
7OelYPHKbKIIsAgSNYpoNFjnX0zdLWHU4UT2nS8ES7bz7TR47HHCHZVKBwK7R5P5
UFqBNA7uufMRNuyAGM1/REtfIdtvcphEJZGlPWwQnN89Hu3oPZCCJn4rBUHnCiiK
aPKeOQI4QrzxcnUjvkmpgAvaLrxWpKLNWDxzCYaXBmUvxSl/LcLgMtOBXbHtaaA/
lt2DX7E8qpyWVznf+xlT+oMMHLzvcFk3yz5fM6wGkMpxogHRRf1bTUZJqx6HH0wF
mJWyp1vSr66RUMb0s2ThRrTx/AaCBWxAIuaD3laId024p89tADeu9KLOrV7V1Qvs
msZSb5D/P5laJyiaFkUP+pA23xP27sfzvascsF56ArwX1UvDL5ZI46HMBMFc4zRb
sHhGI8FO5IOum5GcfEW5ABvS0WvN8G1bIP8yy/405UutCnkC/puzQiKTvCgv/AC3
26iBTNS6y+1KA3BwgAm8
=ZOe9
-----END PGP SIGNATURE-----

--=-1Ho9I/5vx63xnID433oO--

