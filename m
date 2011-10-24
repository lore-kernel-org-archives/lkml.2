Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1JXUpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:45:45 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46783 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1JXUpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:45:44 -0400
Date: Tue, 25 Oct 2011 07:45:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Changhwan Youn <chaos.youn@samsung.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111025074532.cc8cf0d5a9611ecc1246f46d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_07_45_32_+1100_fXpJHyTkiObn/8xU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_07_45_32_+1100_fXpJHyTkiObn/8xU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-exynos4/include/mach/entry-macro.S between commit
292b293ceef2 ("ARM: gic: consolidate PPI handling") from the arm tree and
commit 3a0622811292 ("ARM: EXYNOS4: Add support MCT PPI for EXYNOS4212")
from the arm-soc tree.

Again, I hacked it up (again probably incorrectly - I kept both
additions).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Oct_2011_07_45_32_+1100_fXpJHyTkiObn/8xU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpc5sAAoJEECxmPOUX5FE2M0P/2V0R2rlYTqLjJdegDBU7IOQ
i6BylK/0BDDbd/GwiCkhbR5zKKUvbr6iHSCbJH+LGnwQzTIxermLDtRbS7Le4Qna
ub48+c5hkKd3kvqhhkKaQEy7NH2kWry0EUcI7Cj70kPnCmajLq7ymEH/efxhXpdJ
56ir/ox2Ao9AJq6v3wzZr/uF0k8F7Sisf437VA3065TFjHRsTvh1tXIRC2T9ySoK
7DyJl1BgJFlhD5cTrZsCbbDzrQ5UZFeKr7OfgUpAOJ8unHuo8iqk1euhu6Prnw5w
kVlfry/a0U9hpR1rc1eLLkvQhLo/NT3dKWtGYzScKMiQqZnpuN3lK+1iz4GPADHv
Uo6bRREqY+8vw1qJyHfGBXXX8MFk5BELjr4WUL4MyxDFS3iUg98ZMTwMCGQqHYqz
KL+KXz8g4rSpRL+PJdV5CDQH0HlHIc9R3oLUpLj4g+tvXKLOP+kBz2Qkg51+1rxb
mP+KvIOJEC1glxloPxcBUM11T/vHp5Sdurty6QIluMN2z6xDH9Zc4qqdi8JN33dg
t5GI4Oee+ilDKmIIBCRPwSt0bnBqZ94Z9QJ1Y+bCeF3Dic37O9v+RIXS5BhZMY3c
UlPgpLb1KFjyOQsZ+aqCFjWqzdEHG6V77gnciiKFkSBBk98htsqPJq9KSk3y1nit
ZN3vA4ndNeGTBs9Dskmd
=DINg
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_07_45_32_+1100_fXpJHyTkiObn/8xU--
