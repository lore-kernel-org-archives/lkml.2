Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2GTKKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 06:10:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47688 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350Ab2GTKKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 06:10:02 -0400
Date: Fri, 20 Jul 2012 11:10:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Fix the below warning
Message-ID: <20120720100959.GS4495@opensource.wolfsonmicro.com>
References: <1342720012-3709-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="63aIh6YiuHX+oBFP"
Content-Disposition: inline
In-Reply-To: <1342720012-3709-1-git-send-email-shubhrajyoti@ti.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--63aIh6YiuHX+oBFP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 19, 2012 at 11:16:52PM +0530, Shubhrajyoti D wrote:
> The dma_map and dma_unmap should have same parameter
> passed otherwise we get the below warn.

Applied, thanks.

--63aIh6YiuHX+oBFP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQCS44AAoJEBus8iNuMP3dgKkP+wdqtS2yCzPgOuoBIlgpHqjA
/4NAv7apXnBADUZVdfB7UNU0iV18tlUVQJ6Wp1hlljQfRysMxH0f6l6yotTFFgjR
NdBtz0nsDW5WnIfl5ha7ZbCatWw7nW8aRjazeQWn+5a1hriKTKIo+WUwrHjUOxUV
b+RddhClREfp/rw8mKlVJyqRoII5HgiUlzPaO9k7tPDlOB0CS3H1gn/fk2m2W/67
jryqhwB0fcdK1zcu706bh41A/8fBdamMPRvz8PNKJGgDOSot4uWRJdBkOQ0Qjv0G
X2PAN8ySLMl35dxxeweGUTqcppHudKPg17/7nOoaks+zkBU8p2u2epDHpd40pqL3
nw6RjcNcghmDcVkiGySqHHL90/fmfEIuUgmX2Hn7WN1Cp87bPYxVfY8kB7EeNshx
w1DYfKh4l+1eswJzbI68Ky+QEuroThNu4ugr/EPeh+aG++xiXv5LNrJ36O7mSktQ
v4Hby2rGMqivgogV7TMFLNH8J5jPtp3AxnXxMjN4UNcp5iNLqwjA2GY1M5TqD3iX
VBeTjCk2HVDTOjxRwjXbDyJD+PtTnjKyOQQOTwQmvpumyQsT35MAB1Ru0vobyZTt
tp54cWatfnraYqU+ncC5/pzgBODjqidR718CD8UPsimgktxwsePWbP5TnTjap3SZ
gSqp1Xf3Mdzhn300P8X+
=kgJk
-----END PGP SIGNATURE-----

--63aIh6YiuHX+oBFP--
