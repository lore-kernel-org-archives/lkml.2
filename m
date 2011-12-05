Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab1LEBet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 20:34:49 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43936 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1LEBes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 20:34:48 -0500
Date: Mon, 5 Dec 2011 12:34:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the net-next tree with the  tree
Message-Id: <20111205123428.47213da24624d85aa84711f3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Dec_2011_12_34_28_+1100_ncL=u0oM=6_Q0Cd1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Dec_2011_12_34_28_+1100_ncL=u0oM=6_Q0Cd1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-agn.c between commits from the
tree and commit 7335613ae27a ("iwlwifi: move all mac80211 related
functions to one place") from the net-next tree.

I just used the net-next version (which may require some fixes).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Dec_2011_12_34_28_+1100_ncL=u0oM=6_Q0Cd1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3B+kAAoJEECxmPOUX5FEBBEP/22HNpjAxOb5Vt6tCcMoqeXS
ZNHzv3D5Wgx/DcihPcyxnN9nQIqu/h3AwQStPYw//5dcEUBL/8p5JNZ/hzUZhasT
nRxad4c472ox/4Y9qSf5CRw60tkynDfho1d8uKyBu4Rvhu7AWzemEXn7La9fnOAA
ceqCmNLW0hLbGDWlNIGUW36vUA3G/R0lVJ/sYJd5SyF6vBfSSEdwGw1FcnmbZeCN
pQiAUfrJjB3stnFRk7OZ1cDwLqqVnN4TnM4wDKVL79bt6Ofd/Up8W4Rq/0s6Y9ka
91NDQgMPLSu319evvqXXc02buDPSOjtH8/oXWO/XtY0HL6SNWgSueYvtot+gnGNq
3+QNoHSNp7hzPmLe9VnFly+BZYzFEnIvmf7Dh8gLS1uLx6QyrQgNnhZ519hasqmE
yVOie4VQYkiBoMf5Izbj0eijsa+UNAlLplTS0cFO21vM01SnYZEaLTnqj7Zh78mX
0LateKKbdxG2Q+xRbW8QpwGAM5530rOYd5hMUKD5Sd52fkFpP54E4xw97r8J5L9k
JY1+3imjcFYloC4sTpVIYNEWrx5eJdgJ21QSa4BO6Z2zrB/dTGXXy2y2yeCy+XeG
UplvWfThDHw0gD/3GUwTL568FlQBtiQAWz23qDpRYds5R7EPY829jVmrU4cN2qkG
iY/a6Cx77eC8M9t3aKYm
=Tc7x
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Dec_2011_12_34_28_+1100_ncL=u0oM=6_Q0Cd1--
