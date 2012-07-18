Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2GRJpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:45:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37644 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab2GRJow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:44:52 -0400
Date: Wed, 18 Jul 2012 10:44:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: rdunlap@xenotime.net, sfr@canb.auug.org.au, sameo@linux.intel.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] regulator: tps65217: fix build error if REGULATOR is not
 enabled
Message-ID: <20120718094449.GA22739@opensource.wolfsonmicro.com>
References: <1342593663-23938-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <1342593663-23938-1-git-send-email-anilkumar@ti.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2012 at 12:11:03PM +0530, AnilKumar Ch wrote:
> Fixes below build error if CONFIG_REGULATOR is not enabled.
>=20
> drivers/built-in.o: In function `tps65217_probe':
> tps65217.c:(.devinit.text+0x13e37): undefined reference to `of_regulator_=
match'

This isn't a patch to the regulator driver, this is a patch to the MFD.
Normally this would be fixed by making the MFD driver not depend on the
regulator API - why is the MFD driver using the regulator API?

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBoV8AAoJEBus8iNuMP3dVXwP/1pxnlpS8W3n3KZbkYvTAQDb
1yDP1EbGKF2CaEUrhop4tAQrEnnVW9YDTa7c4sjq2978q2Y1AcUeJeiZquHonhjR
MvIlgO2WpAm+waRpk7CV5C3kGVdDxe8N6E7+rUrV2ghlrAGf9oLJWqudsWWbmRfS
qls9qgnaQXY1HYH9yUZYgqF9//OSEIsCxdEG6G/AKxBj4Fka7FxfqtgewdSBbFxk
AtoG0s/ywGDjw4A8iOKP9TevzIJ9XL7Rf9qFvE/JQ1Eywh12qyFy6qVgq4+tAMgm
oHno1unLROEkc93nlNYQKWgKO90bbM5Hgo4NVId+JuEdZcQ73ZfB5h9B0dE28yVu
4haPIPaiev+5B0ERF29W/uEJRV6gY0IHoJGfbsBdEHG5oqG7hKlYEBeW8DnOtxAZ
IG0tGZKzVUi3Z/QydGBUtAuwTC4OOStVPRjVTQd7hvsAIrDX4rE1x7XveAOIiS7D
WbggLKZH93pI232997o+gb8bcodT4AwwBzO5BQLEWTW3LWBb49UEWqq5ZIH3ZVN+
rdtvYCocBdxINZtmF5psSKffAQOBNZQp9Qgm8hVq2BV/qLUj1WCae3cSnWQGpYoA
LtH3W39Bb9pGxbE+F6Dh1xbBV4g4aaFvtbscq7BRNex88i7ehvCEhxX56kp1amIO
Qgx2uEfvQyySjXmDwcrU
=9gaP
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
