Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab2C2Gn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:43:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45606 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2C2GnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:43:24 -0400
Date: Thu, 29 Mar 2012 08:43:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Huang Shijie <b32955@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
Message-ID: <20120329064320.GA20840@pengutronix.de>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de>
 <1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
 <4F73CCC6.6000001@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <4F73CCC6.6000001@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> >  include/linux/stmp_device.h |   20 +++++++++++
> IMHO, this header should be placed at include/linux/fsl/.

Hmm, one never knows if somewhen in the future some other vendor decides to=
 do
do a device with this register layout. It is just a layout, not an IP core =
per
se. So, I'd prefer to leave it as is.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk90BIgACgkQD27XaX1/VRucGgCgmdnj93ojQ9Q1wCQNQXv1t5yq
bSgAn1vINILZ4Nf0kEHe6kl2Pcm7aYVZ
=0VUw
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
