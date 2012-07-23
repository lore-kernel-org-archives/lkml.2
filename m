Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2GWIcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:32:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab2GWIcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:32:46 -0400
Date: Mon, 23 Jul 2012 10:32:33 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: Re: DT support for Low threshold brightness in backlight.
Message-ID: <20120723083233.GB12868@avionic-0098.mockup.avionic-design.de>
References: <518397C60809E147AF5323E0420B992E3E96A842@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E96A842@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:HCBNzGNcr0F+Bh+8WcFC625mZhKin/tdglIgXWscpJe
 YnnIx/YfCbWE2KahtynHh7Y5UTR3B2XCaJ1GpbfS2FeSqkLocM
 3p1PuJ50A66zAnC4lyW/o7qGf/+h6kIsXOtdmsi+qKJK5VvLET
 GIm5kPlfzyvUBIV8D4HzYdahfgXc5UH0BbH6Mw4UqeDPhprG23
 da7naktC+sV/fiyxSkrVJZ4/X2wm/cT/rBRSiIxvU8eIwWfb79
 JvZZd8GrkHFj7FB3FTbgUv58zmKS1CtsmmlCpun/5p2FBhEZ4j
 nOsRSBiWoq+sSE7OQwB6JR4vH2SS4lxprtOkOHovqWNjukdcEe
 xAcdvW/EetJQCnbG0LBbGt3Cg7ltvkyzCpY5BXWlx6wlA80BPX
 +RljvbNtZfiyG7jU3dSxN9hATMd63cYlKg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2012 at 02:59:32PM +0000, Philip, Avinash wrote:
> Hi,
>=20
> In pwm-backlight driver low threshold brightness support in DT is not
> present. Do you have any plans in such direction?
>=20
> I am planning to add support for the same but want to avoid duplication
> of work.
>=20
> Below scenario describes need for it:
> On some boards panel backlight is OFF at low end of brightness scale.
> So with Low threshold brightness we can have linear scale in brightness
> (Though the actual brightness scale is changes to Low threshold
> brightness value instead of 0).
>=20
> Example with Low threshold brightness
> 	pwms =3D <&pwm 0 50000>;
> 	brightness-levels =3D <0 2 4 8 16 32 64 128 255>;
> 	default-brightness-level =3D <6>;
> 	brightness_threshold_level =3D <50>;
>=20
> It can also be achieved without Low threshold brightness as below
>=20
> 	pwms =3D <&pwm 0 50000>;
> 	brightness-levels =3D <0 51 53 56 62 75 101 152 255>;=20
> 	default-brightness-level =3D <6>;
>=20
> But brightness-levels won't be uniformly divided.
>=20
> So it is good to have low threshold DT support for backlight.
>=20
> Thanks
> Avinash Philip

I have no plans to add it myself, but feel free to send a patch. There
is a corresponding field in the platform data already, so adding DT
support is probably a good idea.

Thierry

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQDQwhAAoJEN0jrNd/PrOhp7oP/10brp9e+0+KY8KaqSURGI8O
1lAg/RRYi7mb1/zitXlc6fnVX/WQfML4N7RrJX0qcDl1Kp5cPTKHLZwREhVhV8P7
p8W7xzsxyGFRftie65Y3w0XjdbGsfSX7ylV/mAypMnq7G492fYZecLLt3lKeRDhW
32Ybsw30NfEIaxSi+zYT3VYQmr/YIpp0DbijrG31LDCyJqMZ/CmDiUmiZiJo1RgU
8F1t0UTm093cwyz89mgZ1lPvDtSKxnkLHfclagdTOE2Z4z0hlEyTDqBSsVS67vKj
7kq4sUqm1qMSSiJHREGj7JyoU8B/JZ7VzAOsbhkNM3eaysMcZe7QHUWE0zuwcVc5
WWZKgKxhCvT2ylsmpXx4pdpLBi4tEXSRmm2RBIWLmVvjnqwnlxK9D1B3kGt19s5x
rNd905jmXIRg0HDbG49LE1oHS23keHJWjOKuAeVR8pTgZ19KhDxSV9QTjaLYcGJC
mKUD8TGrYheOrLclkPBgnQOKciqOAtSMpEbOpo/lhm9fn/Ix0XEnFpusHhEaXkgz
HRaPA8jCvRAOQw1w8dXGHuMulciCQAWAaT/ly/j46ohNRwr4QsKytzc513/68IJP
NcU2D5AYZ4lWTVviZN78Zp+AT5ThkdBomjX9U/zZyTtM5kxfQEAVEy9jR0bfg+gb
93wILkEk+FrWTzIbYxsL
=O7rd
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
