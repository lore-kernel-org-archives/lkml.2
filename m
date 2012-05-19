Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2ESRk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 13:40:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48302 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755602Ab2ESRk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 13:40:56 -0400
Date: Sat, 19 May 2012 18:40:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
Message-ID: <20120519174052.GX4039@opensource.wolfsonmicro.com>
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com>
 <20120519164134.GT4039@opensource.wolfsonmicro.com>
 <4FB7D4D8.2050501@nvidia.com>
 <4FB7D676.9000609@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yKmnPmKxJBqIz68t"
Content-Disposition: inline
In-Reply-To: <4FB7D676.9000609@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yKmnPmKxJBqIz68t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 19, 2012 at 10:50:54PM +0530, Laxman Dewangan wrote:

> > static struct regulator_dev *regulator_dev_lookup(struct device *dev,
> >                                                   const char *supply,
> >                                                   int *ret)
> >

> Also in regulator_register we set the of_node as

>        rdev->dev.of_node = config->of_node;

So, here we're just setting it to whatever the driver told us to use
which seems about right.

>         rdev->dev.parent = dev;

And here we're parenting the class device with the real device we were
passed which again seems obvious.

> Passed config->of_node will only be used if we pass the rdev->dev,
> not rdev->dev.parent

What does this mean and how is it related to anything you've said above?
I'm sorry but I really can't make head nor tail of what you're trying to
say here, there's just lots and lots of statements here but I'm
struggling to understand how they are related to each other.

> Am I missing anything here in understanding?

I certainly am.  Please go back to square one: what's the problem you
are seeing here?  Then go forward and step by step relate it to the code
change.

--yKmnPmKxJBqIz68t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt9seAAoJEBus8iNuMP3dmdcP/3nQ4Ll2VNURXSJ9GZfFd4sV
cnldo7rvrokJypVShv7qLJS9530d5DE2V4RuhWQ7oOH39cKY6lFxvlQp+8XezNaS
08KzEH2elAMd+NTU3therHhW3BvApbq83S0iqwF7HqM93oS+md3klYrQXILmCz/R
KzPbYUj+c+PFOy1SVbgobsJvkJthR2gRF/s1V+Hw1oz/d96VL0bmCOB4vyOmc++B
CEe0B8E+iNzVDGjfCt52WAoH3TF1xkar5BB8RyD+Pl3Y4xj+h3Gqq2hm7iRRvT+4
mk0DWdKL6e9s1JCKP/NnxlgsYLbp+w9BJsa9RKM5d/jDuiqRjONQejPZs5CrXjO7
UUwgzdz8fYUkwijIZSZBtkXONsEGALKHI4tWZ7y8IYbpN39GTpqnfsYyRayPEWec
QiTEkaF/6k/vHyr8Ox9SnOroTnOVCQAX45fWQ3exEVyOSGKmEqnPvx8TKtxN3w+o
0RY+RWvGBA+zZrPBdY8wGv5Gl/n1vjhTuxM/eqtHoPq04Tzt3c+vGG1NkQIo4mil
qutteTTOz8bxU3hSUmnubcXoLWYbs7iYkD9fdHMaz8OmICupjz372eo4ZXkx/udS
1TjoJVHu+2uRJ0yqh5lwc/LsAAG2G6247Js6U7E4iILF93mP7oqU+K+Ztm7icGbc
IlEWVTD+ivHN+HizCOJ5
=QATU
-----END PGP SIGNATURE-----

--yKmnPmKxJBqIz68t--
