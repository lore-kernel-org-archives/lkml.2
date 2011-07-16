Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1GPMh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:37:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60969 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab1GPMhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:37:01 -0400
Date: Sat, 16 Jul 2011 16:36:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20110716163611.891fafffc57ad0563d3f4052@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jul_2011_16_36_11_+1000_GfPT/RW0dzgRxq0j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jul_2011_16_36_11_+1000_GfPT/RW0dzgRxq0j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/cell/spufs/syscalls.c: In function 'do_spu_create':
arch/powerpc/platforms/cell/spufs/syscalls.c:69:2: error: 'ret' undeclared =
(first use in this function)
arch/powerpc/platforms/cell/spufs/syscalls.c:71:3: error: 'nd' undeclared (=
first use in this function)

Caused by commit 05a3ade623fa ("switch do_spufs_create() to
user_path_create(), fix double-unlock").

I have used the vfs tree from next-20110707 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jul_2011_16_36_11_+1000_GfPT/RW0dzgRxq0j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOITFbAAoJEDMEi1NhKgbsaI8H/j4Wuhus1PYPKz6Tsp7K8vZb
25e6LdY+XxeeJQrwoZh27BweZiwcqiuzIdA+Cp/iFVSlpCOQl1iSTpyLybt3YJFx
V1GZPIX9r5jum1h37a3a+uJjKbMhFXowawxSA+w7T823FOwI5epOioZfNJo/WY5D
T3fW1PDSiv8/8OJdaoxnn3kOpJ4kqifpxETPr0bUGWcmZl4aKKFHyDdPkBzpssUK
xVsm2XtRjG+LPHEGMe4RU/OZBU3AJdO5Gw1wzT3F2h7ho93aLKT/G98Kpox1hhtx
4fl9evyr5kJfQlV4J5o71uM2ITzEsKatdnqO9Q3mSMM809Gc9KyYNe45Rg/Y1Y8=
=Pe8Q
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jul_2011_16_36_11_+1000_GfPT/RW0dzgRxq0j--
