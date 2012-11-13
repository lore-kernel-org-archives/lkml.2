Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab2KMEGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 23:06:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54744 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2KMEGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 23:06:42 -0500
Date: Tue, 13 Nov 2012 15:06:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20121113150631.e316da9049b2ce6685aa729e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Nov_2012_15_06_31_+1100_Fj96TS.obOii5TA+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Nov_2012_15_06_31_+1100_Fj96TS.obOii5TA+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/configs/afeb9260_defconfig between commit 77614e025061 ("arch:
Change defconfigs to point to g_mass_storage") from the usb tree and
commit 2484575268e2 ("arm: at91: drop machine defconfig") from the
arm-soc tree.

The latter deletes the file, so I did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Nov_2012_15_06_31_+1100_Fj96TS.obOii5TA+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQocdHAAoJEECxmPOUX5FEzIoP/isGd//fPtk0S5zb0YTBKlDe
85+Yzlis50KeitSrkADGhDyZ47lscvjUtPEvu4EX1aT5Ze989YWoNPrrAgOrOExd
0IQztC8lEkE+Hiyr5PsrzZCZPdPz9zvGM14LDE97Q3gA1Dmidx8zKwAfqtdQL0g/
ohLt9k0hBJQlNTBgwf1ft/nKz7uF4YkOeSQYCVfVmyGD1WK6vguKVn8ZZpqaovDS
D4nslM0vts/pJEUqrJNVCcj/3hZ4KtCWd9rRSUfafhVe/dOBy6gyOZwmi1C+jKYm
Vz/JOZ817c0xnfVZhu0TWsFITEcopuH/iP7B4IadYp5qAAIaR3KZRfUjzZtTsGLr
Co937va0vX2zQWJznq3Uz3JLOhk4XNFYD6fcU14YsPRN6nJv4rZdczSdX3NPI0cs
1rwRAOG6LrbDQ2imj04MDVBF+XfmI4pbk4543wqEKwC/hyxXg88wdDOANUtoWajY
bvosrZYe4I4VsojchEjWaLXEFZP4+33Y98uB6JtQF1E48kHWj22uxEZgpgkSaspP
AojYJoyfDsvjap71dO5ISncZzhyzkKLQRsu5kv2GfAmH6n8kl6H3t05mfnfu1Cqm
guQFuOtN1fGYIOS91BWsrddIhepEyEDfnJCtOWlLg5uaH3EaTR0bDBHDvOqXYzxl
NQgGsJWiBy0TiOYNMF09
=YnTS
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Nov_2012_15_06_31_+1100_Fj96TS.obOii5TA+--
