Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705Ab0J2Amv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:42:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33093 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab0J2Amo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:42:44 -0400
Date: Fri, 29 Oct 2010 11:42:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: linux-next: manual merge of the xen-pvhvm tree with the xen tree
Message-Id: <20101029114237.ae45f678.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Oct_2010_11_42_37_+1100_LjM4Cn0Ftf6vGToO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Oct_2010_11_42_37_+1100_LjM4Cn0Ftf6vGToO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefano,

Today's linux-next merge of the xen-pvhvm tree got a conflict in
arch/x86/xen/setup.c between commit
a1857ddc9ba2dfdbfd70171181e481f2f64b8d0b ("xen: do not release any memory
under 1M in domain 0") from the xen tree and commit
4ec5387cc36c6472a2ff2c82e9865abe8cab96c2 ("xen: add the direct mapping
area for ISA bus access") from the xen-pvhvm tree.

Just differences in a comment.  I just used the version from the xen
tree ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Oct_2010_11_42_37_+1100_LjM4Cn0Ftf6vGToO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMyhh9AAoJEDMEi1NhKgbsBQAH/jfdWUZfubFkqF9DxjplWXVB
EGA0uWXCK8O++hw6fAy9bzilihyPxOhJiDMazrcpK6awkn7ULPDjwHRRjp79hhc2
IE/lvjjt3NBCpEZDhkPTnWlBW1+z8IlXXSMTIOIQvBRky7xa8asCzY4GAJYDysuV
9zsq0+vJu01W4+eQih+xFminNPSKjVzKbgMvyFgyuZwZNU1rpb5XTyWKCqK1Yvkv
R/Y+G8Bv8tId1QiI09JZhGpoAdBi5wdaFAjh1PjyDSP83ZdxYyjJHmjVWnXV0IIL
PT2bgkYkkZhX2FtSzbg3iOKk63g82K6lpLTF5i+gHPpNcnHPPoTJcCgqR6nwXHE=
=ljwt
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Oct_2010_11_42_37_+1100_LjM4Cn0Ftf6vGToO--
