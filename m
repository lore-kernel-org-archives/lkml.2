Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3ADLiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:38:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45032 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469Ab3ADLiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:38:08 -0500
Date: Fri, 4 Jan 2013 11:38:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: alsa-devel@alsa-project.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, lrg@ti.com,
        perex@perex.cz, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        rob@landley.net
Subject: Re: [PATCH V2 1/2] ASoC: davinci-mcasp: Add pinctrl support
Message-ID: <20130104113803.GL4627@opensource.wolfsonmicro.com>
References: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
 <1357293277-25543-2-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0+35XlDF45POFHfm"
Content-Disposition: inline
In-Reply-To: <1357293277-25543-2-git-send-email-gururaja.hebbar@ti.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0+35XlDF45POFHfm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 04, 2013 at 03:24:36PM +0530, Hebbar Gururaja wrote:
> From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
>=20
> Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>

Linus has a change for this in the core which currently looks like it'll
get merged in v3.8 so there doesn't seem to be any pressing need for
driver specific changes that just set the defaults.

--0+35XlDF45POFHfm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ5r8DAAoJELSic+t+oim98s4P/Au5bb0PLI6Sstk4p7TK/BEb
V9UoEbaER+W7387AVbou41RDx6W/ntKHwERjR6Is6Haa8cYXeXqFyeYmsuPfRy2u
6NvuQz1h+I8pr5WJDP3/rJICbIvhP4vsl/3h/6tOCyP/JfHoia3hUbPCSMULOpls
enFHDf6VsMkbLFU3IhKnTuLRRQ+nUVCgZ4QHR33vLs94KVFn2K7DGmiDcMfcXK0/
8Mw9oqtemjpAsN9oXiqe5Sb0epWd0T9XbisvAtPfEP+j3vevhMoMsX01T3UcfTU4
GAZmsLh4Jo6cHdGqm6wJhrmoFlQ8Vfq5wRBjz/QWjFchMGJTgxNQvzRkkCBUZ4Lv
S2LW0s+Jab94ThXbqnbXAlGwOce9xmcv1W7cnnLCkTL88te3Si6l8YZvSAelpu7G
ljRfdeqtPNDYj/qkFNoCsUiODUMSc9X2qCFx3jjOPDyEsqHj/BnixFPfQHVES8Lm
+uWrWtTyZ5TudtluADu/+omFTMX2y4u3dXSfPtFhxf5KJEm5dunQ92Q57I5vFoHY
VBZSgiZVdsozDSVaUQ0ZnM5a6bCGfay6HcZYbf7/hTCqLB41iyFoH9Pxue9eRHiX
5334eakJkFsQKubjs0tsUSOIUcxw6L1F/2wNIUiMIM6ZCzZ/eWvInKFc+5tuSxK8
VvzOHiu2brZ0vSJQD0IG
=J/m1
-----END PGP SIGNATURE-----

--0+35XlDF45POFHfm--
