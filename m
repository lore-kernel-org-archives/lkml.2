Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab1HVKma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:42:30 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:48965 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab1HVKmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:42:24 -0400
Date: Mon, 22 Aug 2011 13:42:21 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Michal Nazarewicz <mnazarewicz@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/4] usb: gadget: rename usb_gadget_driver::speed to
 max_speed
Message-ID: <20110822104220.GR26191@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110819233133.GD13317@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1108192225120.18944-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pa4xkLBhPDIhDLv1"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1108192225120.18944-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pa4xkLBhPDIhDLv1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 19, 2011 at 10:34:29PM -0400, Alan Stern wrote:
> On Sat, 20 Aug 2011, Felipe Balbi wrote:
>=20
> > On Sat, Aug 20, 2011 at 12:33:01AM +0200, Michal Nazarewicz wrote:
> > > From: Michal Nazarewicz <mina86@mina86.com>
> > >=20
> > > This commit renames the =E2=80=9Cspeed=E2=80=9D	field of the usb_gadg=
et_driver
> > > structure to =E2=80=9Cmax_speed=E2=80=9D.  This is so that to make it=
 more
> > > apparent that the field represents the maximum speed gadget
> > > driver can support.
> > >=20
> > > This also make the field look more like fields with the same
> > > name in usb_gadget and usb_composite_driver structures.  All
> > > of those represent the *maximal* speed given entity supports.
> > >=20
> > > After this commit, there are the following fields in various
> > > structures:
> > > * usb_gadget::speed - the current connection speed,
> > > * usb_gadget::max_speed - maximal speed UDC supports,
> >=20
> > this will be handled inside the UDC itself, so why do you need to expose
> > it ?
>=20
> I wondered about this too.  It turns out that sometimes the gadget
> driver really does need to know about the maximum speed supported by
> the UDC hardware and driver.
>=20
> For example, suppose the gadget driver and the UDC both support high
> speed, but the gadget is currently plugged into a USB-1.1 controller
> and therefore running only at full speed.  Then the gadget driver has
> to respond to the Get-Device-Qualifier and Get-Other-Speed-Config
> requests by sending the appropriate descriptors.  But if the UDC
> doesn't support high speed operation then the gadget driver has to
> respond to those requests with a STALL.

aa, good point :-)

--=20
balbi

--Pa4xkLBhPDIhDLv1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOUjKMAAoJEAv8Txj19kN19mQH/1E6ju1X4Efnxnr5ubuLlaDb
MrND17Rw1AyI4oBkyW/phFu8mmsyd+IBo1ITyvZHIOdtCTNnEbU7+QIJShemvIYK
vpDx//nTVdYuUGUjpv/udnuXOV+YG37OL5CxgwKgZLj5dS/UJnvdSqwHpDJp+B98
STBkxVkj55v0TuxzQSgmb82HFG04hUBSunvyySliviXIaqLXScKCYKpXiC5JlrxD
Bx6VLzyuHIo43jhVygG3WCuZYiZ/jd/P45GtSUn+L8iszYKiGz/Jck+QYCA5I/nE
JPoKMznTxKBxrVKpuFXfuhJHQlVSnFE/YTgtJSF0mnl87K2SvawS1QLPUGjRxOQ=
=fsYo
-----END PGP SIGNATURE-----

--Pa4xkLBhPDIhDLv1--
