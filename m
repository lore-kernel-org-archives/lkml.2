Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2FRS4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:56:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47161 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897Ab2FRS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:56:41 -0400
Date: Mon, 18 Jun 2012 19:56:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        arnd@arndb.de, linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 08/14] mfd: Add IRQ domain support for the AB8500
Message-ID: <20120618185638.GY3974@opensource.wolfsonmicro.com>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
 <1339428307-3850-9-git-send-email-lee.jones@linaro.org>
 <20120614183231.GA30185@sirena.org.uk>
 <4FDEEEBD.5070108@linaro.org>
 <20120618102003.GB12029@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YPAu9GJT3m1iC0FS"
Content-Disposition: inline
In-Reply-To: <20120618102003.GB12029@n2100.arm.linux.org.uk>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YPAu9GJT3m1iC0FS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 11:20:03AM +0100, Russell King - ARM Linux wrote:

> > +	int offset = data->irq;

> Are you sure this is right?  I thought irq_data->irq was the Linux IRQ
> number, irq_data->hwirq was the interrupt number inside the domain.

Yes, that's correct.  I'm surprised the code runs without crashing...

--YPAu9GJT3m1iC0FS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP33ncAAoJEBus8iNuMP3dsaIP/3G50jh1o/BrIdKA6mlgZ1vW
4f29COdx+6OPKDd8T8+kF6cCAOb/EIVesiuKYi6WpJouIzrdQcWNp3A03HQOrspo
tZwiiIv6zK28lgEdqnoDAG8WSoolIMNG4N029HcbLSPC8m1LUCxAA9ukCFnXH5FF
oOKy3cwozHlhW+l/XC4SEiyn/81kfJVzIqBDmDRtVuKtLhVuyBUMdz9oyz4rLsBX
H5/0miKxCmNJ3j5yrKUixh2L8GvLGA4jbiFB7gBAJ8TuuKrnM5cQ5xRyxQGU77X6
u3mf65w7e3jDaAvFqnW4G3+w2vJIEDUBm/qI9gWXjVYfzrNw0mynhB0lx9b99ng1
9ti2LfT3Ghb2KVGMdHiT2LGOXc3XIIF/SLKyjpMshZeYJDY0jFUNBB1Hc3pikAg3
mYyoFgMTf8fe2mv8SmjHpVTuNd7wTRdslHntBJSBRLWOlvCW+ejHsF96dKj1fAow
G3ZR5tc3XfG0pefVrloJs/VmLLnlO0+Z0tQnRUCGjr4EcO3m3D8hs+HxAZA7sBEJ
BoE8XaDdoJcUgXSxxr0jWj6ms1s3na/wTz+424gMf+susWOqN+AmqhrPAebWq53t
iOVWuoyaxO86nqiALciijxAaajP04ZrfYDtCLD4gCAngPk/PDlPjajRWyYnc4kA5
Hc8h+cw7NMJ7xWr9YNzt
=Byfd
-----END PGP SIGNATURE-----

--YPAu9GJT3m1iC0FS--
