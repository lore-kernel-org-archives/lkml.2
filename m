Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2FJJ61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 05:58:27 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab2FJJ6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 05:58:25 -0400
Message-ID: <4FD46FB8.1050409@nod.at>
Date: Sun, 10 Jun 2012 11:58:16 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: daniel.santos@pobox.com
CC: Daniel Santos <danielfsantos@att.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/mtd/ubi/wl.c: optimization for in_wl_tree()
References: <1339293473-29444-1-git-send-email-daniel.santos@pobox.com> <4FD40024.9070407@att.net>
In-Reply-To: <4FD40024.9070407@att.net>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8E8A205B919836542FBFE3EC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8E8A205B919836542FBFE3EC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 10.06.2012 04:02, schrieb Daniel Santos:
> Oh, and I forgot to mention that I haven't tested it (don't have this
> device), but it does compile.

Sure you have this device. :-)

modprobe nandsim
modprobe ubi mtd=3D0
ubimkvol /dev/ubi0 -n 0 -N test -m
mkfs.ubifs /dev/ubi0_0
mount -t ubifs /dev/ubi0_0 /mnt/ubifs
testing....
umount /mnt/ubifs

Thanks,
//richard

P.s: Please send use get_maintainer.pl.


--------------enig8E8A205B919836542FBFE3EC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJP1G+8AAoJEN9758yqZn9eNygIAK7aAzBR52u/wVd8f0YuzGqv
4OcVJB86py7BwyXZTAK53NSrTZ9DUb3xUYeFlr3Y17itXsNT7X6eSqSvlhKPNhNO
C8P8qCrYOOJ4Dc7a1/gkM5nlx2Q58ARzDCrPvxi2YZKmdGP/aRxOxLMs6C/rMZnr
3rGZ0YS5lXlnGsY3YkDtQQsXMCWKRegguTi5HjNUmLz1WU0TMdOwJDYrDv+lV6ev
V7tpJsiprVsZLJWN/3S1RMrkxKz7M9MJVFulsats5oVN1jWproyXwCL+G4A6xiPp
ta6D/l4r8QqDhHrJwgkGmK91Zz1yjx0vK7MeaO0Z9pbnhgCzpcq43wL1b641nM0=
=oNvm
-----END PGP SIGNATURE-----

--------------enig8E8A205B919836542FBFE3EC--
