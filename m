Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0GKOW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 10:22:57 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44264 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab0GKOW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 10:22:56 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Date: Sun, 11 Jul 2010 16:22:44 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34.1-tp42-toi-3.1.1.1-04990-g3a7d1f4; KDE/4.4.4; i686; ; )
References: <201007110918.42120.Martin@lichtvoll.de> <1278837584.2538.135.camel@edumazet-laptop> (sfid-20100711_161035_603636_8F7DD04D)
In-Reply-To: <1278837584.2538.135.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3946538.TkO7JYY5vI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007111622.52856.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3946538.TkO7JYY5vI
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Sonntag 11 Juli 2010 schrieb Eric Dumazet:
> Le dimanche 11 juillet 2010 =C3=A0 09:18 +0200, Martin Steigerwald a =C3=
=A9crit :
> > Hi!

Hi Eric,

> > 2.6.34 was a desaster for me: bug #15969 - patch was availble before
> > 2.6.34 already, bug #15788, also reported with 2.6.34-rc2 already, as
> > well as most important two complete lockups - well maybe just X.org
> > and radeon KMS, I didn't start my second laptop to SSH into the
> > locked up one - on my ThinkPad T42. I fixed the first one with the
> > patch, but after the lockups I just downgraded to 2.6.33 again.
> >=20
> > I still actually *use* my machines for something else than hunting
> > patches for kernel bugs and on kernel.org it is written "Latest
> > *Stable* Kernel" (accentuation from me). I know of the argument that
[...]

> > advertised as such on kernel.org I think. I am willing to risk some
> > testing and do bug reports, but these are still production machines,
> > I do not have any spare test machines, and there needs to be some
> > balance, i.e. the kernels should basically work. Thus I for sure
> > will be more reluctant to upgrade in the future.
> >=20
> > Ciao,
>=20
> Anybody running latest kernel on a production machine is living
> dangerously. Dont you already know that ?

Yes, and I indicated it above. But in my - naturally rather subjective I=20
admit - perception the balance between stable and unstable from about 1 or=
=20
2 years ago has been lost. In my personal experience it has gotten much=20
worse in the last time. To the extent that I skipped some major kernels=20
versions completely. For example 2.6.30.

And its not servers - these use distro kernels. =20

> When 2.6.X is released, everybody knows it contains at least 100 bugs.

Then why its still labeled "stable" on kernel.org? It is not. It is at=20
most beta quality software.

Its not more stable than KDE 4.0 wasn't stable, but at least they=20
mentioned in the release notes.

> It was true for all previous values of X, it will be true for all
> futures values.
>=20
> If you want to be safer, use a one year old kernel, with all stable
> patches in.
>=20
> Something like 2.6.32.16 : Its probably more stable than all 2.6.X
> kernels.
>=20
> If 2.6.33 runs OK on your machine, you are lucky, since 2.6.33.6
> contains numerous bug fixes.

Actually it was 2.6.33.1 with userspace software suspend and it had pretty=
=20
good uptimes above 20 days - only interrupted by installing 2.6.34.

Well then if everybody else considers this for granted I just replace that=
=20
"stable" on kernel.org by "beta quality" - from my perception it does not=20
even have release candidate status in the last iterations - in my mind and=
=20
be done with it.

At as soon as the kernel contains a performant hibernation infrastructure=20
I will probably just use distro kernels and be done with it.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3946538.TkO7JYY5vI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw507UACgkQmRvqrKWZhMeSqgCdEbJAO2875aS+50Hl1fCXMLBj
koMAoKzg4Xjh+KnJRnYPL2ybdjyZtmah
=EFpD
-----END PGP SIGNATURE-----

--nextPart3946538.TkO7JYY5vI--
