Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2LGGj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:39:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52602 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab2LGGj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:39:57 -0500
Date: Fri, 7 Dec 2012 17:39:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20121207173947.b7310b1e21a375753000f56b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Dec_2012_17_39_47_+1100_DX9LXKW.llo7OHif"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Dec_2012_17_39_47_+1100_DX9LXKW.llo7OHif
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/vmscan.c
between commit c702418f8a2f ("mm: vmscan: do not keep kswapd looping
forever due to individual uncompactable zones") from Linus' tree and
commit "mm: use IS_ENABLED(CONFIG_COMPACTION) instead of
COMPACTION_BUILD" from the akpm tree.

The former removed part of the code modified by the latter, so I did that
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Dec_2012_17_39_47_+1100_DX9LXKW.llo7OHif
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQwY8zAAoJEECxmPOUX5FEvtsP/0IAIuz2L+ibYedSJHo+xEwY
BgkdNNnP5vtI387a6Ed1Il9E+pMIFDdKJ4y/j81ImyElLNeG1CQHW2eG0jthVuUj
aECgQ+IQ5caIHE36DzLx5d3Hr7NcOK1EfoAlt0qTOzYO/+kiIgi0PAe1c1/pgIU+
mu/kmlD9nTXsSTnI5nSvoZ+c6f+oHkiDl9qwvvYIIVuptLMIuMneurIfdFiBNsjM
XWOJkRCFxE/NQ5u3mq/QMIMpFTTiA0qgBlgSZqjjOJvzorRu49QoPDY2GbtAoHN0
k/arELYXk+/WlJD88fnYhPCMIcf7HxO2ekt4YE+vpLCub+zud9QF132q7kt/2Roe
9jT1bW+k6GdKS8QUHTOooOW6HAIjEvgl3uFrJrUjoSA8qIcxisUgN7Xd2EbaRK9X
/W2Lx1mqqWM0uOIv0rMizQrrf2cOVTXhrF8wfR8JdkzUOb+Bi9uAWuyXfaeB/kQb
eKy5mR8Oyi2MFIJbV9SWjwdRJ6jdwD2WR5NF5ImIIwoS5vtIGKe4y8oKPXtvP1Wo
2lGaqtHqBENXhyzYmkWIAZQSO36WZeKTfBjBNsSv0INsZk70vk9y9B+S1Z8V28yO
/tDePHrjJXqbnhZdm3itdSmqmzkb+Nw/wWCbtoNISWJohIq7N+6/8d8HIg95WBM9
qYr/QHxoQSaqerT0neTW
=8/xX
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Dec_2012_17_39_47_+1100_DX9LXKW.llo7OHif--
