Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2KZMmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 07:42:31 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57633 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab2KZMm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 07:42:29 -0500
Date: Mon, 26 Nov 2012 23:42:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the akpm tree with the tty tree
Message-Id: <20121126234227.b52fd36e85e561d50a44e2d9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_23_42_27_+1100_v8QI3HvUpjO9mv.Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_23_42_27_+1100_v8QI3HvUpjO9mv.Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/tty/serial/serial_core.c between commit 7a876b39b5bc ("serial:
cast before shifting on port io") from the tty tree and commit
"drivers/tty/serial/serial_core.c: fix uart_get_attr_port() shift" from
the akpm tree.

I fixed it up (using the akpm tree version which included the fix from
the tty tree) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__26_Nov_2012_23_42_27_+1100_v8QI3HvUpjO9mv.Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs2OzAAoJEECxmPOUX5FE+uMP/R86iAKiqgA4bI4ndKdjisRA
cviQWyFnTz/6KrhPvyzX32wxBF8qJGZqsmdDkdsVujvxYJY1eQOlTMRq8gPpOTYR
F5P/puM9p+1KzAYU4nymY5HfPJU0JpPkGgW/EZ97syyGfQfQhfET6pZuHxyKjkkx
pJ2qBkgBxPgyu72VAKCU3/KNpBDc+4fxh7iYO6DIFpCvkhCwPMIW/M5gvPB6VIfq
0W3sbg9Mj3qAqU8x8Dz1ThGztIFUvwUuchR8LBz0VQj7CaM9Q51p4o+64iQMeU4J
riZ8XtRu4JKWe3wGj4vkYhrkTUw3cBBFB+dhQQfrA9FOuzI/FIT2kQwc0E//DWGK
0LGpwvxnt2zg+fGXcxIcbiEZZf53PtDbPtoBJ59GlF9lDYbfFf3YaD5JeVTeVaaQ
QmYX/SLPKnohKUwGWeK4L208Zsdg84PwljrCyEZ2s2pNVlqyMt6nixY38SyvLVUY
ON/MHY3/0fVwLJDqzdcAtQWUmY58VaVAi5OZ7mSAlFrX7glqgQwSYBCg1iid0Y95
ORjeLDNfce2IBYdzAlm2fggrIQnWup0IEg0JItRbvgp74xKyy7y+yVN4wecztRiF
j3WV1P7JQOM520/mQ4tibF2IHf+IkM8iygIpnykgw6lNek+2FzCcRK/8MuXdl/rQ
WmYqOpHLzqxGdppjDgbp
=4w2f
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_23_42_27_+1100_v8QI3HvUpjO9mv.Y--
