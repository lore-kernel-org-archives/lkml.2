Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0KIAtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 19:49:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41882 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab0KIAtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 19:49:07 -0500
Date: Tue, 9 Nov 2010 11:49:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failed to fetch the genesis tree
Message-Id: <20101109114900.84679f9e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Nov_2010_11_49_00_+1100_EhZ1M6Vn6g7x8Kf+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Nov_2010_11_49_00_+1100_EhZ1M6Vn6g7x8Kf+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Fetching the genesis tree today produced this error:

fatal: '/pub/scm/linux/kernel/git/lethal/genesis-2.6.git' does not appear t=
o be a git repository

I will use the version of the tree from next-20101029 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Nov_2010_11_49_00_+1100_EhZ1M6Vn6g7x8Kf+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2Jp8AAoJEDMEi1NhKgbswtoH/js+EBLWicIei6szv7KBr0Zs
mIMYsgkPQ+mCTa7MXKhk1yKyqtZLX7Q8p0E/Et17LzgoYYiUnAB6xXM8VuvzeFbp
gkiDN/DF157CsrD6FMLqkPFz5NvEzgV78Nh3VVHiu7zgkqnl6DmAhzAhzwqkVWPb
+G09AePNJRCB6eXUxhJgVrU6vpMoap8L0f2CLGwlhsFAoJxST5K1HAswehdKECCo
vJcDxXSybC3ibbUZJTkgyUlwf3x7nOi6tWu/yIvdnJHpNVttxhlkFysAAQNWK7bh
JKpX5S49GYqoAkU9hAE8B9t+Hmb6FlToexfsSlSRwxDH3Fk+NpoCaxL5DFL6F3I=
=rYXV
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Nov_2010_11_49_00_+1100_EhZ1M6Vn6g7x8Kf+--
