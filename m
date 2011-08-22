Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1HVBva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 21:51:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46582 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1HVBv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 21:51:29 -0400
Date: Mon, 22 Aug 2011 11:51:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@gmail.com>,
        Niklaus Giger <niklaus.giger@member.fsf.org>,
        Tony Breeds <tony@bakeyournoodle.com>
Subject: linux-next: manual merge of the net tree with the  tree
Message-Id: <20110822115118.e5d97beb22befc4ba9396e9d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Aug_2011_11_51_18_+1000_gKhHYF+iNKel0..r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Aug_2011_11_51_18_+1000_gKhHYF+iNKel0..r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in
arch/powerpc/configs/40x/hcu4_defconfig between commit 9fcd768d0cc8
("powerpc/40x: Remove obsolete HCU4 board") from the 4xx tree and commit
3b3bceef26f8 ("net: fix IBM EMAC driver after rename") from the net tree.

The former commit removes the file, so I just did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Aug_2011_11_51_18_+1000_gKhHYF+iNKel0..r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOUbYWAAoJEDMEi1NhKgbs/TYH/01K9djlGn1GqkEH7/cRk90Y
PqyAXfaCqHis+75rBHvFmmXrNXJ8TeSIHkMTebTC7hHsmnAFI8rzUz2c6oynWBTY
iTj3V8jNCn38LICRep5c21rFiVCP6e98pQBNYtBsIFyno1mMgbX8UtjpHCdJYpAJ
WRFyN4PGK5z5+X/qfKIIeZkV8tPXXItBg+XV1o9fnLhowpV1ljmHORgDxU89xJde
WY6RRrCVBmPymvf0nOwTuvpLvjwRcCfNnCSoENLRkgmbWgkaaOIPmm0/fF8xxTdV
Zf5XPNxFQ4WWl+G6O28h1k77CslgRUdZu6NWhaaTCaX8WzN8042TBeRwxMl+3IE=
=WpNp
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Aug_2011_11_51_18_+1000_gKhHYF+iNKel0..r--
