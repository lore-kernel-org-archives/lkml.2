Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab2F2F5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 01:57:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36589 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2F2F5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 01:57:34 -0400
Date: Fri, 29 Jun 2012 15:57:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: linux-next: manual merge of the staging tree with the trivial tree
Message-Id: <20120629155724.99c0b8d8ad0738fdc7ebca33@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Jun_2012_15_57_24_+1000_lqqRH4awx7S7adY="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jun_2012_15_57_24_+1000_lqqRH4awx7S7adY=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/comedi/drivers/s626.h between commit 6ac7d11527a3
("treewide: Put a space between #include and FILE") from the trivial tree
and commit 90fd56af25b7 ("staging: comedi: s626: remove private INLINE
macro") from the staging tree.

Just context changes.  I fixed it up and can carry the fix as necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Jun_2012_15_57_24_+1000_lqqRH4awx7S7adY=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP7UPEAAoJEECxmPOUX5FEdT0P/22nK9DhPx7gP6GW7RjG4k/W
VVWEpoCoK5sPfvlWA7vMj+BTG3b3kwei89GP9HOGGo2UZvzlHX71Z1uL8FJxRx9S
E5t4tq6iVT0JCYJ08DFTqFzupqVfHu1+tuovpbcOmLybP15kahCjGSD9fMd9DuNG
vrzfsQPY6fIQsJc8jhNTdwj2aBQVfx486N5bDNbYbKtY6x8X6sW8/rdGvRRnmrhq
GDOoeKzVPwGFDDWpZw6nwxeZR5HaJgoQiu1xxvINi76jqowr+xV/ChCpT40QhN+b
70eWlIzQ7uflw8c2cB/J8E3kJkIoPTa5VYHSonby+2D0Gmv+0Jef2pnujf25eacB
Li+flaxiqacPKF9TJgLj1AGIE+dusR9QhTlISkZhnEnvhj9usB+wb4e9N+ixqO6F
9d5XWZweS/eL1IlgJP+886rDokCqQa3mqE4xGGsjkrMdhik7XdekQZXpIgplEvSx
xggy+mS+uhDa+4jDQ7Jopgy5g1U4tsav3+GA5E3wwPr0iApRxs9Im3ZLKEBGeygS
+9AqTGJrYxvc5oBepNidbe/leCDDjHpGPOLSql2gJLVsODT+i4zRhjLD39u2seCA
JSSjaraVoYq2UY2Skw9zaxIkoMTMbwozjkga3k6TDg0y4euJNbWvF1OQiOknzjfx
RMjtkHR4irYFa5evxcBA
=ON1c
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jun_2012_15_57_24_+1000_lqqRH4awx7S7adY=--
