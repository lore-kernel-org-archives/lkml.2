Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1GVGmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 02:42:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49865 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1GVGmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 02:42:14 -0400
Date: Fri, 22 Jul 2011 16:42:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: build failure after merge of the final tree (arm-soc
 tree related)
Message-Id: <20110722164204.15f3bfee0c3ab04adb80e611@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Jul_2011_16_42_04_+1000_EQGd/.sNMJ+OYPeI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Jul_2011_16_42_04_+1000_EQGd/.sNMJ+OYPeI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (all arm builds)
failed like this:

arch/arm/mm/Kconfig:835: syntax error
arch/arm/mm/Kconfig:834: invalid option
arch/arm/mm/Kconfig:838: unknown option "ARCH_PRIMA2"

Caused by commit 69ca71d177d1 ("Merge branch 'next/soc' of git
+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc into
for-next-3") from the arm-soc tree.

This commit mismerged the config CACHE_L2X0 entry (forgot the \ on the end
of one of the lines).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_Jul_2011_16_42_04_+1000_EQGd/.sNMJ+OYPeI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOKRu8AAoJEDMEi1NhKgbs0jIH+wVw1iMfVp6u9IUt23pEkU3I
yni1AjZ5Hp+eWUgvqE8cHditWA48jk77R6Ak7bEWsOvnbHQbbxE1/87MtUtiYtjc
PChNk+X43Wcy/cvy5/SIL0mxvDw6nw6UDHbWDbdxXvStHSG2kGro82IqKtCQI9e8
as74xCqCH1b01qZu1oFqVT0gk5mLo9frRv15hywitCrKTE/DAmJygWHRDFiTdYgt
FSOHR+7akEEPMJDfjtHIQwNvR8OkmzPDYHaAxxeeOXOgSWyMXPJ7NmXbU6xiJU37
Rym0L6MuRqvsseuZkdJGMYfTnQXmqSe8CUhBoN26YHVhRRMHDT/RlPeiqwwbmy0=
=mim/
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Jul_2011_16_42_04_+1000_EQGd/.sNMJ+OYPeI--
