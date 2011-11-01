Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab1KAGAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:00:12 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:39459 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1KAGAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:00:11 -0400
Date: Tue, 1 Nov 2011 17:00:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: linux-next: build failure after merge of the edac tree
Message-Id: <20111101170000.6e7301a30bc21e917631eb88@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_17_00_00_+1100_cclQH4z7e3WcqmFw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_17_00_00_+1100_cclQH4z7e3WcqmFw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the edac tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/kernel/cpu/mcheck/mce.c:39:28: fatal error: linux/edac_mce.h: No s=
uch file or directory

Caused by commit cdaf4f4e563c ("i7core_edac: Drop the edac_mce
facility").  This commit removed the file include/linux/edac_mce.h which
is still metioned by the above file (and MAINTAINERS).  Grep is your
friend.

I have used the version of the edac tree from next-20111025 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__1_Nov_2011_17_00_00_+1100_cclQH4z7e3WcqmFw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr4rgAAoJEECxmPOUX5FEcuQP/00Hb+k2GilzGPMNaG7evd2E
AXxBrdbgjo9F4yPSQEdXOicGLEi4wP1G9VKfd+8tuAqmlhJnNlQN7nyBOTI4CN5b
Yho7w4RbbSZ/ONAFFiaby7MLy4lo1AcB8kTRZ3E+uB4NJZY53f3AIQlmEsCP+Wne
WfibnqddB/UiZd/M+H9v6JXUvY7AcMFKqx5+wauoOpH5L6ots6TphtJJJ68RhgVz
lviSthRWLQ6+Kccx1bagIb3klaYjrhxFaM1mXLbsXjJSCOwcRZvLOJUuYUsTACni
V6cZXeFcUBhPLAvQbD1GewsyfTY+WlOr5toy9yu2isShbfYV0ipnyQFe8jvs8omf
uZ+IwibYoQ0yGJuiN1P4orKgQFpiwW+ss5CACTyQzmTZHIeicWhbhirGP/ZDv0ly
Du4o0pANe7qcD+xyFXQ8J9cEKTufB0wKzb6C7SscKim7Dc0/zX0T9jsFtqh0+jQp
Gacl1SNXrLdyO9bU0rfYjACEixXY58OJ0+u/Se+HwziTHwwrMoK1/hKxWmWqV/w8
+RZKHc3e3YLHGBlZFGjZ28PztIeOi6Uyq5/PJZGqvhzz4DbLunxvhzRSU1OsE6rJ
O6NOs4vj/Cchv2XIv3oe5LTLw5JP5cRVT17OX0xjiqVtys+5qhzOj7m6iUOyeJSA
SHpmmV1H8Rh/d45Y8AWM
=3XpC
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_17_00_00_+1100_cclQH4z7e3WcqmFw--
