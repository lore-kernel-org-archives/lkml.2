Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2IDDJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 23:09:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34972 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2IDDJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 23:09:33 -0400
Date: Tue, 4 Sep 2012 13:09:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: linux-next: manual merge of the v4l-dvb tree with the arm tree
Message-Id: <20120904130921.58a3b51ae53a1c971f0bdf32@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Sep_2012_13_09_21_+1000_wkW0PF13Y/9J=WgG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Sep_2012_13_09_21_+1000_wkW0PF13Y/9J=WgG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
arch/arm/mach-imx/mach-imx27_visstrim_m10.c between commit 895576427dca
("ARM: iMX: visstrim_m10: use arm_memblock_steal") from the arm tree and
commit b6c14dc29757 ("[media] Visstrim M10: Add support for Coda") from
the v4l-dvb tree.

I just used the version from the v4l-dvb tree and can carry that fix as
necessary (no action is required).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Sep_2012_13_09_21_+1000_wkW0PF13Y/9J=WgG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRXDhAAoJEECxmPOUX5FEHHEQAJyAFYYrsDGhmB8CN/NMFmdD
qIU55cNjmg/z3C6ATcmSkOXvFQlp08/biUEH1Tb0OzQvaQmbufpDu2nYplbNSt4i
9SoUPgWnyBbmlj+U/OCIogAOKIIt2O6NJMNCLv/DcCkFrfeWHzmyeF9qyEreQeOt
mDxSvfH5Qv5g/w9P/jDGqnBJNCMMNFsT6HyuqHhXNb0/um7KIKWh37BoqWrLD+XO
cW7Cv2KufUuc5LK8zxI+A3H8979PPHrJmxweNI7HGyzVh0NGarjMjIzpCC6sydnx
54qUazGwnUAZj0Jo5/+UH6Iy63vbFD7DE/aH11BZv1YKgVzOzRgrkHJ5XihkkBHL
Nm4XLYaysySoO0EI92wp0RWhKgAtVnkIdzDBj0/AkRm/zLpe3ZPGDhR2SOM08D/0
H7upgF1imBG8XRlxzjX4RapHC9JYEKcrV4vJONhwMqzK+ghf1zlv8d4qLwzWaPiM
zKm300VmbWe2frqQkSxVd01nXBquvxiNvayMDdq9bfJDQOL51am5hnJd1YnkkoEP
fYHA8IfeurKzqNPnIQH5TO+VDK0n+PjcxXpzKr/fb2zdtfiRiUi6t4d3TnCWfENa
qtxlwbLRqcRfUVYce33WOohSL0qkvCf1OpYujVj3bufua094syXPWVDuvEX1yxvv
dC1O9U2bR2I+8rLvR6ad
=dmLe
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Sep_2012_13_09_21_+1000_wkW0PF13Y/9J=WgG--
