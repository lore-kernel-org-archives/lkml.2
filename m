Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423565Ab2KOCRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 21:17:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46772 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab2KOCRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 21:17:22 -0500
Date: Thu, 15 Nov 2012 13:17:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-Id: <20121115131707.25e7df1ab635c18e62f0712a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Nov_2012_13_17_07_+1100_HGnQWeNC5dbsE1Dz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Nov_2012_13_17_07_+1100_HGnQWeNC5dbsE1Dz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c between commit
d61f978b8f26 ("brcmfmac: fix typo in CONFIG_BRCMISCAN") from the  tree
and commit f07998959d57 ("brcmfmac: remove obsolete i-scan and clean up
related code") from the wireless-next tree.

I used the latter (which removed the line that was fixed in the former)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__15_Nov_2012_13_17_07_+1100_HGnQWeNC5dbsE1Dz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQpFCjAAoJEECxmPOUX5FE+w8P/1zcGlIySSWkoAoKu9grYsAN
BbA9dvqVPlOMEnEvvZG+Qd/iq9TTYBphdlL6DoM11IX42PC+8hhtAZl+fMM45hDU
8Lhn9xrTFHKkQP9Ff+GJsU64BYYGUO5ril4QhGdA91UfQhWQoBFI1w0Jo60SxFXd
8F7BpxfH9Voq0AiDVqNA9Plr2yGH5Qy18PJiGudi+WYQpMACkEkR+Aa8HeKpV7zY
9kCPrIrSEMcpnpIDCkcemYfE5TqgLW4EtOfxl8sN3bGdiDOJoLLCbma50VL5MCvb
rwpSGiTSP66Sjq4/mSVYM8MPozoibGDNeq6/iBmqXU0Ij9rcR9XwC8Uxy1ShDheD
AixzEKh2/wpQYSDq7JI30Nowg9JnUfzOBn6aZdSA2RsuJh5zyT4D87oxThqj/iHi
vRZwCX/N3UtWjKi7jWcM7wGWSKx68s0k7ZL8ZVHyrLSA1JYX6WP4MxOCiwpfzL+y
OVTYqS2RNd8i0BqTP3Od2JuRBoZ0JRIsXp/hOjfvb8N3PVxlPHZfSXSJYqiZLNxq
9pheViskyqNS3YQfIBWx3M8DX0TulO7fuhArnRhtNxLfDjjeprYz/SSjkYP+jo3n
zQrWKpWHRO4OK5EEtEEFLN16oJYEzZm6g0F0k0WCU5QBrASz1AW7PjYPCBa0AljL
SE0kLkozE2EGLCFceyBX
=4mqQ
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Nov_2012_13_17_07_+1100_HGnQWeNC5dbsE1Dz--
