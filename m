Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1EWBpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 21:45:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54536 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab1EWBpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 21:45:47 -0400
Date: Mon, 23 May 2011 11:45:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the i.MX tree with the  tree
Message-Id: <20110523114542.9868cba1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__23_May_2011_11_45_42_+1000_9ptZ=/jHf+.VrwJW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_May_2011_11_45_42_+1000_9ptZ=/jHf+.VrwJW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sascha,

Today's linux-next merge of the i.MX tree got a conflict in
arch/arm/mach-imx/Kconfig arch/arm/plat-mxc/Kconfig between the "same"
commits from the arm tree and the i.MX tree.

Please don't rearrange commits when upstreaming them - or if you do, then
update the source tree as well.  I am assuming that the commits that are
in the arm tree amount to the same as what has been int the i.MX tree for
some time.  There are a couple of extra commits in the i.MX tree, so I
just used the i.MX version of those files.   This may not work.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_May_2011_11_45_42_+1000_9ptZ=/jHf+.VrwJW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2bxGAAoJEDMEi1NhKgbswRQH/3cerz52t0EdU/DoG+3SYijl
KfYYGkGvJysUAsePcQslt0D4UPDKLmsNeIAnj65Niaa6gkpGvbMyOPZHDkD3JFSQ
My7HQZBXCRC+Q6gQaPgdkP7P9XEvwwCL8Dm1Y9DIykxBBZg3kTkPGsYu+0bxA0He
/mB/5A7DQ65KFetMIg9xPBbP5Rg+6X0OQODErCQX1EH+WV6u5MrKkUeeB9ouibH6
83T9GsUbP1vt9mbMCRSV1yR8YZr5aJNs2BB0I+uA8ZhPrfN7HQbBAJCAP42Dfuj/
8L+xyjyzCCFEqjmZHONMaTX6xHPvcZ4GMz0aaQn8auByLKXDHtGr8noKg1o8AbQ=
=vGu5
-----END PGP SIGNATURE-----

--Signature=_Mon__23_May_2011_11_45_42_+1000_9ptZ=/jHf+.VrwJW--
