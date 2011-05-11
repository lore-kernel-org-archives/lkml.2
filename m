Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1EKDN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 23:13:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55676 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1EKDN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 23:13:58 -0400
Date: Wed, 11 May 2011 13:06:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the suspend tree with the mips tree
Message-Id: <20110511130618.581a89a3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_May_2011_13_06_18_+1000_VCnLaaL5rnJV58Oc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_May_2011_13_06_18_+1000_VCnLaaL5rnJV58Oc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the suspend tree got a conflict in
arch/mips/alchemy/common/dbdma.c between commit 02810a022fd9 ("MIPS:
Alchemy: Convert dbdma.c to syscore_ops") from the mips tree and commit
4d0fb1376519 ("PM / MIPS: Use struct syscore_ops instead of sysdevs for
PM (v2)") from the suspend tree.

These seem to be trying to do the same thing.  I used the version from
the mips tree for now.  Please sort this out ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_May_2011_13_06_18_+1000_VCnLaaL5rnJV58Oc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNyf0qAAoJEDMEi1NhKgbsV9QH+wYxbnxaUj4WIcxfuWd38KXt
VxFAByAqGg894nLHksZ088vveOdkQ2Fb2Sfq53M0BtN820fAOSPWrWEJx/bSt+vH
1e2HMy478rqp3iDTP3V3RjsOE/U/Xkc1RShJfGURSNC+xCjg3y0WWB96wgReCi5g
ScuU9dZCAcZ6S/ItOkx7xk9x0akfvYVFIWYeRhJ9F+W+wdJ/4K5l/kOi1vDRlEGv
M5gAdPU2DCoqZOxviCzfJTsbkDV1fgEb2M1JjWt8xFxJ0UiW8bVJgHnIIsuSRhJL
C/J0Y3Og9NnDUiolgqrMtDFSzy95NshFLzfeRQKVJMhlKhLc/PCaPGmCqIlRhi8=
=ZtjR
-----END PGP SIGNATURE-----

--Signature=_Wed__11_May_2011_13_06_18_+1000_VCnLaaL5rnJV58Oc--
