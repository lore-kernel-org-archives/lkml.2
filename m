Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2LDEmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 23:42:20 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49685 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2LDEmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 23:42:19 -0500
Date: Tue, 4 Dec 2012 15:42:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Joerg Roedel <joro@8bytes.org>, Paul Walmsley <paul@pwsan.com>,
        Mike Turquette <mturquette@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the iommu tree
Message-Id: <20121204154203.f0e7e87d1ae99e5c528434f8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Dec_2012_15_42_03_+1100_e_41q9GPMZD=WyT7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Dec_2012_15_42_03_+1100_e_41q9GPMZD=WyT7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/clock44xx_data.c between commit 298ea44f211d ("ARM:
OMAP4: hwmod data: ipu and dsp to use parent clocks instead of leaf
clocks") from the iommu tree and commit 13a5b6228679 ("ARM: OMAP44xx:
clock: drop obsolete clock data") from the arm-soc tree.

I just deleted the file as the latter did and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Dec_2012_15_42_03_+1100_e_41q9GPMZD=WyT7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQvX8bAAoJEECxmPOUX5FEni8QAJZtImjQt3te8HGXhrztgrZI
XyFORIL2pOvMowTq4qQoOIb9lDeac/08u6VFLGoueXkEE2j4P1MW2793Idk7UR04
HzgJTGJDdSOkV2TDsXVC5tdYcIWsD5M4tIiG6Jqra12w1yefK0nhvruiP4r2nchU
5yi23CQYRkDBzO3OqvbBfku6NOOBn8gOfiUMq8Tayx5ULHtkx0tWFyyxAyeSsg/f
px7UzkgC1hQn49/8i944vPgvZgy5LkFQQiQHO+7KSbD7iXJamJ2If3fqWCTQwS67
Rw2FrCfPkTeeMN10HEqy2QYSa216+25Qw0ftWxXqdXL+I17YbNGPzV9vLc6VqeOf
hTELMWOJTLz6gFdC6niXCiMdEaWZjw75HocByby8Pjr8k27YKwU4gUhRl/LEiivv
pczBdp4Ul+s9NCtbd2cwA67slBWCV4lW+4lkatcoWlx0q6ddHhj/LuqfuTkzxksM
SeQ/pA0IyDBZ/6HaibumyvMgDFkmEDhA501WFWK8GqNZCvsc3wYIuVRQdLg0v3g7
XKfDUJOi1s40SDHgy5MBK3d5fwuEU+zS6QMdeBL/3tWFNSB0uNDltYycb4wxN4PX
uQLwGpAYK0U8FXo/w/Rw8x/ZHjXQk/jrTWlF8NaUuACbkF7wyK9wU/IiTYWMMIDG
9cgOQhV4dJXySZ45Vp59
=tbHy
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Dec_2012_15_42_03_+1100_e_41q9GPMZD=WyT7--
