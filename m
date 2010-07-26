Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab0GZBOB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 21:14:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33704 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab0GZBN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 21:13:59 -0400
Date: Mon, 26 Jul 2010 11:13:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: linux-next: manual merge of the arm tree with the arm-current tree
Message-Id: <20100726111340.a0bb25c1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Jul_2010_11_13_40_+1000_mdGWcqLxyrqc8R3a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Jul_2010_11_13_40_+1000_mdGWcqLxyrqc8R3a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/mach-l7200/include/mach/debug-macro.S between commit
a2d7c57a2eb1d30a7fdb8df9e965dea721b75711 ("ARM: 6257/1: arm/l7200: fix
debug macro compilation failure") from the arm-current tree and commit
c9c6fe5033191d82e1d819105485c795062107fd ("ARM: Remove support for LinkUp
Systems L7200 SDP") from the arm tree.

The latter just removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Jul_2010_11_13_40_+1000_mdGWcqLxyrqc8R3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTOFEAAoJEDMEi1NhKgbsJisH/21KBGeREpgXQDVXAGweejE5
ZBAqK+il9WVl0XYeRVxG8eeFP/snq92Y3k1CW1HxW3N3eE0sfI15gG2v1j5plIYy
IbZkybrHp7MJsBR87cljPw5mYQrw5RX1Uei6GMdv9+ojFgkiZjNkuz9uRQGYgkZx
6iolLUTmPfsKJ2vNVnK/CXfWri1dvcz8k6QO0IzUhs1Z5Bcrwr3VYMgrf9DPxlRu
ZYVGqFGiSGRu2cw58zf1G7jZQRgcobvR0RuALxpQxloVzLzznQ2iUAF9gPE5+Woa
AAbYvYzpfPBnocSATOje9Topm/OPvu97pwkJIF7IH/u8TcdMLE8VYBbg+vJhHPM=
=lr2I
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Jul_2010_11_13_40_+1000_mdGWcqLxyrqc8R3a--
