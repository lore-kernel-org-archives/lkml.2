Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2BFB0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 20:26:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42220 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab2BFB0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 20:26:05 -0500
Date: Mon, 6 Feb 2012 12:25:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120206122553.e794e84d5f586619d710fdcd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Feb_2012_12_25_53_+1100_8455OFflLRE4p96H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Feb_2012_12_25_53_+1100_8455OFflLRE4p96H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/max9768.c: In function 'max9768_probe':
sound/soc/codecs/max9768.c:138:3: error: implicit declaration of function '=
snd_soc_add_controls' [-Werror=3Dimplicit-function-declaration]

Caused by commit 022658beab55 ("ASoC: core: Add support for DAI and
machine kcontrols").

I have used the sound-asoc tree from next-20120203 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Feb_2012_12_25_53_+1100_8455OFflLRE4p96H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPLywhAAoJEECxmPOUX5FEOREP/3P43HFPNXNq9hBLYsSkuYrm
PGVVM8YTHhVg8SUIeX4524gt4skbGdHy4BqiUb32vfpJFZno4bY6jyDCFSEKTRSj
g6/X2SQzswKACRvBIBd2g/JnP5pAQr8eAZnBRGIdON4QpOKzNc6EY4tl4ukuSv/R
L7Bnx3lVdLKRk343+XPTpzBsndt0rVE6ncFOHblJazpbvEaJ7JdwhTe1/emXAkBf
WQsMslTtXDaoSD4UcwF1QzaXXEYjtb2zRdOff0rZSJYimDZCm08bWwhNgeDLYLKX
SYYFuzZkEagT3L4LlSIjcr2y9OcS0e7v88msLJFSK9PxEECrbM2RSl/NnnOZp7E8
ndeELDicvaE17swcIRmXaqXteMqZBXQynUbpIYQO0oZ1g5SuGf58N5obs9zfoReW
WSbL//HCxwntphCTPo+ucmMhG0Nkzfqs1XPlULF9lun/N5SHOJUxNXrjEdL6JV0w
y6S6KJQe1f5EZJKX98A96KoDT4KKFdET2czZZmHB0UzB+LGP3yXm1Y/FyCyjnc7O
8mw2AUJLDrFwQFoPosMLG7J3o6rmjbikq/lDNdXvemvP2/HUxa06OCPrq5Dfo8HE
aD88eXcBbMM27MdPKkCWtK2AAKkUe4rasGc0ie5mEVuuog1POA9XctKXvLARBuns
r7TbGNYzNgk9knNv/gUG
=uvYg
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Feb_2012_12_25_53_+1100_8455OFflLRE4p96H--
