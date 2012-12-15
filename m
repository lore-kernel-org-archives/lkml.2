Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2LOPDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 10:03:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33279 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2LOPDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 10:03:15 -0500
Date: Sat, 15 Dec 2012 16:55:46 +0200
From: Felipe Balbi <balbi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Felipe Balbi <balbi@ti.com>, <spi-devel-general@lists.sourceforge.net>,
        <rob@landley.net>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2/2] spi: devicetree: add support for loopback mode
Message-ID: <20121215145546.GA15606@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355301960-21523-1-git-send-email-balbi@ti.com>
 <1355301960-21523-2-git-send-email-balbi@ti.com>
 <20121215003224.CBFD93E0BEC@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20121215003224.CBFD93E0BEC@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 15, 2012 at 12:32:24AM +0000, Grant Likely wrote:
> On Wed, 12 Dec 2012 10:46:00 +0200, Felipe Balbi <balbi@ti.com> wrote:
> > there are a few spi master drivers which make
> > use of that flag but there is no way to pass it
> > through devicetree.
> >=20
> > This patch just creates a way to pass SPI_LOOP
> > via devicetree.
>=20
> I don't understand how this would be useful since loopback mode is
> really just a test feature. Is there any reason to do loopback for
> something other than test?
>=20
> I think it would be better to add a sysfs or debugfs property to
> manipulate the SPI_LOOP flag from userspace. What do you think?

might be nicer in the long run, indeed. Want me to look into it, or do
you wanna do it yourself ?

--=20
balbi

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQzI9xAAoJEIaOsuA1yqREwFgP/RdGkkiBhtfeNQAHXMa/bNxI
9dUPXPLjMtMLDj0eEgqUOsJWSFhhq7Sh+yenElWQAfyKjtNMqDsm3ZPLb9VRRHue
a2G1NuD9T86+7NY6FjxglY9XAIqOosIQ3NlwKHnDkNbpwDdVwwQPw8Cw9UJWH/2q
PM3UHHIWifXqXADKlBiznY5rNnpQVEfY2/zm5U5jcUZDPq4cqfdFMxVneEZOgqtD
DJpuskr2Udflw17l1rSVDXmNKfGftavMpMTxVN60deZdlNBwkFt/cyfMB8nFewFJ
RTtKEZNstCkH7AHa/V0fp8s1bB2Zd2zuF00ofGABXx2T7sjqnW082yhFZXPzOgON
xNRnFThKcF6KkEzO/C/Kl8yXoHC2T1QONDV/quL73xk+5T3eXP723l2U6Qb4d+tf
hlxPMEIE8HAsspKK6FcYuaNxnKOHLB9pJe1tTEaLIlWFvHL90uzTJz/dEksM+URO
xFXmEVyN7LDgpDErHUL01daCnHAKF8XiUwa12FEA2Uvn5qw83gTTO0ou3lBjlRaN
3P6OTxrEvVNaElWW29FRpmjDQ4P7WWzjr6ftIbKtN0SS5BgH81XcLN40XlPx95LK
mc4jwtxqlcplXOIOks2xfTsTSitJ9aqSwn4mKT00+CWopLXdc7p8NYtX8zOM+05G
A6cIfq/os96qVbMrQeyI
=SeZs
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
