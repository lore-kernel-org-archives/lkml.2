Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582Ab2ERFsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 01:48:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47061 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab2ERFsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 01:48:10 -0400
Date: Fri, 18 May 2012 15:48:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lu@amd.com>
Subject: linux-next: manual merge of the pm tree with Linus' tree
Message-Id: <20120518154800.3b8cae2960234e03bee0101e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_May_2012_15_48_00_+1000_IRrGdO.y8TcJ9.HZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_May_2012_15_48_00_+1000_IRrGdO.y8TcJ9.HZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
drivers/acpi/scan.c between commit 5c7dd710f691 ("ACPI / PCI / PM: Fix
device PM regression related to D3hot/D3cold") from the  tree and commit
6ef564fd2070 ("ACPI / PM: Evaluate _PS3 when entering D3 Cold") from the
pm tree.

I fixed it up (by using the version from Linus' tree) and can carry the
fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__18_May_2012_15_48_00_+1000_IRrGdO.y8TcJ9.HZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPteKQAAoJEECxmPOUX5FEZYkP/0xzvyhb46DcntZl2rYCuRSJ
2rK0TY3vCJakZe6a74N8SzE1roe93Hk/GWIAwg0ihGUX5MdLHRKDqmApAFbsUPjw
K5VO3ms0fbFOo9h+7CvIrPX1umpfDKq94aQyUH3yskzlNmdk5HYfRDaIwRmsFwAS
E9WYGwvWJGCQ2q9G8GWVuCS3Vp/hyGtuGGnQPKICdzHmMmGZUbjn0ruaNJQjFjor
MasnJ+qqlozF7xJCLYnCwUj32Nlvv2mnNXdvIJLwZd60fw8i+8hB35Hx2E2T2bZ2
b3PsB4LeIzRYP/lLMy5YoRtScJmnnBFNMmBPwB4J0/mMSFITb3YBVumaMVgkvA8a
Rjmz+EG9j4+lXyYCvq4h8nTyjsjKpSLe7R6S2BgkIXSTumvHZZ8XZXNenQ64RDdJ
uSRCN0l19ZTXF43ML1ptl+yJl81eKpE1Qe+KaTIDV5HvipRZ6YMTp4RccNT379Pg
0OW7E9QL05P02Ygd3GePEChFABA5/hpAgW++5jMnnCJjBUi0ZZ96hyz006IEhPav
7xSRrwkWtlXi8uKlT6+3Ow94rHltCrLrw3SP/OPWEN+ezIe8vc25imF2Re7tLjgs
O3fDLaDlKBEQwh4AmvZY2YiLMt5mH9jjbHH+gGhLi8FbMCFUCbUbLx44FnVJMnkL
Bm/1u8e/CMTimng13EQA
=5s0T
-----END PGP SIGNATURE-----

--Signature=_Fri__18_May_2012_15_48_00_+1000_IRrGdO.y8TcJ9.HZ--
