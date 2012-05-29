Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2E2Cd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 22:33:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35527 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2E2CdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 22:33:17 -0400
Date: Tue, 29 May 2012 12:33:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: linux-next: manual merge of the l2-mtd tree with Linus' tree
Message-Id: <20120529123301.b3f33396549e0762f26fa80b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_May_2012_12_33_01_+1000__zkJZ2yy1RJ0PQVv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_May_2012_12_33_01_+1000__zkJZ2yy1RJ0PQVv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
drivers/mtd/nand/mxc_nand.c between commit 97c3213fd9fc ("mtd mxc_nand:
prepare/unprepare clock") from Linus' tree and commit 625bdd2a6bd0
("nand: mxc_nand: Use clk_prepare_enable/clk_disable_unprepare") from the
l2-mtd tree.

The former is a superset of the latter.

This tree (l2-mtd) needs to be updated since most of its patches (but not
commits) have been merged into upstream trees.  Artem, you and Dave
Woodhouse need to discuss your work flow.  (Or I just need to remove the
l2-mtd tree from linux-next.)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_May_2012_12_33_01_+1000__zkJZ2yy1RJ0PQVv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxDVdAAoJEECxmPOUX5FEEg0P/i8LeRybKYKbuxod7O9uDqpt
h8cvN/Y8/o9ig67o1kC/3V884Em0spKsQrje6HuNGEXB9Qd05e0zmxkpxUYWp9qf
Wdbf4BBfPt6hdfKcm1kuoMuYczfjNnQ/2AyBvQe0IaHsdoW5z1eQ26a4shEq3rZ4
xnSNzpT/KvBm8XjCBHXwWKkEyjtKVnd+lUIoGmz4aqj9K5pGWZuD1BIOUYKMCHwe
BQ/30ZNDajMo0NrlnH9I66K5ROgHf5bsWW5iD8qr0UmsMUbDOEfhdzCMRCMxVnbO
PVtNWT0sTA/VPp3vhhJLrriTVSqH/KBphSs+6Ksezd8vHLZ0oltHKHTDZ1/z0nVL
4E9AmeF3IVrD6uSh9IpkR1v74EXOLIBvSBNjkhTKN8o/fs1Rn7ygcPajggZaefPs
mWmPx0FIBABpjjUIFbO9y1gGxndH4Go6ZOVlJe3nEFctGtH3z+yoSRwVSI1laGbP
cKYqFytRfDFDyXW3tJTzFJjXjzNMbHcD3xPUiN04tsa3mt7d69HHqNpdJBhiArS0
ohRI0E2S9lZHs05A2Silpjw9wrPOXzf8PCDgbYnpuZDj6O0USROAPhvVrT6UPc5y
8hUBrbi6BPaufqFP7MVfaXyQeig6GTY2MsSf8ONzxhaGdy8I6n1nh0ikxNwjOhM9
kFatFr071kBfYbQfJLVX
=C/J3
-----END PGP SIGNATURE-----

--Signature=_Tue__29_May_2012_12_33_01_+1000__zkJZ2yy1RJ0PQVv--
