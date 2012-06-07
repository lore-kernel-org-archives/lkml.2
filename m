Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab2FHAzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:55:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58692 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab2FHAzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:55:04 -0400
Date: Fri, 8 Jun 2012 07:37:00 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Message-ID: <20120607233659.GS14525@opensource.wolfsonmicro.com>
References: <1338984098.5195.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="psiTe9LjpVyD9953"
Content-Disposition: inline
In-Reply-To: <1338984098.5195.1.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] regulator: palmas: Slightly code change for better
 readability
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--psiTe9LjpVyD9953
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 06, 2012 at 08:01:38PM +0800, Axel Lin wrote:
> It's a little bit hard to read that the "else" case means id == PALMAS_REG_SMPS10.

Applied, thanks.

--psiTe9LjpVyD9953
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0TsRAAoJEBus8iNuMP3dZ2IP/0amEBPWK5e7F9X0PxgF4wdU
YnOUYYHlXGUrCgKjN1iYK3GRrBmqzgbFy3p0Zv7kuBUTjBlihlit2KsbWD2iLIsv
cfw7QoLQ2yzhUAul7qBNeAPECmD5ZvQJ1D2FB7udR/Cen82sIU61OIUG01Y9PTA8
DE158zK+ruSTgPkwq53220+uVnQCZGehhl2e2m+7/HGjaPT+YpqxraYZxeWG+K0u
0gCFZZlYVNqfVwsI9d9Z31P75al1+4UCsqU0tSAGL78Qq0Y5UAiRAp3F4fWtr4KM
c9IYvLV6acrUgZKIGFOVnLE6FbxP2EsCL4mkolRz2q2hMYe4l+tSSXsczaNUYaqd
62oFO9Z7c/a/40+MRYzlcAfQWYy2HGcxt7wnKCLHij8gezXYV3EHa9V5pqY3Ikvv
iIc2LvsTY/RsNDyQ9XPH2JTwenelSIE+4YSSROqVkMmXIYDjnVllEbghSSZpfXhQ
uFmmD7xRcA2qiGqA0kB0CzRcBE83Z1yPxekZigktNTRKce98G5xQUKdqD2M4tknV
IESKrfCx9T/06RokgEiq9P+DRXqClM7KakzpiOGYpFh+K2dwNkiZYdjOcX2LdPwy
4oufUKdQZteUwpP4eJd5ansYYUtI6pvp4ZNVPzWRp39mFF6OnYv4NMd8pIjqZa1o
Dz4gRH+Kk5tabtNTvpZQ
=MI+U
-----END PGP SIGNATURE-----

--psiTe9LjpVyD9953--
