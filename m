Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1IID3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 23:29:32 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46301 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1IID3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 23:29:31 -0400
Date: Fri, 9 Sep 2011 13:29:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nico Erfurth <ne@erfurth.eu>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the l2-mtd tree with the at91 tree
Message-Id: <20110909132920.3696fbb6c1b90cded9727d30@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Sep_2011_13_29_20_+1000_GTEprY+NP=8iD1_d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Sep_2011_13_29_20_+1000_GTEprY+NP=8iD1_d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
arch/arm/mach-at91/board-usb-a9260.c between commit 6939fd49787e ("at91:
merge board USB-A9260 and USB-A9263 together") from the at91 tree and
commit 29921652b159 ("mtd: ATMEL, AVR32: inline nand partition table
access") from the l2-mtd tree.

The former removed the file modified by the latter, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Sep_2011_13_29_20_+1000_GTEprY+NP=8iD1_d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOaYgQAAoJEDMEi1NhKgbsrYYIAKBdRGNQzKeeTw3pVXk4fSrG
v5zbPt/DEfXG/hXCKlxRe9ZI+XvabjCUaJEUsFTngY8W9+efUp+3zU7u1jquxcJ5
pF43ybCTXu4NqzBjnD0zKOrL7wj7KBouLnC2zeI5aG3wdelkBDBTu+rLeJnfFeEK
DSPBVpesPeZ0yIVpy1ahNkGqBDG0DWrc8p6+YASKQQela/5EWxrolBxqluNC/B6b
4mX7K96Xw970yOce4DqBdwb3e3/cKll1pFuzm0sUUrfWWHTz2B0js/Ta3QEaa3iB
8SAf+yghcRlZijnZ0vGEQT9yU/64ASA3V8A7cuPQacOYbufuLBtSSDXOifdnIwI=
=dw+R
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Sep_2011_13_29_20_+1000_GTEprY+NP=8iD1_d--
