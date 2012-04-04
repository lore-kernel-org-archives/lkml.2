Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2DDGuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 02:50:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49551 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2DDGuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 02:50:21 -0400
Date: Wed, 4 Apr 2012 08:50:15 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: gpio-regulator: Basic devm_kzalloc()
 conversion
Message-ID: <20120404065015.GA24930@pengutronix.de>
References: <1333491789-15883-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1333491789-15883-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <1333491789-15883-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 03, 2012 at 11:23:09PM +0100, Mark Brown wrote:
> There's some other allocations but they're not so trivial as they use
> kmemdup() and kstrdup().

What do we gain then? I wonder if it is worth fixing one occasion if we can=
't
fix the others (yet).

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk977ycACgkQD27XaX1/VRvnUACgwlrbY3XBdf0nopzZzupIE4fp
WoAAn0w1er2DG/xfm5uSdGYB1vBLtJbK
=k/4Q
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
