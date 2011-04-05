Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1DECWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 22:22:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41917 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1DECV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 22:21:57 -0400
Date: Tue, 5 Apr 2011 12:21:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20110405122152.74cc63ae.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Apr_2011_12_21_52_+1000_OGni0U5AHN7JAgfA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Apr_2011_12_21_52_+1000_OGni0U5AHN7JAgfA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c between commit
2e3e66e3bbcd ("rtlwifi: Fix some warnings/bugs") from the
wireless-current tree and commit 324732848c42 ("rtlwifi: Remove
unused/unneeded variables") from the wireless tree.

The latter removes the line that the former modified, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Apr_2011_12_21_52_+1000_OGni0U5AHN7JAgfA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNmnzAAAoJEDMEi1NhKgbsvjUH+wd2lfNZ9PIh1E0kXckhI2vf
FEVAQdQLolxjhYobvVTPi62ZX1+TwgSwdKQULxUHPxTuy+l22r67F0eijyHOU5T2
1tvPxIr8c/4XfpG4k/6w/S0lojWubBe5b09ZExPaN8Gtid04v46wzea+ZpwTV8fS
j8TMm3ZSpQyvLNuPDrsi0mcsJvBqdCnXLE1sJRgtVqU7GgUICtBR9moEuJFxWcI3
nOEaFg1PJK7xCuq7ufHXG9Acbw/0+kmWHXe5JaNY/q1DKJxun7gKoSTgBbuzjT0C
sxb1z5enx//dN3jRDBQlr1akPrJ40JAX33XP9ahGiQ8jIH3ECjn+J1vxBhcYM2U=
=hGQn
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Apr_2011_12_21_52_+1000_OGni0U5AHN7JAgfA--
