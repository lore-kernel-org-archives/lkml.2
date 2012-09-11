Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab2IKWOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:14:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57269 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab2IKWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:13:56 -0400
Date: Wed, 12 Sep 2012 00:13:44 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "Voss, Nikolaus" <N.Voss@weinmann.de>,
        "'ludovic.desroches'" <ludovic.desroches@atmel.com>,
        "'Yanes Martinez Adrian'" <adrian.yanes@aalto.fi>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'balbi@ti.com'" <balbi@ti.com>,
        "'h.feurstein@gmail.com'" <h.feurstein@gmail.com>,
        "'rmallon@gmail.com'" <rmallon@gmail.com>,
        "'carsten.behling@garz-fricke.com'" <carsten.behling@garz-fricke.com>
Subject: Re: [PATCH v11 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20120911221344.GF27031@pengutronix.de>
References: <cover.1345618760.git.n.voss@weinmann.de>
 <4f3dcfbf1e8eab3e251ab3558e9e1e9123643928.1345618760.git.n.voss@weinmann.de>
 <503B4919.6080306@atmel.com>
 <BC0F374A1C27184AB96177CDFEC2F54225ECC330@EXMDB06.org.aalto.fi>
 <503B623C.4030304@atmel.com>
 <BC0F374A1C27184AB96177CDFEC2F54225ECD36E@EXMDB06.org.aalto.fi>
 <EF2E73589CA71846A15D0B2CDF79505D090EC3D6F6@wm021.weinmann.com>
 <503B7D6E.7090906@atmel.com>
 <EF2E73589CA71846A15D0B2CDF79505D090EC3D747@wm021.weinmann.com>
 <504EF5BF.2090404@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="juZjCTNxrMaZdGZC"
Content-Disposition: inline
In-Reply-To: <504EF5BF.2090404@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--juZjCTNxrMaZdGZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2012 at 10:26:39AM +0200, Nicolas Ferre wrote:
> On 08/27/2012 04:29 PM, Voss, Nikolaus :
> > ludovic.desroches wrote on Monday, August 27, 2012 4:00 PM :
> >> For the moment, I don't have the necessary knowledge about the TWI
> >> controller to take a decision. I would say it can be done in an other
> >> patch in order to have your driver included in the mainline quickly
> >> since it doesn't introduce a breakage.
> >=20
> > That would be the most pragmatic approach.
> > Wolfram, is the anything left to do from my side?
>=20
> Wolfram, ping?
>=20
> Can we imagine to have this support and the device tree patches from
> Ludovic in 3.7-final?

Yes. I'd need your ack since it touches mach-specific stuff. Reviewed-by
would be even better since you know the HW better than me :)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--juZjCTNxrMaZdGZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBPt5gACgkQD27XaX1/VRuwcACgj3btCafqBDiUtLacOdNljF3Y
KaAAmwYMqWuNbweu3cLgu74CXze6xTJC
=J9Qi
-----END PGP SIGNATURE-----

--juZjCTNxrMaZdGZC--
