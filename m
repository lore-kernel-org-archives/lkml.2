Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab2KOF1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 00:27:52 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45967 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2KOF1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 00:27:51 -0500
Date: Thu, 15 Nov 2012 16:27:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the i2c-embedded
 tree
Message-Id: <20121115162739.a114b22ad3a1e0b5a04c6aa9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Nov_2012_16_27_39_+1100_L6mONvX8te8OeSov"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Nov_2012_16_27_39_+1100_L6mONvX8te8OeSov
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/plat-omap/i2c.c between commit 49839dc93970 ("Revert "ARM: OMAP:
convert I2C driver to PM QoS for MPU latency constraints"") from the
i2c-embedded tree and various commits from the arm-soc tree.

I used the version from the arm-soc tree (not sure if that is the correct
choice) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__15_Nov_2012_16_27_39_+1100_L6mONvX8te8OeSov
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQpH1LAAoJEECxmPOUX5FEfM0P/1OxUFHu0e+qH0NwjdkRgRqQ
jW8ScDMP/HaYkRaIrXpMdVVWjJceUC3NTloEkpCCPx7wlfs1bohWfZtHL9p5ueHD
RjSchwBpFN+aE+YeQ7yMgOjuKiJ0JQw46j0w9GOQFQsws3Py3Rp23dpsqlF2hdsA
UAKnf+LEvq2m0dOoTsvJv+BYhJZCCzl1ADDZws89XyLpiDqlGCHtgiVW+ts3nNdp
DhUc7byO6FNLPenfWp65yiKFOjWiq0ZpCnhQ9tDhkdh8VulC7sW5ijFrYPBnc64S
FXNoaR3oW1Ig6JwtNuSYrILfHNo5r437GhmhStXNqbLQvv24mtvS/jNT2kCvpXGY
iPxk655ROvECSranj9Wb4Lx/gdhXlq8ueAPZ5iPC6eb+dgZWcf834JJEE8PYdRlV
GUejph8evvTvkYLhzs1H1QWHs6TyaOkvvZh8L3L7mje87mqRArcxtifIhGy2dKiy
QMcIm6kYt2gSMsmzv1GGOky/qbg6kYikFzz5HhV1MC1P48aKzCBcXhcXCFHw8asK
OekaETvFEK10Idf0Yoc5OSpWfGDw+dXhySV2y/kaXCy8xkczdwwri/o7SUxm9otQ
nGg6A2UQJRPhGgRAmA7g/+I4D4TlXK1L9gTx+6941iUXuBAJfn4dOrWh3SLkmWPg
ytKKAt0ELU90ClAlWw8D
=vAdp
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Nov_2012_16_27_39_+1100_L6mONvX8te8OeSov--
