Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2JONNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:13:22 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab2JONNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:13:21 -0400
Message-ID: <507C0BE8.6000906@nod.at>
Date: Mon, 15 Oct 2012 15:13:12 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: jdike@addtoit.com, rdunlap@xenotime.net,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] UM: linux/coredump.h needs siginfo_t
References: <20121015131034.8834.52811.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121015131034.8834.52811.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig029508116C9A463C8E8FB87E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig029508116C9A463C8E8FB87E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 15.10.2012 15:10, schrieb David Howells:
> linux/coredump.h should #include asm/siginfo.h for the siginfo_t type.
>=20
> Without this the following error occurs when compiling UM defconfig:
>=20
> 	include/linux/coredump.h:15:25: error: unknown type name 'siginfo_t'
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>

This fix is already in -mm.

Thanks,
//richard


--------------enig029508116C9A463C8E8FB87E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJQfAvoAAoJEN9758yqZn9eHyoH/jtvzPYonqq4aAtpodH2QZPF
EF6yG0vOtnRwR6TKGOemljf2JaGhvHQbWHm5po267tPVocudaNUgeneGXBUxI/a8
L/jilPnz/FFC2puCfokERWdACm4nD5yybXWAUNRSSXwwbPwoKZ0qPcrSrwKzwhZk
97UYVtjgXKkhjdh/+34KOtMrQJtuytCLFuv5nvKJY/l4QMZct6ipo2Lts4wIoQlr
4Jm4gp7XuqumXFRs4K0Ayt9fkPsXg/i8PvuejJwvKkGl3og2ov/3a/ExcVfi8ktT
XtopnqEh9pZp4/A3WB/7ETdHieCbHcVVdVOGZrpxd4YNrWYk9A1HZXT8r1+zOOQ=
=S8zo
-----END PGP SIGNATURE-----

--------------enig029508116C9A463C8E8FB87E--
