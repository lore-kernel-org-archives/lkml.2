Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1I0G30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:29:26 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:60255 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1I0G3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:29:25 -0400
Date: Tue, 27 Sep 2011 16:29:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the moduleh tree with the mfd tree
Message-Id: <20110927162919.1bf769d918a16a35d91ac1da@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Sep_2011_16_29_19_+1000_TSd8N6wyhqLkZxQM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Sep_2011_16_29_19_+1000_TSd8N6wyhqLkZxQM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/mfd/ab3550-core.c between commit e085f9a2e27d ("mfd: Delete
ab3550 driver") from the mfd tree and commit afb68c4877b2 ("mfd: Add
module.h to the implicit drivers/mfd users") from the moduleh tree.

The former removes this file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Sep_2011_16_29_19_+1000_TSd8N6wyhqLkZxQM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgW0/AAoJEDMEi1NhKgbsmAkH/RiB48X9qcYU4CBvWQc2Ewqn
+cVl8mPW2MosODmQGQO+DBR2iDUVO9aJUUdvsm7Fl8gIUYcz7iB7yXr+5R53O/l8
UuWk1rf/qeESm/M8IvtaVqVPn/DZYmQROyEd4B+USg0RxgItXrr5HCQv+jR4eTgN
b95aiqVXQywk6tVOF5Qn5pHvSB+KH0Pz9yMsMKRj6KorLIaQW/jrrMGtUOsT3fgo
gzIo4YWP51QtX4SSxvcg1VPw++NBwYh/wrHPoJIq1Dd1LXGVZUydWiZku6x6aXiN
ipSGlXe1jG/7qd6x5rjUqMGo5nN5jb3huoaTvC8g30zLm3wCLYvou/Wcpu/xeds=
=n9tK
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Sep_2011_16_29_19_+1000_TSd8N6wyhqLkZxQM--
