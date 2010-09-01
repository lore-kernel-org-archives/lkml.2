Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab0IAT0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:26:55 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37225 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab0IAT0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:26:54 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Paolo Ornati <ornati@gmail.com>
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Date: Wed, 1 Sep 2010 21:26:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33.7-tp42-toi-3.1.1.1-05125-ga817cb9; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201008312153.45792.Martin@lichtvoll.de> <20100901204716.775e9cfd@gmail.com> (sfid-20100901_212311_722290_782CB1E3)
In-Reply-To: <20100901204716.775e9cfd@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2140822.Lh2TJqsBf5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009012126.48174.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2140822.Lh2TJqsBf5
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch 01 September 2010 schrieb Paolo Ornati:
> On Tue, 31 Aug 2010 21:53:43 +0200
>=20
> Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Obviously I am not interested in kernels prior 2.6.33. Should I just
> > do a "git bisect good" without trying the kernel or is there some
> > other remedy?
>=20
> No. Git is right in asking you to test that commit: you are ignoring
> branches and merges.
>=20
> Example
[...]
> So the commit you are testing it's like "commit A": it was done before
> (in time) v2.6.33, on a kernel based on v2.6.33-rc2, but was merged in
> Linus' tree _after_ v2.3.33.
>=20
> So this this behaviour is normal :)

Thanks. That explains it. So I compile this kernel and continue bisecting=20
as usual.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2140822.Lh2TJqsBf5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkx+qO8ACgkQmRvqrKWZhMdBHwCfQqsfg93WkQqs8XpZdYTLMBJE
BjQAnjCUvjgjzEMNGiw5KqzQLHxgocPY
=HD/p
-----END PGP SIGNATURE-----

--nextPart2140822.Lh2TJqsBf5--
