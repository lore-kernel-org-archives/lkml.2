Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686Ab2GLKJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:09:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41489 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933653Ab2GLKJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:09:13 -0400
Date: Thu, 12 Jul 2012 11:52:01 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@nvidia.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/5] i2c: tegra: use clk_disable_unprepare in place of
 clk_disable
Message-ID: <20120712095201.GB27520@pengutronix.de>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
 <1341919244-23327-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <1341919244-23327-3-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2012 at 04:50:41PM +0530, Laxman Dewangan wrote:
> Use clk_disable_unprepare() inplace of clk_disable().
> This was missed as part of moving clock enable/disable to
> prepare/unprepare for using the common clock framework.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

OK, as per the previous discussion, I applied it to my next-branch.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/+nkEACgkQD27XaX1/VRu3LQCghs00wJP/qSFlXGHWciiHug9s
wQkAoK2q036DbY41Y1Av0kJ48vWrP+wN
=sVDQ
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
