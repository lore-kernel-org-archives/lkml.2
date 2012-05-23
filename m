Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894Ab2EWCPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:15:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51784 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2EWCPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:15:21 -0400
Date: Wed, 23 May 2012 12:15:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the rr tree with Linus' tree
Message-Id: <20120523121518.033d689fbd1b4f8526304a35@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_12_15_18_+1000_LTmtgQtKOb94jyAc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_12_15_18_+1000_LTmtgQtKOb94jyAc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
Documentation/virtual/virtio-spec.txt between commit 33950c6e2269
("virtio: update documentation to v0.9.5 of spec") from Linus' tree and
commit e26259736de5 ("virtio: update documentation to v0.9.4 of spec")
from the rr tree.

I just used the version from Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_May_2012_12_15_18_+1000_LTmtgQtKOb94jyAc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvEg2AAoJEECxmPOUX5FEN7EP/3GnChw3i8UPJYwp1uBDRzs1
0P22atkPBZVXMWVp7amr0Ptt9ql6SoCCpKNnRiySh7maCVCrsjSjEdAs5MVdVog2
KZwfGBwL/9Bcid9v9EclBuLetVTRMLpxz8wd5bwwIo6peDIDtf0U6LUEI7kffFxC
tD1UAqKTUrwKVePfRr36uoXLfxdc5LkQ5OykTks1aKC7qq0UXa7vH081bIz+1scX
RahtDYv+E+1p4Oit5HTeVGl/PhdR5fBW3CUsjd/1ZLYxlp2evyM1cGhpClbjvm6o
93ZBRduTCtjnmEEIdDHR+5kKdVJUX2M8oSqXN9miJcE2Bz/2jB/RTiEI5qIDIm1Y
Y71o1iDe2578C641KxiKJdAlhIPEVOhf2dswJxdJWr1rZs8QcZwJGevBgr9apgfp
LxygyUpq5tzQ7fFhlzI2bK91w/cxSfOPib5/nLVjSp2kF8tj9d+wnXBQSUScGfoh
kw4fIC9UFshMkj+Ag+h4wvvKbtU9sdJNuRjDylBC7BEWh/w3DHJkaD7kAPpZqegB
Mo+ZqU04EiuhDGTFfAuC9/Zw4TKKwRmfwG6+niiEcgCEYJIPF8axtOEV/Pkj7/RX
mirwduWljuVXMLAUyB/hQvDiRWA6iMN4QdqvoT2WUdp8N09VxizKal5UPhqRGfxT
cAbdVtg3S2R1HJZmlhVu
=S+Ys
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_12_15_18_+1000_LTmtgQtKOb94jyAc--
