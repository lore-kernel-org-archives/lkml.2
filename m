Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2KNGdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:33:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51575 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655Ab2KNGdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:33:13 -0500
Date: Wed, 14 Nov 2012 15:33:05 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] regulator: tps65910: fix BUG_ON() shown with vrtc
 regulator
Message-ID: <20121114063303.GD7407@opensource.wolfsonmicro.com>
References: <1352872479-25462-1-git-send-email-anilkumar@ti.com>
 <20121114061913.GB7407@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA6B07A@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13EA6B07A@DBDE01.ent.ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 06:25:15AM +0000, AnilKumar, Chimata wrote:
> On Wed, Nov 14, 2012 at 11:49:14, Mark Brown wrote:

> > This is already applied...  got dropped from -next for a day for some
> > reason but it's there.  When resending please do say why.

> Sorry for the noise (My bad missed the version change details). I have
> checked in regulator/for-next tree and not found, so resend the patch
> thanks for you time.

Sure, no problem - the thing about saying why you're reposting is more
for future reference, if you follow my advice and repost when you think
something got forgotten or lost.

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQozpRAAoJELSic+t+oim9oEoP/j2Cmre7NVwYlrAeahLYk+PB
BfbaB0CQr4G56pFj81eTW2rdD41ap97wQrYDLEEaG8YTBuxXrvZ4EhQuh6kSD36V
2bmVZeYTGIVbAYGu+vBsCmw4jku4lti6a4kl9h70UL83dbnEDIyDqPHGtluNYYEs
nLmMpjleyjtqQH8RGqdtYIUCL7TShfssYRmDwKtxIApxsZBlOnHbh9Vdk45P7yVg
ETLDylzp2UTkBm8Zx/CkCR2dFJVjmG7XhevBUqCSj/b1UzJzl5TM45ykb8/zeJk7
IgnOVozG07hJ0lGG2vJbXtgUyFHQ0YpkrEKQwLqkDlxe3Aebf4QLFSTQ5JTnuHfF
O+e6WugoLOU1DGxMjlbIipvIaYN7Qd5wLDV8MBVpmtPvIAjh2Jrf+4iIlSxExzJa
bBrYRCUwoN9V3HNayP4W1VYe+O4bPqOcOiY4NHDd9ROzWcqt3EBniywZYZzUTy/3
CTrQU1i/KTFgWlTC9WZxDMo/b3UGXgrU/SnF7CrYp8lFM6EQCgLZB8W507lA3Lgw
2irbMx2eBbxofZJik+Nr5+P79qjJGVum9yem286/z9cCdYTtAzPel/YDzK4N6DMl
ylXsz3f0wcNMX6/i9trOF60FjTVipHSoG4WA0W47xpAGtxq0NCZy0vjo0vjhh6RZ
Icp1TnznFA+jMkrwGfqE
=3RRD
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
