Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2BOQbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:31:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42576 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364Ab2BOQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:31:15 -0500
Date: Wed, 15 Feb 2012 08:31:11 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Fix cache defaults initialization from raw cache
 defaults
Message-ID: <20120215163110.GH2996@opensource.wolfsonmicro.com>
References: <1329297805-8066-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cW+P/jduATWpL925"
Content-Disposition: inline
In-Reply-To: <1329297805-8066-1-git-send-email-lars@metafoo.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cW+P/jduATWpL925
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 15, 2012 at 10:23:25AM +0100, Lars-Peter Clausen wrote:
> Currently registers with a value of 0 are ignored when initializing the register
> defaults from raw defaults. This worked in the past, because registers without a
> explicit default were assumed to have a default value of 0. This was changed in
> commit b03622a8 ("regmap: Ensure rbtree syncs registers set to zero properly").

Applied, thanks.

--cW+P/jduATWpL925
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPO91LAAoJEBus8iNuMP3dcSMP/1Y61WD4CRAQDrG2vQ4cE2nA
dm9HfV8OWzwQKb5z8+xEBfiLjyQ5dE2gcb0MyMK6tBNxnYPy/N7pnR9Dp7rczMNx
XbYThlTmWOqMHkG6hPSOf8JEuN/HUQr/e1CgqZWsnrYZyk6yKnkBjAdu1AaDEBUd
2XKcimQs8YuulRKuPYcgyVkWONM1ZvYVvnFGRc3jpPz90x6hURrLwn2FvwPj/6Ot
hXYbLsKifFnvc0ud72upVYV07iw86PhSb3FCGfQDg0eRPvuM244A8Otscgd5I5jZ
SptBD4alnVESTuqi/VONXZMe/kHGEWgmmXJ0ZvnG3rLlwLYmIpYLy2Ygx8CMsD/N
fSrj5mwfF0Dz/aA7uS4XZaRWIuYnZsWlti9ZDHklhmI0DkRueujFFGaH/vQLqD3F
RrNCVfdn8keSD7xeGCOmz2TgMC89OPoaZY7TNFLL1hgkq4R+0jQdg1tH+qQ48/Np
YyU7kOslK5IBBhVt4txrepFeeoMZtj0HQiZ98VXQ/uch8Wejv4MRCp877s0Ufsst
/JT1grwW+3m6LB6ZUxQphcF+jgngjdnzjWcoptcOkHB1ChzyXfVxK1Y1IHvwb2sM
XaUy45RUA8AxsX09hVSi8AKw6EwQpA5lrBg6IUldXQV/qNiMaRJYU57+L5gtm4mU
DrC0VTYbywP+s5Z3O0XV
=5hyE
-----END PGP SIGNATURE-----

--cW+P/jduATWpL925--
