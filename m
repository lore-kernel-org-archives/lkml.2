Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab2EGOWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:22:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40018 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756179Ab2EGOWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:22:50 -0400
Date: Mon, 7 May 2012 15:22:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 4/4] regulator: tps62360: Provide settling time for
 voltage change
Message-ID: <20120507142245.GF17002@opensource.wolfsonmicro.com>
References: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
 <1336376139-1048-5-git-send-email-ldewangan@nvidia.com>
 <20120507112321.GI4415@opensource.wolfsonmicro.com>
 <4FA7C31C.7000309@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hUH5gZbnpyIv7Mn4"
Content-Disposition: inline
In-Reply-To: <4FA7C31C.7000309@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hUH5gZbnpyIv7Mn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 06:12:04PM +0530, Laxman Dewangan wrote:

> Yaah, I should put the stylistic change at end..
> I will send next patch for enabling cache and settling time.
> Will keep discussion on stylistic changes and so will remove that
> from this series.

TBH I'd probably apply the style change if the regmap bit were using
static inlines, though I'm not a big fan and wouldn't be happy with it
in any consumer side code that I actively work on.

--hUH5gZbnpyIv7Mn4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp9qpAAoJEBus8iNuMP3dRDUP/2giMDulo5vA9TzzrZJ+zYdV
DPH+m+L0NpyIzKM9slxiBhOZnHmQnehdOUUzmIMiW/W/8mImRK8UypZXd/Q8NZCt
+H58ouTMjn6SFYvoIAr5xUrh5smkJJ39KjcqfXq3Ae663GhavGTKLpVvNLhA/ixA
JH0xJ8b2Fp7ZNMvSUNDcy4yj/7dtfOcelfFdHnqwE6PVf7WjYSCIF1dQw0ongrfz
Ig/mWhjO10bXR84F6HYCHexBIzt63BitX44rUEf7anXq/ODZqfN8TwvdMBLzr0If
HAIIuU7ZxKQ7Ej15bxZTfUEJ7IVyyn3NLZaIoLX2ltocaYaDvOoIV+e/vc13m2tT
HdHsQlpao9lIlCHXZqLh9VBadjoxJX5u0svaIpXfXxCvUyZyuUTUGPDc7/OHFu+r
kaK9a2+8wuVdP8P8Yzcm1eC+FzMD/7lf5S6LVsbOI9DBeAP5MsRUl4VjsJzpHoAz
461aC+nQRrHf7mIhgbhhO+Je+8olDoL4YgkXfu1cEGwqW/i1w1Abk+R+Zvk2ogIz
m2v5itv23mwEWGjgpL8zPjre3Q24oc0zuNSZ8pzMXy28LGYK4oGsFIiDcZiIFcYW
qudrJzYIHkDkzmsUqBFQxM5s4wSuebaqtYsOlcZVsZv97biIuuwtOLWU6TIUhwWn
E45CkVyUMc0/K631HiJM
=hsu4
-----END PGP SIGNATURE-----

--hUH5gZbnpyIv7Mn4--
