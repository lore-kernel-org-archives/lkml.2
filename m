Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab2GCBuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:50:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50323 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2GCBuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:50:00 -0400
Date: Tue, 3 Jul 2012 11:49:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, rnayak@ti.com,
        viresh.kumar@linaro.org, amit.kucheria@linaro.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        mkl@pengutronix.de, sr@denx.de, pawel.moll@arm.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        arnd.bergmann@linaro.org, olof@lixom.net
Subject: Re: linux-next: adding the common clk tree
Message-Id: <20120703114953.24ca1e562374259f934c27cf@canb.auug.org.au>
In-Reply-To: <20120626015551.GW4402@gmail.com>
References: <20120626015551.GW4402@gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jul_2012_11_49_53_+1000_MgDZ0xQV5wq2bjIA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jul_2012_11_49_53_+1000_MgDZ0xQV5wq2bjIA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Mon, 25 Jun 2012 18:55:51 -0700 Mike Turquette <mturquette@ti.com> wrote:
>
> Would you please add the clk-next branch of the common clock tree to
> linux-next?
>=20
> git://git.linaro.org/people/mturquette/linux.git clk-next

This will be added form today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Tue__3_Jul_2012_11_49_53_+1000_MgDZ0xQV5wq2bjIA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8k/BAAoJEECxmPOUX5FEgqgP/3eQeD6NOmBMwl1M6JFiLDoJ
ftc3hJv/JmuCQcLj/N9SjilulOABy3uP00GrPalsBB/jlxoDuYMjvHOigJKE+50e
E4OkyS48OU2wmIx8zjhK/RdyVNq/1/pbEBfcPor1ooNuHVaU8D8UfbiUAAFPS4SE
tTqUByCd+Etu6TRcr1csqwRDbySHFKMtxHbsjiRRQTdoTAkcSrmBHNMMqHIkBmcM
YCY2LgSXXJYj8aG3OncOHZacWBfkzPrkXcFTymnaX3NVZGems7YRLvSD1ZlBfmeq
FcalPWmuuz/4PRSyM7D9FayNjt44YfPruKAHoNMDhI9OWGAz+yqqKZ+8eB7O01+4
1oUgTZ44PySXuTEWb87R9MWIp1ILe19A3B0hPW/kf2cFqXNSBYO99q6XL8MxdDLV
Xq+9i3JGCmP+TKs7RyYhcpqDX7BXfza7jZoyggy76zqxDmT+NO5rX7m3EmrQ9Sqz
I2Iuu3oUmRiAHvXKx6AE2S/GfNqos94IdGyYZdnxvhwufZ9ojPYVD4fAThdo8RLl
tFxMwrtKi0NYtfbs5LKE2v30X5gbbGlDyv3GtD1P31f3h1C8022Ug+mNd1wKxQ0z
J7ZGpVOaAXUutWphOvJjteGMfpkMSHJKT+dL0YL8b8UQFHXJylUGmLAUGTZ+hHaO
UoqNjv6wVHJk6LeZwCrE
=EJ5U
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jul_2012_11_49_53_+1000_MgDZ0xQV5wq2bjIA--
