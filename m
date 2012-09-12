Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2ILDoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 23:44:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35257 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2ILDn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 23:43:58 -0400
Date: Wed, 12 Sep 2012 13:43:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the trivial tree with the mfd tree
Message-Id: <20120912134349.f1dd0f4d050dd4834623e57b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Sep_2012_13_43_49_+1000_5x.8th+EQw57xQ5n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Sep_2012_13_43_49_+1000_5x.8th+EQw57xQ5n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/video/backlight/88pm860x_bl.c between commit a6ccdcd98c39 ("mfd:
88pm860x: Use REG resource for backlight") from the mfd tree and commit
e1c9ac420ef1 ("Revert "backlight: fix memory leak on obscure error
path"") from the trivial tree.

I just used the version from the mfd tree and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Sep_2012_13_43_49_+1000_5x.8th+EQw57xQ5n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUAT1AAoJEECxmPOUX5FETQUP/03Qtr3w6f+vX8sEMtDu/woa
6mjYgOmk5tODbYiaw1Vc0ORtefv9MlQkjHFx2qqHoXqaUgcZqI7sg9VlWpWeo2RQ
WwbSFj4LIiRSNkAlcCLjKDQiI9R88l9Eq21BKbLyzU8F1re0YF82pj1REWnKjcIx
2Lzn0TBJfC36Ec/IqyT1DLL+FvsDRIJAQIG5YAxPC0MILB3wiiRYrwlqcPOFlpFF
oR7Xq48bBPjIVQ45LiXEOtcbiz1DbDhGNFzdmBBGNnJPHRgw9sCAveEKK+Wz0dLM
V14ncFe4jH1SGF7NfrQoqDzGFZcDK7qMLCcYb4haBFW/3HqLtYVdnZ39Dd3SBxge
yHR9D1gd0nESq3tTP/8VYwIJAd5VjF66bJScqTd16M+Q61XjhdrC6NtVlI/Wp3rE
yz2IDNJJZoktViYeVmaXnwkEtWZFqev+M8kCNwgUWkc51B5DTsQ++lEyr4JLqW9A
EFGP/Aa5AEmVS/0/PqXmZF84ZVaCDZLlgJRBGPrIyE2/zPdmIKg/ftXp1E83J53I
YOqwxp+GFcfrE3ThUODIE8+Vxp25On85KvN3JBybXSU/dHgvUt1TndY+m6ZTidZ+
iqzRcPh/jcr9HhyMEt3Q4FyKc+ZjGUJ7prva9SqugkMp22yvYeUCa6luKOwB00wD
YCVpAab4C0Bagk8xcEbL
=2hXX
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Sep_2012_13_43_49_+1000_5x.8th+EQw57xQ5n--
