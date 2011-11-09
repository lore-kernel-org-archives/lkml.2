Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1KICyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 21:54:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60111 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1KICyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 21:54:09 -0500
Date: Wed, 9 Nov 2011 13:53:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: linux-next: manual merge of the akpm tree with the v4l-dvb tree
Message-Id: <20111109135353.69057bcd2463a6ea009b898e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Nov_2011_13_53_53_+1100_E2aD1grJ_2J0plde"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Nov_2011_13_53_53_+1100_E2aD1grJ_2J0plde
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict between commit
"poll: add poll_requested_events() function" the v4l-dvb and akpm trees.
It was very similar (but not identical), so I dropeed it from the akpm
tree.

BTW Mauro, that commit in v4l-dvb comes from a branch that contains a
series of patches that have various Signed-off-by's but not yours ... it
looks like they were imported from patchwork, but you forgot to add your
SOB line.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Nov_2011_13_53_53_+1100_E2aD1grJ_2J0plde
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuetBAAoJEECxmPOUX5FEDFoP/iblIKVC/o/L/Qr1Vcj7WY0L
N8gNtNFU0xPdUvJPl6DSKzNpm6ivILmM4ssx3aEYl122CT/xUCUxUFv1eKGVBX/8
3GyY63N2loqbW33UzCgva4S5g9sssfv/RIQS2iLG45AXvBdwBOCC5tT8mPVE0Iyi
r8c8xywGp7bU9cqQq8TN+Jyz5U/dB6+sISWu/GgbuMK8O1BQPceO9Z3FCyMyU15z
cr5YdQZHf+MGjcrJsgOxuCIapfsyoRNRwNeWmwikL/A2DAt947yw7k2CD0z70zK0
jFPqzuAjgYOvsGGws/EamvYVCDjqw+lw822EfjWFRB1uEm0XG1j3FkyiVx0k9Hp2
yVSHeT56pbqEtkRBYwaONW+UYcnc5bMrzg2YMHCsGxdnVqB+2pW0swztEpVvC6NY
Hak9iTBYQWQ/WNbYvU5nLP8DoGIx8Nmkoes9lj3P+6QYdYmk7IgVa8hFLvs3UFYF
kJFmEzeuInEr0bOwI2eTwKTlV7vdW3wmOysMSE4PNWYzpu2IRodQ1UvfwFZYzMlq
JA41waFGJOQ+a7h04aKF3Tfi87FD654xSUHISoFId4lBoa75ArUY2zGJHvAmHpFI
xRUm8cFhHC2tymnmWHkZipJPvYGZqxzc7R7ksgnT872FHupWVmO51oMrd1mXhAGF
UE4mj+RSwo9xfpSRQ8Su
=CgUD
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Nov_2011_13_53_53_+1100_E2aD1grJ_2J0plde--
