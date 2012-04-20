Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab2DTH2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:28:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35948 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab2DTH2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:28:34 -0400
Date: Fri, 20 Apr 2012 09:28:11 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>, vitalywool@gmail.com,
        khali@linux-fr.org, ben-linux@fluff.org, rob.herring@calxeda.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v4] i2c: Add device tree support to i2c-pnx.c
Message-ID: <20120420072811.GA9769@pengutronix.de>
References: <1334850612-24151-1-git-send-email-stigge@antcom.de>
 <20120419160715.GD24987@pengutronix.de>
 <4F903E0C.6010604@antcom.de>
 <20120419203915.GB28005@pengutronix.de>
 <4F90812F.5090106@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <4F90812F.5090106@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Another solution would be to not use timeout with the dt enabled
> i2c-pnx for now (using the hard coded default timeout as the current
> i2c-pnx.c does) and possibly introduce the (anyway optional) "timeout"
> later.

Yeah, let's do it like this.

> Interesting! When the documentation is outdated - how does the parser
> actually decide between hex (e.g. regs/addresses) and dec (e.g.
> clock-frequency) in the absence of "0x"?

Are there regs without 0x?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+REAsACgkQD27XaX1/VRs6SQCgqaJv1y3tqMeb5Uan3+l48hGi
qagAoKKZ5y/Znj/OBB4iF13tB6hnHX/s
=aoSu
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
