Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1IODOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 23:14:50 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58399 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1IODOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 23:14:48 -0400
Date: Thu, 15 Sep 2011 13:14:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110915131441.db948d436ed630cd88207b66@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Sep_2011_13_14_41_+1000_oNKCg0pMabc=8ydm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Sep_2011_13_14_41_+1000_oNKCg0pMabc=8ydm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-pci.c between commit 16a9d06c753a
("iwlagn: sysfs couldn't find the priv pointer") from Linus' tree and
commit 65e291acd806 ("iwlagn: merge iwl_pci_down and iwl_pci_remove")
from the wireless tree.

I used the latter version as they ended up more or less thae same (with a
coupld of more changes in the latter).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Sep_2011_13_14_41_+1000_oNKCg0pMabc=8ydm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcW2hAAoJEDMEi1NhKgbsD/sH/2nPrVvgLei5hW/RV5luwUxV
uGtJjhfz35VDuenu8zob3UjX4nFvEe/CuJU66I4djJCt9q1dciAD1sZGqBIxgAKg
S/6APifuespLt2CqlMasZSAF6NN0LaN/sz+IfswpPl4mQahaqgHOol5ag+E7JzuB
KOEHoLDc0KZw0i/td/TAhDJv99RTYRaB2+5i4S6POlJRNbP1uGEFuGPDiTsJswEF
iZ4s84YKxMaAOA/FjpifRjvtyCyZCI2Wqu6DUxWkslquBsoZlTJQ/kcykapedTjJ
LwQDeZ4O1VB1LH3dEMEs5LIW/ntoiP8MpFUYrJ4MN4gwdtzTjqnETLnAq/VWz1E=
=0Yt/
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Sep_2011_13_14_41_+1000_oNKCg0pMabc=8ydm--
