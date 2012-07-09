Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2GIShN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:37:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44358 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079Ab2GIShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:37:11 -0400
Date: Mon, 9 Jul 2012 19:37:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps62360: Convert to devm_gpio_request_one
Message-ID: <20120709183709.GK3934@opensource.wolfsonmicro.com>
References: <1341620913.3153.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9JSHP372f+2dzJ8X"
Content-Disposition: inline
In-Reply-To: <1341620913.3153.1.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9JSHP372f+2dzJ8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 07, 2012 at 08:28:33AM +0800, Axel Lin wrote:
> Use devm_gpio_request_one to save a few error handling code.
> Also remove trivial comment for tps62360_remove.

I can't apply any of these patches until devm_gpio_request_one() is
exported in mainline.

--9JSHP372f+2dzJ8X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP+yTCAAoJEBus8iNuMP3dW6EP/3cJi9gr619bR83mHuiqejLY
btVB2lpzgyYv4t5iQXRxKen0GW9ZAk7jzhwzyJZWgu9VGYyY1NlXCJ5qqeyyrYXO
M27tMxKfJRq2qXt9dOjEUFmDkT4s2JnfA9YSLPGk1ra/T1CeMSk1j1F/F9ATU7KG
lszlH4qjrUYAZGI5P7PdDia/blbPpHuxmZAajdQPZ5kTQz4ukrn+RT6hgBozmYTe
Siwc76utHn88cxD91TFlQXgwwpavJbArBW3uVVm5+t13MAn70T6t5XMvpX8YS9I8
yxgqxZzzZ/UnzJXqIh4QhJer/mqpn38yNkygJawJvJ1y73eLouJrn7f94yl2JjPE
w1WRo86T8Xu40KcZeiX0UuUD1LZJcBfD6RlkYhQAjFfm5LsTMQ499tl4t+SSIRxJ
QzsZDtG/AOBOxNPL6I1cjSPQ/5QnSgInZ2efrM3Fh/NqgprQM9NgGpxxlA9bzwX+
2qaKWukr/AdTpqlLuDKs+fE0gMZSDO+qlaRNWZ2x+Mp0W0ZMpS4AmGtLA7ifIFPP
mH3ylLcLWU/aHjXSZFmFV2c2gJzlbpMfccK3COjAlfZTSYRhVVTPeDnOK73ijx6W
hGk6KKYU47zQKrFz+VMRfsoVEWAaCPt6eZPy0NTJhPf1Axt5XSGniqBFnG9EyD2l
Af2OFJ4+w7zqECdmz2Ia
=UfX9
-----END PGP SIGNATURE-----

--9JSHP372f+2dzJ8X--
