Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2GOVAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 17:00:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34425 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab2GOVA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 17:00:26 -0400
Date: Sun, 15 Jul 2012 22:00:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH RFT 1/2] regulator: twl: Fix the formula to calculate
 vsel and voltage for twl6030ldo
Message-ID: <20120715210022.GF4041@opensource.wolfsonmicro.com>
References: <1341804151.14367.1.camel@phoenix>
 <1341831686.4343.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SNIs70sCzqvszXB4"
Content-Disposition: inline
In-Reply-To: <1341831686.4343.7.camel@phoenix>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SNIs70sCzqvszXB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 09, 2012 at 07:01:26PM +0800, Axel Lin wrote:

> I found a problem that before commit 3e3d3be79c, the voltage tables were
> not linear mapping. So why we can convert these voltage mapping table to
> Voltage(in mV) = 1000mv + 100mv * (vsel - 1)?

Guys, it's pretty concerning that there's been no response at all to
this.  Looking at the changes Axel's statement above is accurate for at
least VAUX1 and VMMC, I didn't check all the regulators, so either the
original code was buggy or there's an issue that needs fixing in the
current code.

--SNIs70sCzqvszXB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQAy9eAAoJEBus8iNuMP3di6IP/jxgXAmYMyXh3DboRwCTQLkw
fya9I4IVqM966tOeOUqOwGVtBgVqk18e9RBXW8aAkNzatjw2URJQ6LucjROifBIc
lI2En92mIWZWpft8p7NmPODc5yAJ+ykzzOKMuEnVJAQd/mD6YCr5BFU/Ej1M1Wkw
WtwIvVW6cu3prYk9RvFqeIdo6Ngs9wDTA2OJgPlf5umefN1qBlkUIOgTC7tke/xC
qL6ZIl3Cn2yINGjpNasF/B0osLdSDYp/TlnPJoxoBd6WNvTDMTr+hobIuyg9eVnw
eJ48qPxGRYWxv947cbq5tDfF7WqQTIhNJvXXrM3rCBERKZZEDZp390WNN/7F7O/C
rw479uOQM9KDmHP5vyILgIYAqiL2A805392TdCII3BuW4l7Tt8ZuPBqtCGNWkO/M
yjvZPa+ZdJZv/1na84FMhdCw+cKT2LT1K1cr5qUsQQpzBdunNxO3btmTkOGyVo8W
hbeySWiXlkiJrGRcnG63symNshtoD0iEPbCcfUA9wErxn8FDwvWWf0z75S8aKkeR
oQ1rZMpYvCwVnflVqW7usG4jnrESrg2ozWI+aRMf4OF+yGyN6905md9ym3aCVjwq
DtGl9MJl6BXe2VvlR/meu0PWpdsPifv72MdOWRWQrbb0oAL6Hfr9wvyIuZYPxS3u
iTfihX5qSOrL8gRgnUg4
=r/S3
-----END PGP SIGNATURE-----

--SNIs70sCzqvszXB4--
