Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1KVGR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 01:17:29 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37621 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1KVGR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 01:17:28 -0500
Date: Tue, 22 Nov 2011 17:17:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with the arm tree
Message-Id: <20111122171717.25bcc1eaf6b7e80cfa34a554@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_17_17_17_+1100_JVWvtsWbxH90o4YU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_17_17_17_+1100_JVWvtsWbxH90o4YU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/vmalloc.c
between commit be9b7335e706 ("mm: add vm_area_add_early()") from the arm
tree and commit "mm: add vm_area_add_early()" from the akpm tree.

These are clearly meant to be the same patch, so I dropped the version
from the akpm tree.  (The arm version has a "BUG_ON(vmap_initialized);"
at the start of vm_area_add_early()).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Nov_2011_17_17_17_+1100_JVWvtsWbxH90o4YU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOyz5tAAoJEECxmPOUX5FE7hIP/27GBoc1+SqU3S3KzX1Pwief
/IQIiQsv/CQHM6IbFgB7wbHgDmCoGJMXICzWQN9DfVxv+5rzOz2NnC+42/eyxia+
KDCy5TggvmU3dHJ1NLdxpxxRCLpGZszeqI8HV5D/cne6UI6Zd1SOUZM/yHCbyF7Y
9Hn0uASjlLixQyDbQOdW+qfFkT34uYdV3a1rL8CXl79vLUBpigNd72o+ZYrIXZJ7
4970ZXoxf600q539zvidsXjSfTZ5ziI6jiy0M6kprjfgxVmcIFVjYUrsRv58Yj9k
d+Sd5GKC57AIahL+pe3ihZJneXQjls6wlin5BP4fK15SZfXj3aBml9QMteYI0z/h
bGu9K3tL/2vYYNPESmNgHf57nrFh6hWA9MGdJP4ZrpkbFPaCz99roTKkBvt3Fyc5
8/q/OPFuhkjAwbVn33xrVqW3pk/OlwzKhMOS6T8Em4Pzn20+RqSAQY1A1y5D0qSN
C+8yNLnX8RV5A/GHJUg1aMYfwtdT4SjOIJ95WG4M5PfUcBmKnClCNzJiMmUT9Nia
toZIdR0NuH7c10cvFCayuYQJHst0/o66K1KZObLYpzXmYbWkT2Yfj4OcUOvq6psO
TG/ZNk6U1mK2sxxppVbe8w7BKlRMtJkxuAUoXkDhYFgbVazt4DGvO7ZUXMJO7MRE
MPBI1LM93XwYAQop/x7M
=RFPD
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_17_17_17_+1100_JVWvtsWbxH90o4YU--
