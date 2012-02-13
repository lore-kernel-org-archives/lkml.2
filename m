Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2BMOgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:36:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43877 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2BMOgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:36:20 -0500
Date: Mon, 13 Feb 2012 15:36:13 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Austin Boyle <Austin.Boyle@Aviatnet.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] rtc: ds1307: generalise ram size and offset
Message-ID: <20120213143613.GA9537@pengutronix.de>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
 <20120111110650.GC2605@pengutronix.de>
 <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
 <20120119194541.GA32483@pengutronix.de>
 <1328143057.3159.34.camel@pc786-ubu.gnet.global.vpn>
 <1328221704.3159.50.camel@pc786-ubu.gnet.global.vpn>
 <20120207145652.GH2539@pengutronix.de>
 <1328739796.3117.77.camel@pc786-ubu.gnet.global.vpn>
 <20120208143624.592303f5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20120208143624.592303f5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > this patch is based on Wolfram Sang's tree:
> > git://git.pengutronix.de/git/wsa/linux-2.6.git ds1307
>=20
> Wolfram, that tree appears not to be in linux-next?  If so, please
> let's get it in there.

This is a temporary tree to coordinate the works between David, Austin
and me. I wanted to resend all the patches to the rtc-list once Austin
fixed the last flaws I spotted.

I am tempted to do a tree for rtc-drivers, though. Didn't come around to
try to contact Alessandro regarding that topic yet.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk85H90ACgkQD27XaX1/VRvTAQCfR534WOK/qLeOSKiOyWeja8Sv
edcAn1z9F6s5V1qtN64HnTL4nr1ap7gx
=G4rK
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
