Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1BCENU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:13:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59514 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab1BCENT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:13:19 -0500
Date: Thu, 3 Feb 2011 15:13:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (net tree
 related)
Message-Id: <20110203151309.d4a6c344.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Feb_2011_15_13_09_+1100_LSb.QGO8e1oJhIU3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Feb_2011_15_13_09_+1100_LSb.QGO8e1oJhIU3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

net/ipv4/fib_trie.c:98: error: redefinition of 'struct node'

Probably exposed by commit 3630b7c050d9c3564f143d595339fc06b888d6f3
("ipv4: Remove fib_hash").

Naming a struct "node" (in the face of include/linux/node.h) is a bit
hopeful.  :-)

I have left this broken for now ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Feb_2011_15_13_09_+1100_LSb.QGO8e1oJhIU3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNSitVAAoJEDMEi1NhKgbspPIIAJUnzDVi0BAz2ZecWLyAMELr
ixkjICdr5ajh0Z4u5KDolq3M2BBowzku+2j49UPxgrkz0D7nMuCCtkAotlk4q3XO
TJlq4diuSrCCBiqegbUYHnHiHl9pTc9IXRUMWs4D3o1zeiZShL1X8SZIBlBtH3eV
fDfxYDaNvV0xQEAD1OfHN+WnOhAkO/U3gX2FhFm1hs1vJ4jn+qOJCNEjg/T3JrJ9
/ZnN2H1ODeGy11qFeRmNUM2kLJi30C3hA6C8y8ACevsNtYPkFpu66Qz+DJ6jbI02
hmQa/nYcJSAEwDaJJ6xRv2xGP8nkodcFKxjrtMrbsVAGCg10drSRvwgVq/P2Sk4=
=ASDV
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Feb_2011_15_13_09_+1100_LSb.QGO8e1oJhIU3--
