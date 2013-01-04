Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3ADM0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 07:26:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60908 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494Ab3ADM0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 07:26:15 -0500
Date: Fri, 4 Jan 2013 12:26:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: alsa-devel@alsa-project.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, lrg@ti.com,
        perex@perex.cz, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        rob@landley.net
Subject: Re: [PATCH V2 2/2] ASoC: Davinci: machine: Add device tree binding
Message-ID: <20130104122612.GM4627@opensource.wolfsonmicro.com>
References: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
 <1357293277-25543-3-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s8J8qjRpxLkp1Gun"
Content-Disposition: inline
In-Reply-To: <1357293277-25543-3-git-send-email-gururaja.hebbar@ti.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s8J8qjRpxLkp1Gun
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 04, 2013 at 03:24:37PM +0530, Hebbar Gururaja wrote:

> +		"MIC3L",                "Mic Bias 2V",
> +		"MIC3R",                "Mic Bias 2V",
> +		"Mic Bias 2V",          "Mic Jack",

The CODEC driver biases should be changed over to be supplies, this
makes the above much more natural - the routing there is a hack for
older versions of ASoc.  Otherwise this looks fine.

--s8J8qjRpxLkp1Gun
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ5spdAAoJELSic+t+oim97fIP+wZvBya5sPwFXwvEsKdNH6f5
lGMi177i821/+/pGKj0/t5KeQ5oQXmxvs3WkFXj6rkCsozZGKruJAcgyr6fRflBl
3O8PtuM+RGZGSz2yWNmNYO5MyGMABJfhDigHNV7pXJCM6aXc16TTVu/ClmvWWLdA
IBql9hPtOaz47KkO6sksm+/vaHMqSIZp64/hk3W2UPdtA4aoMqlQyPTFSYyf+9bp
VEB/AIwcqvOA+2sOLU4Ulwrb1QjH7CwDxcOo24cr9g3wovU/4wPNQZc3TBvVnbau
WaNqR/LpFR2DbjkRJdyNVWieYZfN9OVvsxWfE7KoQl5x/TSlD701NZ9sLzOqnU44
vAlWWbPvq0jmsiXFdEZf0MiipLVzdXwaPvdAWb7Eoaf0FS8NyuntFDSHlxZTliCU
K7UqmUZcHMl4ILm6EFpUwkA0n0FW6NE508QTpeRgKFf5w/G8A0uTrusw2TjZkeM+
k8wSGaYjx75lcgMLz64N9vZQz101aS+FnKGl1+Hfm1topY1K764vOeAFt2MXORXr
pAMJ05/YSnWw/Tq/LnNmGBzLvpcB6gpxR/LwmyNJvWo4cuwHeXdHKwCPOYYRZtAh
0oPGIg9cAiKPjz0LSHFCj3+TN2vdaGBJzpB3doa/0mioxFDa34hFGOf8dF8jDP4F
YEsRyInOHW0/9yDYQsJt
=cunT
-----END PGP SIGNATURE-----

--s8J8qjRpxLkp1Gun--
