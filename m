Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3AJMqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:46:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39095 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab3AJMqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:46:20 -0500
Date: Thu, 10 Jan 2013 14:45:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: Benoit Cousson <b-cousson@ti.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <arnd@arndb.de>, <balbi@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: dts: omap: Add omap-usb2 dt data
Message-ID: <20130110124551.GU28920@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1348050772-27819-1-git-send-email-kishon@ti.com>
 <1348050772-27819-3-git-send-email-kishon@ti.com>
 <50EE8A89.4010801@ti.com>
 <50EE921D.8020601@ti.com>
 <50EE9517.3030703@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hFEw+uh9kF5V6COn"
Content-Disposition: inline
In-Reply-To: <50EE9517.3030703@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hFEw+uh9kF5V6COn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 03:46:55PM +0530, kishon wrote:
> Hi,
>=20
> On Thursday 10 January 2013 03:34 PM, Benoit Cousson wrote:
> >On 01/10/2013 10:31 AM, kishon wrote:
> >>Hi Benoit,
> >>
> >>On Wednesday 19 September 2012 04:02 PM, Kishon Vijay Abraham I wrote:
> >>>Add omap-usb2 data node in omap4 device tree file. Since omap-usb2 is
> >>>connected to ocp2scp, omap-usb2 dt data is added as a child node
> >>>of ocp2scp.
> >>>
> >>>Acked-by: Felipe Balbi <balbi@ti.com>
> >>>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>
> >>This patch is also missing in mainline :-(
> >
> >Well, in that case this was done on purpose :-)
> >
> >>
> >>Thanks
> >>Kishon
> >>
> >>>---
> >>>   arch/arm/boot/dts/omap4.dtsi |    5 +++++
> >>>   1 file changed, 5 insertions(+)
> >>>
> >>>diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dt=
si
> >>>index 4fbb9dc..28eaddc 100644
> >>>--- a/arch/arm/boot/dts/omap4.dtsi
> >>>+++ b/arch/arm/boot/dts/omap4.dtsi
> >>>@@ -303,6 +303,11 @@
> >>>               #size-cells =3D <1>;
> >>>               ranges;
> >>>               ti,hwmods =3D "ocp2scp_usb_phy";
> >>>+            usb2phy@4a0ad080 {
> >>>+                compatible =3D "ti,omap-usb2";
> >>>+                reg =3D <0x4a0ad080 0x58>,
> >>>+                      <0x4a002300 0x4>; /* TO BE REMOVED: SCM */
> >
> >Rob and I did not agree to use that temp hack in the case of DT, so you
> >were supposed to repost with a proper driver for the SCM part that
> >control the USB.
>=20
> Ok. Missed that. Will work on that.

Didn't Tony say we should access SCM directly since it's a one time
thing ?

Tony ?

--=20
balbi

--hFEw+uh9kF5V6COn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7rf/AAoJEIaOsuA1yqREyG4P+QH5KEVnnUeSCuX4pK5Mpkm0
QOm9z2T9vYLUYQSGfWxt01AUXq0MbUcl6eZGpGr34lEb53QiEt8TpOw18uPt7sw8
ibOryP1pvD0RsWsNqcd9V6tJzW3U22Q4Zh0OmuTNKcATGXm5seBMxKvN4JBU3C32
nm7yOARCblgBPl4WKUrnG10wAKfYJZhWPg5w9j+rKn1Kzd2s2O/+IkYJfMUlnchp
yDh+HZnGD66xZUKECRCaUkK/+yvl1uePR3Gbt16ZYpRvPxp7NkvaGIfGtILJyShw
vS/U2rf3L9v+umdTHWZ5bqhJiLSXvETZSehzAn9YWQRJLu7PSCsaAnEqEbddUkCA
uhh9ws7foJT1WWkojbvIwgYGrHf6mUugnVuxb2DWLo4KsZcqE8fBynMOkmaf5iIl
kxDPPjWCmm6UgGn5nVimsX6aogLWmAszj3OGzIsf1gjzojDCn0TZN4SqcyszLAHR
pqOb9TnCuSlvOsNeQF0+xD7xMQjmjxMdiFr0nzcwfim1JOztc0b0W/qoRedxt1j8
yye8+Ehs8wZVk9vigynwGCq0ihhrG/HwSID+v9fpFOYG6Ao6eME/6ti/55PyfNQD
an8bPso1rnDQzf4/voqrr9vxbOFEOeMvLz8+0UOr4YZydLKzGjgzcJIMaCvH2MXF
nd+9crNCEsXhYzPdJ56w
=ip/K
-----END PGP SIGNATURE-----

--hFEw+uh9kF5V6COn--
