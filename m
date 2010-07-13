Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0GMAvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 20:51:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57936 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab0GMAvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 20:51:35 -0400
Date: Tue, 13 Jul 2010 10:51:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20100713105130.3c927926.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Jul_2010_10_51_30_+1000_DSpSMkFklaosU_Ql"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Jul_2010_10_51_30_+1000_DSpSMkFklaosU_Ql
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/configs/lusl7200_defconfig between commit
07a8c03f3e06129e847acd068b8b89c13357ee64 ("ARM: reduce defconfigs") from
Linus' tree and commit c9c6fe5033191d82e1d819105485c795062107fd ("ARM:
Remove support for LinkUp Systems L7200 SDP") from the arm tree.

The latter removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Jul_2010_10_51_30_+1000_DSpSMkFklaosU_Ql
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMO7iSAAoJEDMEi1NhKgbsGEAIAIqbuSxkVRGsTr4tXayMfkoV
ny5+pPtAGSc4sarCheoOIBKiMJQTGgg8c1b0f9UpL7T8hs4sUBBiHsOiyrLbfdkT
lsCBSfPAGze299o3+4VAyoLFrCgapEsnHPJ+UC26Q/MpsLcXLvi29XaIeMf0LW2o
ivUgbsv+vUgbJMZG3zmTz8LPSM7FIgra2Fu688eHanWcE0mASYtsQ9vmOvtda9AU
YbR21mslkO0XTV9ng+5JT5MxGCAS1mocHY8dLxUAKFpVDWN09Z5FtiRo+kri1JU6
h0Ova716t9hHamdLEo5Cw4TF1UvR3iRvHGa8QCx6xQiIs7+S4GZeoZaqj8O8564=
=bnbk
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Jul_2010_10_51_30_+1000_DSpSMkFklaosU_Ql--
