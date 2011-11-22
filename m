Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1KVDZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:25:18 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40428 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1KVDZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:25:16 -0500
Date: Tue, 22 Nov 2011 14:25:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: linux-next: build warning after merge of the wireless-next tree
Message-Id: <20111122142502.ca68d0a1640b2a8480d51ad2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_14_25_02_+1100_ika2I3GvSRbSNfUQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_14_25_02_+1100_ika2I3GvSRbSNfUQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build
(x86_64_allmodconfig) produced this warning:

drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: data definition has =
no type or storage class [enabled by default]
drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: type defaults to 'in=
t' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: parameter names (wit=
hout types) in function declaration [enabled by default]
drivers/net/wireless/iwlegacy/debug.c:1410:1: warning: data definition has =
no type or storage class [enabled by default]
drivers/net/wireless/iwlegacy/debug.c:1410:1: warning: type defaults to 'in=
t' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
drivers/net/wireless/iwlegacy/debug.c:1410:1: warning: parameter names (wit=
hout types) in function declaration [enabled by default]

This indicates that this file needs to include export.h.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Nov_2011_14_25_02_+1100_ika2I3GvSRbSNfUQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOyxYOAAoJEECxmPOUX5FEPncP/iq68LFuZIr0VqTbYXvSP8FN
GuUMaeUR7snVSQ5LLoAHVMO6X2Jx+YMla25x3xmZ3VBw2uabZ9oC3RF2gZ7bNzgh
FxX/ko2IsZBM1uR1dth4hZjKSVXuZxac+YOSQskQN6dggbDPRM8bMhBxOeAJbcRH
k8V/fKK0exvit/+aafXoFKF0TmDdliMF9k5BwhHKWkCulFBx+/kKK4PBdxLFx6sN
ElDYf9tiULvMRiClK9oOSE4JEmX2DCzk08dBqIuF+JwZBp2SlV5ZU6Kp32wcGGKt
BRWoNsLeBAgE7VjTs2xapxYr7k+GkK1Qls3uY1GKTYhqtGbgjfkvFp3OUrme34NH
y28DbWX9bOnPdn9ry2mkvCQW1oprGFdfi44/8f6JsbbrQgQ+K3HC746397IUGr2M
DlMuNUKlpLSTtgS8PsRj1lrOaQiU590uBdgoZB37k3jXyc8i8CUmOvqFlsktB5nX
oYmCY+LiHhGkvjnA9rqtTU0ptHPZWE3RIZKCXsGivwp1y/ZL7Da4/jH5zNyVllqu
sa3Hz1kd4WSVWAdjLSIKcS5ea96Vvox+kScyQJLWH0n3D2+lvv51Lfx5e6FXir7A
1n0/SU744jU+8z9b+yuPp8wwiADUVysgQ8TcnZJaPik+AYvmXDMSTf9rj4TAT3J/
qJL/OQzV2u2WKTQw6jyT
=Z7dW
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_14_25_02_+1100_ika2I3GvSRbSNfUQ--
