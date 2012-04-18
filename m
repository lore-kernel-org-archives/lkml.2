Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2DRUVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:21:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44219 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2DRUU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:20:58 -0400
Date: Wed, 18 Apr 2012 22:20:37 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alok Chauhan <alokc@nvidia.com>, khali@linux-fr.org, ben-linux@fluff.org,
        swarren@nvidia.com, olof@lixom.net, bones@secretlab.ca,
        omaplinuxkernel@gmail.com, ccross@android.com, ldewangan@nvidia.com,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        dgreid@chromium.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: tegra: Add delay before reset the controller
Message-ID: <20120418202037.GA32444@pengutronix.de>
References: <1333345982-16595-1-git-send-email-alokc@nvidia.com>
 <20120418142758.GE19220@pengutronix.de>
 <4F8F1DBD.8000009@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <4F8F1DBD.8000009@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Applied with Stephen's ACK and slightly reworded comment and commit msg.
> >=20
> > Wondering a bit that you want it for 3.5, not for 3.4. Looks like a
> > bugfix to me.
>=20
> Yes, applying this to 3.4 would make sense. When I said "for 3.5"
> earlier, I meant I'd like it to at least get into 3.5 not later.

Done, thanks for clarifying.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+PIhUACgkQD27XaX1/VRvUFQCfUaLzzZvLpqp2vD4w4NktXG3/
KH4AoMxEDPPUrybbZIFpKgxfmpIph/9n
=kkAs
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
