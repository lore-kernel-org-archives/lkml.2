Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab1CFKoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 05:44:37 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60583 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1CFKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 05:44:34 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.37-post-rc7 with radeon kms: reproducably locks up hard when using desktop cube of kwin
Date: Sun, 6 Mar 2011 11:44:16 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7-tp42-00142-g212e349; KDE/4.5.3; i686; ; )
Cc: DRI <dri-devel@lists.freedesktop.org>
References: <201103051510.35057.Martin@lichtvoll.de> (sfid-20110305_151616_695932_4AD33AC9)
In-Reply-To: <201103051510.35057.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6163108.e6etboSAu1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103061144.30457.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6163108.e6etboSAu1
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Saturday 05 March 2011 schrieb Martin Steigerwald:
> I will add a regression entry in bugzilla after I got the URL of that
> mail.
>=20
>=20
> Hi!
>=20
> No, I do not actively search for lockup bugs, but they seem to search
> me ;).
>=20
>=20
> martin@shambhala:~> cat /proc/version
> Linux version 2.6.38-rc7-tp42-00142-g212e349 (martin@shambhala) (gcc
> version 4.4.5 (Debian 4.4.5-11) ) #4 PREEMPT Sat Mar 5 12:03:41 CET
> 2011
>=20
> locks up hard when using desktop cube of kwin from KDE 4.5.1.
>=20
> It happens within a few seconds to about 30 seconds after activating
> the effect with Ctrl-F11. Otherwise the machine seems to work fine so
> far - if that continues I do not have much of a problem with the bug
[...]

Upto now I did not experience a lockup except for above situation.

> As I am in my holidays in Sevilla I will only care about bisecting when
> it rains three days in a row ;) - cause I insist on my holidays being
> holidays and so will only do light kernel testing ;). I wanted to
> report this nonetheless since at least on my machine this is really
> easy to reproduce.

I darkly remember that someone told me in another thread on how to reduce=20
commits to bisect to radeon drm kms stuff. That might be a viable=20
alternative. Ah, it was Ted in "stable? quality assurance" (Message-Id:=20
20100907025110.GD6134@thunk.org)

git bisect start 2.6.34 2.6.33 -- drivers/gpu/drm/radeon

Hmmm, I might try this.

But not today, its sunny here ;).

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart6163108.e6etboSAu1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk1zZYEACgkQmRvqrKWZhMepVwCePDiSjaNrryLV5dHn4yO3a9d3
IhkAnjkyTNaG5ejDaj0F/JZ1NTIbgicP
=CLiK
-----END PGP SIGNATURE-----

--nextPart6163108.e6etboSAu1--
