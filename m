Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab2CKGSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 01:18:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25563 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2CKGSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 01:18:43 -0500
Date: Sun, 11 Mar 2012 09:20:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: wharms@bfs.de, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] spi: release lock on error path in spi_pump_messages()
Message-ID: <20120311062059.GB3337@mwanda>
References: <20120310085729.GB4647@elgon.mountain>
 <4F5B2113.3060103@bfs.de>
 <20120311024307.AA5E33E0950@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <20120311024307.AA5E33E0950@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F5C43B8.00C6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 10, 2012 at 07:43:07PM -0700, Grant Likely wrote:
> On Sat, 10 Mar 2012 10:38:27 +0100, walter harms <wharms@bfs.de> wrote:
> > hi Dan,
> > do you want to protect dev_err() by a spn_lock ?
>=20
> Applied, after moving unlock above the dev_err.
>=20

Thanks.

I was going to resend this with Walter's change btw.  I wasn't going
to ignore his review comments.

Anyway, thanks again Grant and Walter.

regards,
dan carpenter


--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXERLAAoJEOnZkXI/YHqRigMP/2vc/fBMxJUo5gxdBjkKJzQa
OJDYNdFehynnEl7FGvU7aH+oTfeMwuNmkKPnjbtwy42dpJ3WXnU0FiiJnQ6TkKGe
ifGhdIYDKDSWrA4ayVvE57ZxNrsQVttXJGJIY14F8DdsS4959UKxNU7zM8/8t2tR
x0gvlxVEC7Pi7VYbHpg6ay29xwYKgOUVBcdfBjkgj8T0v89wKeRkSX8X/oySUCtL
IgfIx+eqVWfeWxwKfw/v8lJ+xgVrn2hImQK2B1fOMUN2gnU/l6h+XwaQmUfDaPOo
9m2oKlKm/5nMm0dBAA3V+mQqaLyQp5CO23k0KzIPhQ2QyUGXrfVjQFRpY+Df1AYg
gwkXSFXimhYDts5He9QqlVFyTBo4S/kJIkr0hM1HYsjbbZEN81j64CqVEzFJ915O
ga2+QOphG0nHVVGtUFQTPHB3c+8LtaOXW98Jh2rmr2qG9a6IIK4utlXSmdiSjcHe
9djdASkzypsap6ADs1axvAWRdzvsRJqfI0tNURtPr05FCrKVna7bWqbsYTj9OJZ5
ZRAUa0RtBvm8P8XJvuqNHfDH1YbO9ct7BTzpgT+1gX86/iA81utyjAiw8yMN1exN
wjrZpaM53enfjIw8OI1aq15e4skdcg8eLjqnP7mNbP8aXekMQ4En4H+IZ20maoIe
maqvsJ9TyFFuiT6KN8Am
=Ypc7
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
