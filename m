Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2ECFxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 01:53:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39615 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2ECFxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 01:53:42 -0400
Date: Thu, 3 May 2012 15:53:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the akpm tree with the driver-core tree
Message-Id: <20120503155316.ac90cdfa900e1d19461f42ef@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_May_2012_15_53_16_+1000__2y75BN75QI4wY=T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_May_2012_15_53_16_+1000__2y75BN75QI4wY=T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/w1/slaves/Kconfig between commit c0a6720977f8 ("Revert "w1: Add
1-wire slave device driver for DS28E04-100"") from the driver-core tree
and commit "w1: fix ds28e04 build, select CRC16" from the akpm tree.

The former removes the text that the latter is fixing, so I just dropped
this patch from the akpm tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__3_May_2012_15_53_16_+1000__2y75BN75QI4wY=T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPoh1NAAoJEECxmPOUX5FEwNAP/R9bKQxb6R9Du8+0IOUt7mQX
vQPihBpdYIh6B1KhTrdfE0ePFcFJ75oT8GqKjowi5f8ajKg11dLqPZtIIVUxofHK
nYJfb8k7tetmCttorgIcxc51/y/d44iqgJ9Rq3d4XW+iSeqnxDskgWbCCeY25LQO
54gatMYg9yogqTOeVaaJ9eFbCOxN8IiSrmfm8XfJTxDLa74TBlRfjkPZvZqZYyCl
w+alWCctZQBNMtdYNkc7SdFY6MDLV1wKycSN7HIDcu1kiIYiorW0BxTFT5c/pp+n
TV3neMFz0SmnM67p/3solZ8mqWkUcFeTTHVkTz9PHGaxh3bRoNJ/EfFN8xOFEg/k
Ackd2Wuhp3q4th2Yle/98YBSx1LfhYw5vjCE9b/2/Z5qIWIXZk+i3MpLrMIQxV1T
f9CuFAGsMybjuk7YHKIfY5RpPWithccsdmszzoORarKSIEMK953z9SENMKUY6y+4
OftjLFtk/XiYIDAhwYrKdRD+QHsZhqjE75jTCSrjPnCdWMdvy+xHYzSmfw7+JrN6
cBO7WTemr06taDNeyRlSXdSq8V46KrkcYcsytm1W2sSb940OCOh9UYqHkHFgy4Px
d7F5QJVDYau4+GO98SxhUQO35ZVKmV+7UCWUubEhcwst4yFDy3gsoS/u/m5Z6TK/
xJ3Qrr4CIJ7+OYcwTPFc
=qMoQ
-----END PGP SIGNATURE-----

--Signature=_Thu__3_May_2012_15_53_16_+1000__2y75BN75QI4wY=T--
