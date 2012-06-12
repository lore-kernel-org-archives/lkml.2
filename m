Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2FLB7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:59:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35783 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab2FLB7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:59:50 -0400
Date: Tue, 12 Jun 2012 11:59:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120612115939.63908eaf9e0a476a15776df1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Jun_2012_11_59_39_+1000_+FuP.tkMPMuYcitW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Jun_2012_11_59_39_+1000_+FuP.tkMPMuYcitW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/ab8500-codec.c:35:43: fatal error: linux/mfd/abx500/ab8500=
-codec.h: No such file or directory

Caused by commit 679d7abdc754 ("ASoC: codecs: Add AB8500 codec-driver").

I have used the sound-asoc tree from next-20120608 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Jun_2012_11_59_39_+1000_+FuP.tkMPMuYcitW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP1qKLAAoJEECxmPOUX5FEe98P/i4RZ6DUEGo5kHbzMm8N2bia
bgsp5/TnpuKdYvH8eP+sMqTtgiaVzOdiv7eDSd8PbLaoCFb9oilWTPBb7wbcah4x
IpFR5mqwLO7NsNz2lW+N/YoUtzj3RViAgvts8lJUXZ3Bb4jiXKSoHLZiXKCfSiJ3
2hYCfy1sKyjuWQnIOXOOCesn1QEcOC+WLmDX1y0fHIv5dCO+ZdW2cDi+Dw2Hzx/b
rus/NSvduNCsBkozQHXemyCkVal+ssm4/heAL+mBwqZwcZP6gNDPjjuFq7KHp5Fp
6L5BwACPLfFlQ7J/nN8h9YXN4LjMJJkbhYVMVTD+AOTDlxlOS8FCyHmCRB56vW3u
vCFszjIpe7dVfB4nm/F/gM6aUyXQ4wQb4fJj2kCnUDc2HemUiyNHygry58eh14a6
fTKXjIitMrq9DIpjUZihmfMjJqvOsTxwrfNxsiLjHbfS51j/3+ariJ61aKzAb4+M
QckAxp0X4A+8JGaTqziITa/jQXZnRU3g2+aX/wUowVgGuA8mjOEebuq+iZsCKz5k
mQbj9O0H1+liiqZk6at+V/Q5NpF1s1wp5UdTvKWsWXVUnWx6cj3wagNydqRVSdds
AlCzEGDqR8DBL5L+ZATQdeqj/v7qHYjfhZ783JEbJyT7RUP1h1QwnOMLgJ/X391k
D8LwerEUXh8Wu/mkwr06
=q4EW
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Jun_2012_11_59_39_+1000_+FuP.tkMPMuYcitW--
