Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab0JQXu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 19:50:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58792 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab0JQXuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 19:50:55 -0400
Date: Mon, 18 Oct 2010 10:50:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Wang <jason77.wang@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20101018105046.368420c2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Oct_2010_10_50_46_+1100_2EwCXjtUkK.N0Q/P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Oct_2010_10_50_46_+1100_2EwCXjtUkK.N0Q/P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-s5p6440/include/mach/debug-macro.S between commit
08a610d9ef5394525b0328da0162d7b58c982cc4 ("arm: return both physical and
virtual addresses from addruart") from the arm tree and commit
29159b7dd244def6e0073ff0e2d4cbb59599187f ("ARM: S5P64X0: Add S5P64X0
(S5P6440 and S5P6450) initialization support") from the s5p tree.

The latter removed the file modified by the former.  I did that.

The appropriate part of the above arm commit needs to be done for the new
file arch/arm/mach-s5p64x0/include/mach/debug-macro.S .  Unfortunately, I
am unqualified to do that ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Oct_2010_10_50_46_+1100_2EwCXjtUkK.N0Q/P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMu4vWAAoJEDMEi1NhKgbsUDYH/j9RF4SntwCstGoImazY6IDI
l1D02xqKVwvxyYnnJQjEOhagOLqlm7ZGu4p044mwhUI6qM9VzGB7qM5PruKvlVqA
Sqi+raekAAJhMaTJ/6wUE4HPUSgvsq0zISO4iDbnP5kHuczXNzX7DfEFPpHwr3Sw
otwuVEcW2omZh/1kygGs6C4+ZA3dKc01rgb6QU6r7VywcIdpLLm2z3jWzaIZ4MUZ
lUVki6egEJDVWaAGU5JPbEDh4KjoIhpybLDFn5oOtSJL6cfQQEEhR/fStZwA3D2n
iuBDlfE9RtACQssNK4Gmk/zisXXtG207faBT45RkZoTXQxlTWUf+28/lhpspuAg=
=BMT7
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Oct_2010_10_50_46_+1100_2EwCXjtUkK.N0Q/P--
