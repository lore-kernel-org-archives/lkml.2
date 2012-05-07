Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2EGCbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 22:31:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35993 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2EGCbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 22:31:09 -0400
Date: Mon, 7 May 2012 12:31:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Andreas Westin <andreas.westin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the crypto tree with Linus' tree
Message-Id: <20120507123100.09a614d4f4eb1bfc14e64351@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_12_31_00_+1000_FMUYSb0TK0PCRiAu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_12_31_00_+1000_FMUYSb0TK0PCRiAu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next merge of the crypto tree got a conflict in
arch/arm/mach-ux500/devices-common.c between commit 3510ec672319 ("ARM:
ux500: remove intermediary add_platform_device* functions") from Linus'
tree and commit 3ba812f4d0be ("mach-ux500: crypto - core support for
CRYP/HASH module") from the crypto tree.

I can't easily resolve this, sorry.  This crypto patch needs to be
revised on top of v3.4-rc1.

I have use the crypto tree from next-20120504 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_May_2012_12_31_00_+1000_FMUYSb0TK0PCRiAu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPpzPkAAoJEECxmPOUX5FE8L4P+we8svQRKxcHWvv9Lly3uFrv
9vjUvNm52mFwZaDeIQSzIboxb/cvMc6hbzvoerkRGA6N9H4JjHUru5jvJwlpQ/n/
KBgK1zDZYPjOGbmREb61aXCJn2Yp4sqU3kWD/qSPujJfnn6quw2QeCstA24Qp5OM
1Snpu7cq/7EPQogi9LGSLFCk/qFYpj5JC3Sf4upwAk56A0PCPIIIHjb01kas4p1k
vZf1SBdUTVAssuBG3x6ZAZOW8uF2YjteN8/xoJh9eDOCc4t2+PUJZZhA92P8IqDG
uMIwnEitt+dDjOL56zMMID1yI1NUM4SUu9qwENGU5SBVciDYjtcA4V9mZFZ57hEO
ymKxJOQzs6GnpcjE8ZCqvsDqEg2hIMYigmO/qI9ghOVGhEsHR4IGhkrFDd/F8Csz
kx7CBbkplwfsBQbaaUUbGRyqSDTZUgcdd2Z67wj8oCpSnhMemzRRLj5hu89FJPd/
kUtf+CD+7qAFw5/Gt6fbAPSaOJF3jIby+A7UpCzBKLSZtq+o1f9aCPpJRjxg0AAD
cTU4GbaqRf3Ze+jmDAtyKpQl6gyVmL5+VVf305lkgsgxxZNFv3Ys+DbjvvCJIp1a
3TsnEYflAMKJxpJVWqIOvQpizJsxULAqOP93SGFVwBD6cNaY5siZNpTzspYjYmCs
Sja16oX4eQUea1lj9PcI
=b+h+
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_12_31_00_+1000_FMUYSb0TK0PCRiAu--
