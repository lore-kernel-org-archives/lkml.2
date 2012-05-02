Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2EBJqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:46:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48666 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2EBJqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:46:02 -0400
Message-ID: <4FA10250.5050104@googlemail.com>
Date: Wed, 02 May 2012 11:45:52 +0200
From: Tobias Powalowski <tobias.powalowski@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Possible 32bit i686 kernel hard crash bug 3.3.4?
References: <4FA0E485.80902@googlemail.com> <20120502091226.GA1591@home.lan>
In-Reply-To: <20120502091226.GA1591@home.lan>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7B2EA51533F23B1D2B68147D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7B2EA51533F23B1D2B68147D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 02.05.2012 11:12, schrieb Jan R=C4=99korajski:
> On Wed, 02 May 2012, Tobias Powalowski wrote:
>
>> Hi,
>> since we bumped to 3.3.4 some users reported hard crashes:
>> https://bugs.archlinux.org/task/29694
>> I cannot exactly say what it triggers it happens for me randomly.
>> This kernel version is not usable for my server anymore.
>> Hope you can help us. x86_64 seems not to be affected.
> What version of binutils you built that kernel with?
> Is it by any chance 2.22.52.0.2?
>
Well it's from 20120323 with this patch attached:
https://projects.archlinux.org/svntogit/packages.git/commit/trunk/PKGBUIL=
D?h=3Dpackages/binutils&id=3D9b0778356b73dd77ed7f98eae5dd5c1f5824ae96

greetings
tpowa

--=20
Tobias Powalowski
Archlinux Developer & Package Maintainer (tpowa)
http://www.archlinux.org
tpowa@archlinux.org



--------------enig7B2EA51533F23B1D2B68147D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPoQJVAAoJEHcd9mJ+32gfB3EH/1fdy3tQq+7iV8W/JJ/J4/B6
j0sa0BB4UcL1llgf4bNuzhLVR7YnZxZpLcLocXxUTxmW0PGqI2gtbJAKmhmoRgfy
iyJE577tVT781xcp4BrS3NS6DpauaTnjrcwqc+GaOu8OCJP8QuyLIzfS7Vdx+oPt
flknArSK4MUd54YlakOu/TAmJYnocZ8yKEyfyHgqRd1tM+mMUzBf08zPW6lqFTA1
e46Rd7pIkUqnWmXp/b7dz+qj3JK7IAIktKU03LEeVGJASlDMncizPy3Iz8Zof2pU
dbDxvKh7rgV5RmiC/rQhv4PhIX7MscpJ51z/abUTF6yChOeYFDu6qI22OYHebj4=
=GYS4
-----END PGP SIGNATURE-----

--------------enig7B2EA51533F23B1D2B68147D--
