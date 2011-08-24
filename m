Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1HXI6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:58:38 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:50780 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308Ab1HXI6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:58:34 -0400
Date: Wed, 24 Aug 2011 11:58:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Michal Nazarewicz <mnazarewicz@google.com>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/4] usb: gadget: rename usb_gadget_driver::speed to
 max_speed
Message-ID: <20110824085828.GF12549@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1314028707.git.mina86@mina86.com>
 <8289497114d3da8366ea7ed8397b4d3f16afb946.1314028707.git.mina86@mina86.com>
 <CABqxG0c=y=hH83CqHewnvrx+OHTLssymzu0Hai+kJzN6LTvYHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K/NRh952CO+2tg14"
Content-Disposition: inline
In-Reply-To: <CABqxG0c=y=hH83CqHewnvrx+OHTLssymzu0Hai+kJzN6LTvYHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K/NRh952CO+2tg14
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 24, 2011 at 10:26:53AM +0800, Dave Young wrote:
> On Tue, Aug 23, 2011 at 12:04 AM, Michal Nazarewicz
> <mnazarewicz@google.com> wrote:
> > From: Michal Nazarewicz <mina86@mina86.com>
> >
> > This commit renames the =E2=80=9Cspeed=E2=80=9D=C2=A0field of the usb_g=
adget_driver
> > structure to =E2=80=9Cmax_speed=E2=80=9D. =C2=A0This is so that to make=
 it more
> > apparent that the field represents the maximum speed gadget
> > driver can support.
> >
> > This also make the field look more like fields with the same
> > name in usb_gadget and usb_composite_driver structures. =C2=A0All
> > of those represent the *maximal* speed given entity supports.
> >
> > After this commit, there are the following fields in various
> > structures:
> > * usb_gadget::speed - the current connection speed,
> > * usb_gadget::max_speed - maximal speed UDC supports,
> > * usb_gadget_driver::max_speed - maximal speed gadget driver
> > =C2=A0supports, and
> > * usb_composite_driver::max_speed - maximal speed composite
> > =C2=A0gadget supports.
> >
> > Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> > ---
> > =C2=A0drivers/usb/gadget/amd5536udc.c =C2=A0 | =C2=A0 =C2=A02 +-
> > =C2=A0drivers/usb/gadget/ci13xxx_udc.c =C2=A0| =C2=A0 =C2=A02 +-
> > =C2=A0drivers/usb/gadget/composite.c =C2=A0 =C2=A0| =C2=A0 =C2=A08 ++++=
----
> > =C2=A0drivers/usb/gadget/dbgp.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =
=C2=A02 +-
> > =C2=A0drivers/usb/gadget/dummy_hcd.c =C2=A0 =C2=A0| =C2=A0 13 ++++++---=
----
> > =C2=A0drivers/usb/gadget/file_storage.c | =C2=A0 =C2=A04 ++--
> > =C2=A0drivers/usb/gadget/gmidi.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =
=C2=A02 +-
> > =C2=A0drivers/usb/gadget/goku_udc.c =C2=A0 =C2=A0 | =C2=A0 =C2=A02 +-
> > =C2=A0drivers/usb/gadget/inode.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =
=C2=A06 +++---
> > =C2=A0drivers/usb/gadget/m66592-udc.c =C2=A0 | =C2=A0 =C2=A02 +-
> > =C2=A0drivers/usb/gadget/net2272.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A02=
 +-
> > =C2=A0drivers/usb/gadget/net2280.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A02=
 +-
> > =C2=A0drivers/usb/gadget/pch_udc.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A02=
 +-
> > =C2=A0drivers/usb/gadget/printer.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A02=
 +-
> > =C2=A0drivers/usb/gadget/r8a66597-udc.c | =C2=A0 =C2=A02 +-
> > =C2=A0include/linux/usb/gadget.h =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =
=C2=A04 ++--
> > =C2=A016 files changed, 28 insertions(+), 29 deletions(-)
> >
>=20
> Still missing drivers/usb/musb/musb_gadget for the speed check

and the new DWC3 on Greg's usb-next branch.

--=20
balbi

--K/NRh952CO+2tg14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVL00AAoJEAv8Txj19kN1Sm4H/3cjBNtps1qH+0ep81Y0qVT8
GSszkphCDTgstlbAl7kaPkgNXfJHsAp2nXpyXii+zfsZzVhbn/8Tbu7Z6JkMg380
6p0iJzqT896hTc/MqNRXHApYK1Aoh4skcpn7nw2iEZ0Nf6lnKjiWl62WGmSBj+nM
6E2ktEYKuRGUJl8bmF/uOX4zZcvzbu1DiyBYvF4bjLO9/PGj3eHCnD0vCHstmY1B
aWVHujLX4HY8f0ebM2Z2Gc6MydSVk3Sd+21NL0y37Ubkruhp710WV2YNkcR8XqIi
lSP/SxSqcoVDkvC5Ofuq6ZMJIzb0o2HiiL2Dl/e9gTYze0VfdU+5uGuTQHOFTLg=
=V9sx
-----END PGP SIGNATURE-----

--K/NRh952CO+2tg14--
