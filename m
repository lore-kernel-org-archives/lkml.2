Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2F0Ndi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:33:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54155 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2F0Ndh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:33:37 -0400
Date: Wed, 27 Jun 2012 15:33:32 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: rtc-linux@googlegroups.com,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: ds1307: Register offset moved to chip description
Message-ID: <20120627133332.GA21572@pengutronix.de>
References: <1340749442.3241.4046.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1340749442.3241.4046.camel@pc786-ubu.gnet.global.vpn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 27, 2012 at 10:24:02AM +1200, Austin Boyle wrote:
> rtc: ds1307: Register offset moved to chip description
>=20
> From: Austin Boyle <Austin.Boyle@aviatnet.com>
>=20
> Register offset is added to chip description instead of being hard-coded
> into probe function.
>=20
> Based on v3.5-rc4
>=20
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>

I would ack this patch immediately if it added another type using this
feature. But only changing already working code doesn't seem necessary
to me.

Regards,

    Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/rC6wACgkQD27XaX1/VRu+/QCffUzGbOOaLyz99sDniEIzyhJh
2jkAnAuYEgB6KiguzZJuws6Qj0bXHxdj
=OR06
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
