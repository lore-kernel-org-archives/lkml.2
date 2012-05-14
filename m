Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2ENAue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 20:50:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49315 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2ENAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 20:50:33 -0400
Date: Mon, 14 May 2012 10:50:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Jean-Francois Dagenais" <jeff.dagenais@gmail.com>
Subject: linux-next: build failure in Linus' tree
Message-Id: <20120514105025.0ba1b124f5e9c192fc11e132@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_10_50_25_+1000_h6vTK.C+Wv_by3fE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_10_50_25_+1000_h6vTK.C+Wv_by3fE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Building Linus' tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "handle_edge_irq" [drivers/gpio/gpio-pch.ko] undefined!
ERROR: "irq_to_desc" [drivers/gpio/gpio-pch.ko] undefined!

This has been reported elsewhere by DaveM.

Caused by commit df9541a60af0 ("gpio: pch9: Use proper flow type handlers").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_May_2012_10_50_25_+1000_h6vTK.C+Wv_by3fE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsFbRAAoJEECxmPOUX5FEByQP/3vCpLP53CBmu6/rnzy2ySBD
Vo9fFWu9tre1Yh95GzbTzfzXpr6Y9spqAUtU3Sm8InsKgXFqj6pXEVoi5MybDLA7
/uNLFVE1EtHndEFAQ2ZqrLDaFkcCqu3wmpf+gVFH+P+IC2NzZgFfAkbbDO0kuDV4
vMR/4HgvCZzasdLMvSQOkVm6YNuReaHam2d1sJ6WnXg4MUdKsFZk+QgzoPpFCipt
d68iPiYQBWVdHELWMyWG8xeiGQ+bnVbZFEm1FU6fLjOESis7eNYnLsO/ONrZj56l
hncoOZJI9BHKwGBMjGPlwXbJqg2dJ6FLfsPDhTodCGQ4/kcQqHcp+8SgYjzIC9im
3kla8zYGp1vZG7WTkGmKfRNRFRc9HejGQW+xh7CxmB16BZyCDZUXvAO8kgrl6Cmb
8E7652oSrt+8Lk5EnJ6GpN10Kz2uEahGew06Qy6Wn+j2LsanWsVoBkNhhYmrTIy4
Jk+1KkqvhWXprsz5QtbZRplNT/9pLabN56AHt1X1zvAElsI7hm3hsyuutDy5No4J
icCCnLRBphQJ8g94ipwzGTVOiULjNeWEKupp04Kd5JC40XuHwVDcN5awznldkDq9
HOEeFJHsktqVKLKPvO00SaJBduuDGg9hh3yn3GbVYP/xXTUriew2aB/ToTcWqfOG
CkwG+pCeY4AWB8AlEDIK
=WoGJ
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_10_50_25_+1000_h6vTK.C+Wv_by3fE--
