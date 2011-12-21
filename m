Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1LUVQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:16:33 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:42921 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab1LUVQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:16:31 -0500
Date: Wed, 21 Dec 2011 23:16:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb: fix renesas mod_gadget printk format warning
Message-ID: <20111221211624.GB17951@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
 <4EF2424D.4020200@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <4EF2424D.4020200@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 21, 2011 at 12:32:13PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> Fix printk format warning:
>=20
> drivers/usb/renesas_usbhs/mod_gadget.c:188:3: warning: format '%x' expect=
s type 'unsigned int', but argument 3 has type 'dma_addr_t'
>=20
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

a bit too late:

http://git.kernel.org/?p=3Dlinux/kernel/git/balbi/usb.git;a=3Dcommitdiff;h=
=3D8418153a4ccd38a3bc3229bc4bd161e3e5db88d2

--=20
balbi

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8kyoAAoJEIaOsuA1yqREuw8QAJS3Sb6cy16RVEw4w9B5QlL7
6gfI0fM6oFjzKDNFfVcORv5/tnvm2SfsKb0nrEEHii6WtapMdlBe1hbNyujiJRPu
5rdooJKGaU/yC84TR2QE4+t9B1s/93pGeU4WCUrcTsdoNTkvqnLhpImkVGZ2hGN1
2bj9qK7dn1YQpD4jhryxH43s+5+zlqTsjX9UNfWcBW4QXk4VcM4YEeJ/PYMkY/ed
+DEtg0tVCwtggXSWcfQe8yuxaYT0p6nvPdX20QsB25KwUEnYHi3/+DF+/CmhkIVM
TKRbDokfU38oHsqomDgp7XJvd34SACY5RL1rAsrsHyZ0q2KdiyGSGPrj2dWeFFrA
zyv1zvVUVF+/2qu6DubM3RWvemfiAto1Ua9XhxMfr8yw7Y2tYDsuZWJkgQEGbwty
MNoZTE95UvZshggAApV0YAQnal4RXHrOGwPteNxYiNb2diA9pAXSyw7g4hEavWfX
o77G5CMIVN/rnXzR270Y3ckaJ8piM260ylWMYAw9bB8tQubmYhbwJMlbAXW0RxDu
BedSq2ZomrJJ6eR5njXTm29mKIPeYxfkl6vRPYQ4RyJYjCQhjhrbzOxRSjHqM7co
1QnCN2D3OKSH2CidTA4PaHYV98yftjgvpAqOPvs1s2uqBlvRhAPcba+TtP5XRJ3e
BHISnD/lqtDL1KCaZjKf
=wDii
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
