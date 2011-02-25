Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab1BYUHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:07:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41746 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868Ab1BYUHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:07:30 -0500
Date: Fri, 25 Feb 2011 21:07:22 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Philip Rakity <prakity@marvell.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jae hoon Chung <jh80.chung@gmail.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] sdhci: always use max timeout for xfers
Message-ID: <20110225200722.GA2192@pengutronix.de>
References: <D8739074-546D-4531-A8E9-23E9F7A33EB5@marvell.com>
 <20110225180248.GA15491@pengutronix.de>
 <9C437661-BFCC-4F73-989E-06589E0D37CA@marvell.com>
 <20110225182206.GC15491@pengutronix.de>
 <62F39533-530F-4DF4-BBC6-AF8E9AB9E751@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <62F39533-530F-4DF4-BBC6-AF8E9AB9E751@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 25, 2011 at 10:49:25AM -0800, Philip Rakity wrote:
> v2
>=20
> use define for max timeout.  remove subroutine call and just
> set the register directly

The generic description goes above the "---" line, the incremental
history of the patch usually below.

>=20
> v1
>=20
> The card/host controller may sometimes return a value that is
> too low and cause the h/w to timeout a transfer that would have
> worked.  Using the maximum value avoids this.
>=20
> Signed-off-by: Philip Rakity <prakity@marvell.com>

What is there seems ok, but it is not enough yet. The quirks can also go
=66rom the users.

After that, it gets even more complicated; after this patch
'host->timeout_clk' becomes obsolete which should probably cleaned up in
a later patch together with host->ops->get_timeout_clk. Hmmmm, that
needs careful auditing.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1oC/oACgkQD27XaX1/VRvRtQCfaLEwCQ5I9tn3GkBGqwhzX/R5
w24AnihN2wYpvuXmuEFYTH+D0loPe2GV
=A6Ps
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
