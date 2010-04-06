Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab0DFITS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:19:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42690 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0DFITO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:19:14 -0400
Date: Tue, 6 Apr 2010 10:19:12 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, ebiederm@xmission.com
Subject: Re: 2.6.34-rc: key ffff8801fefc0310 not in .data!
Message-ID: <20100406081912.GC5102@pengutronix.de>
References: <alpine.DEB.2.01.1004052344210.29272@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1004052344210.29272@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 05, 2010 at 11:57:19PM -0700, Christian Kujau wrote:
> Hi,
>=20
> similar messages have been reported for CONFIG_MICROCODE [0] and=20
> CONFIG_THERMAL [1], this one is for something else, I guess:

Should have been fixed by ebd09ec93c90c8ec571d7e166832fb1fc705bf5e
(which came after -rc3).

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAku67oAACgkQD27XaX1/VRsLSQCgpGvWWr5FFexR0qIHXPIslXc0
EbcAnRHTaFb/HQhRstPjS8Q8WZURVG12
=ju/n
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
