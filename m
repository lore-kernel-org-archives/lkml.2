Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab2EaDNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 23:13:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35995 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2EaDN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 23:13:29 -0400
Date: Thu, 31 May 2012 13:13:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the vhost tree with the net tree
Message-Id: <20120531131319.a1a7f5a47fd5db7c85cebc0e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_May_2012_13_13_19_+1000_8IvLCpoXiOEN5Tt4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_May_2012_13_13_19_+1000_8IvLCpoXiOEN5Tt4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Today's linux-next merge of the vhost tree got a conflict in
drivers/net/virtio_net.c between commit 3bbf372c6c60 ("virtio-net: remove
useless disable on freeze") from the net tree and commit 53ffd226507a
("virtio-net: remove useless disable on freeze") from the vhost tree.

I just used the version from the net tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_May_2012_13_13_19_+1000_8IvLCpoXiOEN5Tt4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxuHPAAoJEECxmPOUX5FEOg8P/2lUYyCO90mb1MFNwRM5Xens
KhWeZ7HaoU+2fVCamLPDJFFvicKTqKaXN2xdNh0Me1hjQSTNa5lY/CdMxZTJlIul
j5EFfOIVKH8Fon+jWUA4ZbqGZcy44RHs7GYz0WHEmfPSeZw0SMiZ9t4VxXu+e01W
sDpWXFfQpv+3Zll7+A+sWh4ljqRHtidWPfaxGq/Ikzv58WtTKaJzu8yj0W6sLJZ+
a4uXvenUszN+gA8aGXomf0y5A+PcCaPxs3JUSmkfL+zuJWwcUqWcNqbAJ3zp/ui7
DNeT28vcOb7E2/c49Hu2FQ6Y2SD7yo3PjHHBiNkC11p0PiGgQTD2J+8F1QeBSCAu
7cKIqW3URfB5vW/tV3nw6sJKawufDI0gJFrUvMajd2tDaXqYrjqX1cR/keG/5qts
xx0W8yFOU7o26V9MxvK7cAc0lCOQ5E9U8k3NqUYS9y8rqOHk2gOJUMGoZ6oJ8h/c
k4rULofaCqTlddpRjKerUwEH+EsQnTSWNIwzFjnkCErdl6HnY3rknt2ZJMh3xDqB
St6+5qSDCVTUHqSZzELaW1iCUSCLadxaIV74pt4xaR8yy0y6ybKMLyjeCguE76p4
VPJ9oO/zp+fNc1FDXBG8/FMf2LhGE3nC+Ngv7vDDZ3A6v3MXRPgUQ3VrGjQ+YB4T
x/KE6iH6SCVqYm+MvfI0
=wpRX
-----END PGP SIGNATURE-----

--Signature=_Thu__31_May_2012_13_13_19_+1000_8IvLCpoXiOEN5Tt4--
