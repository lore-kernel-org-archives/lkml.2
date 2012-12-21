Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab2LUCUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:20:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39053 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2LUCUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:20:24 -0500
Date: Fri, 21 Dec 2012 13:20:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the pinctrl tree
Message-Id: <20121221132014.0bf8772fb3e48c51cec1548a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Dec_2012_13_20_14_+1100_HrPkzc4RivqqWAMo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Dec_2012_13_20_14_+1100_HrPkzc4RivqqWAMo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
drivers/pinctrl/pinctrl-exynos5440.c and
drivers/pinctrl/pinctrl-samsung.c between commit e5b4c9d4ab55 ("pinctrl:
exynos5440: Fix compile error in pinctrl-exynos5440/samsung.c") from the
pinctrl tree and commit d5fd5da290ce ("pinctrl: exynos5440/samsung:
Staticize pcfgs") from the arm-soc tree.

The former is a superset of the latter, so I used that (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Dec_2012_13_20_14_+1100_HrPkzc4RivqqWAMo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ08deAAoJEECxmPOUX5FEZYUP/1OKa6F9BtTw7jcRkesP2wAW
XWqsWPiZ8oowwHc3meA1qIydXIbPq/j6Pj7oB7GMWOR5MoTrEEv5ErvrfQnCe3f6
LQ5gr97drPoAidL/4lLZ3th08K6HK0fHoLFZ6Z2pjFCRlDImAWkPHBrVnRHZ07t6
nD6+iooK5TUZdf6WM+geOxDg9mlP1wBJeKrfghyDfMkS+7aIcNUzS20WS3HjAbct
4u4cQZIUZQn2AAcr4f/XnJhy/rlYwvc6qRmO3QOQd9VGaTd8L6C4gGrwUB3YPTwL
Cm7KlZ5NlRORA3FO05b44l/6ct6V5TAwe7zsxdwQxWm69TGMMXA1RNay8EATge1l
or1uGYNbU1gVJQBUvjbeef8cZeKL0zuWdjJOMK526waRmFfkyTIHYELZURIcZsWW
cMQ8KnlV7K2KewIXhtn7KdzyP+Lc9HwzFMJyu1rnRfU14hBnkvbb4Hy9/NtgFXYU
/3X580If/sXKNF4gqJTZYAOkCPllvIetEeQW76yBepTkU+NBWQ0gBaPa8zMDIt37
X28B4Vqfa4uGDXk8VdKUIKIf/bS+0ia6r5mTqQfhqQz0wP33sHY/4qfUhOJVt0l/
WQ99UHW9hxWmcAi9CKwP/fAkYg+7tOS2hEKACcG9nXPs4pB2/h65Dx4pO8fj5tNL
jQFrCtrm/Vtv6kuqsNHw
=9I96
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Dec_2012_13_20_14_+1100_HrPkzc4RivqqWAMo--
