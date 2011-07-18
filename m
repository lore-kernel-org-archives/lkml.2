Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab1GRFFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 01:05:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56193 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1GRFFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 01:05:49 -0400
Date: Mon, 18 Jul 2011 15:04:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@redhat.com>
Subject: linux-next: build warning after merge of the vfs tree
Message-Id: <20110718150456.d0eea458aab56fd1488ccc39@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jul_2011_15_04_56_+1000_L8Id1Co6K4Lfp.fp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jul_2011_15_04_56_+1000_L8Id1Co6K4Lfp.fp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/char/ps3flash.c:347:2: warning: initialization from incompatible po=
inter type

Introduced by commit 62ec115d5b9c ("fs: push i_mutex and
filemap_write_and_wait down into ->fsync() handlers").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jul_2011_15_04_56_+1000_L8Id1Co6K4Lfp.fp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOI774AAoJEDMEi1NhKgbsUVEH/30ZFReozBqC0N/Tp9UvSjff
VRbx3a+ATPtrfkAgYbDE9PiOMA9mI0DOOUPmML3CA7DOoGHHOPBWGDZd00hAmcon
jfpk9ldxhCHnm5y6QOQn8QsRexngo2oooz1j24MbfuQP02gZ4BgdUvsFUjUKO7aC
LCsk3dHV6ZzmFeUDdA+UJiI2RjMPvK6QJrlXFJMm/dVh+65FvIytfmzGz/DNUBwS
jR0QGcL7PrPFPhb8QylE1VzFcMYsX9tCHQdkpMTHr7K4KInf7r4V45XhdytcjYMC
8PGsyEZ/dOW3+L4ty5tsBOcd2R+HoCYyAV/4ojXxbcZfPuwwVUp6ETnVqw7MACo=
=XSFR
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jul_2011_15_04_56_+1000_L8Id1Co6K4Lfp.fp--
