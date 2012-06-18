Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2FRKG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:06:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60572 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab2FRKG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:06:58 -0400
Date: Mon, 18 Jun 2012 11:06:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: extend the fixed voltage regulator to accept
 voltage
Message-ID: <20120618100657.GG3974@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
 <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bO4vSxwwZtUjUWHo"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2012 at 11:52:13AM +0200, Guennadi Liakhovetski wrote:

> Well, I never insist on being the most advanced aesthetics connaisseur,=
=20
> but I think these two changes are related. The point is, that if we want=
=20
> to support different voltages, boards will have several of these=20
> regulators, therefore they'll need different names. We could splt this,=
=20
> but just the first part - changing the name - would look kinda pointless=
=20
> without the second one, don't you think?

The major point there is I shouldn't be reading the change and going
"hang on, this is talking about names not voltages but the changelog
only mentioned voltages, what's that about then?".  The code looked more
complex than I'd expect too.  I suspect we should be using kstrdup()...

--bO4vSxwwZtUjUWHo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3v26AAoJEBus8iNuMP3d0dsP/2efCYLc2qmQ8CaI0uJyPk35
k1MbaHMHpARH/QQsWgnJ5iyxdQFQsVlyxh2W3XWjI7JeEsbUN8xOTBqqh+IsLXks
yKYM4zUjJrfqOVw04gdCCf8oh9G/q/X7eWlk49s4pvKPXMXT0Ao5zKwPfxeW/YPh
cag2gezeV3Dy+w+jEQi5uXdsIFb0ZBIkzEgvUHxhO67qP99jDnQE/qicAQGOQMcN
SwA3xct+j79oco2j2BrsfBMTscKrAOr/JbAyt1tKwwU5Haw8awomOQDOl65TATi1
5RYjSuMusCt+vpuTBqxp2hLBETseiJYONUqnmtXwGG864c9uqK4r/U8xWxcLiodl
Wt8z3wN5nJgMnQspBFtmA0svhAwu/nOtVBzrOTCyUBM92kshjdwYamrKsxPFAwrb
i5s84wgxOsz2PQZJ5SvjrIQtAgYnJZVPZeA4XBWlA/CBvyouBfj1ClpwSnCl0WD0
fejN5oeDwXBRYw3NmLOKRomgaU6i0NaeCe427WAT2o5KN8LeAHoPMPK9cJnMcC+l
3Xmdok72aG5No4wAws/FyKi5AW7WO2ecEPOT8v9A806+ciXEGh432QDbZhgiocBa
8QUwnr/z47HSAjRZFemuoA+hOuAuBop/BwUPydjXOBS71luNgkzEWZwrgNPXWkzG
gO0RkhrZfoyntRCYjOoO
=xnuP
-----END PGP SIGNATURE-----

--bO4vSxwwZtUjUWHo--
