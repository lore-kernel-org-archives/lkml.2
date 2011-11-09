Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1KIBGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:06:14 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:35307 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1KIBGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:06:12 -0500
Date: Wed, 9 Nov 2011 12:06:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiang Liu <qiang.liu@freescale.com>
Subject: linux-next: build failure after merge of the mmc tree
Message-Id: <20111109120600.2fadafaa1a6c0e38b79ecc1c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Nov_2011_12_06_00_+1100_cpL5tvNw8WCnTkPY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Nov_2011_12_06_00_+1100_cpL5tvNw8WCnTkPY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mmc/core/sd.c: In function 'mmc_read_switch':
drivers/mmc/core/sd.c:310:19: error: 'SD_MODE_HIGH_SPEED' undeclared (first=
 use in this function)

Caused by commit f1649241a293 ("mmc: sd: Macro name cleanup for high
speed dtr").  SD_MODE_HIGH_SPEED is not defined anywhere ...

I have used the version of the mmc tree from next-20111108 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Nov_2011_12_06_00_+1100_cpL5tvNw8WCnTkPY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOudH4AAoJEECxmPOUX5FEB1sP/Rluc24c1kFIy1v1VYi3mBQa
5ml3Yygdjw0zN2l8xKTH/XMM1lQKv6TBwZQApqTzZZj9wy6LtqnQF7+gWEPlmK6j
5PeaKk2GGP1qz3es5ZNmocovWqg5ZS8vykEfRjXRV515tIdPbV0DxWRbwKKdxbZV
qLm3pdMMSlAN0+psvhi0V9cnAbw/XdrJqlJ8sPC1kMqM1t52kfdxIgQPaUUCe8KR
9uyJ6/GyTmwjf4/8w7tmlwkFmFIiiwElq9k0lqJBTcQR7XZqTA82mGPt5of872u0
F6DS2Qt47UpN7s2ZabPb0Ai+1CDC2B9SPwPxTPx4+e9lfs4fhS5N7W//cILZ/2dE
aesyqRblXQXdK2Nqjzt27rMSOxe+JGKdLvkxgqh7+O2z2SQJc2DW5hnYv5zk7qZi
jlmue++R64UfqloTk2OTELLIaKWtshInt1tQpBhHZi8RvFySY2uS/HAf80zlT3+n
5WpPP+hAIzVdAL+5IY6CvkqXHOiimbao5pBx6eOxj+uU4P/Me9rPWG8lxobyr5HU
DT7oTH/Wm5+R1tSlrGbcitys32N652JvbqPakqR27kWc8dYpvP08G2vjCqutCHAT
U70v8nOfdCRY05ZzD8pOxy9bb0mef9PHFWW62oRfE8N8ZypmSZp0MVMKZ9MMQxkw
TbZmQo4o77M7ENd/Yk+v
=tXrZ
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Nov_2011_12_06_00_+1100_cpL5tvNw8WCnTkPY--
