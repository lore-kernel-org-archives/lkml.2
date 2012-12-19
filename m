Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2LSJqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:46:02 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39272 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab2LSJpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:45:54 -0500
Date: Wed, 19 Dec 2012 09:45:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Luciano Coelho <coelho@ti.com>, svenkatr@ti.com,
        linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org,
        lrg@ti.com, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
Message-ID: <20121219094552.GN4985@opensource.wolfsonmicro.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
 <20121218095450.GB27751@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WkHPBKJ2pKcVUM5H"
Content-Disposition: inline
In-Reply-To: <20121218095450.GB27751@arwen.pp.htv.fi>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WkHPBKJ2pKcVUM5H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 18, 2012 at 11:54:50AM +0200, Felipe Balbi wrote:

> damn, this is still part of our v3.7-rc kernel. Original commit was done
> with no testing whatsoever and caused a big regression to (at least)
> TI's WiFi driver which depend on SDIO to function.

> Too bad things break and even when reported nobody gives a rat's ***
> about them :-s

I guess it's going to be even more of an issue going forward given the
recent events but FWIW it was always very unusual to see any review of
any TWL patches, the PMIC appeared to have been rather abandoned so the
only way of getting any testing was to put stuff in -next and hope.

Mind you, if there is an issue it doesn't seem that serious given that
it took at least one kernel release before anyone noticed and even when
they did you're the first person who bothered to respond...

--WkHPBKJ2pKcVUM5H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0YzJAAoJELSic+t+oim9EhsQAJV7Os7mUXx2BCO08e8p8ETH
Ramjq8oCkU3lMO8ksvcLmtLjm8XpSdbzE3D0xrzuUIYobd+XmJL9iBrvoaZFQayh
j1VooLdhelX38bMTJXxoEj+vTBGPh8tPDAvoxnUXEio37swYO7p8SUUBIRLvQuJS
98tuCzvGUTLvSlR2RdtJWdR/CITptqeQaxfAeDbTUg22sF92jxAeuXH/V7ZqKVKy
TjXh+JdQNwkNz5aTkFEqbuZvTbuuc9YgTHf/o4PPAokuk0wKGcg8131jok+w0CHi
lBaRaba3WVuQeaZ2rNWogaV59HPtw5G9eUn6OHhTnKfH5DjA3oBuVnxCD3Ts8uCe
LOBChb4m3/IoY+X+vjFZPPoMraR1tShkMiuYDRzIOzp1UkhgX+4jiOS/EhUgzV7H
vVLqzm9JXO7Q/Blg/AZ1RYB8qJevDaTq0vDMEwvZFzIuQIMpN3mWzhxrms3dOIJJ
0UM1nQu4qoXsgjpLVim27/ywJUn64LiPG8t0LsdRWoTQGvzK+/DoymdrVFDTQnb1
EPPZDYTKTpqxPeMTGSu5Fm34Hiq8QUVTLMsyLKe6GtaJFbUpt7ngSTEtV8HG5MuB
K642ZaUMKsnlcdH0J/vPTMx1NkQm+Rj7KbQ5Bh4O6NTzt2pTryq8k17GWXRkqw+J
pbNC4tNQ0GJnKpVuy3eB
=vHkb
-----END PGP SIGNATURE-----

--WkHPBKJ2pKcVUM5H--
