Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2KZNBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:01:24 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54324 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2KZNBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:01:23 -0500
Date: Tue, 27 Nov 2012 00:01:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: manual merge of the akpm tree with the devicetree tree
Message-Id: <20121127000117.7a1b1fa7824eb1594e90771d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_00_01_17_+1100_._6cTImTwW2tIJdJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_00_01_17_+1100_._6cTImTwW2tIJdJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/of/fdt.c between commit e55b0829cbac ("of: fdt: Constify
'pathp'") from the devicetree tree and commit "drivers/of/fdt.c: re-use
kernel's kbasename()" from the akpm tree.

I fixed it up (using the akpm tree patch) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Nov_2012_00_01_17_+1100_._6cTImTwW2tIJdJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs2gdAAoJEECxmPOUX5FEbDwP/0szxg74BqYAW59XH6fnA5lU
zpAsr7mwPCa+CL3gjjTmlkuZSsXGOBuj4yx9MFfhOwojQ1ZuRIdgQWY5qei6cM9Z
3wcuNZozTcWQXsMJ+gp5j9cqoGInSyoCMb3TbxkR/LxsNcY1l4nzZYVzIADB3mwT
qYzOdf4koR2vv2/d7aqFOINLQVlD1/9TWAtyW9mro7RCjaRoEfKgJdmiekh62qJO
W0ubNvfUmkIPTjUJqzL7yD39OHXjwEeJn7TvTA/eaA2oubR13iVuIX3v3lovnNET
+F/1aNbRLTv99ElRB60C9R7o2KokS/2icyH1PAjPjzcFQf2IO78GhX9jEc3lmNwb
v+JHGVGrsMuGsQ0c61OZnC5go91xo8Jt65zAQnzkycYqXn2wiv2NSMsMCyWPvLH5
RS06iEBuyGj9ENc9n4U4S27MswXeFlD4HeC0K/Ymp2boNFKMshH7zoQPFIIyRmBK
stCExxQxdc+0O2rrL1V+ovHk4Z6WWHZrG08EJo3/fuQIrTr20aJymBJKNLfu5DUO
DBb1LA57ChW4qKI9lvtcXDqhEw72OJJlQOxJ1qgn5hOrVn7hOXUTapHGf6vi3UWJ
6VQwcEeeU9aLiKQo6oZL2BuSpb7KHa2pqUtTGjysjUfaa8UMlVUxV9aW3QqpcAqt
5x2O0j6XJ2t1wDV1FuoQ
=LHzB
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_00_01_17_+1100_._6cTImTwW2tIJdJ--
