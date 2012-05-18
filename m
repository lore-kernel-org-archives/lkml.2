Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762490Ab2ERGCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 02:02:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51565 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759222Ab2ERGCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 02:02:47 -0400
Date: Fri, 18 May 2012 16:02:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Mackey <tdmackey@twitter.com>, Vinson Lee <vlee@twitter.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: linux-next: manual merge of the edac tree with the trivial tree
Message-Id: <20120518160231.8ba3d6157cbbc6d8a92280a6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_May_2012_16_02_31_+1000_6TP0YW=EKZqJftmp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_May_2012_16_02_31_+1000_6TP0YW=EKZqJftmp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the edac tree got a conflict in
drivers/edac/edac_core.h between commit 15ed103a9800 ("edac: Fix spelling
errors") from the trivial tree and commit 90b40d5cadba ("edac: Remove the
legacy EDAC ABI") from the edac tree.

One of the comments fixed by the former is removed by the latter, so I
did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__18_May_2012_16_02_31_+1000_6TP0YW=EKZqJftmp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPteX4AAoJEECxmPOUX5FEEiMP/i7cY9apcYrCGATc66FMRtzP
HJQyI/JzhbWh+rFZCSGhBVinIfiOp+EWI6nRATdd7AN3MAPZG6jLiiQCKibTMG0/
Lbku1Bhs3J++K5Rqg8bxM4dAD1sSs5GjTQ5Paq1YJDNf/mor97cNP4gBVYeyiPI2
bnUQNIhQuLtGISQKKgijVVBI6BuQYbKm5A6RFExe70UTesY/gyqagAtkUwqEzjad
wBLhBC4uvKMMoPhVw4CYzsqKxI69yAXufIMhP73EygRBAs1GD+g6uwhvDzb86cw7
Ir8HkgBE3N+DEQRddInUpLyA3N/bVZ25fgM3YSekJJK5Ab4oWL7dJ0JftR5G8VMi
c9yDpksHNQfXQPIC9Eh3pLgN0NxohDvxURiE2w/23jcIzu9/FJxiXV2Ld5x+1N+h
RUmLVqtK/BdGRq7qgeoJ0QwTr5VWXXq8TyS+7zu70cb1pqaXF7If22LNWlSi3jqf
UHDMNmn50vL16c4nIn4J6D9II1M3OhPYYupOkQU+StOo7BxheDOplvdxnvKd2eRg
wqzzdhfTLHrPr8xe2HDCPQSebIxyOwsPoPnQW5qa9D6JzHHJwDujz9679xdCdwq/
LVVxXw0zYW+ATJKT5xHMj1SOt0W9oDbfRzmziTBuXqexunYOMQG7u4lAI6BHYf5M
oyQMC6aIykfcU6PU1R9R
=H7Qo
-----END PGP SIGNATURE-----

--Signature=_Fri__18_May_2012_16_02_31_+1000_6TP0YW=EKZqJftmp--
