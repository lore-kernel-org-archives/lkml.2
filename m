Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2BUOAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:00:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38601 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2BUOAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:00:21 -0500
Date: Tue, 21 Feb 2012 15:00:15 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, David Anders <x0132446@ti.com>
Subject: Re: [PATCH v4] rtc: ds1307: generalise ram size and offset
Message-ID: <20120221140015.GA3162@pengutronix.de>
References: <20120111110650.GC2605@pengutronix.de>
 <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
 <20120119194541.GA32483@pengutronix.de>
 <1328143057.3159.34.camel@pc786-ubu.gnet.global.vpn>
 <1328221704.3159.50.camel@pc786-ubu.gnet.global.vpn>
 <20120207145652.GH2539@pengutronix.de>
 <1328739796.3117.77.camel@pc786-ubu.gnet.global.vpn>
 <20120208143624.592303f5.akpm@linux-foundation.org>
 <20120213143613.GA9537@pengutronix.de>
 <1329193414.3229.27.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <1329193414.3229.27.camel@pc786-ubu.gnet.global.vpn>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Austin,

> Do you have any comments/objections regarding v4?

Nope, I am happy with it. I picked the patch and pushed out an updated
branch based on 3.3-rc4 [1]. I'll give people two days to test it before
sending the series to Andrew.

Thanks,

   Wolfram

[1] git://git.pengutronix.de/git/wsa/linux-2.6.git ds1307

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9Do28ACgkQD27XaX1/VRuevACeKp2aR6aT+7khwx8EXMZ3PvJ6
T2MAoK1LTM+VKda/pdATcFGJ4/Oz7Hmm
=7OnL
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
