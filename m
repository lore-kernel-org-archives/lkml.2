Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2EWItw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:49:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46816 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933052Ab2EWItu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:49:50 -0400
Date: Wed, 23 May 2012 09:49:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: marc@cpdesign.com.au, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120523084945.GA4085@opensource.wolfsonmicro.com>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
 <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
 <CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 22, 2012 at 11:05:35PM -0300, Fabio Estevam wrote:

> Should the spi->mode and spi->bits_per_word be passed differently?

> Maybe via "struct regmap_config" ?

You shouldn't be setting bits_per_word at all, that'll corrupt the data
that regmap has formatted.  Does removing that alone resolve the issue?

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvKSjAAoJEBus8iNuMP3discP/iW/fzRiYb5jmCkl1siXfa8N
EXYA3BTbMGeZ6INXA4OT8ux9itE1iL7PHcNMmGj6gkxjyteSRJw4CNRw5YmFRmSt
IPdjEd2Njo4XHZa7Cy96aWzAaEQUGViXHBzfanI4LRma7hlpBfF/aUng0suIyNgR
z6BcrifmxwrRNHn9AwQJGyPnAGz5VV3YWydHT+2sdbgXrW/HFw+1+ATahd6JJfi2
c4EW16iO7g551Bc7CIwcGEykNTsTVF+qTcbmBZKI+gaLNt7Lw2QZy43TyIcka8Mv
q/Tt5IJ1wKLtqL/IrwIlN2yxJty+RqVFkBRarUWiJ3LYHGZg7xhuxAs5YA681s+X
CxNZRqtP0EJvnubESs7x8Er1mayr6eTrv7DnReTUsvmt4ErdYhK0su1ye6zV/fwN
5MkE68BFku2HG343EoQ31QR5UujvlZdbXqTEB/GX2Ga3MGe2JqzwRyyWNMwE9Knd
27oQgdfTO4aKcK6OWjC1E3hz5j8VoBDmvp7frmp4g9rjoFjGbEQE3QWTHeujLK40
Q+I2KRFXsZDtrT19IrbyBPvOMEKkFzObUMWgP4PVL0FisbIEIpC2RijI6IWWTy66
4H45wzZpWXk/N+BWOwqclKXiOYYgjZbn3Fjhxycd5jci0Cp955/6wv8qum00ihiD
1vFiboQiOVwOYlgf/A7U
=Bteb
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
