Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab0EYG4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 02:56:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59119 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab0EYG4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 02:56:17 -0400
Date: Tue, 25 May 2010 16:56:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: linux-next: build failure (arm tree related)
Message-Id: <20100525165606.239a0465.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_May_2010_16_56_06_+1000_28EbEePRgUDvRLsg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_May_2010_16_56_06_+1000_28EbEePRgUDvRLsg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Most (all?) of the arm builds are failing for next-20100525:

arch/arm/Kconfig:883: can't open file "arch/arm/plat-s5pc1xx/Kconfig"

I think this may be a bad merge 211cc52a36dedd1e90147af43f6ab5eeb57952ac
("Merge branch 'for-rmk/samsung3' of git://git.fluff.org/bjdooks/linux
into devel-stable") which resurrected the include of
arch/arm/plat-s5pc1xx/Kconfig after it was removed in commit
acc84707d3487735fc666fdeab76185d086428c0 ("ARM: SAMSUNG: move S5PC100
support from plat-s5pc1xx to plat-s5p framework").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_May_2010_16_56_06_+1000_28EbEePRgUDvRLsg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv7dIYACgkQjjKRsyhoI8z07QCfbBV1fslDV3ytEentl+YHVRiB
MN8AoLr/9OxZ8vQIaWVOdurcdTFeQYxv
=No8H
-----END PGP SIGNATURE-----

--Signature=_Tue__25_May_2010_16_56_06_+1000_28EbEePRgUDvRLsg--
