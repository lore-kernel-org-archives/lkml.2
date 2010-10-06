Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab0JFCie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:38:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34555 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab0JFCic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:38:32 -0400
Date: Wed, 6 Oct 2010 13:38:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: linux-next: manual merge of the rcu tree with Linus' tree
Message-Id: <20101006133825.8ca341e4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Oct_2010_13_38_25_+1100_X56Gqs9iJDCzi4jL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Oct_2010_13_38_25_+1100_X56Gqs9iJDCzi4jL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the rcu tree got a conflict in
include/linux/rcupdate.h between commit
b3a084b9b684622b149e8dcf03855bf0d5fb588b ("rcu: rcu_read_lock_bh_held():
disabling irqs also disables bh") from Linus' tree and commit
ca5ecddfa8fcbd948c95530e7e817cee9fb43a3d ("rcu: define __rcu address
space modifier for sparse") from the rcu tree.

I am not sure how to fix this, so I just used the version from the rcu
tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Oct_2010_13_38_25_+1100_X56Gqs9iJDCzi4jL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMq+EiAAoJEDMEi1NhKgbsBdYH/iuOc5yIVLRUWILx6vPfk+3x
l7BQU5cAuDmi2BaUHZqYF1U4AvQ/Gto/hVOnygpqjz4ThPB71UdLfhD4NlGixQ4W
f7P0AQr+DR2l1pKKQS6FKbPFCvL7upeAJsP3NiG9FAqnBWASd8ry8XFDqZOB2Zvq
bYF2jqy5PySkX380850c9xKQjb+5Sub5YUtXLsuFMVKkHc87cVayX+m16KivT/gC
C5XYpiIZhq9v2L1aQkZinaetwEmwbhXk93W6VGRzTGIZs0+/vVzEz98iKmL4vNaz
y9O3Du4Tn4GsylCn6tj5iwxszXALWplgbds0pC4dLcDJ7Ct60lDlCg7bQPwIr3k=
=JTxi
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Oct_2010_13_38_25_+1100_X56Gqs9iJDCzi4jL--
