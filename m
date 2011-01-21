Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1AUBmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 20:42:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40226 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab1AUBmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 20:42:08 -0500
Date: Fri, 21 Jan 2011 12:41:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Bader <stefan.bader@canonical.com>
Subject: linux-next: build warning safter merge of the swiotlb-xen tree
Message-Id: <20110121124159.135c7f5f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_Jan_2011_12_41_59_+1100_c7ne_pRzLecPJevX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jan_2011_12_41_59_+1100_c7ne_pRzLecPJevX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

After merging the swiotlb-xen tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

arch/x86/xen/p2m.c: In function 'xen_build_dynamic_phys_to_machine':
arch/x86/xen/p2m.c:251: warning: passing argument 1 of 'p2m_init' from inco=
mpatible pointer type
arch/x86/xen/p2m.c:121: note: expected 'long unsigned int *' but argument i=
s of type 'long unsigned int **'
arch/x86/xen/p2m.c:254: warning: assignment makes pointer from integer with=
out a cast
arch/x86/xen/p2m.c:256: warning: assignment from incompatible pointer type

Introduced by commit fc0976e2c086e6e518e32dcafedb5a2ba3ea297d ("xen: p2m:
correctly initialize partial p2m leave").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_Jan_2011_12_41_59_+1100_c7ne_pRzLecPJevX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNOORnAAoJEDMEi1NhKgbsHgsH/05xtNQniRUVReDvEODiNNep
QMkdyqO9LYhuk4CELE1ZaPyecaHrdG+dtOV/Lmmg1nkn42TKtjPpDkc9nwb6HY2C
eYQNslVsar2VNdU0MeDhSZGDeJudzicBiZGy0+aHp8TdN49sKDqGnRL2Ks6M+fAE
VuJjJJjolM/hEqNAuQkFq1A0m/Zzg2Iu0HzwgcAtEreqDVdNk4M9JTff/3DOJpqY
0rKiixgGXOf9s/OojPEWwB+G9rdVeubXogCA/3anzeREyilnOrIz10sfMGoxdUBb
9qp7HOU01qaL6TSiHtD2Ju0MebuDbtJtJ2Ha2b4hmx2e0UY9uIZkuCKDNE783z8=
=nydy
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jan_2011_12_41_59_+1100_c7ne_pRzLecPJevX--
