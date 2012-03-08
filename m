Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab2CHGID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:08:03 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44519 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2CHGIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:08:00 -0500
Date: Thu, 8 Mar 2012 17:07:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20120308170751.8197b85ec3ab0a95e99ce945@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_17_07_51_+1100_IxxIVkYaH.q6pNf7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_17_07_51_+1100_IxxIVkYaH.q6pNf7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-vexpress/Kconfig between commit 43a6955fa8c3 ("ARM: 7346/1:
errata: fix PL310 erratum #753970 workaround selection") from Linus' tree
and commit 8deed1786a64 ("ARM: vexpress: Add Device Tree support") from
the arm-soc tree.

The latter took the former into account, so I dropped the former for this
file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_Mar_2012_17_07_51_+1100_IxxIVkYaH.q6pNf7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWEy3AAoJEECxmPOUX5FESHEP/1OeRVoIZV+F6HTCef9NnVei
0Mqoh3BR4H8IMyYaSWgefDAb1WJw4YSzoOaD/+N4uEY9K82d8R5O/vUoCMMDKcZg
GXgnA94XG2N9usHAuydFzGNMPyBmHmcwksyici4eK0FlP3TCwOVo6JJTFC1mYrZS
MtUXxqzmWL+rwLaSxmYi7/1bHXxUuoiW2so+05zrvEchNWliK9gE/b2+UP7syOHa
9Cwpa8tOd85TcjkabJsPF/ELZlnHDcDJtVB7MxphRc5Yvf196IIq35UDD9ahozcf
ovYFsRhpY5XwE3GLBna+TDiYmrzTHl+UmuTkjX5FsA1muIgNgM0Dvki8AG0Hvsth
uRG+/A9S7KDONcG7FWWaJzxh3v029aKYBr90LQFADd7cW+MJlH5m9wQFlgoZbgxD
fR0LhtLXdCciO4SStbavUT8nRd8iyMh4Djl2fmNjdh3j5SVgY9rUEbYLQOy+GmEu
7mezLmoDFhm0Oza+a6yS3zS3FFu8bmANuA19RymTw5L2v18wFyTf6G0dqcyAzk1Q
Y4CBerULGY44HCttg/YYDTIAY2i/GiM0m1JRP/mXTTdyrF19JcUcJZ7j6qy6gOv/
kYjkqosZwb/qZBWELDsaj3P29+FxcZwagsgouZjt5Zgvoi5wSlNsTUx7Rsb8aOOM
E28VYRXJUBim6Qv53Rxa
=HjbL
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_17_07_51_+1100_IxxIVkYaH.q6pNf7--
