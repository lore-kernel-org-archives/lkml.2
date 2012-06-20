Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab2FTLsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:48:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53545 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932132Ab2FTLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:48:43 -0400
Date: Wed, 20 Jun 2012 12:48:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: arizona: Add support for microphone supplies
 on Arizona devices
Message-ID: <20120620114840.GL3978@opensource.wolfsonmicro.com>
References: <1340189141-20219-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAF+7xWmmmUGy7zYdv+n66KVDUqLKJncjfGDosM7js17Mb2XSZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yaPAUYI/0vT2YKpA"
Content-Disposition: inline
In-Reply-To: <CAF+7xWmmmUGy7zYdv+n66KVDUqLKJncjfGDosM7js17Mb2XSZg@mail.gmail.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yaPAUYI/0vT2YKpA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 20, 2012 at 07:32:18PM +0800, Axel Lin wrote:

> I think you may want to put this Kconfig entriy along with other
> Wolfson Microelectronics chips. So all Wolfson chips show in a group.

I'd rather keep the Kconfig entries sorted alphabetically.

> BTW, seems the MFD_ARIZONA patchs are not (yet) available in LKML.

Surprisingly I am aware of that...

> > + =A0 =A0 =A0 if (selector < 0)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;

> I think you don't need this checking. You already ensure min_uV >=3D 1700=
000.

No harm in being paranoid.

--yaPAUYI/0vT2YKpA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4biSAAoJEBus8iNuMP3dFq8P/i5Nxh0rDGjNKRQMjxrQzgFq
H6INEC73YH32RDU2v/Y1mrcDyS6ET7TX8txRYLVJPPoGNOnfAHfgYF2gyqnPX7Ug
hrXSBUV3cEZS4uXeuTum1WrA6Yq+8wjGyEOqN9/kGxnmpKRV1lYu0YEfkpoW4fri
LhDjLmLsFy5ZntbOrAXgqFCbO3T/e9U0rPQUOA4IuVvgUCdmrq9TCtgD44HTlVHY
dghWCgYilKFTcuHNt17nokjzlmxGcaiqR7PaxH73lQT4TDACgRVhwaeSbcS86Ojp
0urvCivSZFIf3uWPABq6f8ah+I9v1Co81+x+8VAs4cNhZCqSCzA7XiW8l6J6RZKg
Aj62mK8U/CvEmKrUM3Ap1NdolMVQXpG7BeTQ7P+ALAjk6FcZirR4NH0IjKW1+joV
Ci/f6g2ofaC54NXuyYm9PuY/HBV0vmZrXZxuPWd52s8LmSHYJ39GLXkLQZ/NsoVI
sfWdzwYWSLQmxBsq8DICOU3zBLpTJsULPA5hX0kI7aT9mRZ5kmBjx9snmtKknbMd
dyd90OxU7GphW5p4iRXP3K72VqUZe1ut1rRiboNP4EcndWbqBHfe1fAhrq1iA0lu
LoM2gU9UoLqHWFVPo5L+yRcvm71H2ZHnht9yd++PsXpEloS1VFOfcn2X3eQgIUqT
coNEgaay0LCdVX1O1S3t
=8OJd
-----END PGP SIGNATURE-----

--yaPAUYI/0vT2YKpA--
