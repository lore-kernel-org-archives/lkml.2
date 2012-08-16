Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab2HPIWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:22:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53376 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab2HPIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:22:28 -0400
Date: Thu, 16 Aug 2012 10:22:10 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, olof@lixom.net, khali@linux-fr.org,
        ben-linux@fluff.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 0/4] i2c: tegra: required clock support for controller
Message-ID: <20120816082210.GA26183@pengutronix.de>
References: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
 <5022A89F.8070604@wwwdotorg.org>
 <502BD51C.4010204@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <502BD51C.4010204@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 15, 2012 at 10:58:04AM -0600, Stephen Warren wrote:
> On 08/08/2012 11:57 AM, Stephen Warren wrote:
> > On 08/08/2012 01:51 AM, Laxman Dewangan wrote:
> >> The Tegra's i2c controller required two clock sources for proper
> >> operation named as div-clk and fast-clk.
> >>
> >> Adding support to make sure that driver will get these clocks and=20
> >> enable before any transfer and disable after transfer completed.
> >=20
> > This works fine on Cardhu and Ventana for me. I'll apply it once I get
> > an ack from Wolfram to take the I2C driver patch through the Tegra tree.
>=20
> I haven't heard from Wolfram, but since the I2C driver patch is pretty
> trivial, and pretty much has to go through the Tegra tree due to
> dependencies on other Tegra patches, I went ahead and applied this
> series to Tegra's for-3.7/clock branch.

For the I2C subsystem:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAsrbIACgkQD27XaX1/VRsaBgCgwGBW6bgVA5yX517dbWxnJHCO
a+MAn2SpJnx2oc6WKUCiizNC7tJCSzGC
=mDc/
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
