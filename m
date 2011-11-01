Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab1KAHyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:54:36 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:60263 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1KAHye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:54:34 -0400
Date: Tue, 1 Nov 2011 18:54:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: linux-next: manual merge of the akpm with the scsi tree
Message-Id: <20111101185413.694c111f8b8bf015326fbc83@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_18_54_13_+1100_ECBrmuEJXcc4varn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_18_54_13_+1100_ECBrmuEJXcc4varn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/scsi/sd.c between commit 21208ae5a21f ("[SCSI] sd: remove
arbitrary SD_MAX_DISKS namespace limit") from the scsi tree and
"drivers/scsi/sd.c: use ida_simple_get() and ida_simple_remove() in place
of boilerplate code" from the akpm.

I think that the latter supercedes that former, so I used it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_18_54_13_+1100_ECBrmuEJXcc4varn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr6WlAAoJEECxmPOUX5FEj7UQAIflCKAYH09ZpPY2IfB23amD
7nYHEcp45lVoRYZw8XNNvRCNgUfieTLKAfe2BbbgmD39ZHwDFixQkc0ZALd//yfT
X0w/6fA4t/LLwBmaYNFGZxTho1uYeJHJ4T5/m3uov3zUVyVVZ4hDc6JZqBBrf82+
Hf9q6c5iQ/OODCmM2/xLirEf+DqaZelMxQgmsTwUS/1LhNo3Ts0K90XmaHjSm7qq
n0/mgd0RpbC+DgtpqOcQBrH1a4U20+ioGYQ4xJGphZSxn/thYJ2isE8m0fws//4V
wOw2VSJVVknXydzVeqroDT/+R6Lk+ALiuDELG/N8eTmdyAz3mSQLz6t7MlFt2oxJ
mhmRo/XChEVWyji7nYSyzd5nqCJQKu2B6WSdUL0sUnnGqihOgpJZTcWsLZew4+lL
v1BBkRyVFTQ8vKJuKPseBvTYDBUGc+YG7vBh+WTQGZV+Jcwm3Bei4Au4pVSRFbOO
cWWgyKNmFKfSA0x2LX+EuOvY3zzr3WHoY33d4KFO0fCZGQ4FiueiwCk1S5SPHC42
OHil5brS4MVgRoZRtaf88EChTyJEe9yD8hvKHabGNyYlinbsmRuSYERWpYYPQSz9
uhdclNxIb2vf7ayWvw1KFRVgWVGiog+StxC9LSVEuIFsz9wivK+MUH6WPjZDEaOc
nhDNXrx0QykD/5fzn+Wp
=ws2k
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_18_54_13_+1100_ECBrmuEJXcc4varn--
