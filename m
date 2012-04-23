Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2DWRAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:00:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35785 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2DWRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:00:38 -0400
Date: Mon, 23 Apr 2012 19:00:26 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH 1/2] i2c: mux: add device tree support
Message-ID: <20120423170026.GG27321@pengutronix.de>
References: <1334688545-8465-1-git-send-email-swarren@wwwdotorg.org>
 <20120423111507.GF19192@pengutronix.de>
 <4F957F9F.7000309@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BzCohdixPhurzSK4"
Content-Disposition: inline
In-Reply-To: <4F957F9F.7000309@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BzCohdixPhurzSK4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 23, 2012 at 10:13:19AM -0600, Stephen Warren wrote:
> On 04/23/2012 05:15 AM, Wolfram Sang wrote:
> > On Tue, Apr 17, 2012 at 12:49:04PM -0600, Stephen Warren wrote:
> >> From: Stephen Warren <swarren@nvidia.com>
> >>
> >> * Define core portions of the DT binding for I2C bus muxes.
> >> * Enhance i2c_add_mux_adapter():
> >> ** Add parameters required for DT support. Update all callers.
> >> ** Set the appropriate adap->dev.of_node for the child bus.
> >> ** Call of_i2c_register_devices() for the child bus.
> >>
> >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> >=20
> > David Daney (CCed) posted another variant [1]. Just looking at the
> > patches (and not really using them), I tend to like the approach using
> > <reg> better. But I am open for discussion, so I'd appreciate your
> > feedback.
> >=20
> > Regards,
> >=20
> >    Wolfram
> >=20
> > [1] http://lkml.org/lkml/2012/4/12/423
>=20
> Ah, that does look like a reasonable binding.

May I interpret this as an ack? :)

> to be listed last in pinctrl-names (if it's listed at all). I'll update
> my patches based on that David's patch.

Thanks.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--BzCohdixPhurzSK4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+ViqoACgkQD27XaX1/VRsbzACeJWZ2Q3iq8pZZV+J/Bm4vX+6V
y7gAnRBJOanvSIpsh8HIXFtfSFdqkW+a
=TUJf
-----END PGP SIGNATURE-----

--BzCohdixPhurzSK4--
