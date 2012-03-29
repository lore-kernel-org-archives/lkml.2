Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab2C2LJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:09:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52198 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758519Ab2C2LJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:09:16 -0400
Date: Thu, 29 Mar 2012 12:09:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Only update [LDOx|DCx]_HIB_MODE bits in
 wm8350_[ldo|dcdc]_set_suspend_disable
Message-ID: <20120329110913.GG3668@opensource.wolfsonmicro.com>
References: <1332989256.29774.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z0mFw3+mXTC5ycVe"
Content-Disposition: inline
In-Reply-To: <1332989256.29774.2.camel@phoenix>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z0mFw3+mXTC5ycVe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 29, 2012 at 10:47:36AM +0800, Axel Lin wrote:
> What we want is to disable output by setting [LDOx|DCx]_HIB_MODE bits.
> Current code also clears other bits in LDOx/DCDCx Low Power register.

Applied, thanks.

--Z0mFw3+mXTC5ycVe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdELKAAoJEBus8iNuMP3dwcQP/jgH4qxg7rl5CYKJhzXkDbuw
9M/MdM7+dEPcEzKE+EZt/sBSEFHzHxb8pLalSrZ9N7T3IjgTh3IfIFF0irh4fh+U
4OT0tgS+6dDqeCA6OI9w63o4HGv7NT7kiFM/DU9c5FAUI+ry18p1u/Pynl95RC4d
Qo02OSEKZUeAKlZf6LkGvPq6gSwNyCUJ/bf1TdIhFahzHoV7FnelaACGbP+KGGj9
7VwF0qZA3DChcbcMBb0havylHlX54W363z4/aS5UYF4f2vOn6C3f35Vz/iqLmu3k
ozGfY3T7H9nLnCpKqXyyfhI/Kwb7wFGwpNDnHgDhH5Ew1QY11lmZJH7QNAVb523J
N8gQDMw9sFz7pVPQEtkHemuVFYgV7OyI3mLmvKUwENBIir764sjDmjlWJsHFeiDu
EyXiRivvL6AEaRYlqQUlmxCSed+RXUkU0qOGMcOtQW6TIFzg3x7wa8/6gSEUuQ5t
bgbW82fe0ImMwQcGQaI1R5QWIoMR2Dw+tKIVYLP6wl9NcfFgi8uI1nRJv2D6NVIb
MYVePv2EsK4vYLPhwZgi0gmV3MWiizwwYYKQrJAuLvZTYyX7FsjnxtX4TYEn7YF8
BJEWr3AXX8mTxrMApT3zb3+JS/nBJ7W+XhAmIlog9HNJIjnnumUoxNR4in+CgmMb
T09aNTNQSN4/WKroVDTU
=fS2r
-----END PGP SIGNATURE-----

--Z0mFw3+mXTC5ycVe--
