Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1EKDGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 23:06:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53433 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab1EKDGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 23:06:53 -0400
Date: Wed, 11 May 2011 13:06:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the suspend tree with the mips tree
Message-Id: <20110511130651.34e7e90e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_May_2011_13_06_51_+1000_tcJhofUSVyk2FTXE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_May_2011_13_06_51_+1000_tcJhofUSVyk2FTXE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the suspend tree got a conflict in
arch/mips/alchemy/common/irq.c between commit 41bbb08bca72 ("MIPS:
Alchemy: Convert irq.c to syscore_ops") from the mips tree and commit
4d0fb1376519 ("PM / MIPS: Use struct syscore_ops instead of sysdevs for
PM (v2)") from the suspend tree.

Again, I just used the version from the mips tree.  I may have broken it,
of course.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_May_2011_13_06_51_+1000_tcJhofUSVyk2FTXE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNyf1LAAoJEDMEi1NhKgbs8mAIAIF4wkH6bgh3F3uSDBXsLmFx
msupj9rB0tK/b1kQ9dN8XFvDYVLhbqcIlM5/xvaBk0dPxhKsE40M0atFLHUaxJJw
VDiWs4vDkmPsfNhMB/xWZtzhVK+XSFd59jfIIQdCYtenVO8g+SMNf4NvdRL3gSg6
0cDWwL1lePiPsk+U+aXJ6FvmVhRFcPe+b4sFn8s6nU1YVQ7io3IQi7XyoxFcupwZ
VFIbm/eAsSf8NxMNPLaqy6laAUq6A8+A5Qcbig9isYhpDN+h1TSkpCb460wH31AV
m/fsx3n4npniA6UY2AGsxThZlbwxb7oV7kJ3IP1StBSY7b6MfeWgnW2AzTBvQJc=
=VjSa
-----END PGP SIGNATURE-----

--Signature=_Wed__11_May_2011_13_06_51_+1000_tcJhofUSVyk2FTXE--
