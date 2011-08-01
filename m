Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1HADJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 23:09:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35831 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1HADJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 23:09:28 -0400
Date: Mon, 1 Aug 2011 13:09:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the moduleh tree with the  tree
Message-Id: <20110801130919.52333344fbb9995ff67fb821@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Aug_2011_13_09_19_+1000__DlzTxodAdfrlnpY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Aug_2011_13_09_19_+1000__DlzTxodAdfrlnpY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/dma/ste_dma40.c between commit f4b89764c470
("dmaengine/ste_dma40: use AMBA PrimeCell helper macros") from the
slave-dma tree and commit dbd9b79ce7bd ("Add export.h
to /home/paul/git/module.h/linux-2.6.git/drivers/dma/ste_dma40.c") from
the moduleh tree.

Just a trivla context change.  I fixed it up (just overlapping include
additions) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Aug_2011_13_09_19_+1000__DlzTxodAdfrlnpY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJONhjfAAoJEDMEi1NhKgbs3PQH/3tv9OZuY0s8rlXiOSl1hC1/
865hvYRE3uNkBVof0j11N/gPfTWlOAG7n4QScP6iP3howyD2QVI8SuJ8gtAXV4/l
DpEQCCJH6mMbLWQ+wWKjS0THP/cOgVa6z/SnGgNLquH/b7rbdlSnFmwcsPObtDiu
XyV7vfKl/fnU7o4CLxENz4wo1zDLyfgxA739Jmz5CNILmeVOU1rPv8HAglsoU4dD
7eI5tEQIyfiZceLvLQ5YecD2oK89WzKWUJ/NS3hfiPnA7qmrTam1Y/8VVl9aEx0F
9vNQeq8la5EirR2ONHuo5dY7M3vmYJEfKallCTDGiDrF6a7QaCgkZKdTIOTn7rc=
=Id/F
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Aug_2011_13_09_19_+1000__DlzTxodAdfrlnpY--
