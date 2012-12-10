Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2LJE32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 23:29:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37150 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab2LJE31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 23:29:27 -0500
Date: Mon, 10 Dec 2012 15:29:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the trivial tree with the regulator
 tree
Message-Id: <20121210152914.62b84949534e6d68a709e1d5@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_15_29_14_+1100_ZbBWSl3kALdp1E8E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_15_29_14_+1100_ZbBWSl3kALdp1E8E
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/regulator/palmas-regulator.c between commit bdc4baacebda
("regulator: palmas: Convert palmas_ops_smps to regulator_[get|
set]_voltage_sel_regmap") from the regulator tree and commit 02582e9bcc36
("treewide: fix typo of "suport" in various comments and Kconfig") from
the trivial tree.

I fixed it up (I used the former as it also fixed the typo) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Dec_2012_15_29_14_+1100_ZbBWSl3kALdp1E8E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxWUaAAoJEECxmPOUX5FE85MP/ig5dNn/Adr2gMOawWzZP63p
rN+K4zMFyWz0pF7SYJ3Yc6MrJRF3yF0i7QH1+J8jvBBwYPNQp7Jb/4B4FenNlg6Q
mWkJv1hrOVXHqBVkm99SL036+Q9+qtOb3nx+yAcYbiBlMeS8TQQEvDu2GeHfVwcR
U930Z1jOO88yQNeljc+QWQ74J6VlIrG55wls4s45LeQmxNClAhXRZeNP+LbuiryQ
xmARk2n3ReKVg5LQL4jZz4NoyqAq/pocCA9SdZquTCs7c7UzRNGlJkmKSdENlS+h
hSy2kLeh7dp6aWo3F6v8V/fKxJVylNJvsiLSa0cASJIGqPx+pdMsGaPgW5R0QnCI
jBc7nljFIdxfOGs9+ULWd7cCCoLQz9Tzk9tQDbIQPtBet29w/6bj1pSszJEL4cN4
d6uQ/epo2RXy8vSe3T+mXG8uYI4H9PP26skwN+F3kj5jJfFgci1Cyt9X7X91DbOa
SMkALJZgLpZRkefDaU4zUhHhS13OHG49BCG3r7uiN4kOtSGZElJrVyoQiD356Bmv
bxbI9g4wGGj4gg/BCWph5RdGPgWhXk8koYqvbMN1TqiznXHOO4EYvbLH/Xt862S8
Spk1g3EdMVpizyvmW6gFfwtoTvyiErn3J+Se+3khEHywCeWLpLgp3tTG/Hp+JQXx
JYG0qtTw1QLEca3qAAlS
=r+TT
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_15_29_14_+1100_ZbBWSl3kALdp1E8E--
