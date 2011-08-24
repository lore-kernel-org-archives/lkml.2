Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1HXI4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:56:25 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:40292 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660Ab1HXI4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:56:20 -0400
Date: Wed, 24 Aug 2011 11:56:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Michal Nazarewicz <mnazarewicz@google.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110824085615.GD12549@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <op.v0okm8hlvgw7ix@mnazarewicz-glaptop>
 <Pine.LNX.4.44L0.1108231636000.2069-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ycz6tD7Th1CMF4v7"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1108231636000.2069-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 23, 2011 at 04:49:37PM -0400, Alan Stern wrote:
> On Tue, 23 Aug 2011, Michal Nazarewicz wrote:
>=20
> > On Tue, 23 Aug 2011 20:00:25 +0200, Alan Stern <stern@rowland.harvard.e=
du> =20
> > wrote:
> > > For the time being, perhaps the best answer is to use the _lowest_
> > > max_speed value among all the function drivers.  It's the simplest
> > > answer and most likely to be correct most of the time.
> >=20
> > In theory, one could create a composite function with only SS/HS
> > descriptors.
>=20
> The only reason for doing that would be if the function was incapable
> of carrying out its duties when running at full speed (insufficient
> bandwidth, for example).  Something like this is discussed briefly in=20
> section 9.2.6.6 of the USB-2 spec.
>=20
> >  So it would work for SS/HS but not for FS.  I'm not
> > saying that it would make sense (or that it's not a bug) but that
> > adds to the discussion.
>=20
> If somebody writes a composite gadget containing two functions, one of=20
> which supports only full speed and the other only high speed, they'll=20
> get what they deserve.  :-)
>=20
> Still, maybe I was wrong.  Maybe it would be better to use the fastest
> speed supported by at least one of the function drivers.  The user can
> always force a SuperSpeed-capable device to run at high speed by using
> a USB-2 cable to plug it in.  I'm not sure whether the user could force
> such a device to run at full speed, however.

plug it behind a full speed hub, like those that usually come on USB
keyboards.

--=20
balbi

--Ycz6tD7Th1CMF4v7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVLyvAAoJEAv8Txj19kN13sQH/RlAMgL4LZsZBIX2MjkgJTn1
3pfpjS4A9KP9c1FFXOTlLEkwB/joeSDcCKXjMohLT6m3gmpUiPNx+bGboBmJAl9R
sVTISnJQ6CPG6T0LCkRG5xJjdpCOeJYcHZHb7KajhrUAftWZ1uxqCqABjL7yuiVt
nCpJg/3DSgKoexiGZiSMfS71HfP7ulIPDaDOPh+8glHmdM5sKekaSWWd7QXFSyb/
mkQNSRaVeTr22OdBbLtb5ZUURsdEyqY9gRWLwr/SRT4cZ8RYENk742F457ozniS9
oEivlSCzwrRndf1NU45HuO1OHw3mXBl+p5YsAuq8CJIk19/vtxux4UY+VCFofNM=
=CC34
-----END PGP SIGNATURE-----

--Ycz6tD7Th1CMF4v7--
