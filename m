Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab2HTR4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:56:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48904 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab2HTRz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:55:58 -0400
Date: Mon, 20 Aug 2012 19:55:27 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Kevin Wells <kevin.wells@nxp.com>
Cc: Roland Stigge <stigge@antcom.de>,
        "vitalywool@gmail.com" <vitalywool@gmail.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Bakki <srinivas.bakki@nxp.com>,
        "aletes.xgr@gmail.com" <aletes.xgr@gmail.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Subject: Re: [PATCH RESEND 1/2] i2c: pnx: Fix bit definitions
Message-ID: <20120820175527.GA9169@pengutronix.de>
References: <1344411752-23469-1-git-send-email-stigge@antcom.de>
 <20120818095108.GB24812@pengutronix.de>
 <5030A81E.5090508@antcom.de>
 <083DF309106F364B939360100EC290F823A0354A3D@eu1rdcrdc1wx030.exi.nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <083DF309106F364B939360100EC290F823A0354A3D@eu1rdcrdc1wx030.exi.nxp.com>
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

On Mon, Aug 20, 2012 at 06:26:54PM +0200, Kevin Wells wrote:
> >>> This patch for i2c-pnx affects PNX4008 and LPC32xx (and LPC31xx,
> >>> not yet in mainline). Can you please test and double-check the
> >>> manuals of PNX4008 and LPC31xx? I only found this via the manual
> >>> of LPC32xx but assume it's the same for the others, also.
> >>>=20
> >>> Thanks in advance!
> >>=20
> >> Kevin, since the other manuals seem to be not easily available, can
> >> you please check?
> >
> >Yes, would be great if someone at NXP could confirm that PNX actually
> >uses the same IP core for the I2C controller as LPCs do (which is
> >currently assumed by Linux anyway).
>=20
> I've never had my hands on a PNX4008 chip at NXP, but I do believe they
> are the same IP. That specific I2C IP was used in a number of NXP/Phillips
> chips besides the PNX4008/LPC32xx. I don't think there are any PNX4008's =
in
> the wild, and even working in NXP, I can't find any non-marketing referen=
ce
> material for that part (including the user manual).

Thanks for the heads up. I'll apply both patches, then.

Roland, this looks like 3.6-material?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAyeg8ACgkQD27XaX1/VRtlTwCgrHgO0kka5bADERX7BKsT6bTS
CYkAn29IJnHA1MYhjr9cL/RK75yussaO
=UufT
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
