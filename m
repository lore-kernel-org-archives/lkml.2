Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab1DECVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 22:21:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41910 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab1DECVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 22:21:50 -0400
Date: Tue, 5 Apr 2011 12:21:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20110405122138.0c807ec2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Apr_2011_12_21_38_+1000_3ln5PANXJPbDdC8D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Apr_2011_12_21_38_+1000_3ln5PANXJPbDdC8D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/rtlwifi/efuse.c between commit 2e3e66e3bbcd
("rtlwifi: Fix some warnings/bugs") from the wireless-current tree and
commit 324732848c42 ("rtlwifi: Remove unused/unneeded variables") from
the wireless tree.

The latter removes the line that the former modified, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Apr_2011_12_21_38_+1000_3ln5PANXJPbDdC8D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNmnyyAAoJEDMEi1NhKgbsf3sH/1EyF4mx8RTaL4vL1cXaFdBN
zkO007Xp+RCLy4vudbGWeHmodDRC62Ph0zj7m6E7Zt1efVBuN7VnYNYHBXeKrr+7
Bhuk1xf3cEl5NiK5rk3xwnWqbUm0RyoiuSZO7qM6SSrnwBvW3aGtFx+tb5ArdQSw
cpAHroo1yjnt8LaBNLvmrvIFYwUnnbanEhNTijXtMnk/VZiPq2VD52zR0GIQQg9G
xmkfUAnsfdA2NFl7Yzjyx4aYGsiQo5paHMyqcT49bf8d6GGOxT03mzOmXHsyddNq
5J4QYPRw3zKE/8u4daA4TnkmM7SLK/LF58gSAF1WokTvPqGpi0gtWmz04OkAwGU=
=bNqZ
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Apr_2011_12_21_38_+1000_3ln5PANXJPbDdC8D--
