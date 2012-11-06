Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2KFDxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 22:53:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60805 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2KFDxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 22:53:42 -0500
Date: Tue, 6 Nov 2012 14:53:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shubhrajyoti D <shubhrajyoti@ti.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the tty tree with the arm tree
Message-Id: <20121106145332.5fd40abf0d74f8239156f75e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Nov_2012_14_53_32_+1100_Oep47o41yMjZN0XV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Nov_2012_14_53_32_+1100_Oep47o41yMjZN0XV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/omap-serial.c between commit d864c03bfce2 ("SERIAL:
omap: remove setting of EFR SCD bit") from the arm tree and commit
7ba897d77ce2 ("serial: omap: Remove the default setting of special
character") from the tty tree.

I fixed it up (using the version from the arm tree) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__6_Nov_2012_14_53_32_+1100_Oep47o41yMjZN0XV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQmIm8AAoJEECxmPOUX5FEISQQAI7s1XvuzobtO/R5Tmj+8+0u
mQOOd8hBo+Rhue4Un2+R8G0MjBsYpmJxma56jdRS5UhrKPDFvsA2ZuWlSrZo4VoT
h0bC7GlGy6IUEZgUynhLPDFTkAfZOPwaT1KCV+hqxEYouMD8FK39AOwU3IqZABrK
MhupOgr4rt0Fx9uxzhGJBdXfqel6veWH8zX8ROPLMLpQhHbiMKokROS6O1oEK/c1
C4M08v9UhaMHAd2pI1OYHJuxDJ4VvmbXadCUvXSqAGbsIi++l4KG7865hVayrbto
55X4+2aZKPBX4JQa0OJDcMiSNWUHcg/nTZ1q9ukCap3CvPpyKlYkBNnbXjnY1eZK
Z4AG7VQDxSopv1s6wZ9i/g5gqhzjblbDVNVZZpsbakNKqgeaCp/V9UaljibUT1zj
Ti/CBJOLIJm6QSZ/SPxdEgnYkYWrWbSvJ8hIUWHYrYEX/LtsYBbVt1MqP36EuUVq
KQdlBIDOVqMARucuaj4B5ZFouwwRwYc2UV2XTJTJyD3LhgQTRCHESCQPkcyfQa55
5R5m4XMAUPttsXOuJt9yibLKOzGbQJDWoeSLeEMcVAkXN058LH7o3PmFgPSlEQ9d
n4kSsP1vzw4GYAMeyc4ROWD/csrHJNzMC+OkQ+2fL8Ae83wnsmstfSI5W7CBXKl2
zkHxE7jPxeGmyO6dMFMR
=JEbs
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Nov_2012_14_53_32_+1100_Oep47o41yMjZN0XV--
