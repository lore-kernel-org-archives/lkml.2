Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab0IAQKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:10:36 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52735 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab0IAQKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:10:35 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Date: Wed, 1 Sep 2010 18:10:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33.7-tp42-toi-3.1.1.1-05125-ga817cb9; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201008312153.45792.Martin@lichtvoll.de> <20100831223921.GA23476@deepthought> (sfid-20100901_180804_207596_0BE2D449)
In-Reply-To: <20100831223921.GA23476@deepthought>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2810095.oVqUAdDl7R";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009011810.31642.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2810095.oVqUAdDl7R
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch 01 September 2010 schrieb Ken Moffat:
> On Tue, Aug 31, 2010 at 09:53:43PM +0200, Martin Steigerwald wrote:
> > Hi!
> >=20
> > I am seeking help with encircling the cause of:
> >=20
> > [Bug 16376] random - possibly Radeon DRM KMS related - freezes
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D16376
> >=20
> > I started a bisection as described in which has been painful for me -
> > at least for a first time bisection -, but after the second skip of
> > a non- booting kernel git points me to a kernel that is outside of
> > the initial range between good and back.
> >=20
> > good is: [60b341b778cc2929df16c0a504c91621b3c6a4ad] Linux 2.6.33
> >=20
> > bad is: bad: [64ba9926759792cf7b95f823402e2781edd1b5d4] Merge branch
> > 'for- linus' of git://git.open-osd.org/linux-open-osd
> >=20
> > After skipping the last non booting kernel, git bisect put me to
> > 5be796f0b842c5852d7397a82f8ebd6be8451872 which is just 300 lines
> > after 2.6.33-rc2.
> >=20
> > Obviously I am not interested in kernels prior 2.6.33. Should I just
> > do a "git bisect good" without trying the kernel or is there some
> > other remedy? its 11 cycles already without testing anything outside
> > the initial good/bad range and it takes about half a day to be
> > somewhat sure that a kernel is good, so I'd like to avoid testing
> > versions outside this range.
>=20
>  While you are bisecting, don't believe the version in Makefile.  I
> got similarly freaked out a couple of years ago - if I understood
> correctly, it's something to do with when a change was created.
>=20
>  The key point is that during bisection the apparent version *can*
> go back to a version that appears to be before the initial "good"
> kernel.

I verified the version by running git log after doing the skip. And it was=
=20
just 300 lines after Linus commited 2.6.33-rc2. Can git log be showing=20
incorrect results during a bisect?

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2810095.oVqUAdDl7R
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkx+evEACgkQmRvqrKWZhMfl8wCfQLi07cHZftYmuqHA9rKK757t
JQwAoKv/fyKrAd/AVlnBGmzGT6qMj9sg
=FMje
-----END PGP SIGNATURE-----

--nextPart2810095.oVqUAdDl7R--
