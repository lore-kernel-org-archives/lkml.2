Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab2DRJUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:20:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39241 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2DRJUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:20:22 -0400
Date: Wed, 18 Apr 2012 11:20:19 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Huang Shijie <b32955@freescale.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
Message-ID: <20120418092019.GB2232@pengutronix.de>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de>
 <1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
 <4F73CCC6.6000001@freescale.com>
 <20120329064320.GA20840@pengutronix.de>
 <20120418090551.GA30966@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <20120418090551.GA30966@shlinux2.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 18, 2012 at 05:05:52PM +0800, Dong Aisheng wrote:
> Hi Wolfram,
>=20
> On Thu, Mar 29, 2012 at 08:43:20AM +0200, Wolfram Sang wrote:
> > Hi,
> >=20
> > > >  include/linux/stmp_device.h |   20 +++++++++++
> > > IMHO, this header should be placed at include/linux/fsl/.
> >=20
> > Hmm, one never knows if somewhen in the future some other vendor decide=
s to do
> > do a device with this register layout. It is just a layout, not an IP c=
ore per
> > se. So, I'd prefer to leave it as is.
> >=20
>=20
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Thanks!

>=20
> I'm converting mxs-dma driver to be mach-independent which also needs
> this patch.
>=20
> Do you know when this will be merged?

Nope. I assumed it could go in via arm-soc, since it makes sense and
Arnd used to comment this series. He is probably busy, currently.

> BTW, one small question:
> Is it possible that stmp_reset_block also be used by other vendors?

Sure, why not? I could ask a friend to to do an FPGA for me with this
layout.

> If not, i guess include/linux/fsl which already exists may be the
> right place.

Which is a bad choice in my book. linux/dma would have been the proper
thing for mxs-dma.h, I'd think.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+Oh1MACgkQD27XaX1/VRvRUwCcD/NFORwblRRBZYZds0rL+UIv
DXkAnRMvSlvqXTZUCGYddP6qLzmDCykW
=v7eA
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
