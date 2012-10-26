Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2JZGxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:53:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56634 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab2JZGxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:53:33 -0400
Date: Fri, 26 Oct 2012 09:47:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <arnd@arndb.de>,
        <olof@lixom.net>, <rdunlap@xenotime.net>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] drivers: bus: ocp2scp: add pdata support
Message-ID: <20121026064736.GA22206@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-2-git-send-email-kishon@ti.com>
 <20121016165043.GS15569@atomide.com>
 <20121025004806.GK11928@atomide.com>
 <20121025061722.GB4449@arwen.pp.htv.fi>
 <20121025174446.GT11928@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20121025174446.GT11928@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2012 at 10:44:47AM -0700, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [121024 23:24]:
> > Hi,
> >=20
> > On Wed, Oct 24, 2012 at 05:48:07PM -0700, Tony Lindgren wrote:
> > > * Tony Lindgren <tony@atomide.com> [121016 09:53]:
> > > > * Kishon Vijay Abraham I <kishon@ti.com> [121007 23:01]:
> > > > > ocp2scp was not having pdata support which makes *musb* fail for =
non-dt
> > > > > boot in OMAP platform. The pdata will have information about the =
devices
> > > > > that is connected to ocp2scp. ocp2scp driver will now make use of=
 this
> > > > > information to create the devices that is attached to ocp2scp.
> > > > >=20
> > > > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > >=20
> > > > This fixes the regression on my panda es for musb port:
> > > >=20
> > > > Acked-by: Tony Lindgren <tony@atomide.com>
> > >=20
> > > Looks like nobody has picked this one up and we need it to
> > > fix the musb regression on omap, so I'll queue these up.
> >=20
> > I don't seem to have the patches around in any mailbox :-(
>=20
> Bounced them to you. Do you have any better ideas for the
> -rc cycle to fix the MUSB regression on omap4?

Well, there are two regressions that I know of. One is caused by the
mode1 DMA changes, which I'll just revert, and the other is the
missing platform_data support on the new PHY driver which these patches
are supposed to solve, right ?

--=20
balbi

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQijIIAAoJEIaOsuA1yqREhtEP/3l/7rgO5eSA5jA5IyL7zPso
7MUVLME9mI1UYg316FrOrs1cfx3KPbvKwx+YyCEUlgGww2YM01M4jidH1fr234NY
leW1YB7efoII/JT/DuYI3uecXYHFSg87SczquzClchSpa5BiECofMFMrYQWsDQhu
1+XkVvjwGRxicDTlFwI16AcADQGRSmD0j8raGWEX9YlstG/BPNXCDkNsR4sRALK9
uMpCyuMF/dXUB3I8eAIyxn/NCEvF2fpPtDVO/dytw2dvxknGMI/ti8vCZ8YsQc5Q
+yMZOOqJmF90XhxujiJGOOkl8cxE1q+y6pbndp1ntWwPqgjaIlwkt2encyFg5dil
vDBkYbo/wwajoKBRyGboZ3m9dQnQR7PCYIW5AOZNuDtZ2wPGnmQWWzH+6HskS4eL
oNJkLfUvq28KeDh5qUN383X9W20GDKCIYfp/QkeTeto3/cZ7b2WZqcX1G1xYNUza
M8ShbRE+owvj8MECaBWIxMhCxqGk/tDb4E1fXc72O824q63725JZYc7rkHsKP+xa
qvleHazDxhlJi28F+1pi+/NHX8C2nEMB6S9KFVXGdix06d0X5d7i1ZN+ihR5ssg6
hz+miCopnDRpETYF2SA6qyiC9cssVt2dyo36NB553L0uv0pP8gKzr4jy9HUHi+/T
TyyZr58KddqPanpi79tM
=4MZD
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
