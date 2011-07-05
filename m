Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1GEWm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:42:58 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:40535 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab1GEWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:42:57 -0400
Date: Wed, 6 Jul 2011 01:42:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3 5/5] MFD: twl6040: Remove wrapper for threaded irq
 request
Message-ID: <20110705224251.GF8023@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
 <1309895376-17446-6-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V4b9U9vrdWczvw78"
Content-Disposition: inline
In-Reply-To: <1309895376-17446-6-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V4b9U9vrdWczvw78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 05, 2011 at 10:49:36PM +0300, Peter Ujfalusi wrote:
> Remove the twl6040_request_irq/free_irq inline functions,
> and use direct calls instead in the core driver to
> register the threaded irq.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--V4b9U9vrdWczvw78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE5NrAAoJEAv8Txj19kN1c4wH/RlWrTJheu9sZpJFm0Am3jTB
m4Vem9KINiCSwRjDQSQi9gcDVGOHRXc6ssYMT15RhHY4O71e7ZezAKy94gJTHdCc
rKqkfluMeCeVTlpZXWlx1pLcu6sxXb9r+bPCc8MeXq+tCVX8/W41p6fsw/XktsIs
f99v7DpXTN0PoyKEtnVGhNwjV7u7mc51/7oH2r16Rk+22GvFAvcTuvQkqzb9Cnzf
sCLpKzzCVcuLvwaMBX9+atF1Fi5a/Rfgag3iWKr+TgO9y4qEUh+1BK6x1L4qFO8E
S+xaLt3bRc7rMQfXZvUJA3oav4jgIlANImpAZzzGHhaUwOlX7e3CUxt88pSce4s=
=BOkA
-----END PGP SIGNATURE-----

--V4b9U9vrdWczvw78--
