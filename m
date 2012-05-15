Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966963Ab2EOVX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:23:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52614 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966208Ab2EOVXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:23:55 -0400
Date: Tue, 15 May 2012 22:23:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix double free in wm8350 error path
Message-ID: <20120515212349.GA4069@opensource.wolfsonmicro.com>
References: <1337103940-31899-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <1337103940-31899-1-git-send-email-jhovold@gmail.com>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 15, 2012 at 07:45:40PM +0200, Johan Hovold wrote:
> Fix double free in probe error path introduced by the recent conversion
> of wm8350 to use regmap.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsslfAAoJEBus8iNuMP3djzMP/3pt6KvjAUr1+Zz5yrJfvky7
aISKibrIBYuyNQhCIalJ/X/rkfK4wO9wP47zRNGPi9eCyT+pPkLXReg7D/orq0jn
lbWQaM+wYpoB5yaVU9zGoNqC79KAc2Sbum7VlnZplx0MNtx2V+Vvw8rwTTzpqQOK
3HsFchjU2+DBlbFeFNyXjQuqmg+HQp9xUpnXDO9dRulWtSGfEzBNrThEyqnnUEDg
zAQfu4OaqgbL+T7TYM354d3GmCoD1SU4ewsLGF/YLCG2VK4sr5RfqoEdrTdG1EKr
1jF8/C27XUPvnXPzTqpQ92yNDK+DPecslhFMUU6V5Ck1vOLrdy+RATJmFwm4uWDw
k5zB7K2kZ/B7wwcstjPOFxWjG+IRYLIIHbUA43bPayH9UQ8A0SkygQY5y+wFigQ2
NHnv4vg5r/zguDpmA3v76ox6m84EznjUB+eSaB+jtO47Jyz9+8TBVKTwE5V1mwNY
AgPT7Z8SQIzUYw0cpXnfHjQSf9jCGGJDmJn5flYZ6h7fHMQ0JI/sT4+jDpjLbu1j
7BgMy+BNUTj8os6bczlT2YSJTTJmGPL1OS/+cBo8ZoSJdBFfW+JHCovKqUspFCk2
hcwZ8Y4DIp03A9rr+LcdQUwXT7+lSZJj7Sx5mYfzrvvJw+Y8hRBJL+0xqVom3Lch
EUuHeqs2itINb9u47O/l
=FkdE
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
