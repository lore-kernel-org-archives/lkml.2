Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab2DMJCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:02:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52479 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758033Ab2DMJCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:02:04 -0400
Date: Fri, 13 Apr 2012 10:02:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Brian Austin <brian.austin@cirrus.com>, Axel Lin <axel.lin@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lrg@ti.com>, joe@nucleusys.com
Subject: Re: [PATCH] ASoC: cs42l73: don't use negative array index
Message-ID: <20120413090200.GI3168@opensource.wolfsonmicro.com>
References: <alpine.LNX.2.00.1204122152340.7553@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BghK6+krpKHjj+jk"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204122152340.7553@swampdragon.chaosbits.net>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BghK6+krpKHjj+jk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 12, 2012 at 09:54:34PM +0200, Jesper Juhl wrote:
> If cs42l73_get_mclkx_coeff() returns < 0 (which it can) in
> sound/soc/codecs/cs42l73.c::cs42l73_set_mclk(), then we'll be using
> the (negative) return value as array index on the very next line of
> code - that's bad.

Applied, thanks.

--BghK6+krpKHjj+jk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPh+t3AAoJEBus8iNuMP3dAYAP/0f6vqfXWl8NDFaEi2v9/osc
xiH55Y1Lk+V1+GSUsUq/ei2d+NQQFmLEOwO7HoA0FYdosMsLacRy7vyivVhnkH8s
dfBtIxQN1+w3MyFsBjd/wxWK0JOzooLNEWdkXAxLK+0S0Lnge1+pZXWiPHLDSspY
cOmGMrk4BYAkCA7Mu0Ka/eAZkC0GGgRU2CoaxRSAQ8gv9B0+yepOST2QX/W5Z1sM
hh9BcIJtOJPKal+jg05f0olhX6CMpDBT54evt769/zb2wUFnZ3FSOluldO145iYl
G4Fcr84lueGmUKKqcau45wV3kPFK04XBGHu4dv4/oU9QJjpAVwPfmgwKwnZd6nV4
9CbDJhoj4qNngyUzIjM/X2SJssEgG1ntc5QHXOxXIuBrja8Tb/499SDLzz/YwdCg
GR5MYZ/h9RVvyN5sl5o4/0EoHn9oOiiG+5RpOm2/n963F3AbZXE+nIUNnKkj8Mmp
556dKC1ssbL7QqKO0mbYh8PDwQNbvDfhIytrE/2VUep1xqARMsLXjw+JSAIirF3V
YTkC8RFBt3R4ANVz7uLLjHBZc4YlhBhOF9469yCaiA6/qB08X6S8SCubBXXuEj8u
HqhIVLdT2drTV1EirtrrbSOim7ZX8Q2kLg8UV5TI3vinTCxNG1hM9xjzttfgD6sm
BAzeiDPQMP/EEJ/4EEwg
=J/t7
-----END PGP SIGNATURE-----

--BghK6+krpKHjj+jk--
