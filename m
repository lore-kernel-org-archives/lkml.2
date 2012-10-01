Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2JANKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:10:47 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:44182 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab2JANKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:10:46 -0400
Date: Mon, 1 Oct 2012 16:05:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: balbi@ti.com, Viresh Kumar <viresh.linux@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv3 1/7] dmaengine: dw_dmac: use helper macro
 module_platform_driver()
Message-ID: <20121001130517.GD20213@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <20120927074039.GH12592@arwen.pp.htv.fi>
 <1349088437.13371.167.camel@smile>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cQXOx3fnlpmgJsTP"
Content-Disposition: inline
In-Reply-To: <1349088437.13371.167.camel@smile>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cQXOx3fnlpmgJsTP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 01, 2012 at 01:47:17PM +0300, Andy Shevchenko wrote:
> On Thu, 2012-09-27 at 10:40 +0300, Felipe Balbi wrote:=20
> > On Thu, Sep 27, 2012 at 10:31:55AM +0300, Andy Shevchenko wrote:
> > > From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > >=20
> >=20
> > commit log would be great.
> Will do.
>=20
> > >  static struct platform_driver dw_driver =3D {
> > > +	.probe		=3D dw_probe,
> >=20
> > probe's in __init section. This is wrong. You need to change probe
> > __devinit.
> Have you checked this one
> 0272e93f364eac1a30f2831adcaca3dd633d5f14
>=20
> Or might be I missed something?

My bad, missed that one. Looks like I need to update my local branch.

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--cQXOx3fnlpmgJsTP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQaZUNAAoJEIaOsuA1yqRE3igP/2OdHiOEdqwjsIk0SXqWua9o
iaMmsA//A+mfz/enaLcgED1webGOPFB31rWX7OZIIOC9afvMG2+Z3bs6JxvCZuh2
yGT0X4Wi8PUxA1pxSAtW8qNrBGw8VUuGeRHjSkB22pq8W1kGyC+rwjsb9B4spaGv
ao2M3YA878JoI6DaOuIb07rz3GlE+Wx80M05luYTLD03AAa3nZ0bw6phKvK80+qf
pDBdV1839OGQJdjUoD8KUcjQ8nkzbB8NGk1Ys64rQCGGdAd2+zPe5j8lGYUIcpBJ
lNq1Wlei4VlOO8RQ0UK/j8tKj2sHbULm80eJATObZMbqIgg/0arSb51eerv3jJ1Q
wtc+l3nt0aZvoCmw8r1s5AHia+n96TgoqS3NxP6CelQ77BYsm0h1Xgc7AhzOlbWK
NDTgGZZgkv+T2v/tV4s/gg15gMx2w3Xluiwr/5noiLuTgCBz04q9IN98IspGqhNI
Foc9DzwCvUa8zglgxlqu8V+LG24cryM3NbzWQZse/VuSLWGhIfHGMd5MD0NoC8Ww
Xpmu2ZXc7SVrkIAlXitSzIRb1BGEPvWeh6G0nQ9vTInoC/+npxcg+QmachYUYSJD
UUa51HzbSPUwY1oVU+wJm47YlFqx+89N8lzj3CVSUkNbQjy4PT+RFTA9g4ffdeUB
YQkiBQ8W9ab5+XywWJ0r
=65o9
-----END PGP SIGNATURE-----

--cQXOx3fnlpmgJsTP--
