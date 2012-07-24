Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2GXP3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 11:29:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46718 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2GXP3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 11:29:52 -0400
Date: Tue, 24 Jul 2012 17:29:34 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, khali@linux-fr.org,
        ben-linux@fluff.org, swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH 5/5] i2c: tegra: convert normal suspend/resume to *_noirq
Message-ID: <20120724152934.GA25942@pengutronix.de>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
 <1341919244-23327-6-git-send-email-ldewangan@nvidia.com>
 <500D96E6.4060507@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <500D96E6.4060507@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 23, 2012 at 12:24:38PM -0600, Stephen Warren wrote:
> On 07/10/2012 05:20 AM, Laxman Dewangan wrote:
> > To provide the late suspend and early resume for i2c
> > driver, convert the suspend/resume as
> > 	suspend-> suspend_noirq
> > 	resume -> resume_noirq
> >=20
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>=20
> Why do we need this change?
>=20
> IIRC, I proposed it before solely to solve some suspend/resume ordering
> issues, and Colin Cross NAKd it. These days, deferred probe should make
> this change unnecessary.
>=20
> Unless there's a really good reason for this change, I'd tend to request
> reverting it.

I will drop it from my tree and exclude it from my pull request. Please
resend if it should go in later.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAOv14ACgkQD27XaX1/VRvV3wCfcHSaErshHwP4cAd+V1ysV+8M
i9sAn1pSEwrBjkeb/zrWtlZ0zYvi4gNl
=goUI
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
