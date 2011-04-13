Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1DMCa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:30:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56545 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab1DMCa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:30:28 -0400
Date: Wed, 13 Apr 2011 12:30:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110413123014.ddad9450.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__13_Apr_2011_12_30_14_+1000_z3cfp7OiAQDsJDKP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Apr_2011_12_30_14_+1000_z3cfp7OiAQDsJDKP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-core.c between commit 25985edcedea ("Fix
common misspellings") from Linus' tree and commit ee3cd7e04ca0 ("iwlagn:
cleanup to remove the reference for 3945") from the wireless tree.

The latter removes the line that the former corrects, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__13_Apr_2011_12_30_14_+1000_z3cfp7OiAQDsJDKP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNpQq2AAoJEDMEi1NhKgbs1qIH/2eTrvEZGzYmHs9XVSGqqome
JcHmiQL5WdJJY0EzifLP9opLvRs05KvV6R/SwPxWx7Ehg6fU5THhkBTVy4IH9k35
lSNdzL7BEmiF+Lv82zM4cy58ULZwCHfpZaSQBI5sNr5Zi4XW6cYfU5uaxZGSuKnw
iKecWPSx2nIt2hXzbtsUDhFUJknixa4z/g5X2132nVu4w8ETBM2DJMcUSGl8OiOc
674FZ9hZmHTYfzAl11O+ryrLTKTyrG7bE4X2UcNpw7CRoF2dCztKDSCQmoTRPnEp
SUBgbpIia1a4syST29ZP496Xe9ltyYrQS+n/icPD8OtuDlL32zx2UtWRyEQZy48=
=ZFWp
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Apr_2011_12_30_14_+1000_z3cfp7OiAQDsJDKP--
