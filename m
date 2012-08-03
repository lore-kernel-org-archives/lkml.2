Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2HCNch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:32:37 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:37288 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835Ab2HCNcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:32:35 -0400
Date: Fri, 3 Aug 2012 16:28:53 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 03/11] drivers: usb: otg: make twl6030_usb as a
 comparator driver to omap_usb2
Message-ID: <20120803132852.GE8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-4-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <1343639400-28725-4-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 30, 2012 at 02:39:52PM +0530, Kishon Vijay Abraham I wrote:
> All the PHY configuration other than VBUS, ID GND and OTG SRP are removed
> from twl6030. The phy configurations are taken care by the dedicated
> usb2 phy driver. So twl6030 is made as comparator driver for VBUS and
> ID detection.
>=20
> Writing to control module which is now handled in omap2430.c should be
> removed once a driver for control module is in place.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

This looks good for the time being. Do you think it has any hard
dependencies on your new phy drivers, or can I apply this without those
other patches ??

--=20
balbi

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9IUAAoJEIaOsuA1yqREsCkP/2rDy2Re7qFXgQ3oNSuVf9V9
VudMHTfo+AfMHKRl+TeD9RH9H2Cr7agrfhMy1G0WOznh43bmqkDkYO8If1y6fojc
wIo7Bril2heOaywIF3v3oQPDqnKMIFFZJncBYttKGY5kzozTySmCgxusBLN7dugr
+sT0v7Gqb06tz3wYvGlGXzC4ueOqmu78YfSD8FMAZeOSNtwiWoG7/O03Mg4dvFdy
tuA/WQNMkvKZPFQNYUPHsYLQlyWMc8ANbFfQyKO8xxTWGiu8NPpjCcqodLRQWnDk
kbKYGWHPomvKL8W21TWirl91FDCB7KGuDA9Hw8U5KxP3cJ3QP0+AzDi3T0IhPbTP
MSRWt/tj+m5aDC0H1EMACTQ8uaGN8HknzxR50YWUARIBce5awZnj71US55Jzd1ne
xHnxwP1ito+xUrDHNpI08Ckxk0yAv8cNOKDytuijeqkLzSl+wLZPAgcm8afVN203
A1Psf8iTVo5jFajWNUoIP53YZ/Do7cmWnE0lxLRxUJtca6/Ged4TLj3d1ma98PBT
rscJ2nziKS8qUjdwEOcw5H6Q9QiCS348IdakypxSWRoaix9da1xBjJUZB2iQfbG8
naSouQdN/Q2Cc32/qwV6pogkNlqWX7XioZPxbfL+rH9kEkBsmz58TNFsQpvBx2sG
p12olqejxY9wHO6og6sx
=JDjb
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
