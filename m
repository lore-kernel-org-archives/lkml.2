Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0KJA4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:56:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46712 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab0KJA4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:56:21 -0500
Date: Wed, 10 Nov 2010 11:56:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build warnings after in Linus' tree
Message-Id: <20101110115610.45619ae8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Nov_2010_11_56_10_+1100__DZjebravDR_/Psy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Nov_2010_11_56_10_+1100__DZjebravDR_/Psy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

With Linus' tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

drivers/xen/xenfs/super.c: In function 'xenfs_mount':
drivers/xen/xenfs/super.c:128: warning: return makes integer from pointer w=
ithout a cast
drivers/xen/xenfs/super.c: At top level:
drivers/xen/xenfs/super.c:134: warning: initialization from incompatible po=
inter type

Introduced by commit fc14f2fef682df677d64a145256dbd263df2aa7b ("convert
get_sb_single() users").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Nov_2010_11_56_10_+1100__DZjebravDR_/Psy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2e2qAAoJEDMEi1NhKgbsIM0H/1xttSuB/zI9YUkP1b+1Ji3t
KPkK89/gTJt/o5Svo6tahnIj9bw2wNkemOkWA4bWvxeASFAprABlxt5V65JAzyW/
1WpP0UOy5BSRmePd2CJYSAnaznz6W8IuVP7Ns/NPp08w4km4X+jT8Hz76tVTcIPQ
thWY7Qo6o23fLF7s/Q9X1ExKBsvTp1wr2jwmIfeT8ekcakLSG8KuY6hfATTAV8u9
dPcaUb+sx4B3Ng1P17gp0SPDDAZBixeoEihjFWrQk5LSB8llg3q9L+axPoS6mAWo
Y5mCOozQk9TohiGJtuJ6LwCgqZWIsO3l1qga0RK2N9WmfNJDbkz9bTZtjJo7f4c=
=Kvt7
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Nov_2010_11_56_10_+1100__DZjebravDR_/Psy--
