Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1D0BAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:00:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42006 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab1D0BAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:00:52 -0400
Date: Wed, 27 Apr 2011 11:00:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Chaoming_Li <chaoming_li@realsil.com.cn>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110427110043.9c61e87e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Apr_2011_11_00_43_+1000_1Yngf4lydMqImYvz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Apr_2011_11_00_43_+1000_1Yngf4lydMqImYvz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/rtlwifi/pci.c between commit 25985edcedea ("Fix
common misspellings") from Linus' tree and commit c7cfe38ee0f9 ("rtlwifi:
Convert pci routines for addition of rtl8192se and rtl8192de") from the
wireless tree.

The latter removes the line corrected by the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_Apr_2011_11_00_43_+1000_1Yngf4lydMqImYvz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNt2q7AAoJEDMEi1NhKgbsDt4H/2NvaaTdQorGAXrjd3TQbUf4
CIPtCkr1LPtrHAzdi90rJ8v2fmzBRA2GdNRBY7VDkyCVyUi3ipOpMCAhgbZhutgN
9OecLHvkAnt2m8lvYOrbX/EyzTLIFpDnjQeX8mbev1yCMmaRAGhTaujLmdYmE56F
t4qOCIh+JUCIHwX66pZRFF42wDHOvQt1aK/t3WCv9aiibXnIkXwaS7/Ue1LMGKh4
K2AaoY9DAI8QBj5CunMNz/1kHeO9fRjk2D0bYOFBl3M4gUREJvG59JjLJ9CjPXQ4
ef7ix13jWFto0c2bjHI9eGNlCQb2YPggxgcbP4wIQuDAXfaRaT84HzPc8V+cm5s=
=vtA+
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Apr_2011_11_00_43_+1000_1Yngf4lydMqImYvz--
