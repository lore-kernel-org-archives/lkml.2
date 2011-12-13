Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1LMD6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 22:58:17 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:47638 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab1LMD6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 22:58:16 -0500
Date: Tue, 13 Dec 2011 14:58:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20111213145805.dfdab4f81bc8ffb22c582393@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Dec_2011_14_58_05_+1100_PRQHMZbX/K8BXXKy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Dec_2011_14_58_05_+1100_PRQHMZbX/K8BXXKy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/base/regmap/regmap.c: In function 'regmap_reinit_cache':
drivers/base/regmap/regmap.c:259:2: error: too many arguments to function '=
regcache_init'
drivers/base/regmap/internal.h:109:5: note: declared here

Caused by commit bf315173359b ("regmap: Allow drivers to reinitialise the
register cache at runtime").

I have used the sound-asoc tree from next-20111212 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Dec_2011_14_58_05_+1100_PRQHMZbX/K8BXXKy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO5s1NAAoJEECxmPOUX5FEgpUQAKKyeWHWnxnTrOVTlYc0CyTB
+Une/7YyhnK8hyCuAacmB2y1q1ECiMRppGXRzrzqlLi/s6WOiA+FknrRaF3COQLT
ajB4E5bP3WmgzbL4+dm0m+j08e2W5SZj868RPHuxvS3Co3cEUhS44Mi8++KGCQM5
JuV+h+Q+ftlQ8bpb4IEmYO+iqITdY7PUSwJIBm7+vxDMlndVP3T2Q4Kbb7mYn9h9
QgmEGQRwn4gKx+L2i9OvOiyOCdQqPl9g+6nUynjp8D1BH5wCKwIusPpZIw+SlfVI
G5oZlDrTROZIe6KOvwgS9NYn4F0tUvNVEWZz3wu9GO27xaeJjrI/2yiPxijMa+Wn
Q/eod5FWau1WweXZSU/WMrUflCqXP2jXvCbrrkMGvXEh7kGJowWvUsfsx9h/lYQD
mgoU36dliUntZqEHpSnaqfamtE7Ke3A6NzXUGjeNLvt+I09efEKUHMrJqrv4EK0S
uOl+hSuI/ybfnw1SDc4ZqmKgOZKhZValy0b1lb9rlJzuG2aTKFGWeUEJelc77M3q
D/rYuNrNt2ZCqSXYKH2B1mVcDkJehY34mZxD8Ya2sJpAqKJGlb0NZvk9iUmRZgJo
V2hYblybrIWDQ15kwbmOHwjQn2IWoV1HAKB00Mq7ZMb6zfmef8SUG+0R5BqG2sCT
mwIPS6Cfw8GwGtrsNDci
=A0tv
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Dec_2011_14_58_05_+1100_PRQHMZbX/K8BXXKy--
