Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1JDG5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 02:57:17 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44117 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1JDG5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 02:57:16 -0400
Date: Tue, 4 Oct 2011 17:57:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the moduleh tree
Message-Id: <20111004175703.0e319ee270c9dcd1ff253164@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Oct_2011_17_57_03_+1100_PgCDhC0gujBqPEc="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_17_57_03_+1100_PgCDhC0gujBqPEc=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

I also dropped the following already applied patches:

wireless-ath6kl-use-of-module_param-requires-the-inc.patch
staging-add-module.h-to-various-iio-drivers.patch

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Oct_2011_17_57_03_+1100_PgCDhC0gujBqPEc=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOiq4/AAoJEECxmPOUX5FEBM8QAJPluikYU4Y8bjJGdPt4Q6rC
2k6VzWuPFgGkLe++CnjlLB0NFNIvtKVVuHsEklNmNDEN/fHaRoYsHKPgpdMoid7Y
a6tBpC+kPHZWRrVt/9l0s2hGFRu0EvHQ2gsfsLDc99ftfY7FnTsk6uENSe9FQioa
A0wg/XGeVLRpRxT9fBB1fn7kEYMCbPkadDDLvvfyJvs8pH7bhrk228UYwzGn186h
jMJipQtrVZcys/zJwUqrAau1edRXi7jkPjAZiZ17JvBSaGw+fk14CuELJHIfMPqx
FdEKfOlaCC1QkVtEKXBbwd5r7Va6YR64ICgt8i9s0JiE/Qaflm1dvYNMrSM3eVME
exY8c1ccygYrOjyBKC5N1YnPSC7FmHs+LM6oN0zn93azZsrntvzLqC4xpHKQvB2m
MSB2zj6HfzPDwJIVxMv1Tj49ocQGCzYypCXxcKC7IoVW9c1AbuU4budcxoLmUsBq
UDo8Nyl5iECR0fjboRBMCy9NMFivsD+yh4+OfwIMLd/jpKqULE7OFo3qLNifIQ2E
2o6eoyDwhC5u41bDqQHVqfL0KVu942MQuhN8zl+zQUALr/opb8SKJFnKZdos/36d
m6CUt+HI6ULWKAmEWs8aQFai8NPyVIoThAbSZJw/eesKkCT80+4CNZwX/noCDDJR
/SHFtNTTrGCdazyuPjIS
=3Nw1
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_17_57_03_+1100_PgCDhC0gujBqPEc=--
