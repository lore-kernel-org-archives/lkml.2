Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391Ab1JEKx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 06:53:59 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58554 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933571Ab1JEKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 06:53:58 -0400
Date: Wed, 5 Oct 2011 13:53:53 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: balbi@ti.com, Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the usb tree with the arm-soc tree
Message-ID: <20111005105352.GJ24472@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111004165030.ab90295677251fc80bf843a2@canb.auug.org.au>
 <20111004152611.GC29994@kroah.com>
 <20111005085237.GB24472@legolas.emea.dhcp.ti.com>
 <20111005215133.14e6afa68aae2527f5a5c090@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJAclU0AInkryoed"
Content-Disposition: inline
In-Reply-To: <20111005215133.14e6afa68aae2527f5a5c090@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJAclU0AInkryoed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 05, 2011 at 09:51:33PM +1100, Stephen Rothwell wrote:
> Hi,
>=20
> On Wed, 5 Oct 2011 11:52:39 +0300 Felipe Balbi <balbi@ti.com> wrote:
> >
> > looks ok, but I don't see omap_phy_internal.o being added anywhere.
> > Maybe this hunk doesn't show...
>=20
> Yeah, it didn't conflict, so there is a
>=20
> obj-y                                   +=3D omap_phy_internal.o
>=20
> line a bit further down.

nice, looks good then :-)

--=20
balbi

--IJAclU0AInkryoed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOjDdAAAoJEAv8Txj19kN1bYoH/icgXcRNyYu45ux8WPhMjs8j
cBagdMzDqA48Dll7mm1FbJeogPGmY7UB9Gn0MFr3E6eD6ip0QG+ku93aIqw4dV4q
9WSE9Dj+3sFO3TX5IfQ7ud/R/270uYsy2Zhg2a1TjA9IFNltB8nDCBSWAqnUPC4e
A//rT14Thdg4H6B5T0v5TZ+KFYhyBDF3mIjH9KpDwNHQfVu+o8s5jLgBNIwMyn+G
bC9sO7k5YZmbHDgCWL1Ip9AvIvoCgZU4fNVbfnCgXS7vkmbUnfjnYhLuX/InJUBN
QJ9Vvz4Z2Wzn6VbZianxA0Hyt4Hlvcqeu4Zy6DDXeABHMrDT17OMoqbz6iOXKj8=
=x3RD
-----END PGP SIGNATURE-----

--IJAclU0AInkryoed--
