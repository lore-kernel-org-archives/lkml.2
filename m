Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2GQCaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:30:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57607 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab2GQCaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:30:15 -0400
Date: Tue, 17 Jul 2012 12:30:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sangbeom Kim <sbkim73@samsung.com>
Subject: linux-next: manual merge of the regulator tree with the mfd tree
Message-Id: <20120717123007.8e6aeb257ecb88378f3320e1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Jul_2012_12_30_07_+1000_pOF_WitcXvhVIvnn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Jul_2012_12_30_07_+1000_pOF_WitcXvhVIvnn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the regulator tree got a conflict in
include/linux/mfd/s5m87xx/s5m-core.h between commits from the mfd tree
and commit c848bc8538cd ("regulator: s5m8767a: Support AP watchdog reset
operation") from the regulator tree.

This file was renamed (twice) in the mfd tree, so I removed the version
in the regulator tree.  The changes from the regulator tree turned up in
an mfd tree commit as well.=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Jul_2012_12_30_07_+1000_pOF_WitcXvhVIvnn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQBM4vAAoJEECxmPOUX5FE3FIQAIf9FyNetO0OphxHDYnPGCpy
7cDcZWeutx9j/cpbpBWSmcYFbvvl5KoJ/dyUnhvmpCJrkMdKSIX7qdjhKMKMAky1
uvSbxEyQccljPfbRZNxpGRpzoVMryVqI4UN3b9dVTyal9y8arSy5FwDAlRLF9RrE
wCwLyg1OTnbhjomCkwSYIEsUanAURfNUBQ1VHa3/x9L0hTUwH0jNNF/XQNukQ6uq
szGlXl7kCRtJXGenYmnRWLWrnW5htzjcYKQEYu7aCp6JwL4s5SWex+ieCCLcMRim
kmu07FPX1XUgmf8LXLW+s1BambD49GCJAA1//sn7WggmMT7XYyKsa2gLO5yf54Rh
wVHO3mlDiEpeR6T4chmaSRY3LUPepFn/FV2kiD5a+/bxghOsJGiCxNl60O38T4bq
02cX9UTqA8M9Mu1d87VUaZjdUYS3rAkJAefSEGRu1xiIx05x8WiKltAg/DYQeg1+
cvq7RM29pnnoTSvgWzPFhqKyNmUdfuNwE0jEFN2khh06xCGmDpshzRrx3jfZh6Hb
8y5mVWoSpWrGQdjmj4v6HUkOVPIC5WOTXQg3f6cGd3L58k7OgETt1XXiEpK7rR8Q
leif6qTQE7+PQa2ELg1+dwTw1Cw/zBEcrMa84Zl6FUSGvdpk4947sWu7IpjQWL3S
exi0pMY/7LftRAuVia6y
=73Cr
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Jul_2012_12_30_07_+1000_pOF_WitcXvhVIvnn--
