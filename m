Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2KNKB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:01:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38671 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187Ab2KNKB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:01:56 -0500
Date: Wed, 14 Nov 2012 19:01:49 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lrg@ti.com, ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: core: Avoid deadlock when
 regulator_register fails
Message-ID: <20121114100147.GH7407@opensource.wolfsonmicro.com>
References: <1352198049-5941-1-git-send-email-ldewangan@nvidia.com>
 <20121106111256.GA2512@opensource.wolfsonmicro.com>
 <20121106113138.GB10080@opensource.wolfsonmicro.com>
 <20121113163040.GA19089@opensource.wolfsonmicro.com>
 <20121113232537.GA27212@opensource.wolfsonmicro.com>
 <20121114093931.GA23525@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Gk0KcsbyUMelFU1"
Content-Disposition: inline
In-Reply-To: <20121114093931.GA23525@opensource.wolfsonmicro.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Gk0KcsbyUMelFU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 09:39:31AM +0000, Charles Keepax wrote:
> When regulator_register fails and exits through the scrub path the
> regulator_put function was called whilst holding the
> regulator_list_mutex, causing deadlock.

Applied, thanks.

> Cc: Laxman Dewangan <ldewangan@nvidia.com>

Please avoid doing this.  I know a lot of people do but it makes for
hand editing of the commit log to remove it.

--/Gk0KcsbyUMelFU1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQo2wCAAoJELSic+t+oim9eQ0P/3WnBu8Eg4wYJhYjiaGcfqMm
FDyavxX5qPi9DD4GU98zGE0e5trWvMQCM2iMu8NGY0aeTFZXYoGPOpbE9fkH8u7G
Z6qX94a3HIqOuiQKbKYtfvFxA2NemZnRNgP58aSgk1Pd/H7lX8qDMHGWPAsR6bEF
zeP3Whl5dJwnjBGFMuA/Pd4UlXLBwBGGfGwNVTPtKYChG/Pvu9f4zKW0B23H5AJP
7pAFHCq9BBp7Es776vtjRGHOMYeNoilEaTFuQDpk4OO/4kUAcvjRZwlMMSg5mi+5
WcRLGLK+GfseJ99NTto5DiX6C1ur8MJRlcOvhAggZGoD86QRDrCgmAj5YO3TCjJm
fLnV9evnqQVy8m7qVQdvE8Zh7xUmI9Zf/a2UeFdgqeCAhzIiSh+qGJP8v8oQS5m1
Zj/3zj+Exf+sZj9Gfmy1g7c/Rjw/Y9y/TAcx+uNxUC2YgLbAZyOQXhTV+Svciy0m
N4kw19sv8oin0or/PRF7DAk91Zo2BFILTCnPAQLHbHQRZ/OWhy4jydm4scXSy4PG
u4u2U/76VVT1RA/ver/vqV+Qg4HnUJi9FN6/Ih1c7PA+zTLIgIlF9CZQ0G51tB68
abroZqtrBttWuNujbAovesD8vwRSyjdl62bDYs4PZuxkOo8x7bfNXSdFrzK/F3C8
sFeaOKM+l2Z0ffApnk3v
=bXvk
-----END PGP SIGNATURE-----

--/Gk0KcsbyUMelFU1--
