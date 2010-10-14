Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0JNB77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 21:59:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53384 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0JNB76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 21:59:58 -0400
Date: Thu, 14 Oct 2010 12:59:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Subject: linux-next: build warning after merge of the spi tree
Message-Id: <20101014125952.e4be4c9b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_Oct_2010_12_59_52_+1100_m++b43DNiD2f+VjB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Oct_2010_12_59_52_+1100_m++b43DNiD2f+VjB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the rcu tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/spi/spi_topcliff_pch.c: In function 'pch_spi_process_messages':
drivers/spi/spi_topcliff_pch.c:752: warning: 'data' is used uninitialized i=
n this function

and, indeed it is ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__14_Oct_2010_12_59_52_+1100_m++b43DNiD2f+VjB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMtmQYAAoJEDMEi1NhKgbst04IAIqxA++ki6e9MFRdmNOJTkqH
56GoR/nxkK3MiEnIZiUU9y2DE4xp6uks37HDoU5UvzBk794P7iNomFv1YZGHyjXh
TLic55zHQ58CgrOuDr6Gcbz/I8XHkzQi5ZoZeqaEVt8Gc8AmCw9/ujymm/Ql0bYf
JIkh52GGfy7EdKIZqIsN+4iV5L9LecXSgyx4MQpffc9vljfBsbItkk7D4C21fXO3
bm/zrW0hgFVXmPiVRLR31Qc3/qdM2CaghIXWfNjoSAHRzI8tmfGfuXiKu4chHbi2
w6RMXqS2jHajMWeibxn5wzdiXpAZcO+pxRiJpXDTh+/wcqGyGZ9sYnSRxhtptXk=
=It02
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Oct_2010_12_59_52_+1100_m++b43DNiD2f+VjB--
