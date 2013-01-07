Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3AGA0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 19:26:48 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35336 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3AGA0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 19:26:46 -0500
Date: Mon, 7 Jan 2013 11:26:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: linux-next: build failure after merge of the slave-dma tree
Message-Id: <20130107112637.71699f7daefcccc9ab94d5cf@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Jan_2013_11_26_37_+1100_yV774_BS_vp_T1Wu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Jan_2013_11_26_37_+1100_yV774_BS_vp_T1Wu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

After merging the slave-dma tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/dma/dmatest.c: In function 'unmap_dst':
drivers/dma/dmatest.c:244:21: error: invalid storage class for function 'mi=
n_odd'
drivers/dma/dmatest.c:244:1: warning: ISO C90 forbids mixed declarations an=
d code [-Wdeclaration-after-statement]
drivers/dma/dmatest.c:265:12: error: invalid storage class for function 'dm=
atest_func'
drivers/dma/dmatest.c:550:13: error: invalid storage class for function 'dm=
atest_cleanup_channel'
drivers/dma/dmatest.c:570:12: error: invalid storage class for function 'dm=
atest_add_threads'
drivers/dma/dmatest.c:614:12: error: invalid storage class for function 'dm=
atest_add_channel'
drivers/dma/dmatest.c:652:13: error: invalid storage class for function 'fi=
lter'
drivers/dma/dmatest.c:660:19: error: invalid storage class for function 'dm=
atest_init'
drivers/dma/dmatest.c:685:1: error: invalid storage class for function '__i=
nittest'
drivers/dma/dmatest.c:685:1: warning: 'alias' attribute ignored [-Wattribut=
es]
drivers/dma/dmatest.c:687:20: error: invalid storage class for function 'dm=
atest_exit'
drivers/dma/dmatest.c:687:1: warning: ISO C90 forbids mixed declarations an=
d code [-Wdeclaration-after-statement]
drivers/dma/dmatest.c:701:1: error: invalid storage class for function '__e=
xittest'
drivers/dma/dmatest.c:701:1: warning: 'alias' attribute ignored [-Wattribut=
es]
drivers/dma/dmatest.c:703:1: warning: ISO C90 forbids mixed declarations an=
d code [-Wdeclaration-after-statement]
drivers/dma/dmatest.c:704:1: error: expected declaration or statement at en=
d of input

Caused by commit 98edb45b7ba0 ("dmatest: adjust invalid module parameters
for number of source buffers").   You build tested this, right?

I have used the slave-dma tree from next-20130104 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_Jan_2013_11_26_37_+1100_yV774_BS_vp_T1Wu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ6hY9AAoJEECxmPOUX5FE/DwP/3MGyyuYNSTbb7OZmAAQApuG
IenRFWzl/A1JSZW2zqdiJm8DjDAFs06k+SKZRIeWIIVANGYPs7GVbizn0WjRqgD+
GDIXmZhUsl+04uReMoYNDA1rcbQLUP3MJvVDvkSMt1ZpIkAiabgGYSLw/2tOUBvG
9ZJDaEmlwhmKz90sc9ccVO9wXAfCMkBRIekLHYHINTwMj7PhkSz5JddYcCXJn+8k
armDGd5INcYuE4+x+Y7HJFSMbJms+dI8Lh6HchXKV/UV4X1FdIIW2eNVcvkL36gj
/1pialX9YFwbOvfvLTC6tNKa9hCadukiZEkZ8cJKXahDFLGS+GUbEx6rXxDt2TIv
D2mA3G3jE0SZB0qfVvz0IU87uGqvtlmmjUAukY/WNaaaMoqYMKVKwYvvfIvweBNj
4r8XNRQl45hHp3BAi2l0EfM7TxSg5YgX5ojCCbIyvjLwY2EnZfHEVIpmYVkN8GCh
yIu5cMaXG3HvXzuxoznmumBBj8h9v/ZRKIjG5T2nMjBVVWUoYD519zz3mu+FXtxA
MIA0qRI1I/T2N64Z4LihDldqu68DUtnGCwuk2wc7URpjCYD9ROySQhh3d3Q4J44x
8BtXueca62ytzsfGKm7EaOJXwHCll5mDPiwQpe5YXRKDsSvsghtIvPsHJURGl4bt
T5nHdiuytenR5p0E6tgY
=V2+X
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Jan_2013_11_26_37_+1100_yV774_BS_vp_T1Wu--
