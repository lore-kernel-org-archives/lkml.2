Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2EBPsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:48:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55799 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab2EBPst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:48:49 -0400
Message-ID: <4FA1575C.8010400@googlemail.com>
Date: Wed, 02 May 2012 17:48:44 +0200
From: Tobias Powalowski <tobias.powalowski@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Possible 32bit i686 kernel hard crash bug 3.3.4?
References: <4FA0E485.80902@googlemail.com> <20120502091226.GA1591@home.lan> <4FA10250.5050104@googlemail.com>
In-Reply-To: <4FA10250.5050104@googlemail.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCE94EB0A843B9D1ADAC93864"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCE94EB0A843B9D1ADAC93864
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 02.05.2012 11:45, schrieb Tobias Powalowski:
> Am 02.05.2012 11:12, schrieb Jan R=C4=99korajski:
>> On Wed, 02 May 2012, Tobias Powalowski wrote:
>>
>>> Hi,
>>> since we bumped to 3.3.4 some users reported hard crashes:
>>> https://bugs.archlinux.org/task/29694
>>> I cannot exactly say what it triggers it happens for me randomly.
>>> This kernel version is not usable for my server anymore.
>>> Hope you can help us. x86_64 seems not to be affected.
>> What version of binutils you built that kernel with?
>> Is it by any chance 2.22.52.0.2?
>>
> Well it's from 20120323 with this patch attached:
> https://projects.archlinux.org/svntogit/packages.git/commit/trunk/PKGBU=
ILD?h=3Dpackages/binutils&id=3D9b0778356b73dd77ed7f98eae5dd5c1f5824ae96
>
> greetings
> tpowa
>
Ok issues identified,
broken binutils caused this.

Soryy for the blurb.
greetings
tpowa

--=20
Tobias Powalowski
Archlinux Developer & Package Maintainer (tpowa)
http://www.archlinux.org
tpowa@archlinux.org



--------------enigCE94EB0A843B9D1ADAC93864
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPoVddAAoJEHcd9mJ+32gf6GcH/RvSc7G55dXzq5Zs45T1/4oM
62gq8l4tKzUTNGNhPcVzx3qslyVZ+V9ZKfQOabrLBRRC2ywm39ko//+WW1DXgOcM
/a87tHv3haxI86AHmPBoZDb8QhG1sT5uI6vKMUuYQ+Be+XiBZwXlLinSQZmdV1+w
RIMc5Xs5WDGM38McXA9iCPSpU3Qzi7Stbanw9a1AfMIKeItEqwJThK4q+ohaz14I
eB6KW8YNyK3cw3R1lePPGpAFzDAmhp0p0xql4TcE5n9rwItVBMdi5Z/AHJSOpVzN
kOyKtgAQrn/bXfx9vY1bXc+nbswG4WJOf07RssZLY++CCUQ/hV4bQMxj+y+ewx4=
=UITD
-----END PGP SIGNATURE-----

--------------enigCE94EB0A843B9D1ADAC93864--
