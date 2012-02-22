Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2BVNpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:45:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43264 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707Ab2BVNpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:45:23 -0500
Date: Wed, 22 Feb 2012 13:45:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: wm8994: Return error when device ID mismatch is
 detected
Message-ID: <20120222134520.GL7340@opensource.wolfsonmicro.com>
References: <1329877484.3210.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iK/wEI4vkfDmI6Zw"
Content-Disposition: inline
In-Reply-To: <1329877484.3210.6.camel@phoenix>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iK/wEI4vkfDmI6Zw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 22, 2012 at 10:24:44AM +0800, Axel Lin wrote:
> We base on wm8994->type to set wm8994->supplies and wm8994->num_supplies.
> But in current code, wm8994->type may be changed when device ID mismatch =
is
> detected. If we change wm8994->type, then the wm8994->supplies and
> wm8994->num_supplies settings are wrong.
>=20
> Fix it by return error immediately when device ID mismatch is detected.

No, there are valid use cases for registering as the wrong device.  It's
not ideal to have the wrong supply set but it's going to cause more harm
than good to fail hard on this.

--iK/wEI4vkfDmI6Zw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRPFpAAoJEBus8iNuMP3dfdIP/j37JiyOaytJERCXdL9uSufu
qmqRd4IJMJC451G+QZdD0NfNyEa8iNfshrSPPZ+zJ31/yp7uOWObuEhHMHC6t5vs
yd3hiQVBpKHJYb1SjQKSGsVte32XBVeygxDS1utW4imTZw2mtc9j2Tn20Om5483O
oReP+p7mimx7nd9+QaHtGbz9Hf6sb3NTRPfKulGgr3z0dhXA1bNPQODVe6YgKOlI
astO2a6P3EZXyvOfMSfD2mFvtFtI/dD63QB0G2c9lEoJEvHDaKuaca2gWCzKn025
58a4Ng+dtyHlghDz+QBOy9YjFYUaJCbIL88wFhiLXsMxX+O3FSfrjftdXWstS+bo
gWomuEoSryD/8P9KOqc8TO2zc9DJFA55F64l0jz+yfaTq60QD8MV1ddKInmL7yL/
kiIFXVhpJB/C07JsDn+gV4VkVjrksLyn387wmrheHUqGGKMWZX3ou9Oqp5a4jIC/
pe5oILJ9unZ908Ia+OU7I6c6Sx8HXy6pJbDfWx4UiTxl0tB+ikjsVd8bbyquoRLD
3TeI/XvKKGujSDs8qwshx0A8gDvxt+mz5tlQS37skWR6BpCTj1W0dCtWm5/aRFDp
YHpYMR3LlTwJr0vvMbgMs7bjkmTJRRCiq5J7ivudFhx2hebI/nsbFqlGX5kVzn5k
sJB3kPrX4KOBB36pWVkO
=IdIi
-----END PGP SIGNATURE-----

--iK/wEI4vkfDmI6Zw--
