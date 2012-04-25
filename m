Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2DYKND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:13:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56336 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757167Ab2DYKNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:13:01 -0400
Date: Wed, 25 Apr 2012 11:12:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] twl-regulator: Allow CONFIG_TWL4030_ALLOW_UNSUPPORTED to
 be requested.
Message-ID: <20120425101258.GI3195@opensource.wolfsonmicro.com>
References: <20120425122924.0f08f5dc@notabene.brown>
 <20120425082417.GE3195@opensource.wolfsonmicro.com>
 <20120425195956.5b3d9c2a@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l0l+eSofNeLXHSnY"
Content-Disposition: inline
In-Reply-To: <20120425195956.5b3d9c2a@notabene.brown>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l0l+eSofNeLXHSnY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 25, 2012 at 07:59:56PM +1000, NeilBrown wrote:

> That make sense - but I cannot find a good place to put the flag.
> TWL doesn't have any twl-specific platform data, it just uses
> struct regulator_init_data.  I don't suppose it would be acceptable
> to tuck an 'allow_unsupported' flag inside 'struct regulation_constraints'?

> I'm not sure how else to do it without fairly major surgery.

This is what the driver_data in regulator_init_data is there for - to
allow device specific extensions to be added if needed.  I guess it
should be possible to use that?

--l0l+eSofNeLXHSnY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPl84FAAoJEBus8iNuMP3dwqYP/jcASzt1B4xvBI25eWTX8LS2
gvv6dYJmhO/OugK5KjNbgFLIu4jMI1kH6qXk2x4j4BZI8HiT2P5JyK1tTXYz/nG/
hBGwMz/nE/YMIojiaaB+3gYRONj7OkbZwWNGJwoxhcXmo5DQgQjFeB/fwX9Nj1V3
U3VTnSXGzmCcFgV8PN8PxkO5kUb+B7f7JgBIQvtuDMaaGrMxMfZzOYAjqA3IL04J
sGrDdEfrIyZ7lK6NvbrY6oQMXLreRp+joLXkbJH0G74mxj2of79Jwf+sgJB9P2Ri
u2our4wJBID2kklwcHlcq66G/0v/liHxIi1WiQ8pq+wBNdsM21feFtgoxGhEPDGh
8QYbDrqXe8dMNAarcS2/wfPIxFOvQRWZpKhEs65YRvCs5WTAZIyhUA5ZpZwx8HV2
2+qB07i21UgxsUYSbopxIuKcCbxDw+dodlljGtqg7bYWeZopSN5cR0r+nY5CALRv
TjhaSeYVmAwVw6rtcwwda6HhQKnz3wqcX25r1inFGkUzpI4bJExZLJ5ln3pVlxUI
obcimf0Od63b58iXwbTXIQwxeH33Fdrzml/391Esfh0LHl4I2y2YJ1Yi5vNn582m
Cd8V+X3xBUz0oIduvfxwArfmwTMZAjzme6sAjTsYjM34ZjeSYXC+yzW7F0lT1GWc
xUPRzW1xWE0vQAW58ehR
=PT5C
-----END PGP SIGNATURE-----

--l0l+eSofNeLXHSnY--
