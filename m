Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab2JYGXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:23:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47743 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab2JYGXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:23:16 -0400
Date: Thu, 25 Oct 2012 09:17:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <arnd@arndb.de>, <olof@lixom.net>,
        <rdunlap@xenotime.net>, <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] drivers: bus: ocp2scp: add pdata support
Message-ID: <20121025061722.GB4449@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-2-git-send-email-kishon@ti.com>
 <20121016165043.GS15569@atomide.com>
 <20121025004806.GK11928@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20121025004806.GK11928@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 24, 2012 at 05:48:07PM -0700, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [121016 09:53]:
> > * Kishon Vijay Abraham I <kishon@ti.com> [121007 23:01]:
> > > ocp2scp was not having pdata support which makes *musb* fail for non-=
dt
> > > boot in OMAP platform. The pdata will have information about the devi=
ces
> > > that is connected to ocp2scp. ocp2scp driver will now make use of this
> > > information to create the devices that is attached to ocp2scp.
> > >=20
> > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >=20
> > This fixes the regression on my panda es for musb port:
> >=20
> > Acked-by: Tony Lindgren <tony@atomide.com>
>=20
> Looks like nobody has picked this one up and we need it to
> fix the musb regression on omap, so I'll queue these up.

I don't seem to have the patches around in any mailbox :-(

--=20
balbi

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiNlyAAoJEIaOsuA1yqREAyIP/iUSBlnbBi0JeX6Z0birF5ip
Og42T4LcpMxRMDbyd2otbeL20iLE5cyXOthe24AdeMW7ZY765GGDgiUWCxiUl5XM
H1aBT+SqCNvuOu2Tr1Jdl3ZbivfXSlKRIxK4al9gk3BNQPAsDSwjvci7QlbXld/Z
ATW0qK72In6VaMI9xBSh74bdf2XKOJi2fMgI4vkw9gcLwCeNMhz6L+AekY0obThC
xw9I1XIu4jWwgyw2Gt1uebXwHZTjgOMBDZL7ueEw385Yug6Cu71lptWBd/JPD3j3
pSww0unIMD3NTcr6LvhOfUVHfp+Z8aMS9Mgs9SzG7Fy0ns3a6+JgSwNDN1Uao+Jk
xK+Dq/76yj3NiM9o6ddtPksJCD+TTbNpVQPyQe43nD0Itf2f3V0swuNHgYY96oDX
tsgQUwus8qcoknw5M2PBl0o8BI3q2eonM5Fu93Zk+ANw7v19AhaSXbQbErSKretr
rmY5vdFMeY6fSx0E5h0VogbXC9yxrxgoNCPGH72akIcZd5T01aeVhvfdKMAs978E
EB3Tv/tLZGMK9bSnduqtbPOeZZ6eshlb6iKBkb2Wo/svo+x++AcbrMY/R6pjsqVk
lqWfgew0naBC8wrcLAKQzPw938knf1iaR6CHm/MRmLEPUYDc2D0kGsRB+jN6xIYD
aXmux3jt6u+8ytPC5BfL
=G2wd
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
