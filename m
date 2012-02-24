Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab2BXKOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:14:39 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:33169 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756990Ab2BXKOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:14:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of balbi@ti.com designates 10.112.49.67 as permitted sender) smtp.mail=balbi@ti.com
Date: Fri, 24 Feb 2012 12:14:33 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Eibach, Dirk" <Eibach@gdsys.de>
Cc: balbi@ti.com, Shengzhou.Liu@freescale.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        stern@rowland.harvard.edu
Subject: Re: Commit 529febe breaks usb on Freescale P1022
Message-ID: <20120224101432.GK17178@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <48D3D52125C49B43AE880038E2E5314BB5BF89@SRV101.gdsys.de>
 <20120224100513.GH17178@legolas.emea.dhcp.ti.com>
 <48D3D52125C49B43AE880038E2E5314BB5BF8C@SRV101.gdsys.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DXTueXWT3Da08pik"
Content-Disposition: inline
In-Reply-To: <48D3D52125C49B43AE880038E2E5314BB5BF8C@SRV101.gdsys.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DXTueXWT3Da08pik
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 24, 2012 at 11:11:46AM +0100, Eibach, Dirk wrote:
> =20
>=20
> > > This commit introduces a check for the USB PHY clock.
> > > Problem is that CTRL_PHY_CLK_VALID bit seems not to be=20
> > present on all=20
> > > Freescale ehci implementations, at least P1022 does not have it. So=
=20
> > > this check always fails and the driver never gets loaded.
> >=20
> > hmm, you would need a revision check on that function then.
>=20
> Since I have no idea which Freescale platforms provide this bit and
> which platforms don't, I suggest withdrawing this commit and do some
> investigation on Freescales side to do this properly.

Could be, but I would like to hear from Shengzhou first. Not sure what
Greg thinks though :-)

--=20
balbi

--DXTueXWT3Da08pik
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR2MIAAoJEIaOsuA1yqREk70P/3YF+gdi5W38I8t7VVqIPSTI
w7rH945s6bGs/2h35Yl6FGGXisga8SCw3CYxuh5kK+CEYW/TnDfRfl70IpKf8TiQ
ZBv3hVqNq0Xwna06FKhsFiJpF+NnFzyXPLtCTBGH6jCsYCF/Rvk012E4EScFOIY7
0Yb0BplVW9+70eZsmlpJwXwiSKvjyion352yFv/llY502zfSryOfAQ1l71KOlJWp
duilNjlfLTMM6uAhGhiy3jC+rTYE8wVOO8eQ3dQg7/EMr7HtxtzPeoKNfnW5OTvM
UvtncHF3vLPlJA6D/WdSPFR2sqqLaOr1nIfOK98sHyzPYJ9dDvPJU0u68hyH4uuc
oxScaLr9DK4UuTH6yeB8LX0Pzx7H3JepRjfVDauiEqrHOuK3hzlbegvfwm5t6uEB
AK84iXoMjNN2sV3iv4S5pnI3Fz19E69sUQKb6Cl35IgGXf9/BDWZTEgvgioy4VU0
jdoSRr2uuPuseV2Q1Q3ApgZzdsvMMXWvhsXdEAyJAc/otow+fgfBDRr8if3wGCJy
2KaYRWY0R0uEjDRV1OlWU8B7CfFIcwelWqXkRCuWaK17lDjkZjZY2TTXaQMKBTi0
rbCKsFn8Bdng7bQM+R4vW+uuVCUkjuO3eFLUBnfN+TNkXqdkiO02YHoKXNsfSPtq
35ff7Hz32xBvuUKQvSOL
=CC9J
-----END PGP SIGNATURE-----

--DXTueXWT3Da08pik--
