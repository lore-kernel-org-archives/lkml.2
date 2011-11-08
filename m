Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab1KHTNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:13:08 -0500
Received: from gerolde.archlinux.org ([66.211.214.132]:36485 "EHLO
	archlinux.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754712Ab1KHTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:13:07 -0500
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 14:13:07 EST
Message-ID: <4EB97DD2.7000209@archlinux.org>
Date: Tue, 08 Nov 2011 20:06:58 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
In-Reply-To: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enigBA7DEB0D1472A961CC83F5F7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA7DEB0D1472A961CC83F5F7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 08.11.2011 03:10, schrieb Linus Torvalds:
> Which brings me to a question I already asked on G+ - do people really
> need the old-fashioned patches? The -rc1 patch is about 22MB gzip-9'd,
> and part of the reason is that all those renames cause big
> delete/create diffs. We *could* use git rename patches, but then you'd
> have to apply them with "git apply" rather than the legacy "patch"
> executables. But as it is, the patch is almost a third of the size of
> the tar-ball, which makes me wonder if there's even any point to such
> a big patch?

=46rom a distro packager's point of view, I can say this:

For packaging, we always use the latest .0 release tarball and patch it
with the -stable patch files from kernel.org. It would be desirable if
those would keep working with GNU patch - not necessary though because
'git apply' doesn't require a git repository.

When packaging development versions of the kernel, it is much easier to
pull the lastest code directly from the git tree, so I never needed the
patch files for the -rc's.


--------------enigBA7DEB0D1472A961CC83F5F7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREIAAYFAk65fdIACgkQEda5KzHP/VAExACgjJXeumtlSOBiCACCFUoo4urk
b/QAnA3PIGNqNhxPf62+N9MgtTkr19yC
=j2d3
-----END PGP SIGNATURE-----

--------------enigBA7DEB0D1472A961CC83F5F7--
