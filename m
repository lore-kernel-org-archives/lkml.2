Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2LAWgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 17:36:39 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:35459 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab2LAWgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 17:36:38 -0500
Message-ID: <50BA85A7.7060206@gentoo.org>
Date: Sat, 01 Dec 2012 17:33:11 -0500
From: Richard Yao <ryao@gentoo.org>
Reply-To: kernel@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121128 Thunderbird/10.0.11
MIME-Version: 1.0
To: Roger Heflin <rogerheflin@gmail.com>
CC: kernel@gentoo.org, Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: My SD Card Reader cannot read SDHC cards
References: <50B9F233.5040902@gentoo.org> <CAAMCDefRCdB1oLGmXxoChzqhoYKK8y4LZ5pOQVN1Uriz514_3w@mail.gmail.com>
In-Reply-To: <CAAMCDefRCdB1oLGmXxoChzqhoYKK8y4LZ5pOQVN1Uriz514_3w@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig43D91386F613FB486E042835"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig43D91386F613FB486E042835
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/01/2012 01:30 PM, Roger Heflin wrote:
> On Sat, Dec 1, 2012 at 6:04 AM, Richard Yao <ryao@gentoo.org> wrote:
>> Standard Microsystems Corp. 8-in-1 Card
>> Reader
>=20
> Does that card reader support SDHC cards?    The older readers don't
> support >2GB (ie sdhc)
> cards, and that would mean a 2GB card works and the 4GB or larger ones =
won't.

SDHC is defined in version 2.0 of the Secure Digital specification,
which did not exist when this card reader was made. From what I have
read, the main difference aside from additional space is a change in the
format of the Card-Specific Data register. Newer SD Card readers have no
problem handling both formats and I expect that it is possible to modify
older SD Card Readers to support it.

I am not familiar with the subsystem involved, so I need some pointers
before I can start looking at it.


--------------enig43D91386F613FB486E042835
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQuoWtAAoJECDuEZm+6ExkoLIP/jY3ddarPWxZGAi6uSkZJtTA
E1DzBpzgHBIe6ul9q/d2lvTXg6BRtpjIIbnPKzkY1zVpQUl9+q8NECZWprHcRSVk
BAYWQZ98ItEr2AYruyroTZ8AwJhIPhJJ3jIkv+zptdbC4PorJo2IAXs9aUPP6JOy
oMvhLUC94KEdHqZ7FJM8pMAhfCkm5hNpdzUqoQRZtw/Hnnlnp6aY6SxM5bUDNPUt
Ei+32Zdh6tXoeSqqrlTu2shn/fH9JDe7LNz2Ji6Ji+sY/CI6fiymk3XVZfoamURe
Ss/QscdYnztMuXe71zuvYxF068shSWq+tjMjpLHmJX7FYbwQ0Nolfh5+ICuB0iH/
wzvwBK+p5N1lqCmcBuPhwId9hiSesCLND1AZ7vWCxzuzcgkzNZbYTF8UFVKDbJAs
cDfqDmkCDGGbuQKe5i5BcDxrc60t/uW3jzCiLioIwoTT288RxLvov93ux85Kzal6
esg+2CQ49OHuQChjawPyYQV7cl5W5y0qYPoXnPpJD2Fgikj5/RMqhkjAUP/ei8Y1
K0JDpk3Pbzypt3xugpVEaUb3xtlIkHr2p7r6Le51YIibZLPsMdSMIiLWTVXwUDKV
vutHemq9ccq+mHd2vW3f8MIDUjyH8uUwV0GCX/1bRFryoc57vIFRw3XKF7xdHlVV
zWsKMIQB5w9+EfhZ2j4P
=Rv8y
-----END PGP SIGNATURE-----

--------------enig43D91386F613FB486E042835--
