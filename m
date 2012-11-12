Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2KLEPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 23:15:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55273 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KLEPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 23:15:50 -0500
Date: Mon, 12 Nov 2012 15:15:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Maxim Levitsky <maximlevitsky@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: linux-next: manual merge of the akpm tree with the block tree
Message-Id: <20121112151540.16dd14cd1eef76432c098e8a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Nov_2012_15_15_40_+1100_JE7Vxkqc3QeBwZWq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Nov_2012_15_15_40_+1100_JE7Vxkqc3QeBwZWq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/memstick/core/ms_block.h between commit 0604fa04ccc7 ("memstick:
add support for legacy memorysticks") that use to be in the block tree
and commits "memstick: remove unused field from state struct", "memstick:
ms_block: fix compile issue", "memstick: use after free in
msb_disk_release()" and "memstick: memory leak on error in msb_ftl_scan
()" from the akpm tree.

The block tree commit has been dropped, so the 4 akpm tree patches no
longer have anything to apply to, so I have dropped them.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__12_Nov_2012_15_15_40_+1100_JE7Vxkqc3QeBwZWq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoHfsAAoJEECxmPOUX5FETiEP/2xJwbadjM5ZSJ/RQil828gr
+FoTkw+CaG1nXQFBVEZV92RUt0ZbJbcC0hVOt+4aOPG7ZoxVsewHzwmNdogJLf7h
pJT7psqEc+CXXSxzMjW6y/UWSUILT5XfdsMN4lwb2IqPFHG0Y8t4FgMffBoH2vcj
tzRO8IcDt4qsUXc6lxN2v4S7R6yylqd/bST3VSD/wC17LywbRh13Qf8HWeTuEuAS
Pu4PjaRL8loNLBv31QdQgMHYSl/A7TroUUUbS+UwrblDJMuoHIu88HS4LoxODtZj
Ts6XAi6xpr0ONY387lhVNZm8sarak6aWmhAwEilCC65T4qwFd/8xVZ4jletq4b1V
72o3nmS0YClK5Yj+2K0MS9IOqGfxsal8viV7oA40DuYLXcBJ5kJQzAq6b5UycWy+
Uw06CiTQ3D6MIbPm1D396TNQgTZm+Em+xsNgbHiFiyEr7JLn1S+aryCZXqXdUh5l
wKVFByDMKEH6g0bYUWI6fQ/DQpi8b+k5o5BIPEI+VhO/9ryXuqJJyugI6yjdREcD
qtAt3wPnh6V5Le+J2NkSUemqjrlLCpXFm5KEy344ftdxo7o1IjTeUqgF0P0NGArr
SzjzV+H4FPj2JV7wjh4AxRRLmkMn8JSUm3Ilqr0EfWFKo/HbAyNodRsvM58xHqgP
/4KIfYFBSY6dpD8CBuaQ
=iB4x
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Nov_2012_15_15_40_+1100_JE7Vxkqc3QeBwZWq--
