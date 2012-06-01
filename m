Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab2FAO14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:27:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37137 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759026Ab2FAO14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:27:56 -0400
Date: Fri, 1 Jun 2012 15:27:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: wm831x-ldo: Use
 regulator_map_voltage_linear for wm831x_alive_ldo_ops
Message-ID: <20120601142752.GQ24139@opensource.wolfsonmicro.com>
References: <1338457140.4165.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kERJ49nCKmnv470N"
Content-Disposition: inline
In-Reply-To: <1338457140.4165.1.camel@phoenix>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kERJ49nCKmnv470N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 31, 2012 at 05:39:00PM +0800, Axel Lin wrote:
> wm831x_alive_ldo_ops uses simple linear voltage maps.
> Thus use regulator_map_voltage_linear is more efficient than using the default
> regulator_map_voltage_iterate.

Applied both, thanks.

--kERJ49nCKmnv470N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPyNFfAAoJEBus8iNuMP3dLJsP/iJfxLK9d3NqwnnzaXTlv0Pq
+9pAzpSF4w/WnZUFXUX1ic+1B3zo85jC1gi3jAxfar5Kla5wb6SQGfMSjm1aF9bU
SlUDJtFix4VmsfjsaCqIoeumdeOqG6ZEtCq4EXGM5tJlm7Uv7bjxRJUhkzzHcEYH
PWbMMw5HeFvshfA1oHwfta/LpCEJsXm2v4QlPWxcSJNJ1MjG4FGA6e56As2BX+mu
tL9AqqcYKXZta3sLVFwvOGpeJXia/a9wEv8zg+36cR5Z/ejeKT0yMqcq/mWcTEQ0
GJqKq7p5k7TVqLEE/+H1wd5/QotFDV61jMUS54tVQO1CYu1xk/42WpgtEuOZUzSh
4HIBwRcl2tVpzgL5znUvwcrK3VFkBE8K+WExa17UmnnljdheXRv9ZjQVqoDd/4fh
EviUpvkDlrWpNlE6Pz52w9rKKUYaizOuiIbXl26QbU3ASFzyMw7Z63HzzaP+Ug53
Zpt1O6HHNkddBXQiOGQhRohwDMgq/F6UhvpwnyI8iZLdFXIXacaudroMzveX6zjO
69PzvDOArq6YKKOx+fSfn3spXdo2w56UV4lOPKslAOz6uWKlO/sv9U7ZbXzZCJkJ
YTbSpabe9bUixKHEDRZpM+6b7s7etXf5u3vTOZT64Iw7O0OUGcqJGdaRIk7ZdljR
L3b0gg+HUDlrB7lv0GJ1
=hLK4
-----END PGP SIGNATURE-----

--kERJ49nCKmnv470N--
