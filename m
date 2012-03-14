Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2CNOKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:10:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53286 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932278Ab2CNOKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:10:31 -0400
Date: Wed, 14 Mar 2012 14:10:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: s5m8767: Check pdata->buck[2|3|4]_gpiodvs
 earlier
Message-ID: <20120314141019.GO3133@opensource.wolfsonmicro.com>
References: <1331340182.18199.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lLR1BQqf7txDtYcF"
Content-Disposition: inline
In-Reply-To: <1331340182.18199.3.camel@phoenix>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lLR1BQqf7txDtYcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 10, 2012 at 08:43:02AM +0800, Axel Lin wrote:
> If we need to ensure only one of the buck[2|3|4]_gpiodvs can be specificed,
> check them earlier.

Applied, thanks.

--lLR1BQqf7txDtYcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYKa/AAoJEBus8iNuMP3dSzUP/jbCnKYc04utzi0UGY8qIfzH
4vUUwZ3Rb0Qp3wDKnN0+cChPTvDPXBq7rsUbEPqdK9B7zQEiVylVsrGpw2cMi4q3
zLRSBVuEjLtfMtPXrLnDniwsJhHRWhobKglbQn5mIUrRVFavydngOw7Jz/HCf+51
uWv8qnecEIr385iy8MN3R9eI0w0Sfj7KjA5WVOAQGPlZM5eLAyy3NXIck6AuzpLi
lRmg4OQXo9ozTr5uAoSpfm8+CB2EJA9iwkDPeoHDFkcIBs9ZaLwvZH5LELyrzK3S
pvC5dcxNmUxvUSJBqYeDJjG3y4Am5/l5juEY+YeldeQZiM/uh4xpXXh5BXV2b1W+
ZfNsGXyjmEzIpUX01MhNP8MfYzWmpWoRsbhLfC9rgNhH1jUHW8y/u8DaYdiwvaiU
38naJ4KZCRlUvC+mEDElbrcR1kiJpWnvwrRCK4DaKecaFlWi35kCv1Qj4MnW0wxd
DTR5zxiEyTAQ7YFTAem0gRov/UuzTqszzJapXOn/p7fj7XyXVYxuLYUj7lWNmofY
kKibfAUcexEBN1VsjV3qALYvarZmjtI0VJpbM2b5eIJ8HFYk008jrTecmf3ExmlS
ybSdgAYGbMIGYCOfd2o/JX6INvD2pJ9727vka7C8hF4lqOxCC+bN4gfg163cPebk
nR867UJr+4qdMCUYqo5W
=UPt/
-----END PGP SIGNATURE-----

--lLR1BQqf7txDtYcF--
