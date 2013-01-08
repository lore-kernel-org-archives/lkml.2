Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3AHDTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:19:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42142 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab3AHDTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:19:32 -0500
Date: Tue, 8 Jan 2013 14:19:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kees Cook <keescook@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the drop-experimental tree with Linus'
 and the net-next  trees
Message-Id: <20130108141927.5ad3a82b9758e75fc068f895@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_14_19_27_+1100_NXhqwB/22=SIexiQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_14_19_27_+1100_NXhqwB/22=SIexiQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kees,

Today's linux-next merge of the drop-experimental tree got a conflict in
drivers/net/ethernet/intel/Kconfig between commit c56283034ce2 ("pps,
ptp: Remove dependencies on EXPERIMENTAL") from Linus' tree, commit
483f777266f5 ("drivers/net: remove orphaned references to micro channel")
from the net-next tree and commit a9270b9a8436
("drivers/net/ethernet/intel: remove depends on CONFIG_EXPERIMENTAL")
from the drop-experimental tree.

I fixed it up and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_14_19_27_+1100_NXhqwB/22=SIexiQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ65A/AAoJEECxmPOUX5FEmdoP/iKs+T9hrT9FJVHZutyfEHmH
RbwE9RLC/qmw7lSgXFuOajfuFH/H407hT4dLIRDfQbdkThHPnNfUV1A0MKmVccdo
dymKpzztVJD+AlOr35MgEppsQhs1nBS9yhh/prMApyGTV05uiwavNlWoBH2RqAsT
n/9RkbQYm7k3Fcq+LNEqXDdyjimWk457Mj8mBRSJsCj+NPLrrFaJ35WbQACWwqKd
ca+iCbAe8tGHPjwElif3dpm2np+vo3fhdOMclBMn8BxRhvb5A/uV0vGRFbPil+A8
fLFLR8U/JcNeidCMGlFwUlkn0E9BHWr8sOXNHjacJU4zrxCu5GIWt56tylIxR8sa
iLXOqWwV+o0auRzFC/CSgGqEGrA5ddzAYvl15+UHTCC7MgLARiZIHoiPd8+i775W
lE4OFawKX94SNPuMDlOv3RdLy9cXQEZL2tpn5U9DN21ZhgTR+W2WEC5PRVkfHoj0
81q2mVWxfunK9oKw67CV3p86b1mfSKJ52utJE1+k936PODwXW5Qu7hG16yagWsJW
z2fihoIGNL3/gEuWy4stacsYhQSbmhyq1XyipR5a3KXaXNL8uHAK0ID9pelycSJF
E2lpOyguMLxemXPgPNg3vecuKphQHAINuQHYR9nmY34y7qfYOS2Vc0R0hHPkMdXT
gaTmAd6MH1U6SiahuowR
=0eqo
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_14_19_27_+1100_NXhqwB/22=SIexiQ--
