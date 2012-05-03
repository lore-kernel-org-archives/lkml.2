Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab2ECISz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:18:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48867 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2ECISx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:18:53 -0400
Date: Thu, 3 May 2012 10:18:30 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 1/2] i2c: tegra: fix 10bit address configuration
Message-ID: <20120503081830.GA9574@pengutronix.de>
References: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>
 <1335251976-31925-2-git-send-email-ldewangan@nvidia.com>
 <20120424105815.1d9e7d95@endymion.delvare>
 <4FA221FA.2030305@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <4FA221FA.2030305@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 03, 2012 at 11:43:14AM +0530, Laxman Dewangan wrote:
> On Tuesday 24 April 2012 02:28 PM, Jean Delvare wrote:
> >On Tue, 24 Apr 2012 12:49:35 +0530, Laxman Dewangan wrote:
> >>The slave address of device to be configured in packet
> >>header as follows:
> >>     7 bit address: PacketHeader3[7:1]
> >>     10 bit address: PacketHeader3[9:0]
> >>
> >>Fixing the code to make packet header3 properly.
> >>
> >>Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> >>---
> >>
> >Looks good.
> >
> >Acked-by: Jean Delvare<khali@linux-fr.org>
> >
> Can it be apply? This is independent of other change in this series
> which is under discussion/review.

Applied to next. Or do you need it in 3.4?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+iP1YACgkQD27XaX1/VRvN8QCbBzF0UAd/UwxcljvYhWDgkGo/
o7IAoK4I9E+AgLV9gM3PF51tPR2DWx8g
=7WHf
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
