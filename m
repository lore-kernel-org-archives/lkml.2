Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1LHIqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:46:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39731 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1LHIqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:46:34 -0500
Date: Thu, 8 Dec 2011 09:46:29 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] spi: use gpio_request_one() instead of spi_gpio_alloc()
 helper function
Message-ID: <20111208084629.GA23908@pengutronix.de>
References: <1323071447.20963.3.camel@phoenix>
 <20111207212109.GA1314@pengutronix.de>
 <CAF+7xWmnYsjM-mcx=2pvKavE6RAnLFv2Ey0N1+0_n46G3Km27w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <CAF+7xWmnYsjM-mcx=2pvKavE6RAnLFv2Ey0N1+0_n46G3Km27w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 08, 2011 at 09:36:23AM +0800, Axel Lin wrote:
> 2011/12/8 Wolfram Sang <w.sang@pengutronix.de>:
> > On Mon, Dec 05, 2011 at 03:50:47PM +0800, Axel Lin wrote:
> >> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >
> > This will make the driver depend on GPIOLIB, currently it depends only
> > on GENERIC_GPIO. That needs to be addressed and made sure it won't cause
> > a regression for the in-kernel users.
> >
> Ah. You are right.
> GPIOLIB can be optional or not available at all in some
> architecture/configurations.
> Thanks for your review.

Note that there are plans to make GPIOLIB mandatory, but we are not there y=
et.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7geWUACgkQD27XaX1/VRtVUACfd8wA/1RPl/ris/ba6dbNRAUK
rcsAn1NtofA8Kuc+P2ny3oenAoJ2HYC3
=z4Qj
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
