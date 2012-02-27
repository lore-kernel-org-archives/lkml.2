Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2B0EFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:05:35 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55362 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2B0EFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:05:34 -0500
Date: Mon, 27 Feb 2012 15:05:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the regmap tree
Message-Id: <20120227150518.d5d521c9662a8b4b7850710d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_15_05_18_+1100_gVad7SU+1=PM5yIu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_15_05_18_+1100_gVad7SU+1=PM5yIu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the regmap tree, today's linux-next build
(x86_64_allmodconfig) failed like this:

drivers/base/regmap/regcache-lzo.c: In function 'regcache_lzo_sync':
drivers/base/regmap/regcache-lzo.c:344:2: error: implicit declaration of fu=
nction 'for_each_set_bit_from' [-Werror=3Dimplicit-function-declaration]
drivers/base/regmap/regcache-lzo.c:345:41: error: expected ';' before '{' t=
oken
drivers/base/regmap/regcache-lzo.c:340:6: warning: unused variable 'ret' [-=
Wunused-variable]
drivers/base/regmap/regcache-lzo.c:338:15: warning: unused variable 'val' [=
-Wunused-variable]
drivers/base/regmap/regcache-lzo.c:368:1: warning: no return statement in f=
unction returning non-void [-Wreturn-type]

Caused by commit ac8d91c80190 ("regmap: Supply ranges to the sync operation=
s").

I have used the regmap tree form next-20120224 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_Feb_2012_15_05_18_+1100_gVad7SU+1=PM5yIu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSwD+AAoJEECxmPOUX5FES9wP/3flTNCWSySq6ouIpQ33DqK0
71FIc0X8gwZyMasUY84Kj7jpbyYwLic5arNKIJTkC+4D+3AprIVsHVY7DwlN6Nrz
JtAJ3642y4C4ueQKBUAypj3OLM9n7AF7YEjDhMzsNL02UlqjgpxyRUXMps6frFpr
v/VvF0UJ9qHcEER2hPU4h3DnIVQzhc+bP7Ee49lahErlxyEugZiRKwnPsLU5sEs7
SaYEr5ssP+ENbjTM64whQk291ElvtLfSH0yfc7rFe4TyjTTkndSc1iAW3VVbLaOx
WKFItS4lbab+5zq9Fnga68BBfLMC9Ec48MBrz6ev11h0MnjoN9QRftE0eKXuxhgH
VfIbQrHy+6+EfM1mFTss9Exyajzws0E9Uet0+QNtWvJZIb4l+hYX7p1X0oG5ciyB
EAEJyZAPMsMCPVvs19c+OeyTvMFFKQihToM/KbtZl6LaBAIBnmfDZZ/VT0enMPtn
jgP1m2Oo5aGKro/ITaVDURTSG0yohJcdBKuN0vPY88c3I0zjppI5c6iEn5OjN/F6
B3azvaPuf4c3StrpVH5PYB4WHi+fc7ynNIQmiDJkOSnI4vLaXTkDWR5osUnWtIbN
lnaeDbk8EfwEetwy1SmBo/cWe5SxaB883dGXcEM7qyPiT567TccB7t5xQevfFlUj
OHGMot66wxcU5KPcJpFQ
=+37R
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_15_05_18_+1100_gVad7SU+1=PM5yIu--
