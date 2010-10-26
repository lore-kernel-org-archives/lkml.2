Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0JZAcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:32:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48957 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0JZAcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:32:20 -0400
Date: Tue, 26 Oct 2010 11:32:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: linux-next: manual merge of the mtd tree with Linus' tree
Message-Id: <20101026113213.1faaf8a1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Oct_2010_11_32_13_+1100_g+fZmG692auiXyhh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Oct_2010_11_32_13_+1100_g+fZmG692auiXyhh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the mtd tree got a conflict in
drivers/mtd/mtd_blkdevs.c between commit
2a48fc0ab24241755dc93bfd4f01d68efab47f5a ("block: autoconvert trivial BKL
users to private mutex") from the  tree and commit
480792b7bf188c29b8d4b10fee65c3a06ec5dbf7 ("mtd: blktrans: kill BKL") from
the mtd tree.

I fixed it up (by removing all the bits of the former commit) and can
carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_Oct_2010_11_32_13_+1100_g+fZmG692auiXyhh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxiGNAAoJEDMEi1NhKgbsVkoH/2SeDD+LM1iKJY23V9kDzh/n
qzhjxxuBQCeklUs52wAKlZMfFr8A3eAI3clJlABk/M1LnFX8pcAqIpbM9b6jmqtn
TK7AJ1jCM3Nh6hw/bPACu+abWTDpUmeGnDasHlIBkWdGUVG//2DfmUyIpc3l+McD
9OCkU4j2C8GEvw6EVaghN8lzffHv2/6BjsDo88UF3AYHpYfgstBB0+w7nxGknXz/
Vfc2ankWEQ/hq1xhfujcGLdYH17c0hD1xOqkWJ1VRpKMmGsu9bVz39HsvwX/LG3a
Y+JJUcYY6p9wdQVOE+2SnC+N0Bq8PjILYHk+GB8wHuqXDtyobNY0b86jqg3pbZM=
=hzHA
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Oct_2010_11_32_13_+1100_g+fZmG692auiXyhh--
