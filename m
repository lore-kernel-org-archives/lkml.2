Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688Ab2FEKPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:15:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40910 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756394Ab2FEKPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:15:16 -0400
Date: Tue, 5 Jun 2012 11:15:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max8649: fix missing regmap in rdev
Message-ID: <20120605101514.GK23408@opensource.wolfsonmicro.com>
References: <1338891010-24805-1-git-send-email-haojian.zhuang@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mGCtrYeZ202LI9ZG"
Content-Disposition: inline
In-Reply-To: <1338891010-24805-1-git-send-email-haojian.zhuang@gmail.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mGCtrYeZ202LI9ZG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 05, 2012 at 06:10:10PM +0800, Haojian Zhuang wrote:
> In probe(), rdev->regmap must be assigned.
>=20
> Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Applied for 3.5, it's not needed in -next as the regulator API will do
the lookup automatically from the device.

--mGCtrYeZ202LI9ZG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzdwoAAoJEBus8iNuMP3dlAgP/2lzSAGTAzZKKTU2pYowiw2w
uP3I3p/PzGTh3zHsDYlYULBLj2aYo+OnW+EiSHvC48tzT6Edsq/Mj8LSO/dJtrql
rG+nA98WNSOwkvM9wKnGA+I2zvnEuVbG9eNDhUD4emxeQA+6fovFdBKCt+f/E3U9
B1M6OAjqZmOgbZeDg4XC4CIANJq/e8xpRFGwsXIaxmdqffdzVpH9PDR0OHNyPdzk
VEerDCUGM7tSD6Uzw91w/jCJg14ftQBsKnsyZ0vKugWIwFz5cftkY0YgMvVCyRme
yGHcNw8mbGWJ7+xcpkYsLePN5IxGOe5NnNcnTslnmzesAwZuQlVNGqGCBAhopVpd
XWn8Ag+GrhZGxpJBu+vech4C+eEM9GBGVRdfUs4crx4EqxMd4pJDJoYHqtUxnu7z
ptEbwKbgS9jGgAHyDrsErG/kMkhEWlmeGKh6O9/PrzRBgsEBJvFCSvEm/OaoAxR0
6lBBdaRnSvfGEAjUSpZJnthb4iX0uBZ5DtxU9nP68QkYd/2sR3N0g0V0NpdL8wvj
Uj0iSCow13ANmT/Csz1OmxPFdMNIvyDN214md8cT7Y/vXh1wCjS0x11xcNrtR1OW
6bHYb2iZsi/zxWi+GCtg30PB8mSfGY7kGaEE5Y9QJlw/lrKYZhQTWK9H2w12x09K
mZfi9UrplA/0Dp0dbJYF
=/9s/
-----END PGP SIGNATURE-----

--mGCtrYeZ202LI9ZG--
