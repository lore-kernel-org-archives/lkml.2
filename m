Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1KGLfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:35:43 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:45125 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311Ab1KGLfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:35:41 -0500
Date: Mon, 7 Nov 2011 13:35:36 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: "'balbi@ti.com'" <balbi@ti.com>,
        "'linux-i2c@vger.kernel.org'" <'linux-i2c@vger.kernel.org'>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<'linux-arm-kernel@lists.infradead.org'>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'plagnioj@jcrosoft.com'" <plagnioj@jcrosoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>
Subject: Re: [PATCH V2] drivers/i2c/busses/i2c-at91.c: fix brokeness
Message-ID: <20111107113535.GD19489@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <alpine.DEB.2.00.1111071019560.21431@gatekeeper.vosshq.de>
 <20111107094701.GF4265@legolas.emea.dhcp.ti.com>
 <EF2E73589CA71846A15D0B2CDF79505D087B38B21C@wm021.weinmann.com>
 <20111107100446.GG4265@legolas.emea.dhcp.ti.com>
 <EF2E73589CA71846A15D0B2CDF79505D087B38B2AB@wm021.weinmann.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Content-Disposition: inline
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B38B2AB@wm021.weinmann.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 07, 2011 at 12:06:52PM +0100, Voss, Nikolaus wrote:
> > > > IMHO, you should split this patch into three or more smaller patche=
s.
> > > > You're doing lots of different things in one commit and it'll be a
> > > > pain to bisect should this cause any issues to anyone.
> > >
> > > I didn't split the patch because it is virtually a complete rewrite.
> > > Due to the severe limitations of the old driver, I think it should
> > > replace the old driver.
> >=20
> > The final decision is up to Ben and/or Jean but I think we should alway=
s have
> > incremental patches, not sure if we should allow big patches for the re=
asons
> > above.
>=20
> Splitting the patch implies the possibility to test each incremental
> change independently, a possibility I don't have with my current setup as
> the old driver didn't work at all for me (for example, my client needs

What didn't work ? You couldn't do any i2c transfer at all ?? Or just
this repeated start didn't work ? If repeated start didn't work, you
could make it work in one patch, then add that context structure to
allow for multiple instances and so on.

> repeated start). I developed and tested the driver in an all or nothing-a=
t-all
> approach. Splitting the patch would be a purely academic exercise for me,
> without any extra value beyond readability (which is admittedly bad now).
> From that point of view, I should maybe submit the patch as a new indepen=
dent
> driver (although it is a logical replacement for the old one)?

no no, it's the same controller, so the same driver should be used.

I'll let Ben take the final decision here.

--=20
balbi

--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOt8KHAAoJEIaOsuA1yqREwh8P/2Jz1jk/RSAc+EbFu+j/ILEz
jmvtVThWljZTgl9deDhYvxXcnqcoLEPVtOy94oh96Fl3Xl2YwxEVFYXQ9uNT6YNy
8dRP2sWZAdH/4Lc2n1G+007vyC7fVPQC4OvH12+pPK/vV2AagVRIbAETUKSQtE1p
gbJ/I09bvsS7zI3lM1FGuU4obVtx0uvu+yv1i9ur1vq2jes3jkQXtgt+wi70qjpm
CGsa0VcRkLvqc55lUkgdTVTIjBgubMvWHC6EEfhbH3nXfVZpXBM4K3EDV3bgySxY
d4PqCThOrz044DHykTMW2tZRymrQ9J3YKhSbYcbPcJFIyeL6229aJBlHsEWiY9eI
TbFrncYRmdBWjvsqxm2kUp05/8Q7pDSWy4H8XyKJw2/oPmJTJ5a+R4IAo+aS2ZRE
Pld7rlnKYmFKpR2FZuIuwKpwMtNRLEcXyRsefi0WgRnu5sKMBqXFqOJBLq/8rzxi
MZDTrBrt+vnXokdVZt6tNxWQddfqd7HQDprZ8nZqNVrrJNwwiMWK/5EwTbaotnUo
2BMNHnL0R8ocaINNV4sDuotqDZx1sp2nWy4Uit0dwJ1apjtHlIlgXNKWy8Us8qtB
G+hP+FxPwHiYxQQb+hoqDDwJBlShaF9yHDH4zDVvhTWwUcGErFAa/2jk3XAGsafG
Ai//V6sei59fS3so1fcH
=5OOq
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--
