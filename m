Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966033Ab2B2XT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:19:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33319 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965089Ab2B2XTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:19:54 -0500
Date: Wed, 29 Feb 2012 23:19:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator mc13783: bail out without platform data
Message-ID: <20120229231951.GB8295@opensource.wolfsonmicro.com>
References: <1330502500-30567-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <1330502500-30567-1-git-send-email-s.hauer@pengutronix.de>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 29, 2012 at 09:01:40AM +0100, Sascha Hauer wrote:
> the platform data pointer is used without checking it. Bail out
> in the driver instead of crashing the kernel.

Applied, thanks.  Ideally the platform data would just specify the
constraints and the driver would still be able to register the
regulators even without constriants being provided to allow diagnostics.

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTrKHAAoJEBus8iNuMP3dbAQP/1dKH8UiqsGrRErcu68wWKTB
JiRcsNE+oJod1wlbu2eZJBVuCmYFavHRj5TIl/nNH3hx5wUjxBWYhRBYkispLCCV
o+FX4G/ExdSj6s/FW0pC6kVu28CeFUpDTfzahirXnCltQVM+wn1WiefukCG/SAlV
/KxuXQQ8EMF6X8IzF/VrPn/UZOEz3kkZ6q3CjnRDsletvHqwiVUQh7v8rlqRTkaa
NBOQpe3Ns8MFexHZnvBjlhC/pdc5n6kaPQToftwY+8m+B/a/MyGNx2S8YU9D7DgQ
Svl5qHnz+qLK5d1k6bKDvnZyEiK/4IumizdeRqvzxBh0epMKHO1UFuoN+xeBji2v
EBmiNMtO+exeOn269awYc7pW8B3Jei4hY9d46AUvpCiqNjbHsrmN1cknUNjSkB1Q
bCYvLYKxFMf8+Wbx+CL3qJ8wqZl8D5SqATwsDWkxNf3gLRNuoDjzgwF2qWQ+MoRh
aiKx3zwwh+oBoS3cbBQKKrR+c/4yFrEj3pF6esdQNZgkWA+5oadT3HkFt/SpG6m2
w3ISPAocGehQE3DthhEEqije57WE6ImDJpOQpadAuJM5R+Cn+TW2TD4YXJRWzBqh
nIrotgQ75xlh7Q3RXDIHMB6pnQ5GV5OajZ6XjgeznGGrN+6tvx9A75qkA5UQUi+4
osO1RLOiaouKrPyxHxAO
=xJcQ
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
