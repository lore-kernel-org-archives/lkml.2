Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2LTNvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:51:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57497 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519Ab2LTNvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:51:07 -0500
Date: Thu, 20 Dec 2012 13:51:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "lrg@ti.com" <lrg@ti.com>, "perex@perex.cz" <perex@perex.cz>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: dapm: Fix the unpaired runtime_get/put cases
Message-ID: <20121220135104.GB4985@opensource.wolfsonmicro.com>
References: <1355913397.17896.10.camel@cliu38-desktop-build>
 <20121219091127.GL4985@opensource.wolfsonmicro.com>
 <27240C0AC20F114CBF8149A2696CBE4A1F3CA7@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qesg98+uAFykT7J8"
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A1F3CA7@SHSMSX101.ccr.corp.intel.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qesg98+uAFykT7J8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 20, 2012 at 06:37:26AM +0000, Liu, Chuansheng wrote:

> Meanwhile, is it useful to add one warning there for that case?
> After all, in probing, set the bias to _STANDBY even idle_bias_off == 1, and calling get_runtime_sync(), it
> will let the code more obscure. So giving a warning there to indicate the driver:
> it is not suggested that in probing, set the bias to _STANDBY even idle_bias_off == 1.

Probably, send a patch please.  Like I say it is possible to start off
in _STANDBY providing the driver grabs the runtime PM reference too but
I can't think of any reason for doing that so the warning seems sensible.

--Qesg98+uAFykT7J8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0xfBAAoJELSic+t+oim9OcwP/2qvlKJiYgOSs0EcPmKGyLxI
nTuHXHDykUuNxmCq7mYNGIlSfkoTtuQGtjxiRaKyY6myXShky1qxka8RZ1o8XsYt
gIC/veb+G9kxSid92v/pxXkLkfU3X0mEdRzYqbTlyLWVBfsIZQjqeVrJsBGDHZkO
1MQmz0YAHvGdhzAO8Iw7627E8xDRAUwlPfNMwnKsUAUF7KOe1p3En4pKJlRqYAfB
ZvFeFpfAUjeOB5nz/cV2zZ2wJby7cqDs8tUoRKupozZR+PpVRTVEOkY0v/9UTnTo
qwp3yE6GOTcQycvG/RChaTM4t5CfXYE9hGTbO8QM/BVaVOGJ3XAfXlt1vD0X+6UU
h/adDNdkcZwtiA77Gv5SD7YPBS2SWOn+c7w/bGgBKybl3f/chFwH7ssMQKj87boN
RGa10rXttvRgn1zdEn97hryrfQOa/ygbPcFjXzDQfeTOV7QEihTgKTQ4X0WBd+/f
0ogHZo/N3k16N2YUbs44GbYr3+HnnqkVOg8WgcZ3XnMNeaQz5tgs2Hh3w+w0h4pS
NQC+1EHpoe4GHR9nGHiu9GMlVWHPQF093b1WJ0/q3R2qhUPJrOi+m0z9++fv6SdJ
RX0M4XUL3ECrYJdVHNX6HAozca4GuSDEgaXYc89Nu3uT93TAsjGoCBi2RLNxt0c+
iU2dxBPMzpopJUUtXy3V
=UZDv
-----END PGP SIGNATURE-----

--Qesg98+uAFykT7J8--
