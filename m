Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab1L0Uvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 15:51:45 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:44009 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925Ab1L0Uvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 15:51:40 -0500
Date: Tue, 27 Dec 2011 22:51:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: balbi@ti.com, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Vladimir Zapolskiy <vz@mleia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 08/10] usb: gadget: remove useless dependency in config
Message-ID: <20111227205132.GD26671@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
 <1324341747-5922-9-git-send-email-felipe.contreras@gmail.com>
 <20111220104240.GA31842@legolas.emea.dhcp.ti.com>
 <CAMP44s2vJfG-Co+eF5jgt2cb3vd__=_M_HLALbVM5_kCArwxBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Content-Disposition: inline
In-Reply-To: <CAMP44s2vJfG-Co+eF5jgt2cb3vd__=_M_HLALbVM5_kCArwxBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 22, 2011 at 06:14:34PM +0200, Felipe Contreras wrote:
> 2011/12/20 Felipe Balbi <balbi@ti.com>:
> > On Tue, Dec 20, 2011 at 02:42:25AM +0200, Felipe Contreras wrote:
> >> USB_OTG_UTILS is already selected by NOP_USB_XCEIV.
> >
> > did you mean it's selected by the isp1301 driver ?
>=20
> No.
>=20
> config NOP_USB_XCEIV
> 	tristate "NOP USB Transceiver Driver"
> 	select USB_OTG_UTILS

that "select" line is on all transceiver drivers. The legacy omap_udc
doesn't use Nop-Xceiv. All known boards use isp1301_omap, that's why I
asked.

--=20
balbi

--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO+i/UAAoJEIaOsuA1yqREEkgP/38kE9zlMJpf6wK3cZC6rT/M
GxlWPDoG5G576irhj3syhCm3nPIThx60V9W/tphOAanahsKk9Q4XgPMuWU/KRKpR
Pcf68LuNp7Tmsl+l1J6kKCOOQXV80JRXMfSWdZNhXku5EO/5t2W3UQSD/3fAy4vp
CBuloG1Kk6iqYlpJIwOEF3BqQomwN/S8CMWe5/4OZCgAmM/PVTvZmo6y0btsjncb
dCmiYZeoCRUM2L7UGDLBsrZOPcO1nWTHSqyafkvrpQM8V6xFJ9MtmPMhaWmPufwH
/qbmgKjLIFiqHDRu+Q/nkfllYixhMpNF23vTPESg0bXc5BYGwqfRaSwHBU2R+a/3
ocIcQOSEMs8t3hRrbzcev+uMQ+IgD7Jl7eGDn/Fn/5LP2Os6E3ZIwAcgN/CXXD50
MZmA2eOaq5XJzjeG6LGBWYru8J0pVjcD4Rd4WifWEdWLREu4J/KnOovYTSHv8BPm
oHGPH1loXASLB9z42DiXYy+PB3p1z18sgN1UyRwP+fM/CUKlkKJFqEiOBiiFQ7mh
W8R9yVqGYnHcoYf1asHdB9oC8ZMPEg+XF/NJcFCfBMRqQEj8KbiKHZFelDl0ghOJ
JNmaQglGfKQFDu7dnVeK3ZPORmC5xYxwRAEsBphL5NI5jOBQIi8XUru91ZSveKwX
iW6cLNi07Xe18c/3aixx
=9xjx
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--
