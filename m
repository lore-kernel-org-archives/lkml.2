Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1DUMJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:09:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41266 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1DUMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:09:00 -0400
Date: Thu, 21 Apr 2011 14:08:55 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: John Williams <john.williams@petalogix.com>
Cc: Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
Message-ID: <20110421120855.GC2135@pengutronix.de>
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu>
 <20110418160658.GD23814@pengutronix.de>
 <BANLkTimFnfgiQ5aMq_KwqHP8p92pjOJJwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
In-Reply-To: <BANLkTimFnfgiQ5aMq_KwqHP8p92pjOJJwg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 19, 2011 at 11:58:25AM +1000, John Williams wrote:

> As we discussed at ELC, putting a real vendor/device in there is also
> broken because all instances in the system wil bind to the generic
> uio, which is not necessarily what is desired.

IIRC I pointed you to mpc5200b-psc devices which also have multiple functio=
ns
and have seperate bindings for these functions. It fits the "hardware
description" character of a dt, because it says this PSC is a UART or an
SPI or whatever.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2wHlcACgkQD27XaX1/VRsJ6gCfaecnGhrefmK8VMVcQAuhbJ8p
jysAn3dUUAEEovHf07XyPGIV1sPVvw3v
=BvYf
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
