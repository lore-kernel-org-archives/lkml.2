Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966342Ab2JZUFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:05:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37497 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966288Ab2JZUFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:05:12 -0400
Date: Fri, 26 Oct 2012 22:59:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <arnd@arndb.de>,
        <olof@lixom.net>, <rdunlap@xenotime.net>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] drivers: bus: ocp2scp: add pdata support
Message-ID: <20121026195915.GA29548@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-2-git-send-email-kishon@ti.com>
 <20121016165043.GS15569@atomide.com>
 <20121025004806.GK11928@atomide.com>
 <20121025061722.GB4449@arwen.pp.htv.fi>
 <20121025174446.GT11928@atomide.com>
 <20121026064736.GA22206@arwen.pp.htv.fi>
 <20121026171655.GI11908@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20121026171655.GI11908@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 26, 2012 at 10:16:55AM -0700, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [121025 23:55]:
> > On Thu, Oct 25, 2012 at 10:44:47AM -0700, Tony Lindgren wrote:
> > > * Felipe Balbi <balbi@ti.com> [121024 23:24]:
> > > > Hi,
> > > >=20
> > > > On Wed, Oct 24, 2012 at 05:48:07PM -0700, Tony Lindgren wrote:
> > > > > * Tony Lindgren <tony@atomide.com> [121016 09:53]:
> > > > > > * Kishon Vijay Abraham I <kishon@ti.com> [121007 23:01]:
> > > > > > > ocp2scp was not having pdata support which makes *musb* fail =
for non-dt
> > > > > > > boot in OMAP platform. The pdata will have information about =
the devices
> > > > > > > that is connected to ocp2scp. ocp2scp driver will now make us=
e of this
> > > > > > > information to create the devices that is attached to ocp2scp.
> > > > > > >=20
> > > > > > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > > > >=20
> > > > > > This fixes the regression on my panda es for musb port:
> > > > > >=20
> > > > > > Acked-by: Tony Lindgren <tony@atomide.com>
> > > > >=20
> > > > > Looks like nobody has picked this one up and we need it to
> > > > > fix the musb regression on omap, so I'll queue these up.
> > > >=20
> > > > I don't seem to have the patches around in any mailbox :-(
> > >=20
> > > Bounced them to you. Do you have any better ideas for the
> > > -rc cycle to fix the MUSB regression on omap4?
> >=20
> > Well, there are two regressions that I know of. One is caused by the
> > mode1 DMA changes, which I'll just revert, and the other is the
> > missing platform_data support on the new PHY driver which these patches
> > are supposed to solve, right ?
>=20
> Yes that's it AFAIK.

Kishon, any other patches I need to take to get MUSB working on v3.7 ?

--=20
balbi

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiuuTAAoJEIaOsuA1yqREgLQQALIaJJz0yr7gwd4dtEb2flZK
NDg6B0bpBBIBt2to8IW7nAc3rUfTSYQNSha77vzXsdLO8tumNvdeP+FTc7TKoJBf
I3cux5Xl18Q42yg1sEjuJdWxlx9O1A2UpJpcqF8OqOejaBZk3pJA8T17YKbVFSbk
edE5xNNzE8gTs5VphyAq0+QxFoyh2+T80IYUBjDsRTIl76lWKKWLBJvXIFZ8c9T3
lNvYvRoLffo3SPwjYGSVS+T6L/87g1t8yhIeJrLcvN8I9Ow1xKsfRnXkPkGbufSH
Q+lacyf9yVqgxfpZnA9kfz3adLtTxIY+vUfVqdArr8fwZm3LnoIjvwr9DokQcswv
cdvvh/9NXbL9kkPcHLSVU00Sj7ev5xF1Jk0TGM07fLB+FekizqEO6FQJKmzrUuoZ
nhmt2CT7ZcVYsaL2pRk1Guo87swtW2q5tbdyB/oFnZXTkc/Vc4w/Kah6X+ufTjn8
/En56XnyqUW9rkZHx+sCRgCTWEk7kfubr6MezrGlZziP4Pfoi8ZAKjDbXOOmA5ni
uJRlEr0+JTtaFuS9/q5+cqdjHO2gbUnGHiWpXYFyFLu1Vc+NKpGG9RNVnOxlF3A5
MC14uFheoHNilPyQJb1BogU8ZIS6d38kLDDqBCmUeqaZqiotpCyLqBeGfW7cnrHw
PCeR/bhA6FkbSbWEa32J
=n7Hz
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
