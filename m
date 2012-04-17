Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2DQDed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:34:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60101 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2DQDec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:34:32 -0400
Date: Tue, 17 Apr 2012 13:34:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Benoit Cousson <b-cousson@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the mfd tree
Message-Id: <20120417133418.2280ccb3897436e6c8e82398@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Apr_2012_13_34_18_+1000_hlAC=RMhfGPZ.IsS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Apr_2012_13_34_18_+1000_hlAC=RMhfGPZ.IsS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/board-generic.c between commit aa1d7775696c ("mfd:
Convert twl6040 to i2c driver, and separate it from twl core") from the
mfd tree and commit 93651b85bbd1 ("ARM: OMAP2+: board-generic: Remove i2c
static init") from the arm-soc tree.

The latter seems to supercede the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Apr_2012_13_34_18_+1000_hlAC=RMhfGPZ.IsS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPjOS6AAoJEECxmPOUX5FEluIP/0NcHeFr1FnOj/kti0tAy7lm
/8qwMTPk2+7X2Yq6q9dJyf/QqqcgyPUxCceE9H2PBOhOHWTdMs7j7GH+I+9yx6F8
cmX9CRQUreY68arqYr/8DSQUX8T0t4RIt59FDRhMsTt2ObUcaGDhMU2iDW4TpKcd
AgaNmKSImw0y+HvYadsAnF83IrrbASykuRp07Md7J4QPkaLWGd8Lq9SmT842mFO+
/pbos+3vIygw56/qdxCPnmWwO7qD0PapbSiuZCEChCNxmpfrc1ZAWT9w7qhUNeaR
LBb7uzwyhGdg7zZMHkGy/b+uSWZFAm91vCHY4aQsc+hY3Y0s81Y7PunJDISAC/GV
3bdex5H2Ekx8zESkSHT9n5lUmA68JvtV6sOIOz1IODtfNmPJukv1OcRGH4wViS1V
RtO28pIhPNKkZoJmYES0xpo+mLg1JZB9jSvwHmRCYdFok9VHoZzLRtV9R9WUZn4D
Q9mFfLN7gisihIh3b5r9cFXupP2xi2TPNJWF9IQoyx4QV/+frIX8UECkk4FaWHbk
TLmPCuGqTr84KiNNwE6ysSGsSdJDilLdxegTpuMsZTWvGm/cFauila3YnLE12U3p
CxwSMkEvklfxN4atHsgM3JQzV+vq+UecTRcoas1BZIyPyc4VGWX+31Ng0BTdu7nP
yA+jMKgBP0lqg5VP9xef
=OvcQ
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Apr_2012_13_34_18_+1000_hlAC=RMhfGPZ.IsS--
