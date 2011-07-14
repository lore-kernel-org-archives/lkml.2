Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab1GNS1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 14:27:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44670 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab1GNS1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 14:27:37 -0400
Date: Thu, 14 Jul 2011 20:27:34 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>
Subject: Re: [RFC 0/6] watchdog drivers converted to the new framework
Message-ID: <20110714182734.GA31082@pengutronix.de>
References: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
 <ADE657CA350FB648AAC2C43247A983F001F383E05B65@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F383E05B65@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I would also like to convert this driver into a proper platform_driver us=
ing
> ioremap'ed addresses instead of the static mappings.  Converting the driv=
er
> to the new watchdog framework would make this a bit cleaner.

Try managed devices (devm_* and friends) for an extra cleanup bonus.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4fNRUACgkQD27XaX1/VRv+OQCgyVGGLGwpS7SU/OvHYyr8erBD
33wAoIFhwtet7vu1IGLDBYfZV+3vCOsh
=sJqD
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
