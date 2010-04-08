Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0DHFfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 01:35:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57035 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab0DHFfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 01:35:13 -0400
Date: Thu, 8 Apr 2010 15:35:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Linn <john.linn@xilinx.com>, John Tyner <jtyner@cs.ucr.edu>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20100408153505.eb205158.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__8_Apr_2010_15_35_05_+1000_fDna6R+IqUTyE_tA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Apr_2010_15_35_05_+1000_fDna6R+IqUTyE_tA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/ll_temac_main.c: In function 'll_temac_recv':
drivers/net/ll_temac_main.c:695: error: implicit declaration of function 'v=
irt_to_bus'

Caused by commit 459569145516f7967b916c57445feb02c600668c ("Add
non-Virtex5 support for LL TEMAC driver") from the net tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_Apr_2010_15_35_05_+1000_fDna6R+IqUTyE_tA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku9awkACgkQjjKRsyhoI8zQXwCguB+SOeXdfC1OL4vYQtQPsFI4
J1EAnibu/oS53XCD/SjmeD4XjvSh7OdB
=n8l+
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Apr_2010_15_35_05_+1000_fDna6R+IqUTyE_tA--
