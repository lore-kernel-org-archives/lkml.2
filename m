Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab2CUOjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:39:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:30509 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757738Ab2CUOjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:39:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="123414860"
Message-ID: <1332340949.14983.9.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: phram: fix section mismatch for phram_setup
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Ryosuke Saito <raitosyo@gmail.com>
Cc: h-fache@ti.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2012 16:42:29 +0200
In-Reply-To: <1332323267.14283.13.camel@HDL00099>
References: <1332323267.14283.13.camel@HDL00099>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lwullPuVdty3QrSXSfIw"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lwullPuVdty3QrSXSfIw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-03-21 at 18:47 +0900, Ryosuke Saito wrote:
> phram_setup() is only called from init_phram() which is in .init.text,
> so it must be in the same section to avoid a section mismatch warning.
>=20
> Signed-off-by: Ryosuke Saito <raitosyo@gmail.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-lwullPuVdty3QrSXSfIw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPaejVAAoJECmIfjd9wqK0NaIP/3fthKv8KXnBdFSqtLfeKUky
bFfQ2g85ON1rbubHTiR0t1GDGaOn280Ny1+/siSiolGJrI76bMcsXetk3GbEeUy+
AecODRH2qOTBa6kDuTDLtlGCCz2zsCULqocMQtG7wh7JgmxZdZwFupNJnVjADqP+
CXK/c34Vx7KE1b86xJKS4gZ7rlD1U8rWi1FCPTLrM5Jrg0s9qg7GtTVCrv4vx/2U
g0tzssJ5vK06OXmeLBleKM3rhrEAy+EvE5qymEFruedx6jfY2/MXtqqDQ+dIrFi5
xFLr4guQtw4czICuzKaiS1sdo1WkypQC6FzDtfYVFcTslF93RqQ9JXaNMlOlUBM/
YGKDTiTji2r5FgRBoCqhWq6ihoU9wPlixj6UCW6d9KEDHejSyP4U90SUEJg97SiZ
iJsQlOrZRzK+Ocd++zNGPIhL9fKZsMXMx944eeZh6EaLD29Y3YZbohw4Pz1JjfhM
CfqjC3g/ehKEPxZNAFUaDj3/ND5UWyyXFzgGBfqjCFrdfVaA2f88+uelgr1MDyAO
oM1wFP2o1c14QLe7cweGVoqSHV3wu1CaqXhNf5x29F2QkrU9qdKmyt3CkkZGBQTi
G4mFSk9R8jD9KTCJiOfMfcrjKSsW0CF67wX2OWdQn7r2tUdo9YiSCFaC/J2jXp6c
jBT0NmOnOICyWSa66+b3
=C3IH
-----END PGP SIGNATURE-----

--=-lwullPuVdty3QrSXSfIw--

