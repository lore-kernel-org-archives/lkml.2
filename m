Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1DSWZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 18:25:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51576 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1DSWZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 18:25:30 -0400
Date: Wed, 20 Apr 2011 08:25:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the kbuild tree
Message-Id: <20110420082514.a9ec4d68.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Apr_2011_08_25_14_+1000_Bty42tOrsUGVi8wz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Apr_2011_08_25_14_+1000_Bty42tOrsUGVi8wz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

After merging the kbuild tree, today's linux-next build (s390 allnoconfig)
failed like this:

/opt/crosstool/gcc-4.3.2-nolibc/bin/s390x-linux-ar: illegal option -- D

Caused by commit 09ff9fecc039 ("kbuild: Use the deterministic mode of ar").

$ /opt/crosstool/gcc-4.3.2-nolibc/bin/s390x-linux-ar --version
GNU ar (GNU Binutils) 2.19

I presume that this version of ar is now too old to build the kernel?
Documentation/Changes only mentions Binutils verion 2.12.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Apr_2011_08_25_14_+1000_Bty42tOrsUGVi8wz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNrgvKAAoJEDMEi1NhKgbsmX8H/RIDsoJBV2FXM/xkLZGWOgbe
/p0Fxunh3nC9ytJ/nohImQTll73NbhG1MVg+nS1BKGuI5tGXkbgn1ZwzhNM0SoPM
Eu53Wl6GflYZicCMRE/zHTjxBXyf1U9mORXaE/M0/DXKPI6k+sFlwVo8Pb5TWk/X
EyvcSF+snV+E4UkBbYP+0BcKZOxTh2zZR00fRH29IBOo7VDkft0wLjWFYAEb4d2i
jpXPK/TmtMlIeHGVyaH7iGX8Ji/7u2jQ2IhI5FWgX7oZKbUEz3+nOoipnfBbLFXV
IJEGu9dJPVExCIeFZ24JqVQTHMbwvmwp0yxfdkwKlyQnvxTw4nKzG/6mVmyvu0Q=
=8Yvr
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Apr_2011_08_25_14_+1000_Bty42tOrsUGVi8wz--
