Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1GVJXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:23:55 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:46265 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301Ab1GVJXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:23:54 -0400
Date: Fri, 22 Jul 2011 12:23:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Brendan Moran <bremoran@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: gpio_set_debounce return value specification
Message-ID: <20110722092349.GM32058@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <586BFDFA1320D943A83378A4BDEF65B0BF7C649BFD@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B9BE8dkJ1pIKavwa"
Content-Disposition: inline
In-Reply-To: <586BFDFA1320D943A83378A4BDEF65B0BF7C649BFD@SJEXCHCCR02.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B9BE8dkJ1pIKavwa
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 21, 2011 at 01:52:56PM -0700, Brendan Moran wrote:
> Regarding gpio_set_debounce, declared in include/linux/gpio.h, defined
> in drivers/gpio/gpiolib.c
>=20
> The return value for gpio_set_debounce isn't clearly specified.=A0 The
> current use of the return value appears to be 0 on success, <0 on
> error.=A0 Because many hardware implementations allow only specific
> debounce intervals, the actual debounce setting after calling
> gpio_set_debounce is unlikely to be the argument with which it was
> called.
>=20
> I suggest that on success, the return value should be a positive
> integer indicating, in microseconds, the actual debounce interval
> which has been applied.=A0 A value of 0 would indicate that the debounce
> was applied successfully, but the driver does not support this
> reporting.
>=20
> The current code in gpiolib.c would support this without change. =A0=A0A
> documentation change to gpiolib.c and gpio.h would be necessary.

Just send a patch fixing the documentation and the current users of
gpio_set_debounce()

--=20
balbi

--B9BE8dkJ1pIKavwa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOKUGlAAoJEAv8Txj19kN1wH8H/1fvMsuPzVwDTc8uerzP1vNj
YQLVGYQ+lb+7R7AOu4FQcgGTGodcpT6hLgiu/qm4ttraBfXGrZLXnS83arFqBqat
S6uyZEqfVTJ/+Svc3RAc+wSe1nGzjR11bE/1bF9Ns8X+HzMGq+FnEbVrtLXp4Wng
K5etpcnF2far1JLn59DQzCV0A/LuCObbXNUIvSlHdbRK+NSNuwC5fYz913GIwAgE
JHlUWkb+VmUrQG2OcLtW1n3+1Ipuj12/iUpTwKiTPic5tzVtZfVztx2Api9iyEYR
tay+yNZ94rYOb5mbALEcalmVh4j+fe1/fv7tpHr2a1yW0Vz/QMkuVTTTiDXHyCo=
=KtOC
-----END PGP SIGNATURE-----

--B9BE8dkJ1pIKavwa--
