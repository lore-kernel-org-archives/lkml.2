Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1AaCZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 21:25:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36727 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab1AaCZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:25:30 -0500
Date: Mon, 31 Jan 2011 13:25:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: build warning after merge of the cifs tree
Message-Id: <20110131132522.a81827db.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Jan_2011_13_25_22_+1100_e5/flyaIUMvz=l4u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Jan_2011_13_25_22_+1100_e5/flyaIUMvz=l4u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/smbencrypt.c: In function 'mdfour':
fs/cifs/smbencrypt.c:61: warning: 'rc' may be used uninitialized in this fu=
nction

and, indeed, it may be ...

Introduced by commit ee2c9258501f83d3ed0fd09ce5df1cec53312cf0 ("cifs:
More crypto cleanup (try #2)").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Jan_2011_13_25_22_+1100_e5/flyaIUMvz=l4u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEbBAEBAgAGBQJNRh2SAAoJEDMEi1NhKgbsoQEH+I/fl7+GhwzA+qZ5uzhEasDW
6Dpt7HK4B8VDaQxsxqQ1Rx6KOykCIpVJ05DlG4pyiuHW80Mpy1+r7PoRkS+a6kj0
653jgq/up2hvpNiFLnLztOYDx+H9BPNWZ6Gs6olCxssxDl6y/C4TVKzkAKWwIZAd
ioD8cxSlJlQIaFqGHeTtyWAcVmmA957O9NMJSPOruALywGWKKdFpxwLnw7l/LoJT
PqC7Ixz1Yg4A6Oz4BbKBKeEps1x6/zuhIzLB/P1nt0u9e2y1C1uaxRKmK8rj59ug
9zlh2k+y4YzXRQ76XTqH0EJ0KnWLL34ymraZOFXVSK1OvqOPeO4DqJDi+s9wzA==
=QRgj
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Jan_2011_13_25_22_+1100_e5/flyaIUMvz=l4u--
