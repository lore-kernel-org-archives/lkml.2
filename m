Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2K1DUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:20:42 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35159 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2K1DUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:20:40 -0500
Date: Wed, 28 Nov 2012 14:20:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20121128142032.2c9eebbceb93a3c2bf2d391f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Nov_2012_14_20_32_+1100_0sp1rbC6KJbb72M2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Nov_2012_14_20_32_+1100_0sp1rbC6KJbb72M2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/mfd/twl-core.c between commit 78a3c5ab1749 ("mfd: twl-core: Fix
chip ID for the twl6030-pwm module") from Linus' tree and commit
afc45898f62c ("mfd: twl-core: Support for proper PWM drivers") from the
mfd tree.

I fixed it up (using the version from the mfd tree) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Nov_2012_14_20_32_+1100_0sp1rbC6KJbb72M2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtYMAAAoJEECxmPOUX5FEfP8P/juodLjPRMEmmIi+kRAFq8Yi
wZFxuix445L43nyIJLlqnQL9d0xF4CO0zR4mccSJyD1AdEqpyGYijYR99RB8jpAR
zj+Hzq3YHG+pvFraJfFaogUHzlx7C0lwTRiJQQfTlmE2GrKRhymRBhK/6VK2tTby
8LGAlNooTU6BRD+Fx0P8M701bBJPCpq3IawT0ipfdn+2FhQvzNcmDXniJOGZcPSa
UOxTQ8bn7ZwY/lAVUi3TL3TlucUX9q4RcvSCS9ubE1L3ME77ygkRMdRSXLrl7YtW
u1CaGdUqlPvg5lp9kzzf4hWCIBK+uv2+Me2gx6oWHn8+CWN7xIo2lrkNAB4t17wA
69Bm4s5rzaV2XQ5CPvf8BxIU879wK3Jdds9iPlqj2mAbQfR+E3tsbHB0AYF2uNMY
TRi1timLecNm4ohgA4GqrGN5bNXShx0Ox9GHxmUgtm5Mfpj2D7oUyOPrWrn7cJ07
RD6sxZ8y+E1iofWcEa6mwPBBZIe0C750orRemILMrfh6pr1MMdVvw7DK6KCznz1+
FuJMl2ld5mQSsGdWU4bWDVjqQRZCZI+wBiT/6a+dgInWGBTqMKIMdk5dBjXNau5Y
wQEgt+dduIiZOS/h/mDB2WKRUIZOAKZzG5nK+28ZFOLQWaSv/Y4RmLidvO9IWo1u
zkU9PD1dWIlh5Vg/OmhF
=6xM8
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Nov_2012_14_20_32_+1100_0sp1rbC6KJbb72M2--
