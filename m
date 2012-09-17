Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2IQICP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:02:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47277 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2IQICL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:02:11 -0400
Date: Mon, 17 Sep 2012 18:01:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Grinberg <grinberg@compulab.co.il>,
        Tony Lindgren <tony@atomide.com>, Venkatraman S <svenkatr@ti.com>,
        Chris Ball <cjb@laptop.org>
Subject: linux-next: manual merge of the arm-soc tree with the mmc tree
Message-Id: <20120917180157.dada1de4e34b3dcf59971ccd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_18_01_57_+1000_VOv8N4m/pENAP=rn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_18_01_57_+1000_VOv8N4m/pENAP=rn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mmc/host/omap.c between commit 2976837c6ea8 ("mmc: omap: remove
unused variables and includes") from the mmc tree and commit cf3a6ec2c0a4
("ARM: OMAP: remove plat/board.h file") from the arm-soc tree.

The latter is a subset of the former.

I fixed it up and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Sep_2012_18_01_57_+1000_VOv8N4m/pENAP=rn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVtj1AAoJEECxmPOUX5FEttsQAJTgY0N/1xA1zQ0e9RlbvAll
FowZuHqBX2YPjrfLqillii75gcP2PQLOsADCr7IZBgT2jCmfyHwHqJKSZGP0uyvL
KWMTRfjBj9e+qbvFd9e2+yr+p59QRYzUKbl6xReiCDpEkQrf8dTKSqqzezxFYkoi
a/Dddg0qnyZiI/bwjFOCbj1EJIo3xOWLhaQA7QMgMRueOVDBwECfQDTOdcwBhDWh
1f/HoEd+mlA2EdMl6ROCbW72zfLwTJbWyZC/od+S1fbw704YrpK67XUp4nfUntvQ
G2IyuDP5mRG3Nf3Kj8FfVz8bG5rch/Yh2+eiObEiUYh6txtdkCnQjymlNmtM5LHt
ZCaEqKUQXX3FLkXq4SaHO16OCrnYWaxBLHTAtSSca7sGxJ4NZz1QcSO51+i6aQDo
T9UOU9m52p/u2U7vpBwIsvZQrU8ZbxY34dXAM4RA83BV1H/0SJV+f9XjpaEinNmk
ZfrMXbDTOffuLC4NccsGKNEBkQOOQyqiL1XkAyUvLE9irj1vqiAeg7SoQNwYyhKQ
e/0Upc24rp9z2IP7/tvc6GqaVwewzt4qqew5lvRa9ezCpWtmDBUtjmys+xS6j02Y
FO0PCRMrd8nNr2SftTyR/iQMsTSbUHeXMzwIJjgzdGD2R/l5O6qMlYdXSnPBEBtt
pZxrlCs9WzYoCfp9EBWS
=zIWY
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_18_01_57_+1000_VOv8N4m/pENAP=rn--
