Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1JKOIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:08:49 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35190 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754695Ab1JKOIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:08:47 -0400
Date: Tue, 11 Oct 2011 17:08:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
Message-ID: <20111011140839.GF12293@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111011081352.GC10155@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1110111000460.2177-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SnV5plBeK2Ge1I9g"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110111000460.2177-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SnV5plBeK2Ge1I9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 11, 2011 at 10:04:28AM -0400, Alan Stern wrote:
> On Tue, 11 Oct 2011, Felipe Balbi wrote:
>=20
> > > > It doesn't shown here, but the TLL link is completely optional. It's
> > > > mainly used for modem integration, IIRC. Still, if we're using TLL,=
 EHCI
> > > > and OHCI will depend on a clock provided by the USBTLL block.
> > > >=20
> > > > Clearly, USBTLL isn't either a parent of UHH, nor a parent of EHCI/=
OHCI
> > > > blocks. We can, from a code perspective, make USBTLL into a parent =
of
> > > > UHH to make things simpler, but this will mean that calling
> > > > pm_runtime_get() will also unconditionaly turn on TLL clock, unless=
 we
> > > > add some nasty hacks to allow TLL know if *HCI port is in TLL mode.
> > > >=20
> > > > That's why I decided for making TLL and UHH siblings, because that'=
s a
> > > > closer relationship than parent-child.
> > > >=20
> > > > Can you see the problem now ?
> > >=20
> > > Okay, now I understand better.  The word "sibling" implies that the t=
wo=20
> > > objects have the same parent, so a different word would describe this=
=20
> > > relationship better.  Something like "friend" or "associate".
> > >=20
> > > Or maybe, following Paul's suggestion, the driver core doesn't have t=
o=20
> > > be changed at all.
> >=20
> > I see... I just thought that if there are other similar cases, it might
> > make sense to have a more generic way to make those two devices talk to
> > each other. But if you all agree that an EXPORT_SYMBOL_GPL() is enough,
> > then it's ok ;-)
>=20
> At the moment, I can't see any way to set up a more generic mechanism=20
> that wouldn't be more complicated and have higher overhead than a=20
> simple EXPORT_SYMBOL_GPL.
>=20
> Can this be handled by adding another resource to a platform_device? =20
> That at least would make use of an already-existing mechanism.

maybe, but let's go with EXPORT_SYMBOL_GPL(). My only concern is that
this IP comes from synopsys, and I'm not really keen on adding
OMAP-specific, integration-related knowledge on a driver which was
supposed to be reusable ;-)

But at least for the time being, I guess that's what we need to do ;-)

tks

--=20
balbi

--SnV5plBeK2Ge1I9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlE3mAAoJEIaOsuA1yqREHBYP+gLYkqMQwsIv6eKT5unX7/rU
c8vRnCgpcxDUo3sXHLvZe98E0DaXOX6AwdKrfYAgsAk0ZTYth/vts4DHNeDW6Q64
7wj1WncYXsreDJ/EIJ93L5/DH+uCM+9wy0d7ZITM3R6I8u9geNUoRTj4Ni+MaOlN
rEm2zIPzYc/4x2IFTKSe8TyqZXe9cy1NVRr3Z21aURaRJ8LiLM2MSR+5vAgZjlyg
5sii6Wga/FBN7YPshCOwTLcL+v92d5MCJtGQnVxnDA8uwqNfeEa5WClqAjvHL7LZ
g4DkNYli/AayInWwT4aLwlzL1+wuopMQOyVWp2/0c0v/A6t9rvbBj9Lk1d1zVHKh
RAOxcqHh8KmUZfY7u0AQ150z7CpRxZAWOJltgHt72AE5KjOX7YwllRxTYsjSCGRk
mMQoLZssBLobUrdEZAx36kirnv01DrV1IdLnxt6Gh2+Ew6/vd7214RAejjBrPcWl
LG3K0FmkrbWWr7UJO0Mp+R//+cCInogO99f/qQMr1HqXEkZyBSGQHif2uIsvVEd1
lQ0rCbNiN/dS7Vimon0SOCPZLGp3U+bUi+PzZKcCmbWij30RfRttkuAU7/nwdTbH
+xdZXiEF1warSYZDwgpwFa22DZZpICe0EPiJuRiLru4rvTHKH9dN0TCo14+f2C+t
rbCuh22qU+YYW9rhZL8P
=jJvq
-----END PGP SIGNATURE-----

--SnV5plBeK2Ge1I9g--
