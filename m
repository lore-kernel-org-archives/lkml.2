Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1FNEbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 00:31:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41439 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1FNEbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 00:31:16 -0400
Date: Tue, 14 Jun 2011 14:31:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the trivial tree with the  tree
Message-Id: <20110614143108.f7c19c54.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Jun_2011_14_31_08_+1000_ITIh=.ebl.fzehRv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Jun_2011_14_31_08_+1000_ITIh=.ebl.fzehRv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
sound/soc/fsl/fsl_ssi.c between commit 147dfe90f730 ("ASoC: p1022ds: fix
incorrect referencing of device tree properties") from the sound tree and
commit 28f65c11f2ff ("treewide: Convert uses of struct resource to
resource_size(ptr)") from the trivial tree.

The former supercedes the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Jun_2011_14_31_08_+1000_ITIh=.ebl.fzehRv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9uQMAAoJEDMEi1NhKgbsR2QIAJYoQCoCq7BU9S82vc6NPthq
977QURBP1W7+C+maG7+arDGOlMrltLQ8xohtPWiZ0DmduITSAyAy2IX4m/1tMSlT
MFi1zzUBNBGoGlSjfwf5ac5VY3kvs5AxZ5SpRcmIrpH2mRpJgNVNPNjw9GtxNgd0
Umx+GdWBGjZYxYLYXIchSM5Rvpqq30msNc8VCfd5kyLziGEo8Wj5g3DBBjXnQVO8
JmTJ5g+Aew0vuNVEW2yVJ+UHmWExWRWgQAm2m7BXxDZ1zKL9pPpk5oDBS6d5Q9fb
NzST5nxfCHr/UH3TcoTXxpGQ2aOj1M4iNxN7oGKft6qYeV8GFNUraOk+RPDg5m0=
=otKN
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Jun_2011_14_31_08_+1000_ITIh=.ebl.fzehRv--
