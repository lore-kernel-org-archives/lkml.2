Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1KVDfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:35:44 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37437 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1KVDfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:35:42 -0500
Date: Tue, 22 Nov 2011 14:35:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20111122143523.ee83308efc48baf19f691441@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_14_35_23_+1100_HKevlburjjgNG5Wl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_14_35_23_+1100_HKevlburjjgNG5Wl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build
(x86_64_allmodconfig) failed like this:

ERROR: "il_dbgfs_unregister" [drivers/net/wireless/iwlegacy/iwl4965.ko] und=
efined!
ERROR: "il_dbgfs_register" [drivers/net/wireless/iwlegacy/iwl4965.ko] undef=
ined!
ERROR: "il_dbgfs_unregister" [drivers/net/wireless/iwlegacy/iwl3945.ko] und=
efined!
ERROR: "il_dbgfs_register" [drivers/net/wireless/iwlegacy/iwl3945.ko] undef=
ined!

Presumably caused by the large cleanup of iwlegacy.

I have used the wireless-next tree from next-20111121 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Nov_2011_14_35_23_+1100_HKevlburjjgNG5Wl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOyxh7AAoJEECxmPOUX5FEGdAP/j8kzrzpUHpmrrtPyGa5ZmJQ
FcL6mNdKGfUchPrvfaYSHkawQoIZVoU1UgmxzPwrsqGKJrYTu9cpEbUxPBGdoSnx
fW6AOiQoLCrA5bT/4Ngd2b+3kugetEiKA8CUHcKsDEoq9lryEJPG6wzCyEgNe+SW
hy7JC3ex98jGpdkRWu5ZmkHxZyZ+JL5cQRQxm8bDf17ZLBIuqLf1y10er6B+qsds
xk4vu8rlZF5J8jlM7HCWhktphUq+5gh0NsvF7GAIjXS/GT207mpESIhC260HYsTO
0RQtdWiRavdFuT3x/+nT9Pt/2770bT6Szmo4+0cIhTrrOohpTw1zUFKQLOpj4QpY
RhuFUps00V/IpLKfWEKsWquusCzb2m4eiCUrB0oiGQQF7PvhRVPFccmuYKXEE1FF
zZwHsjnPFwxvOQhAF1C/RR2Dx2MytDz6J3+9TWPY8l1RY/7t1ktAk24BsEf7gcpo
LtYNk3ks+5I3laeVVBvO33doWRt+A5FB7sEasxdDt7T0BFYVZKKLajgcTpitpwgl
kZT+0YZQn/7XfLjm8qDNfdWGesRxmVDEdVlFPl8QkPlZKOR6kigfZRtfIfb10BSX
1B1uaL69rLWuk7xIbKazV17Sq/+g/49GPTrMc6yHscyroV4Em+wi/x53jnnP9L4g
UsHmHMJ9AAExQj9tyY9n
=g208
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_14_35_23_+1100_HKevlburjjgNG5Wl--
