Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2ECGQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:16:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53997 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2ECGQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:16:38 -0400
Date: Thu, 3 May 2012 16:16:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: linux-next: build failure after merge of the final tree (net-next
 tree related)
Message-Id: <20120503161623.ad219e088031fd66be212407@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_May_2012_16_16_23_+1000_ivTM+H94r94IGoid"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_May_2012_16_16_23_+1000_ivTM+H94r94IGoid
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

net/core/sock.c: In function '__release_sock':
net/core/sock.c:1703:4: error: implicit declaration of function 'prefetch' =
[-Werror=3Dimplicit-function-declaration]

Caused by commit e4cbb02a1070 ("net: add a prefetch in socket backlog
processing").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__3_May_2012_16_16_23_+1000_ivTM+H94r94IGoid
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPoiK3AAoJEECxmPOUX5FEIGoP/iFFZK3g3lM7rFx0pM51ojqA
rOK0p8I5wo2fsZkd1ODN5ROJ2Q9Hf0w6h4GKEdMaJ13RqhnFFcDLiNLw002QRFPx
q3LKsbIcwOACG+KTB+Kj4+4iYzT7HE6gt6PudPf0cDs9n1iezN8xXaLnRGT5UvXr
SenXPbV0JMyt7s9W7tbG8Ak2ttbjYZJuK6/rleWA5UeRWnHNT5zK/qOtmHGwPzlC
zYn0LnUA0oSYi47zkSsfTVTI5VWYp2I4yM+s0qJdFGX6q24xWBpruKrzD/hQtQVO
ZhCr4aFrOPSA8z6A+FQSJROGTKfsgEaRo30qSjMCVDAM6Ew62+L/1940LQmYZvSd
2kWguO5WQKbLBpYzhbD5Ta8wCD2J/p1Qm8MCDqKKCQr5AdDMdMnhHFsbl3O7Hxrl
53xLlqCb8xapVpkyWrIbvGNLcwh6lpq8Cxrbyi5H2YLOBcc/QjKTCVs5qFt9uyQJ
ERVaBjzV9Nr6jTvsEKiUiEYNtv/IrW/1H5ADA+6HJa8DrrAMJgnqWsKOIXc8HNfR
bzZNQltFgkmMTH75i8E1S6v4EiOnTZRIv9l9s8plkJZfydcDViV40J6okcOKgEaD
BsW2KR8nkpKt82w0+70sIdAiThW41bGqCnuGgV8aAwiC+evDWPwUqWbcrSGEhuEP
Yeec9w4gJTUb7A7hr/Gf
=/B9u
-----END PGP SIGNATURE-----

--Signature=_Thu__3_May_2012_16_16_23_+1000_ivTM+H94r94IGoid--
