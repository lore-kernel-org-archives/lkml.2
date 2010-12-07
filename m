Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0LGDLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 22:11:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41808 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab0LGDL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 22:11:29 -0500
Date: Tue, 7 Dec 2010 14:11:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>
Subject: linux-next: build warning after merge of the wireless tree
Message-Id: <20101207141121.966ebcfe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Dec_2010_14_11_21_+1100_w6u1h1OhkGFmzurN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Dec_2010_14_11_21_+1100_w6u1h1OhkGFmzurN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

net/mac80211/mlme.c: In function 'ieee80211_sta_work':
net/mac80211/mlme.c:1981: warning: too many arguments for format

Introduced by commit 04ac3c0ee2c773c321ec472d892635a20556f34d
("mac80211: speed up AP probing using nullfunc frames").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Dec_2010_14_11_21_+1100_w6u1h1OhkGFmzurN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM/aXZAAoJEDMEi1NhKgbsjt0H/jLSU9YrExqblTzk2495qwyt
aUK4Hd4HdLwFvYQOdLJ9lcXiu1Hesk7iFtSWN/WBJGyv2Y5kTmZncrYnYUKm/Kud
i85/ccuTSJ7dihR03RdBrvQGpGUXassNPT/aOLxsu+XD4HqgJJIXqvTHGXiLbEoq
NY7PNFihldfdsHjdFc659xvHH5gXbuE6NQF0J3O4ItyhSW8tNgdamXdCYni5hY7s
3xoVc4zjej20a3ajCbPbmWBHkzEu/i/3gjhqnNc+Qem/GYJJVc0ciSQLub7VXwYL
8+W2w6ZeIwf3stwRhAGggt55mcx8Pi6CbhFGaK/yUuKcpbw1ltQrbwue9zzvAg4=
=AxVU
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Dec_2010_14_11_21_+1100_w6u1h1OhkGFmzurN--
