Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2AaD15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:27:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56330 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab2AaD14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:27:56 -0500
Date: Tue, 31 Jan 2012 14:27:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: linux-next: manual merge of the kmap_atomic tree with the
 staging.current tree
Message-Id: <20120131142747.a2dd139403833a50939dbd17@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jan_2012_14_27_47_+1100_ef3dSH0lNoSS=XGU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Jan_2012_14_27_47_+1100_ef3dSH0lNoSS=XGU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cong,

Today's linux-next merge of the kmap_atomic tree got a conflict in
drivers/staging/gma500/mmu.c between commit 344bc24c2947 ("staging:
delete gma500 driver") from the staging.current tree and commit
cb422c115787 ("gma500: remove the second argument of k[un]map_atomic()")
from the kmap_atomic tree.

The former removes this file (as the driver has migrated out of staging),
so I did that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__31_Jan_2012_14_27_47_+1100_ef3dSH0lNoSS=XGU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPJ1+zAAoJEECxmPOUX5FEnYMQAI4Q05nWk9PuW1rQgsUOf4oP
v5dumtFA/gnaNT8juUquheJpPpaklUq99DTwZhbdX8WA+H030kjHE1NX8hQROf7c
N0G5FGXNECxEbRGAUMt9kdVpUqnA9tN7zbMYpIeZfCeyykPWa8FEp2CaulP/qVh8
u3xRyb2VlHDk1J8Yw3ZZRjGZWBm/V4NKDexRBrpige3rMNON3Cdh9g5/Fre3hU4M
9VrfLE4UYiJhgx5g7nzDRm3GxGErWCVG5f8XVXwvh+THaXtVsY0xMLPcnHh5lX4F
q7sni8MohscyPG8aoV26VSxA1VVoS4K/HXL643ue0fCT3EG8AW57yxJMmTGlolon
pYosT+HhlrpvT2gCBYmL2AXOXUAL+UK3COxYoorYjY3Er+sVzzXS+jW557dv3Lmz
jKJD/UXS7d1AMqY0vcW3cLrZaNHGBtean9awwR9GW71EPg74au1S5Q4FA7LUFLgI
i7l+KSYpdAc5Pkb3mlloL+s1gpnZmO7JGdNbGVfTeKPm/Yt0kuSDkPXfJYa19bIK
/hbxzifweNY29jP77oyVK1No9VYFqLMwN2JUKFLalekD2nND7XUA8HUQgGdeK+fT
exZ6g3XgqywDxsmvzHeto0spVF8CypZ1sMYLNEnYgev9EE7kaTQrOJfY3Zl14EiX
Yfxp+L9DF/IsIv1/8fET
=uZhk
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jan_2012_14_27_47_+1100_ef3dSH0lNoSS=XGU--
