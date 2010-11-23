Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0KWMuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:50:13 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40895 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0KWMuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:50:12 -0500
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2010 07:50:12 EST
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.36.1
Date: Tue, 23 Nov 2010 13:43:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-tp42-gtt-vram-apart-v2-dirty; KDE/4.5.3; i686; ; )
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
References: <20101122191831.GG4340@kroah.com> (sfid-20101122_213859_570360_74FEA74F)
In-Reply-To: <20101122191831.GG4340@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2071928.XGHkB49eUo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201011231343.21778.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2071928.XGHkB49eUo
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Montag 22 November 2010 schrieb Greg KH:
> I'm announcing the release of the 2.6.36.1 kernel.
>=20
> All users of the 2.6.36 kernel series must upgrade.
>=20
> The updated 2.6.36.y git tree can be found at:
>       =20
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.36.y.gi
> t and can be browsed at the normal kernel.org git web browser:
>       =20
> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.36.y.git;a=3D
> summary

I am missing=20

drm/radeon/kms: MC vram map needs to be >=3D pci aperture size
b7d8cce5b558e0c0aa6898c9865356481598b46d

from Alex Deucher which fixes

Bug 28402 - random radeon/kms/drm related freezes with kernel 2.6.34=20
https://bugs.freedesktop.org/show_bug.cgi?id=3D28402

random - possibly Radeon DRM KMS related - freezes
https://bugzilla.kernel.org/show_bug.cgi?id=3D16376

which according should have been queued for stable[1]

[1] https://bugs.freedesktop.org/show_bug.cgi?id=3D28402#c96

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2071928.XGHkB49eUo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzrtt8ACgkQmRvqrKWZhMdQlwCeNqEgG4eb6Lm+1Kl59l3IWH97
9EcAoJDEcrvk2DKDrupjjZRkU/FFmvsW
=QtaE
-----END PGP SIGNATURE-----

--nextPart2071928.XGHkB49eUo--
