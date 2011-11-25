Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1KYJNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 04:13:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41972 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1KYJNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 04:13:34 -0500
Date: Fri, 25 Nov 2011 10:13:11 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        keguang.zhang@gmail.com, wuzhangjin@gmail.com, r0bertz@gentoo.org,
        zhao zhang <zhzhl555@gmail.com>
Subject: Re: [rtc-linux] [PATCH V1] MIPS: Add RTC support for loongson1B
Message-ID: <20111125091311.GB2535@pengutronix.de>
References: <1322189527-4761-1-git-send-email-zhzhl555@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <1322189527-4761-1-git-send-email-zhzhl555@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2011 at 10:52:07AM +0800, zhzhl555@gmail.com wrote:
> From: zhao zhang <zhzhl555@gmail.com>
>=20
> V1: replace __raw_writel/__raw_readl with writel/readl.
> thanks for Linus Wallei's advice.
> This patch adds RTC support(TOY counter0) for loongson1B.
>=20
> Signed-off-by: zhao zhang <zhzhl555@gmail.com>
> ---

Grepping says that rtc-au1xxx.c also has registers with the same name.
Has it been checked if those drivers can be merged/reused?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7PXCcACgkQD27XaX1/VRuVRwCbBHtgb9dJhBSGGcHtZgpdFCWM
QJgAoJ4JXCrKCFqcNCcfInANSQ8pyvQc
=8K9q
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
