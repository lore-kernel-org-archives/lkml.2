Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab1LOCxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:53:42 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:36054 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab1LOCxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:53:40 -0500
Date: Thu, 15 Dec 2011 13:53:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net-next tree with the wireless
 tree
Message-Id: <20111215135330.94caf28045fd307801fa5ef9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Dec_2011_13_53_30_+1100_.a=RkJxFFstiaaIk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Dec_2011_13_53_30_+1100_.a=RkJxFFstiaaIk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-agn.c between commit 81670a491849
("iwlwifi: tx_sync only on PAN context") from the wireless tree and
commits from the net-next tree.

I used the version of this file from the wireless-next tree (where this
conflict has been resolved).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Dec_2011_13_53_30_+1100_.a=RkJxFFstiaaIk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6WEqAAoJEECxmPOUX5FEcoMP/1i9u2ihOpZ9mCZkWRJTuqTf
AqfiZ/+daoePJxB61QM/92rKLGhkD8Lluqvbt53yoXUed6jNUksyhVnJWI7OnleZ
spXr2LrifDtKMbbzkX2X2VsFRiy2IalcVbhGLJNTPJ2nNEszZzIcaTDkeJ+wfe5w
ijeAYdihm7qjzga5KaKx5BTX6d75y6eQVF9tq6cZIKAAlfkibWTTaxEmtxKwY7t5
+VtER+D5ftePTSjl6YgKgIY0xGnQb5uxs75XTsa3ElW0pKtUphXUYeaidh8BF9e3
2/btAzQIgvGjAV1ZKYgP2Fmw1B6TcgASZT03Nn1N/wHjptCeCnakwAB2CNIq5SWi
fFrAN9PW8ZjAfSElY57BJbiiDsxr4tGgX09F9dGpV/Lc9JmRnNxei4maRVcgO5Ck
fsqiylLPBafn016QxXj82X0ScW1aUj/b4DXU3gX8aYJNH9URA9mce6gKW+Uq+hv0
URFdTDkBZ2+rpnUQxlpVD2s9+ALoqYOOd0Q4ehKQzE2wgv3ZRiwIkaFCM0Z1CbE/
upp177pQ0Mi5U1qhgFvk1tEC6NgIZkGT4+teAFD7aNgjwFAbAKyysRS2W4PvEd4G
jZMyuZUe5BWDo2on7FyEDJ/Hvcdizg9cNiv9b91IzcIHmmANR0iRkvhYPyHi2BxS
zmGAxcrV6UhN2jv8cidQ
=H9+7
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Dec_2011_13_53_30_+1100_.a=RkJxFFstiaaIk--
