Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0ICDCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 23:02:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51634 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab0ICDCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 23:02:45 -0400
Date: Fri, 3 Sep 2010 13:02:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@petalogix.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: linux-next: manual merge of the tty tree with the microblaze tree
Message-Id: <20100903130236.1f5f331c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Sep_2010_13_02_36_+1000_FZjSB2SnnnimE+Y_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Sep_2010_13_02_36_+1000_FZjSB2SnnnimE+Y_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/serial/uartlite.c between commit
52ea4a7ef12f286bd68d13a93daaa688f56a1e14 ("serial: Add CONSOLE_POLL
support for uartlite") from the microblaze tree and commit
0e5176373d9c9a7741b54ce81a9eea342291bdca ("serial: Add CONSOLE_POLL
support for uartlite") from the tty tree.

The same, but slightly different patch. I used the version from the tty
tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Sep_2010_13_02_36_+1000_FZjSB2SnnnimE+Y_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMgGVNAAoJEDMEi1NhKgbsF68H/idVjPsFawwu4pZE43//zNox
C8595Kdw4Kf1lu+zWKrCpZj/t2q5zzErkwV9MJY1BJ+e8jU1tNY99w/nk/czMaU4
W2hWCzs70HmqVhyCB2P+n57LXatOY8STxdt06X6O3PwEfns/ky1JhTz8bTzt32rx
hpzwu69JkPp9NMkIpdOThbgF534pXWkce079xPY87HAJcCztmx7FD1IH/jISsqrH
47J38v9G3b2jWcV+o5wkS7XXvswPonezO7/XhLWg1aOhUZlxYO3R/E9iChZsdIcf
i1R4oOFCrJOIl3Q55hLZqNsKXaWHUFE+uL80TstM2PgadhtwoSY1tuQ0/mhFJJA=
=G7Hf
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Sep_2010_13_02_36_+1000_FZjSB2SnnnimE+Y_--
