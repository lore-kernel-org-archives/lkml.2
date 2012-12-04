Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040Ab2LDFHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 00:07:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50020 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab2LDFHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 00:07:20 -0500
Message-ID: <1354597630.17107.42.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [GIT PULL] linux-firmware: cx23885: update to Version 2.06.139
From: Ben Hutchings <ben@decadent.org.uk>
To: Tim Gardner <rtg.canonical@gmail.com>
Cc: tim.gardner@canonical.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Tue, 04 Dec 2012 05:07:10 +0000
In-Reply-To: <50BCEBCB.4080303@gmail.com>
References: <50BCEBCB.4080303@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HhT6AtSnLrSekVnwOFHD"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HhT6AtSnLrSekVnwOFHD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-12-03 at 11:13 -0700, Tim Gardner wrote:
> Ben - what is your policy on extracting firmware from Windows drivers?

I suppose the policy should be that the driver's licence must allow
extracting and then distributing the result.  Which I wouldn't expect
ever to be the case, in practice.

Your commit message refers to the Hauppuage driver package at
<http://steventoth.net/linux/hvr1800/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip=
>.  I didn't find any licence text, other than 'All rights reserved', in ei=
ther that or the currently distributed version of the same driver <http://w=
ww.wintvcd.co.uk/drivers/HVR-12x0-14x0-17x0-33x0-44x0_1_48_29272_SIGNED.zip=
>.

> It seems like it ought to be OK, and they _are_ the same files that are
> covered under the license in WHENCE.

I'm not sure how you can say they are the same files, as you're
proposing to change the contents.  The copyright on the current files
belongs to the chipset vendor, Conexant, and Hauppuage *presumably* used
firmware supplied by Conexant, but either of them might have chosen a
different licence for the versions in this driver package.

> The following changes since commit bda53ca96deb3cacbef10a7a84bbaee2d09c7f=
34:
>=20
>   brcm: new firmware version for brcmsmac (2012-12-03 14:46:28 +0000)
>=20
> are available in the git repository at:
>=20
>   git://kernel.ubuntu.com/rtg/linux-firmware.git master
>=20
> for you to fetch changes up to 3c592f80519a7e82eadeccfad7a5cd1604ca463c:
>=20
>   cx23885: update to Version 2.06.139 (2012-12-03 11:07:43 -0700)
>=20
> ----------------------------------------------------------------
> Tim Gardner (1):
>       cx23885: update to Version 2.06.139
>=20
>  v4l-cx23885-avcore-01.fw |  Bin 16382 -> 16382 bytes
>  v4l-cx23885-enc.fw       |  Bin 16382 -> 376836 bytes
>  2 files changed, 0 insertions(+), 0 deletions(-)

How odd, these two files are currently identical to each other...

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-HhT6AtSnLrSekVnwOFHD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUL2E/ue/yOyVhhEJAQrnsBAAmwD3kF3P5GByRFQVqsNPr3whghomTECm
QeLmh2ac0J8NcwjYL/U02SMtO1i+XcU0D7hAHBfFZNyaGcUZVvEL8KSbnvN8pCI7
9zpdYMDDIc7tv4gkKBaD4SQ/wIeiVyhBRRVG1w3Tep03FsUQAyPL+FAUlY8LcAdy
A2aarC+S70epphK22Kz5Pxsxgnup+MBhs5gWJWiEg3bslAV24TRJZCkFnmx5S9OP
dYSi0H9YKZ0EFcJT01+phPFmj4iMCiv82J5VQrXCVuQ46+eAniyGXTcgH4Ug7bZ9
B0T3InJlWONub5MhuPZvuvvFw7V5I5SZNjs2df30B7fkxes4cIjzVSmUYy7ZypJn
QnBnKWtG6lYuVgjIrhpSyqGhI0dL94OnkZ2QUIg4cidvGhZDHQMqCy5mUB5lnTfF
07VLBp6LIGPXpHz0L2xHLFvPX9bTWyCWnrHwkQSdguMY2bWCjaOOcVd14ov7/fPU
a+5na+43ywEV29rkNEuBcuy5jyj+CftBGwM7MVEwn9cPjfBraHwpt8VyklFNh8Mp
oBjdZtJChrTJo3819CKpnpC3bVRGdJu4FF62ERkhdQWDRLCmgD+20t8XJllaZTsv
MDlEZ4Lc7Jn7aLfKQHzoEPOPk9KRBfK9TGr2Qayz/ZWH2vR6O25mXlEqXRZCvsJ8
jMl+xh63lJA=
=g677
-----END PGP SIGNATURE-----

--=-HhT6AtSnLrSekVnwOFHD--
