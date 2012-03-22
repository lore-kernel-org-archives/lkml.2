Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab2CVMFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 08:05:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49683 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab2CVMFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 08:05:53 -0400
Date: Thu, 22 Mar 2012 12:05:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: Add TPS65090 regulator driver
Message-ID: <20120322120550.GH3091@opensource.wolfsonmicro.com>
References: <1332417673-13991-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7J16OGEJ/mt06A90"
Content-Disposition: inline
In-Reply-To: <1332417673-13991-1-git-send-email-vbyravarasu@nvidia.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7J16OGEJ/mt06A90
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 22, 2012 at 05:31:13PM +0530, Venu Byravarasu wrote:

> +	rdev = regulator_register(&ri->desc, &pdev->dev,
> +				&tps_pdata->regulator, ri);

This still won't compile against the current regulator tree, or even
against 3.3 or Linus' tree.  As I pointed out the last time...

--7J16OGEJ/mt06A90
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaxWPAAoJEBus8iNuMP3dw1oP/1PJ6gYkthGzGTXYFM9ZFM9m
z7w7fwztFZryBPbxp7iAAEy4HVRv3Mjzpwft6oi3qpjPT172e+p+GOfGNGGWYLz7
xQWFCWN0/9b49Kn8w+EENlAllHFsLevjcJAnirag2WMALIfcfmrhgFE5PgY1uPQN
LC9ZjJ0qJRtHGLcHHQ6fqSmHzRLI2fy7oXDv5zmar2DY100+mZeWe44RTr+Qb/gU
Z4Svb4eRPgJ3w6VDUz13t5gwsRmKiid82AeZNh8CjIVoFsIhuSfSvRvk9ON8rEwh
ON+i+5OdJyUBNsnM0nU81T5lSszWkSI8U/hCaMPbxCbhIFybkq3s/klmTzMBV/0f
6HHdNMK+mhe2LpxUzJ9lDA57/7O6iD679Pm2GlYj57niX0Zc3ZrRJF6qcMo4OFB7
WO5AmLRexXcjWWTI2D77vxX9hLMJQC4Y9Qa0W2pRbMS9i57+sRWbio978xs/yKg6
3mu163MoK/Ja7VoCDYOYUAjI4QAr+GIvGAMV2cY5j3AJZHiLoe5nqPJRFHM14cw1
Jhj0aYA/14ae/qgzfRtKHrpgD58qk/yKIRmnu/dljAOVGJOpl2RvFa+PidXZ9Wn7
OApLsumH4vyBnAqeL+76DQlx67iiyVXPvwQJ+LxlOMAFqlVTwtNGoNiAT0UoZvXk
PHG7zmRWPzVVZTzcCWIM
=ikhH
-----END PGP SIGNATURE-----

--7J16OGEJ/mt06A90--
