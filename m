Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0HQCVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:21:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52344 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab0HQCVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:21:50 -0400
Date: Tue, 17 Aug 2010 12:21:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarkko Nikula <jhnikula@gmail.com>, Tony Lindgren <tony@atomide.com>,
        <linux-omap@vger.kernel.org>
Subject: linux-next: manual merge of the sound-asoc tree with the omap tree
Message-Id: <20100817122145.f399e543.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Aug_2010_12_21_45_+1000_MZVDMmvF67pYs3uF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Aug_2010_12_21_45_+1000_MZVDMmvF67pYs3uF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
arch/arm/mach-omap2/board-n8x0.c between commits
1c37553eb1778802f0e7b6730df36542752e801e ("omap: n8x0: Cleanup i2c1 and
menelaus registration") and 69be0f6f4b8e3be992ab6a333a3a82e043784c52
("omap: n8x0: Register i2c2 and add board info with tlv320aic3xfor N810")
from the omap tree and commit f0fba2ad1b6b53d5360125c41953b7afcd6deff0
("ASoC: multi-component - ASoC Multi-Component Support") from the
sound-asoc tree.

I couldn't figure this out, so I effectively reverted the part of the
latter commit affecting that file.  Is there no way that the latter
commit can be broken up into smaller self contained pieces?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Aug_2010_12_21_45_+1000_MZVDMmvF67pYs3uF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMafI5AAoJEDMEi1NhKgbslK0H/03cQOXfAj42GPxDPOmj4fti
TAKybM9kvnA29NyNy/Tj3swP50JSq2fKbtR1gVsx4zFstc15AV0k0z130yQiPEMN
rtBKnJPQUUr8iT07ZNP/oriHiDnFvVzA1B55v1rN9MQE8En73saNNqA0brZeR532
FZRFuMqRxmr3BFCSzbOfDUZ/KNc8jrycYEsw7Plu+LIQfmO9QlNm8mY4eP7j/s9U
nNRgBjRVENv/EUfSYzuTeK1SxsA7UCsFmVRgndvbXqnPIOO4aHLRqBz5fF2N9mr2
npdGL56aZbmI7dCnPoQ+GNIVkyxJBWkLxt9KJ16gfAb13uHzNg7d0MKPQwia2LE=
=KQyr
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Aug_2010_12_21_45_+1000_MZVDMmvF67pYs3uF--
