Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1I1Il6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:41:58 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:34177 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1I1Il5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:41:57 -0400
Date: Wed, 28 Sep 2011 18:41:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110928184150.0fcf097b7f9128f8639059f3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Sep_2011_18_41_50_+1000_L0zjN0ZKq=mjwi=4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Sep_2011_18_41_50_+1000_L0zjN0ZKq=mjwi=4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) went on producing more failures (beyond those reported
earlier).  I have used the version of the moduleh tree from next-20110927
for today and will see if I have more stamina tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Sep_2011_18_41_50_+1000_L0zjN0ZKq=mjwi=4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgt3OAAoJEDMEi1NhKgbsSc8H/AnRWE8MrZq8p5O+sc8wb+GN
BiuwyKzNh3F14c/PL+hwhxBMPE3eE68xEzQypxKioMAygi9qklGE/Pc7PniAN6e8
RIsqxt0Yn/5bpXyfkhR2lmxaMiPD2LfnYUSFw9dDyutbwVyzKvAkGlwuesmwcaZh
heMFPMRCntReDhO8srbzK4F0qqQM4K2e7vVFqTMqeYEGvLuT34YAzByCJB9u0Tgv
a9YaF0ILiEO7LLN34eZQ6GIxoh0/I/n8FTxdn1zrWT9WRWKZIFCjzl3iCcE8LPd8
1LpFYdf76f3DcGL/oJA0NpKxGvtE8r+pOYjBW61vD7SmySIEI6XvdUOWdvb8Wbk=
=4P8M
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Sep_2011_18_41_50_+1000_L0zjN0ZKq=mjwi=4--
