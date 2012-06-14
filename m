Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2FNDNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:13:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48926 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab2FNDNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:13:07 -0400
Date: Thu, 14 Jun 2012 13:12:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net-next tree with the wireless
 tree
Message-Id: <20120614131256.2fed671219b8d571a47987c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Jun_2012_13_12_56_+1000_hROgnTMBU1+Xh19f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Jun_2012_13_12_56_+1000_hROgnTMBU1+Xh19f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/wireless/ath/ath9k/main.c between commit bcb7ad7bcbef
("ath9k: Fix softlockup in AR9485") from the wireless tree and commit
ef1b6cd9a1ba ("ath9k: Group link monitoring logic") from the net-next
tree.

The latter removes the code modified by the former, so I did that.  The
fix from the former patch may be needed elsewhere now.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__14_Jun_2012_13_12_56_+1000_hROgnTMBU1+Xh19f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP2Va4AAoJEECxmPOUX5FElLsP/jHVoAu2fRP4HMnK5VHSqqQ6
eeJjCRyb7K3fVUm8IagNc36il/G6L41yYvbDCHPRThqPMaBRzEr5QSFO434T796o
LzNy8T+WZ35mCRmOWI6RAhwyCY8UnnCJNjphXMf4SGzD83/BXnOtTVIvyXulTACd
fmTMaBoz5QtXXaSIHWehsX/Z04D7P5f02SCC5y3VqTD8Rz7Qd47R1ur2xcR2BM6B
31ziT7SqcnJ5AmOCcBDps1hB+V6tWzyC/1Ou5AHX7YVjf9GZj2fP3NREzJbGYsHt
sGCS65Zp3s5u7/COzrqSKPsnGDhDx372gJ+27GgoX8VsbjJhVQ2lnEyMZPC/KKbR
oKv7PkvYx1BwxDQy+ElItOxmGGgbjkF4fUw9xNkAEPms+bh3Yywe3rqyGKqv9js6
UJB8mqMVulm0DK6JfhTCKeDl01jM1I3HYSya4RYoiajgOZAvu3sdBAa+MkmKYNQe
k3CraE1J8pQ62K74gqlm8cgHGpRjJLVckvi/EwjG557UMaYypJ50iPsC9AOnvc3H
oo6AqBbXVtxo7MumKlqD2AFf7k/PQ9n5W3su2fjlWudhTvv62Fvx/IfrlIpnepI9
pu7lQJIaQmJ7psuRRnvs7XVOiPmzMevb+yFNq7FqzQJEBzGqYs4WE0Mj089ziUWc
d+1R5TsTXX/7+9ZjU/QK
=ONwt
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Jun_2012_13_12_56_+1000_hROgnTMBU1+Xh19f--
