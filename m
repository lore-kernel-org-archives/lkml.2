Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2GWKo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 06:44:56 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:34193 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029Ab2GWKoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 06:44:55 -0400
Date: Mon, 23 Jul 2012 13:41:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Du, Changbin" <changbin.du@gmail.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, ben@simtec.co.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] usb: gadget: s3c-hsotg: fix core reset timeout
 failure
Message-ID: <20120723104145.GR8265@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <4ff3af7d.42da440a.5573.ffffe2c2@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kSOhxpxUsM1s2qz/"
Content-Disposition: inline
In-Reply-To: <4ff3af7d.42da440a.5573.ffffe2c2@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kSOhxpxUsM1s2qz/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 04, 2012 at 10:50:30AM +0800, Du, Changbin wrote:
> The timeout values were 1000 and timeout issue occurred many times on my
>=20
> s3c6410 Soc based board (mostly when booting with USB cable not
>=20
> connected). This patch increase the values to 10000 to guarantee the
>=20
> success of reset.
>=20
> =20
>=20
> Having set timeout to 10000, I printed the remained timeout values
>=20
> which can cause timeout issue before this change (tested several times):
>=20
> the first timeout value remained:
>=20
>          timeout =3D 8079
>=20
>          timeout =3D 8079
>=20
>          timeout =3D 8078
>=20
>          timeout =3D 8081
>=20
> the second timeout value remained:
>=20
>          timeout =3D 7940
>=20
>          timeout =3D 7945
>=20
>          timeout =3D 7940
>=20
>          timeout =3D 7938
>=20
> Seeing from above values, I think 10000 is big enough.
>=20
> =20
>=20
> Signed-off-by: Du, Changbin changbin.du@gmail.com
>=20
> ---
>=20
> Changes for v2:
>=20
>          Fixed wrapped line done by my mail client

now it' s even worse. Please use git send-email instead.

--=20
balbi

--kSOhxpxUsM1s2qz/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQDSppAAoJEIaOsuA1yqREHPwQAKxg5isNIPIcZrWJ04ppDqgU
aqdF7ZbzNDtPngi93sg59cBm9f/lZiTBYj92ZrTsbsP64Or+eylRPVwyoAwsKWd5
NQbh3eCODics3ZWK0h2StWjGn0MfaBzmQSjzuMOg6+XAcXb9P27qLiyP0MKv1uoJ
SjpsDwhim9oXfxhLSvNTt/UNTVF1Esporg+6iPAUgHE/FpYdoKr+1wyr88y6R1eT
COlQXpdjTGbyIOx623aqx1+AAqBNK0VtcoXnYFGUzSDW82SxFot5UO5Zckq2vq/W
/V+cXsZUTnR2SipqFB/6VYVPK19SvKhQF3+hQf8elrVrDXC6yqGi6RCr2Nfq2AHs
Y/klEQViDncxMONw3a8I7QoyDibUhH6lVxGw8gPDACuig/W8TDCg9ECE3TqYU3TI
RCuvsUI5QeWayeTkb1Ml//kWKwO8+NMz1WxCFYiyu48yNWxRyMqmvXfvuIDWjovy
WJ9F5lQ54qq/ivWeUHhWgo8pXPGVZcUXogeFxVcoagtFWihYFynCyK/1mD8Ao4ot
+Wm+ENbNU3dYytDnFo/+ukslWI7cDMdiAdS06WbX3nNtLvO5Hfnf58D+PvgbuWBi
RDEWEUNOvE1YGzfTCXq5Uog7p+qGPQ4lY58SUkBC8VfTCTDKGcFtJkPHkRWbiog+
BDfAcJVK2Y7xyZL0coPH
=3mRc
-----END PGP SIGNATURE-----

--kSOhxpxUsM1s2qz/--
