Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2EaAvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:51:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35368 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2EaAvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:51:18 -0400
Date: Thu, 31 May 2012 10:51:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20120531105108.1bdae885e23a49429d9b3b07@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_May_2012_10_51_08_+1000_CYfI.6lCIhmSmw2I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_May_2012_10_51_08_+1000_CYfI.6lCIhmSmw2I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/stat.h:6:0,
                 from include/linux/module.h:10,
                 from init/main.c:13:
arch/powerpc/include/asm/stat.h:33:2: error: expected specifier-qualifier-l=
ist before 'unisgned'

and many, many more. :-(

Caused by commit 9f240ea8060e ("powerpc: get rid of nlink_t uses, switch
to explicitly-sized type").

I have used the vfs tree from next-20120529 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_May_2012_10_51_08_+1000_CYfI.6lCIhmSmw2I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxsB8AAoJEECxmPOUX5FEHfMP/ivdqztu8IlWyQ7DbQyOxkbQ
sj9Pd5+2uRBHHujIij8h3MsTzbnwCzgLzvJOAMXAANWe4gpxjbl5U+F4jvE8psHZ
ejWyOhpW3YWpS4qQRn/+50RPAkHJ74vmFB9uJ+CE60T9z4ux4EIw0AU4oRTYyBf+
r4uUpStRy3G6U+BNxN3cp3JDudKZAEg+OaqsE9xee8jVsr2jXyyG1e6W23VzElS0
o0hcLo10F0TMvLU28345vDIr+pfqMoqcT2nJmWW8X2tf6KZeYtNDb02M888kqMG2
SWlErOxWfDg/Zemo2xAQrMEnePpoTxActiWY1B6Il5POu4MU/UAyNp+yg7h9uDmt
uXfklqCx3zbG8FnpugN4QqRAwmHLfntSEgqOMdK0p7lm6ZzWm+AskqHfnpE6y7qD
0wxDn5qRHrKWSwtnbACHr5SrcJ+CWXnwahB+uJfvaNYeMHwHIHfOCiIlI4tINDBa
61YZ9Cktc27cEKlNTiYq7YI7yl65/+Xx2SXJERceFv/cHWeZLEDpe6PH/9MMIcf6
7t4UGzBh4duX5C8J6UACxXXhGqCa1M29zud1DntQ30iFzA2y2VTQxiD177j29enT
tuxBESPkqUZI8dL5vrh3wag3nXNb4VeexBBFIdAx3WpjhCl0NFD6R8sKd3IzXbsY
9WXvR8i2L+IqClr73jdd
=KMRE
-----END PGP SIGNATURE-----

--Signature=_Thu__31_May_2012_10_51_08_+1000_CYfI.6lCIhmSmw2I--
